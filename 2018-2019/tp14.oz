%Exercice 1 
%Monitor définition
%%%%%% Queue (extended concurrent stateful version)
declare
fun {NewQueue}
   X C={NewCell q(0 X X)}
   L={NewLock}
   proc {Insert X}
      N S E1 in
      lock L then
	 q(N S X|E1)=@C
	 C:=q(N+1 S E1)
      end
   end

   fun {Delete}
      N S1 E X in
      lock L then
	 q(N X|S1 E)=@C
	 C:=q(N-1 S1 E)
      end
      X
   end

   fun {Size}
      lock L then @C.1 end
   end

   fun {DeleteAll}
      lock L then
	 X q(_ S E)=@C in
	 C:=q(0 X X)
	 E=nil S
      end
   end

   fun {DeleteNonBlock}
      lock L then
	 if {Size}>0 then {{Delete}} else nil end
      end
   end
in
   queue(insert:Insert delete:Delete size:Size deleteAll:DeleteAll deleteNonBlock:DeleteNonBlock)
end

%%%%%% Lock (reentrant get-release version)
declare
fun {NewGRLock}
   Token1={NewCell unit}
   Token2={NewCell unit}
   CurThr={NewCell unit}

   fun {GetLock}
      if {Thread.this}\=@CurThr then Old New in
	 {Exchange Token1 Old New}
	 {Wait Old}
	 Token2:=New
	 CurThr:={Thread.this} true
      else false end
   end

   proc {ReleaseLock}
      CurThr:=unit
      unit=@Token2
   end
in
   'lock'('get':GetLock release:ReleaseLock)
end

fun {NewMonitor}
   Q={NewQueue}
   L={NewGRLock}

   proc {LockM P}
      if {L.get} then try {P} finally {L.release} end else {P} end
   end

   proc {WaitM}
      X in
      {Q.insert X} {L.release} {Wait X} if {L.get} then skip end
   end

   proc {NotifyM}
      U = {Q.deleteNonBlock} in
      case U of [X] then X=unit else skip end
   end

   proc {NotifyAllM}
      L={Q.deleteAll} in
      for X in L do X=unit end
   end
in
   monitor('lock':LockM wait:WaitM notify:NotifyM notifyAll:NotifyAllM)
end

%Exercice 1 commence
class Mvar 
   attr Monitor Cell
   meth init
      Monitor:={NewMonitor}
      Cell:=0
   end
   meth put(X)
      {@Monitor.'lock'
         proc{$}
            if @Cell\=0 then 
               {@Monitor.wait}
               {self put(X)}
            else
               Cell:=X
               {@Monitor.notifyAll}
            end
         end}
   end
   meth get(X)
      {@Monitor.'lock'
         proc{$}
            if @Cell==0 then 
               {@Monitor.wait}
               {self get(X)}
            else
               X=@Cell
               Cell:=0
               {@Monitor.notifyAll}
            end
         end}
   end
end

proc{MakeMvar ?Put ?Get}
    M 
in
   M={New Mvar init}
   Put=proc{$ X} {M put(X)} end
   Get=proc{$ ?X}{M get(X)} end
end

local X Y Put Get in
    {MakeMvar Put Get}
    thread {Put 2} end
    thread {Put 3} end
    thread {Get X} end
    thread {Get Y} end
    {Browse X}
    {Browse Y}
end