%Exercice 1
declare
A={NewCell 0}
B={NewCell 0}
T1=@A
T2=@B
{Show A==B} %False car designe un endroit dans la mémoire différent
{Show T1==T2} %True car désigne le même contenu
{Show T1=T2} % 0 qui est le réassignement de T1
A:=@B
{Show A==B} % False car il désigne toujours un espace memoire différent
{Show @A==@B}

%Exercice 2
declare
fun {NewPortObject F I}
   proc {Loop Ms State}
      case Ms of M|Mr then
	 {Loop Mr {F M State}}
      end
   end
   S P
in
   P={NewPort S}
   thread {Loop S I} end
   P
end

proc {Access C ?R}
    {Send C access(R)}
end
proc {Assign C E}
    {Send C assign(E)}
end

C={NewPortObject
    fun {$ Msg State}
        case Msg of access(?R) then
            R=State
        [] assign(E) then
            E
        end
    end
    0}

local X Y in 
    {Assign C 5}
    {Access C X}
    {Browse X}
end

%Exercice 3
declare
fun {NewPort S}
    {NewCell S}
end

proc {Send P Msg}
    local X in %S est assigné à Msg et le reste de la liste, on assigne ainsi de manière récursive à chaque appel de send
        @P=Msg|X
        P:=X
    end
end

local S P X in
    P={NewPort S}
    {Send P 5}
    {Browse S}
    {Send P 6}
end

%Exercice 4
declare
fun {NewPortClose S}
    {NewCell S}
end

proc {Send P Msg}
    local X in
        @P=Msg|X
        P:=X
    end
end

proc {Close P}
    @P=nil
end

local S P X in
    P={NewPort S}
    {Send P 5}
    {Browse S}
    {Send P 6}
    {Delay 4000}
    {Close P}
end

%Exercice 5
declare
fun {Q A B}
    Acc
    fun {Sum A B Acc}
        if A>B then
            @Acc
        else
            Acc:=A+@Acc
            {Sum A+1 B Acc}
        end
    end
in
    Acc={NewCell 0}
    {Sum A B Acc}
end

{Browse {Q 5 10}}

%Exercice 6.A
declare
class Counter
    attr i
    meth init(X)
        i:=X
    end
    meth add(N)
        i:=N+@i
    end
    meth read(N)
        N=@i
    end
end

C1={New Counter init(1)}
{C1 add(5)}
local N in
    {C1 read(N)}
    {Browse N}
end

%Exercice 6.B
declare
class Port
    attr S
    meth init(X)
        S:=X
    end
    meth send(X)
        local New in
            @S=X|New
            S:=New
        end
    end
end
local S P X in
    P={New Port init(S)}
    {P send(5)}
    {Browse S}
    {P send(6)}
end

%Exercice 6.C 
declare %Héritage marche pas car il ne reconnait pas S
class PortClose
    attr S
    meth init(X)
        S:=X
    end
    meth send(X)
        local New in
            @S=X|New
            S:=New
        end
    end
    meth close(X)
        @S=nil
        X=@S
    end
end

local S P X in
    P={New PortClose init(S)}
    {P send(5)}
    {Browse S}
    {P send(6)}
    {P close(X)}
end