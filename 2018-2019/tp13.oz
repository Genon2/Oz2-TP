%Exercice 1
declare % Il est possible que certain message envoyé à {Send} soit oublié
proc {NewPort S P}
    P={NewCell S}
end

proc {Send P Msg}
    NewTail
    L
in
    L={NewLock}
    lock L then
        @P=Msg|NewTail
        P:=NewTail
    end
end

local S P in
    {NewPort S P}
    {Send P 5}
    {Send P 4}
    {Browse S}
    thread {Send P 8} end
    thread {Send P 9} end
end

%Exercice 2
declare
proc {Counter C}
    C:=@C+1
    {Browse @C}
end

C={NewCell 0}
thread {Counter C} end
thread {Counter C} end
thread {Counter C} end
thread {Counter C} end
{Delay 400}
{Browse @C}

%With mutex
declare
proc {Counter C}
    local L in
        {NewLock L}
        lock L then
            C:=@C+1
        end
    end
end
C={NewCell 0}
thread {Counter C} end
thread {Counter C} end
thread {Counter C} end
thread {Counter C} end
{Delay 400}
{Browse @C}

%Exercice 3
declare
class BankAccount 
    attr Montant L
    meth init
        L:={NewLock} %Les attributs d'une classe sont des cellules
        Montant:=0
    end
    meth deposit(X)
        lock @L then
            Montant:=@Montant+X
        end
    end
    meth withdraw(X)
        lock @L then
            Montant:=@Montant-X
        end
    end
    meth getBalance(?X) %Pas besoin de lock car on ne change pas la variable commune
        X=@Montant
    end
end

local A X in
    A={New BankAccount init}
    thread {A deposit(5000000)} end
    thread {A withdraw(4999000)} end
    {Delay 500}
    {A getBalance(X)}    
    {Browse X}
end

%Exercice 4
proc {Transfer A B Montant} L in
    L={NewLock}
    lock L then
        {A withdraw(Montant)}
        {B deposit(Montant)}
    end
end

local A B X Y in
    A={New BankAccount init}
    B={New BankAccount init}
    thread {A deposit(5000000)} end
    thread {B deposit(5000000)} end
    thread {Transfer A B 50000} end
    thread {Transfer B A 9} end
    {Delay 500}
    {A getBalance(X)}
    {B getBalance(Y)}
    {Browse X}
    {Browse Y}
end

%Exercice 5 Theorie