%Exercice 1
declare
A B N S
Res1 Res2 Res3 Res4 Res5 Res6
proc {Server S}
    case S of H|T then
        {Wait H}
        case H of add(X Y ?R) then
            R=X+Y
            thread {Server T} end
        [] pow(X Y ?R) then
            R={Number.pow X Y}
            thread {Server T} end
        [] 'div'(X Y ?R) then
            if Y==0 then 
                R=0
            else
                R=X div Y
            end
            thread {Server T} end
        else 
            {Show 'message not understood'}
            thread {Server T} end
        end
    end
end

fun {LaunchServer} 
P S
in
    P={NewPort S}
    thread {Server S} end
    P
end

S={LaunchServer}
{Send S add(321 345 Res1)}
{Wait Res1}
{Show Res1}
{Send S pow(2 N Res2)}
N=8
{Wait Res2} %Add for see Res2
{Show Res2}

{Send S add(A B Res3)}
{Send S add(10 20 Res4)}
{Send S foo}
thread {Wait Res4} {Show Res4} end
A=3
B=0-A
{Browse A}
{Send S 'div'(90 Res3 Res5)}
{Browse 'Work'}
{Send S 'div'(90 Res4 Res6)}
{Wait Res3}
{Show Res3}
{Wait Res5}
{Show Res5}
{Wait Res6}
{Show Res6}

%Exercice 2 
declare
fun {StudentCallBack}
    S
in
    thread
        for ask(howmany:P) in S do
            {Send P {OS.rand} mod 24}
        end
    end
    {NewPort S}
end

fun{CreateUniversity Size}
    fun{CreateLoop I}
        if I=<Size then
            student|{CreateLoop I+1}
        else nil
        end
    end
in
    {CreateLoop 1}
end

proc {Response L P Pbeer}
    case L of H|T then
        {Wait H}
        case H of student then 
            {Send Pbeer ask(howmany:P)}
        end
        {Response T P Pbeer}
    [] nil then skip
    end
end
fun{Server}
    S
    proc {ServerB S Count Mean Max Min}
        case S of H|T then
            {Wait H}
            case H of info then
                {Browse [Count Mean div Count Max Min]}
                thread {ServerB T Count Mean Max Min} end
            else
                if H>Max then
                    thread {ServerB T Count+1 Mean+H H Min} end
                elseif H<Min then
                    thread {ServerB T Count+1 Mean+H Max H} end
                else
                    thread {ServerB T Count+1 Mean+H Max Min} end
                end
            end
        end
    end
in
    thread {ServerB S 0 0 0 28} end
    {NewPort S}
end

local P Pbeer List in
    thread List={CreateUniversity 100} end
    thread Pbeer={StudentCallBack} end
    thread P={Server} end
    thread {Response List P Pbeer} end
    {Delay 4000}
    {Send P info}
end

%Exercice 3
declare
fun {NewPortObject Behaviour Init}
    proc{MsgLoop S1 State}
        case S1 of Msg|S2 then
            {MsgLoop S2 {Behaviour Msg State}}
        []nil then skip
        end
    end
    Sin
in
    thread {MsgLoop Sin Init} end
    {NewPort Sin}
end

fun {Porter Msg State}
    case Msg of getInt(N) then State+N
    [] getOut(N) then State-N
    [] getCount(?N) then N=State
    end
end

local P N in
    P={NewPortObject Porter 0}
    {Send P getInt(5)}
    {Send P getCount(N)}
    {Browse N}
end

%Exercice 4
declare

fun {NewStack}
    fun {Stack Msg State}
        case Msg of push(X) then X|State
        [] pop(?R) then 
            R = State.1
            State.2
        [] isEmpty(?R) then
            if State == nil then R = true
            else R=false
            end
            State
        end
    end
    fun {NewPortObject Fun Init}
        proc {MsgLoop S1 State}
            case S1 of Msg|S2 then
                {MsgLoop S2 {Fun Msg State}}
            end
        end
        Sin
    in
        thread {MsgLoop Sin Init} end
        {NewPort Sin}
    end
in
    {NewPortObject Stack nil}
end

proc {Push S X}
    {Send S push(X)}
end

fun {Pop S}
    R in
    {Send S pop(R)}
    {Wait R}
    R
end

fun {IsEmpty S}
    R in
    {Send S isEmpty(R)}
    {Wait R}
    R
end

local Pile in
    Pile = {NewStack}
    {Push Pile 4}
    {Push Pile 5}
    {Browse {Pop Pile}}
    {Browse {Pop Pile}}
    {Browse {IsEmpty Pile}}
end