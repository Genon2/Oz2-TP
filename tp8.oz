% Exercice 1
declare
proc {ReadList L}
    case L of H|T then 
        {Browse H}
        {ReadList T}
    [] nil then skip
    end
end

{ReadList ['Hello' 'My' 'Name']}

% Exercice 2 et 3
declare P S
{NewPort S P}

{Send P foo}
{Send P bar}

% {Browse S}
{ReadList S}

% Exercice 4
declare
proc {RandomSenderManiac N P}
    proc {Loop I}
        if I>N then skip
        else
            thread 
                {Delay ({OS.rand} mod 3000)+1000}
                {Send P I}
            end
            {Loop I+1}
        end
    end
    in
        {Loop 1}
end

% Exercice 5
fun {BrowseAll}
    Stream in
    thread {ReadList Stream} end
    {NewPort Stream}
end
P={BrowseAll}
{RandomSenderManiac 4 P}

% Exercice 6
fun {WaitTwo X Y}
    case X of H|T then 1
TODO: To continue