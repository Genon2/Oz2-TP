%Exercice 1
declare
proc {ReadList L}
    case L of H|T then
        {Browse H}
        {ReadList T}
    [] nil then skip
    end
end

{ReadList [1 2 3 4 5 caca]}
%Exercice 2
declare
P S
{NewPort S P}
{Browse S}
{Send P foo}
{Send P bar}

%Exercice 3
declare
proc {ReadList L}
    {Wait L}
    case L of H|T then
        {Browse H}
        {ReadList T}
    end
end

local S P in 
    {NewPort S P}
    {Send P foo}
    {Send P caca}
    {Send P 5}
    {ReadList S}
end

%Exercice 4
declare
proc {RandomSenderManiac N P}
    proc {Show P Number}
        local X Y in
            X={OS.rand}
            Y=(X mod 3-1)+1
            {Delay Y*1000}
            {Send P Number}
        end
    end
    proc {RandomSenderManiacB N P Acc}
        if Acc==N then skip
        else
            thread {Show P Acc} end
            {RandomSenderManiacB N P Acc+1}
        end
    end
in
    {RandomSenderManiacB N P 1}
end

proc {ReadList L}
    {Wait L}
    case L of H|T then
        {Browse H}
        {ReadList T}
    end
end

%Exercice 5
local S P in
    {NewPort S P}
    {RandomSenderManiac 10 P}
    {ReadList S}
end

%Exercice 6
declare
fun {WaitTwo X Y}
    local R in
        thread 
            case X of H|T then
                {Wait H}
                R=1
            end
        end
        thread
            case Y of H|T then
                {Wait H}
                R=2
            end
        end
        R
    end
end
local S1 S2 in
    {Browse {WaitTwo S1 [2]}}
end

%Exercice 7
declare
proc{Server S}
    case S of H|T then
        case H of Msg#Ack then
            local X Y in
                X={OS.rand}
                Y=(X mod 1500-500)+500
                {Delay Y}
                Ack=unit
                {Server T}
            end
        end
    end
end

local S P Ack in
    {NewPort S P}
    {Send P hello#Ack}
    {Browse S}
    {Server S}
end

%Exercice 8
declare
proc{Server S}
    {Browse S}
    case S of H|T then
        case H of Msg#Ack then
            local X Y in
                X={OS.rand}
                Y=(X mod 1500-500)+500
                {Delay Y}
                Ack=unit
                {Server T}
            end
        end
    end
end

fun {SafeSend P M T}
    local Ack R in
        {Send P M#Ack}
        thread {Wait Ack} R=true end
        thread {Delay T} R=false end
        {Wait R}
        R
    end
end

local S P in
    {NewPort S P}
    thread {Browse {SafeSend P lol 1000}} end
    {Server S}
end

%Exercice 9.A J'ai pas vraiment réussi les précédents donc je skip la suite
%J'essaierai de la faire avant l'exam pour m'échauffer


%Exercice 9.B = 42