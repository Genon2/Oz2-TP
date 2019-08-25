%Exercice 1
declare
fun lazy {Ints N} N|{Ints N+1} end

fun lazy {Sum2 Xs Ys}
    case Xs#Ys of (X|Xr)#(Y|Yr) then (X+Y)|{Sum2 Xr Yr} end
end

S=0|{Sum2 S {Ints 1}}
%Exercice 1.A
{Browse S.2.2.1} % On affiche 3

%Exercice 1.B
proc {Display N L}
    if N==1 then {Browse L.1}
    else
        case L of H|T then
            {Display N-1 T}
        []nil then skip
        end
    end
end
{Display 50 S}

%Exercice 1.C
declare
proc{Ints N ?R} 
    thread 
        {WaitNeeded R}
        R= N|{Ints N+1}
    end
end

proc {Sum2 Xs Ys ?R}
    case Xs#Ys of (X|Xr)#(Y|Yr) then 
        thread
            {WaitNeeded R}
            R=(X+Y)|{Sum2 Xr Yr}
        end
    end
end

proc {Display N L}
    if N==1 then {Browse L.1}
    else
        case L of H|T then
            {Display N-1 T}
        []nil then skip
        end
    end
end
local S in
    S=0|{Sum2 S {Ints 1}}
    {Display 50 S}
end

%Exercice 1.D
% Dans les fonctions, la suspension est réalisé sur la valeur de retour
% En attendant qu'un Thread en est besoin. Dans les procs, c'est R qui est suspendu. 

% La suspension dans {Sum2} pour R est soulevé et de même pour {Ints}. Elle est soulevé qu'une fois
% Et ensuite, une suspension est remise sur R dans le nouvel appel de chaque fonction.

%Exercice 2 -> Théorie

%Exercice 3
declare
%% Delay random time. Print job's type. Bind the flag
proc {Job Type Flag}
    {Delay {OS.rand} mod 1000}
    Flag=unit
end

%% BuildPs binds Ps to a tuple of process descriptions.
%% Each process is assigned a random type
proc {BuildPs N Ps}
    Ps={Tuple.make '#' N}
    for I in 1..N do 
        Type={OS.rand} mod 10
        Flag
    in 
        Ps.I=ps(type:Type job:proc{$} {Job Type Flag} end flag:Flag)
    end
end

proc{WatchPs I Ps}
    for J in 1..N do %Parcourt l'ensemble des éléments de Ps
        if Ps.J.type==I then
            {Wait Ps.I.flag} % Flag est seulement assigné après que le job a été fait donc on attend sa valeur
        end
    end
    {Browse 'all the threads of type I are finished'}
end

%% Lauching 100 processes
N=100
Ps={BuildPs N}
for I in 1..N do
    thread {Ps.I.job} end
end
% On parcourt l'ensemble des types de job
for I in 1..10 do
    thread {WatchPs I Ps} end
end

%Exercice 4
declare
proc{WaitOr X Y}
    local Z in
        Z={Record.waitOr X#Y}
        {Browse Z}
    end
    {Browse 'Bound'}
end

declare X Y in
thread {WaitOr X Y} end
{Delay 500}

Y=b

%Exercice 5
declare
fun {WaitOrValue X Y}
    Z
in
    Z={Record.waitOr X#Y}
    if Z==1 then
        X
    else
        Y
    end
end

declare X Y in
thread {Browse {WaitOrValue X Y}} end
{Delay 500}

Y=b

%Exercice 6 %Fonctionne à moitié
local S1 S2 S3
    fun {Pipe N}
        if N==0 then _
        else
            local X Y in
                X={OS.rand}
                Y=(X mod 3-1)+1
                case Y of 0 then
                    e|{Pipe N-1}
                [] 1 then
                    m|{Pipe N-1}
                [] 2 then
                    c|{Pipe N-1}
                end
            end
        end
    end
    fun {Counter S1 S2 Acc}
        fun {Parcours X Acc}
            case Acc of H|T then
                if X==H.1 then
                    '#'(1:X 2:H.2+1)|T
                else
                    H|{Parcours X T}
                end
            [] nil then 
                '#'(1:X 2:1)|nil
            end
        end
    in
        local Z X Y in
            Z={Record.waitOr S1.1#S2.1}
            if Z==1 then
                X={Parcours S1.1 Acc}
                X|{Counter S1.2 S2 X}
            else
                Y={Parcours S2.1 Acc}
                Y|{Counter S1 S2.2 X}
            end
        end
    end
in
    thread S1={Pipe 25} end
    thread S2={Pipe 25} end
    thread S3={Counter S1 S2 nil} end
    {Browse S3}
end