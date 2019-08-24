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
local X Y Z in 
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
local S1 S2 
    fun {Mine N}
        if N==0 then nil
        else
            local X Y in
                X={OS.rand}
                Y=(X mod 3-1)+1
                case Y of 0 then
                    e|{Mine N-1}
                [] 1 then
                    m|{Mine N-1}
                [] 2 then
                    c|{Mine N-1}
                end
            end
        end
    end
    fun {Counter S1 Acc}
        fun {Parcours X Acc}
            case Acc of H|T then
                if X==H.1 then
                    '#'(1:X 2:H.2+1)|T
                else
                    H|{Parcours X T}
                end
            [] nil then '#'(1:X 2:1)|nil
            end
        end
    in
        case S1 of H|T then
            local X in 
                X={Parcours H Acc}
                X|{Counter T X}
            end
        end
    end
in
    thread S1={Mine 50} end
    thread S2={Counter S1 nil} end
    {Browse S2}
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