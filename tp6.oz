%1
declare
proc{ReadList L}
   case L of nil then skip
   []H|T then
      {Browse H}
      {ReadList T}
   end
end
{ReadList [1 2 3 4]}

%2-3
declare
P S
{NewPort S P}
{Send P foo}
{Send P bar}
{Send P foo}
{Browse S}
{ReadList S}

%4
declare
proc{RandomSenderManiac N P}
   proc{Loop I}
      if I>N then skip
      else
	 thread
	    {Delay {OS.rand} mod 3000 +1000}
	    {Send P I}
	 end
      {Loop I+1}
      end
   end
in
   {Loop 1}
end
%5
fun{BrowserPort}
   Sin in
   thread {ReadList Sin} end
   {NewPort Sin}
end
P={BrowserPort}
{RandomSenderManiac 5 P}

%6
declare
