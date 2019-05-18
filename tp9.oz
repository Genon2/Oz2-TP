declare
fun {LaunchServer}
   fun {Pow X Y Acc}
      if Y == 0 then Acc
      else {Pow X Y-1 Acc*X}
      end
   end
   proc {Loop Ms}
      case Ms of M|Mr then
         {Browse 'Case'}
   	   case M
	         of add(X Y Z) then Z=X+Y
               {Browse 'ADD'}
   	      [] pow(X Y Z) then 
               {Browse 'POW'}
               Z={Pow X Y 1}
   	      [] 'div'(X Y Z) then
               {Browse 'DIV'} 
               if Y==0 then Z='Nop'
               else Z = X div Y 
               end
   	      else {Browse 'message not understood'}
            end
            thread {Loop Mr}
   	   end
      end
   end
   I P
in
   P={NewPort I}
   thread {Loop I} end
   P
end

declare
A B N S
Res1 Res2 Res3 Res4 Res5 Res6
S = {LaunchServer}
{Send S add(321 345 Res1)}
{Wait Res1}
{Show Res1}
{Send S pow(2 N Res2)}
N = 8
{Wait Res2}
{Show Res2}
thread {Send S add(A B Res3)} end
{Send S add(10 20 Res4)}
{Send S foo}
{Wait Res4}
{Show Res4}
A = 3
B = 2
{Send S 'div'(90 Res3 Res5)}
{Send S 'div'(90 Res4 Res6)}
{Wait Res3}
{Show Res3}
{Wait Res5}
{Show Res5}
{Wait Res6}
{Show Res6}

% 2 ième exercice 
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

proc {ServeurPort ?M}
in
   
   {NewPort P}
   thread {Add P 0}
end
I={StudentCallBack}
J={ServeurPort}
{Send I ask(howmany:J)}