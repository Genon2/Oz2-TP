%Exercice 1
local X Y Z in % Les thread attendent une valeur pour X et Y pour exécuter la suite du code
    thread if X==1 then Y=2 else Z=2 end end
    thread if Y==1 then X=1 else Z=2 end end
    X=1
    {Browse [X Y Z]}
end

local X Y Z in % même conséquence qu'au dessus
    thread if X==1 then Y=2 else Z=2 end end
    thread if Y==1 then X=1 else Z=2 end end
    X=2 
    {Browse [X Y Z]}
end

%Exercice 2
declare % La suite du thread est exécute seulement quand le if du Guess aura une valeur.
proc{Guess X}
    if X==42 then skip else skip end
end

thread {Guess X} {Browse oui} end
X=42

%Exercice 3
%Les threads vont se créée dans l'ordre donné par le code 
%mais ils vont attendre l'assignation de la variable dont'il ne connaisse pas la valeur
%3è thread, 4è thread, 2è thread et enfin le premier
declare A B C D in 
thread D=C+1 end
thread C=B+1 end
thread A=1 end
thread B=A+1 end
{Browse D}

%Exercice 4
declare
fun {MergeSort L}
    L1 L2
in
    case L of nil then nil
    [][X] then [X]
    else
        {Split L L1 L2}
        {Merge1 thread {MergeSort L1} end
                thread {MergeSort L2} end}
    end
end

fun {Merge1 L1 L2}
    case L1 of H|T then
        case L2 of Head|Tail then
            if H<Head then 
                {Append H|Head|nil {Merge1 T Tail}}
            else
                {Append Head|H|nil {Merge1 T Tail}}
            end
        [] nil then H|nil
        end
    [] nil then 
        case L2 of H|T then
            H|nil
        [] nil then nil
        end
    end
end

declare
proc {Split L ?L1 ?L2}
    proc{SplitB L Long ?L1 ?L2}
        if Long==1 then 
            L2=L.2
            L1=L.1|nil
        else
            local X1 X2 in
                case L of H|T then
                    {SplitB T Long-1 X1 X2}
                    L1=H|X1
                    L2=X2
                end
            end
        end
    end
in
    {SplitB L {Length L}div 2 L1 L2}
end

{Browse {MergeSort [1 4 3 2]}}

%Exercice 5
declare 
fun {Producer N}
    if N==10 then
        N|{Producer N+1}
    else
        n
    end
end

fun {Consumer S1 Acc}
    case S1 of H|T then
        H+Acc|{Consumer T Acc+H}
    end
end

proc {Disp S2}
   case S2 of X|T2 then
      {Browse X}
      {Disp T2}
   end
end

declare S1 S2 in
    thread S1={Producer 1} end
    thread S2={Consumer S1 0} end
    thread {Disp S2} end
end

%Exercice 6
declare 
fun {Producer N}
    if N\=10 then % Pour stopper sinon Le compileur plante
        N|{Producer N+1}
    else
        N
    end
end

fun {Filter S1}
    case S1 of H|T then 
        if (H mod 2)==1 then 
            H|{Filter T}
        else 
            {Filter T}
        end
    end
end

fun {Consumer S1 Acc}
    case S1 of H|T then
        H+Acc|{Consumer T Acc+H}
    end
end

proc {Disp S2}
   case S2 of X|T2 then
      {Browse X}
      {Disp T2}
   end
end

declare S1 S2 S3 in
    thread S1={Producer 1} end
    thread S2={Filter S1} end
    thread S3={Consumer S2 0} end
    thread {Disp S3} end

%Exercice 7
%SKIP 

%Exercice 8 % J'ai pas eu d'erreur et le jeu ne s'est pas arrêté :/ Mais je suppose que L prend une valeur trop importante à un moment dans la mémoire
declare
proc {Ping L}
    case L of H|T then T2 in
        {Delay 500} {Browse ping}
        T=_|T2
        {Ping T2}
    end
end

proc {Pong L}
    case L of H|T then T2 in
        {Browse pong}
        T=_|T2
        {Pong T2}
    end
end

declare L in
    thread {Ping L} end
    thread {Pong L.2} end
    L=_|_