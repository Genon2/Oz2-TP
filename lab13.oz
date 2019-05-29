%ex 1 %version de benoit
declare
proc {NewPort S P}
    P = {NewCell S}
end

proc {Send P Msg}
    NewTail
in
    %lock sinon P ne gérera pas tous les messages
    @P = Msg|NewTail
    P := NewTail
end

%l={NewLock}
%lock L then 
%   [critical section]
%end


%ex 3
declare
class BankAccount 
    attr amount l name
    meth init (Name)
    name:=Name
        amount:=0
        l:={NewLock}
    end
    meth deposit(Amount)
        lock @l then
        amount:=@amount+Amount
        end
    end
    meth withdraw(Amount)
        lock @l then
            amount:=@amount-Amount
        end
    end
    meth getBalance($)
        lock @l then 
            @amount
        end
    end
    meth getName($)
        lock @l then 
            @name
        end
    end
end

%4
proc{Transfer Montant De A}
    {De withdraw(Montant)}
    {A deposit(Montant)}
end
local A Bin 
    A={New BankAccount init}
    {A deposit(200)}
    {Browse {A getBalance($)}}
    {A withdraw(11)}
    {Browse {A getBalance($)}}
    B={New BankAccount init}
    {B deposit(200)}
    {Transfer(40 B A)}
    {Browse hello}
    {Browse {A getBalance($)}}
    {Browse {B getBalance($)}}
end

