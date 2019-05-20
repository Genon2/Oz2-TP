%Exercice 1.A
declare
fun {Numbers N I J}
    if N==0 then 
        nil
    else
        local X Y in
            {Delay 500}
            X={OS.rand}
            Y=(X mod (J-I))+I
            Y|{Numbers N-1 I J}
        end
    end
end

{Browse {Numbers 10 10 20}}

%Exercice 1.B

proc {SumAndCount L ?C ?S}
    fun {Sum L Acc}
        case L of nil then Acc
        [] H|T then {Sum T Acc+H}
        end
    end
in
    case L of H|T then 
        {Delay 250}
        C={Length L}
        S={Sum L 0}
    [] nil then skip
    end
end

%Pour comparer la vitesse avec l'exerice 1.C, decommenter ce thread
% thread
local X Y L in
    L={Numbers 5 10 20}
    {SumAndCount L X Y}
    {Browse [X Y]}
end
% end

%Exercice 1.C
local S1 X Y in
    thread S1={Numbers 5 10 20} end
    thread {SumAndCount S1 X Y} end
    {Browse [X Y add]}
end

%Exercice 1.D
fun {FilterList Xs Ys}
    case Xs of nil then nil
    []H|T then 
        if H==Ys then 
            {FilterList T Ys}
        else
            H|{FilterList T Ys} 
        end
    end
end

%Exercice 1.E
local S1 S2 X Y in
    thread S1={Numbers 5 10 20} end
    thread S2={FilterList S1 13} end
    thread {SumAndCount S2 X Y} end
    {Browse [X Y filtered]}
end

%Exercice 2.A
declare
fun{Not X}
    if X==1 then 0
    else 1 
    end
end

fun{NotGate S}
    case S of H|T then
        {Not H}|{NotGate T}
    []nil then nil
    end
end

{Browse {NotGate [1 0 1 0 0 1]}}

%Exercice 2.B
fun{And X Y}
    if X==1 andthen Y==1 then 1
    else 0
    end
end

fun{Or X Y}
    if X==1 orelse Y==1 then 1
    else 0
    end
end

fun{AndGate S1 S2}
    case S1 of H|T then
        case S2 of Head|Tail then
            {And H Head}|{AndGate T Tail}
        [] nil then nil
        end
    [] nil then nil 
    end
end

fun{OrGate S1 S2}
    case S1 of H|T then
        case S2 of Head|Tail then
            {Or H Head}|{OrGate T Tail}
        [] nil then nil
        end
    [] nil then nil 
    end
end

{Browse [{OrGate [1 0 1 0 1] [0 1 0 1 0]} {AndGate [1 0 1 0 1] [1 0 0 0 0]}]}

%Exercice 2.C
fun {Simulate G Ss}
     X Y 
in 
    {Browse G}
    case G.value of 'or' then 
        case {Record.label G.1} of gate then X={Simulate G.1 Ss}
            case {Record.label G.2} of gate then Y={Simulate G.2 Ss}
                {OrGate X Y}
            [] input then Y=G.2.1
                {OrGate X Ss.Y}
            end
        [] input then X=G.1.1
            case {Record.label G.2} of gate then Y={Simulate G.2 Ss}
                {OrGate Ss.X Y}
            [] input then Y=G.2.1
                {OrGate Ss.X Ss.Y}
            end
        end
    [] 'and' then 
        case {Record.label G.1} of gate then X={Simulate G.1 Ss}
            case {Record.label G.2} of gate then Y={Simulate G.2 Ss}
                {AndGate X Y}
            [] input then Y=G.2.1
                {AndGate X Ss.Y}
            end
        [] input then X=G.1.1
            case {Record.label G.2} of gate then Y={Simulate G.2 Ss}
                {AndGate Ss.X Y}
            [] input then Y=G.2.1
                {AndGate Ss.X Ss.Y}
            end
        end
    [] 'not' then 
        case {Record.label G.1} of gate then X={Simulate G.1 Ss}
        [] input then X=G.1.1
        end
        {NotGate Ss.X}
    end
end

%Il faut sélectionner jusqu'au pécédent declare et faire Feed Region :p 
local G in
    G=gate(value:'or' gate(value:'and' input(x) input(y)) gate(value:'not' input(z)))
    {Browse {Simulate G input(x:1|0|1|0|nil y:0|1|0|1|nil z:1|1|0|0|nil)}}
end   

%Exercice 3.A % Je supprime les {Delay 200} car ça marche pas sur mon pc avec
declare
L1 L2 F
L1=[1 2 3]
F=fun{$ X} X*X end
thread L2={Map L1 F} end
{Wait L2}
{Show L2}

%Exercice 3.B
declare
L1 L2 L3 L4
L1=[1 2 3]
thread L2={Map L1 fun{$ X} X*X end} end
thread L3={Map L1 fun{$ X} 2*X end} end
thread L4={Map L1 fun{$ X} 3*X end} end
{Wait L2}
{Wait L3}
{Wait L4}
{Show L2#L3#L4}

%Exercice 3.C
declare
proc {MapRecord R1 F R2}
    A={Record.arity R1}
    proc{Loop L}
        case L of nil then skip
        []H|T then 
            thread R2.H={F R1.H} end
            {Loop T}
        end
    end
in
    R2={Record.make {Record.label R1} A}
    {Loop A}
end
local R2 in
    {Show {MapRecord '#'(a:1 b:2 c:3 d:4 e:5 f:6 g:7) fun{$ X} {Delay 1000} 2*X end}}
end

%Exercice 4 exercice à refaire du TP 4