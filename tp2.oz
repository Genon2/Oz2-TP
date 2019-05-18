%Exercice 1.A
declare
proc{Max L ?Num}
    proc{MaxLoop L M ?Num}
        case L of nil then Num=M
        []H|T then 
            if M>H then {MaxLoop T M Num}
            else {MaxLoop T H Num} end
        end
    end
in
    if L==nil then Num=error
    else Num={MaxLoop L.2 L.1} end
end
local Num={Max [1 2 16 4 5]} in
    {Browse Num}
end

%Exercice 1.B
declare
fun{Fact N}
    fun{Facto N}
        if N==1 then 1
        else N*{Facto N-1} end
    end
in
    if N==1 then 1|nil
    else {Append {Fact N-1} {Facto N}|nil} end
end

{Browse {Fact 15}}

%Exercice 2.A ce n'est pas tail recursive suite au point 2 :p
declare
fun{Sum N Acc}
    if N==0 then Acc
    else {Sum N-1 Acc+N} end
end

{Browse {Sum 3 0}}

%Exercice 2.B
declare
fun {Append L1 L2}
    fun {Appendbis L1 L2 Acc}
        case L1 of nil then Acc|L2
        [] H|T then {Appendbis T L2 Acc|H}
        end
    end
in
    {Appendbis L1.2 L2 L1.1}
end

{Browse {Append [1 2] [3 4]}}

%Exercice 2.C
declare
fun {Fact N}
    fun{Facto N}
        if N==1 then 1
        else N*{Facto N-1} end
    end
    fun {FactTail N Acc}
        if N==1 then {Append 1|nil Acc}
        else {FactTail N-1 {Append {Facto N}|nil Acc}} end
    end
in
    {FactTail N-1 {Facto N}|nil}
end
{Browse {Fact 13}}

%Exercice 3.A %Le code attend une réponse pour Y afin de réaliser l'addition
declare
local X Y in 
    {Browse 'hello nurse'}
    X=2+Y
    {Browse X}
    Y=40
end
%Exercice 3.B %Le code n'attend pas la réponse de Y car il stocke l'endroit en mémoir où se situe Y dès que l'espace est rempli avec une valeur, il l'affiche
local X Y in
    {Browse 'hello nurse'}
    X=sum(2 Y)
    {Browse X}
    Y=40
end

%Exercice 4.A
declare
proc {Pairs L E}
    case L of nil then skip
    []H|T then
        {Browse pair(H E)}
        {Pairs T E}
    end
end
proc {ForAllTail Xs P}
    case Xs of nil then skip
    [] H|T then 
        {P Xs}
        {ForAllTail T P}
    end
end
{ForAllTail [a b c d] proc{$ Tail}{Pairs Tail.2 Tail.1}end }

%Exercice 4.B
declare
fun {GetElementsInOrder Tree}
    local L R in
        if Tree.left\=nil then
            L={GetElementsInOrder Tree.left}
            if Tree.right\=nil then
                R={GetElementsInOrder Tree.right} 
                {Append {Append L Tree.info|nil} R}
            else
                {Append L Tree.info|nil}
            end
        elseif Tree.right\=nil then
            R={GetElementsInOrder Tree.right}
            {Append Tree.info|nil R}
        else 
            Tree.info|nil
        end
    end
end
Tree=tree(info:10 left:tree(info:7 left:nil right:tree(info:9 left:nil right:nil)) right:tree(info:18 left:tree(info:14 left:nil right:nil) right:nil))
{Browse {GetElementsInOrder Tree}}

%Exercice 5.A
declare
fun {Fibonacci N}
    if N==0 then 0
    elseif N<2 then 1
    else 
        {Fibonacci N-1}+{Fibonacci N-2}
    end
end
{Browse {Fibonacci 35}}

%Exercice 5.B
declare
fun{Fib X}
   fun{Fib X I Acc1 Acc2}
      if I=<X then {Fib X I+1 Acc2 Acc1+Acc2}
      else Acc2
      end
   end
in
   {Fib X 3 1 1}
end

{Browse {Fib 35}}

%Exercice 6
declare
fun{Add B1 B2}
    fun{AddDigits D1 D2 CI}
        local X in
            X=D1+D2+CI
            if X==3 then
                output(sum:1 carry:1)
            elseif X==2 then
                output(sum:0 carry:1)
            elseif X==1 then
                output(sum:1 carry:0)
            else
                output(sum:0 carry:0)
            end
        end
    end
    fun{AddB B1 B2 C}
        case B1 of H|T then
            case B2 of Head|Tail then
                local X in
                    X={AddDigits H Head C}
                    X.sum|{AddB T Tail X.carry}
                end
            end
        [] nil then 
            if C == 1 then 1|nil
            else
                nil
            end
        end
    end
in
    {Reverse {AddB {Reverse B1} {Reverse B2} 0}}
end
{Browse {Add [1 1 0 1 1 0] [0 1 0 1 1 1]}}

%Exercice 7
declare
fun{Filter L F}
    case L of H|T then
        if {F H} then
            {Filter T F}
        else
            H|{Filter T F} 
        end
    []nil then nil
    end
end
local X in 
    X=fun{$ H} if H==2 then true else false end end
    {Browse {Filter [1 2 3 4] X}}
end

%Exercice 8
declare
fun{Filter L F}
    case L of H|T then
        if {F H} then
            {Filter T F}
        else
            H|{Filter T F} 
        end
    []nil then nil
    end
end
local X in 
    X=fun{$ H} if H mod 2 ==1 then true else false end end
    {Browse {Filter [1 2 3 4] X}}
end
