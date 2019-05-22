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
    {Browse Type}
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

%Exercice 6 %Ne fonctionne pas 
declare
fun{Mine}
    local X in
        X={OS.randLimits 1 3}
        if X==1 then 
            e|{Mine}
        elseif X==2 then
            m|{Mine}
        else
            c|{Mine}
        end
    end
end

fun{Counter S1 S2}
    fun{Parcours Acc Actual}
        case Acc of H|T then
            if H.1==Actual then
                '#'(Actual H.2+1)|T
            else
                H|{Parcours T Actual} 
            end
        [] nil then '#'(Actual 1)|nil
        end
    end

    fun{CounterB S1 S2 Acc}
        local Temp={WaitOrValue S2.1 S1.1} in
            {Browse S2.1}
            if Temp==1 then
                {Browse 'S1'}
                {Parcours Acc S1.1}|{CounterB S1.2 S2 {Parcours Acc S1.1}}
            else
                {Browse 'S2'}
                {Parcours Acc S2.1}|{CounterB S1 S2.2 {Parcours Acc S2.1}}
            end
        end
    end
in
    {CounterB S1 S2 nil}
end

fun {WaitOrValue X Y}
    Z
in
    Z={Record.waitOr X#Y}
end

local S1 S2 S3 T1 T2 T3 in
    thread {Browse {Counter S1 S2}} end
    {Delay 500}
    S2=m|T2
    S1=e|T1
    {Delay 5000}
    T1=nil
end