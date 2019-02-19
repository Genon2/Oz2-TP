declare
local L M R Max MaxLoop in
   Max=proc{$ L ?R} 
	MaxLoop=proc{$ L M ?R}
	    case L of nil then M
	    []H|T then
	       if M>H then R={MaxLoop T M R}
	       else R={MaxLoop T H R} end
	    end
	 end
   in
      if L==nil then error
      else {MaxLoop L.2 L.1 R}  end
   end
end 
{Browse {Max [4 5 6]}}

declare
fun{Fact N}
   fun{Fact N Acc1 Acc2}
      if N==Acc1 then Acc1*Acc2|nil
      elseif Acc1==1 then Acc1|{Fact N Acc1+1 Acc1}
      else Acc1*Acc2|{Fact N Acc1+1 Acc1*Acc2} end
   end
in
   {Fact N 1 0}
end
{Browse {Fact 4}}

declare
fun{Sum N}
   fun{Sum N Acc}
      if N==0 then Acc
      else {Sum N-1 Acc+N}
      end
   end
in
   {Sum N 0}
end
{Browse {Sum 4}}