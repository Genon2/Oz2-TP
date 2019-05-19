%Exercice 1.A
local X Y Z in % Le programme plante car il attend l'assignation de Y et Z
    X = Y+Z
    Y=1
    Z=2
    {Browse X}
end
local X Y Z in
    X = plus(Y Z)
    Y=1
    Z=2
    {Browse X}
end
%Exercice 1.B
local X Y Z in % Le programme plante car il attend l'assignation de Y et Z
    thread X = Y+Z end
    Y=1
    Z=2
    {Browse X}
end
local X Y Z in
    X = plus(Y Z)
    Y=1
    Z=2
    {Browse X}
end

%Exercice 2
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

fun{Counter S1}
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

    fun{CounterB S1 Acc}
        case S1 of H|T then
            {Parcours Acc H}|{CounterB T {Parcours Acc H}}
        [] nil then nil
        end
    end
in
    {CounterB S1 nil}
end

local InS in
    thread {Browse {Counter InS}} end
    InS=e|m|e|c|nil
end

%Exercice 3
declare
proc {PassingTheToken Id Tin Tout}
    case Tin of H|T then X in
        {Show Id#H}
        {Delay 1000}
        Tout=H|X
        {PassingTheToken Id T X}
    []nil then
        skip
    end
end

local S1 S2 S3 in
    thread {PassingTheToken 1 1|S3 S1} end
    thread {PassingTheToken 2 S1 S2} end
    thread {PassingTheToken 3 S2 S3} end
end

%Exercice 4
declare
fun{Bar S2 Acc}
    case S2 of H|T then
        if {Length H}==4 then
            {Bar T Acc}
        else
            {Delay 500}
            {Append H|nil Acc|nil}|{Bar T Acc+1}
        end
    end
end

fun{Foo S1}
    case S1 of H|T then
        {Delay 1200}
        H.2|{Foo T}
    end
end

local S1 S2 in
    thread S1={Bar [1 2 3 4]|S2 4} end
    thread S2={Foo [1 2 3 4]|S1} end
    thread {Browse S1} end
    {Browse S2}
end 

%Exercice 5
declare
proc {MapRecord R1 F R2}
    A={Record.arity R1}
    proc {Loop L}
        case L of nil then skip
        [] H|T then
	        thread R2.H={F R1.H} end
	        {Loop T}
        end
   end
in
   R2={Record.make {Record.label R1} A}
   {Loop A}
end
{Show {MapRecord '#'(a:1 b:2 c:3 d:4 e:5 f:6 g:7) fun {$ X} {Delay 1000} 2*X end}}