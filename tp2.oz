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

declare
fun{Append Xs Ys}
   case Xs of nil then Ys
   []X|Xr then
      local Zr Zs in
	 Zr={Append Xr Ys}
	 Zs=X|Zr
      end
   end
end

{Browse {Append [1 2 5] [3 4]}}

declare
proc{ForAllTail Xs P}
   case Xs of nil then skip
   []H|T then
      {P Xs}
      {ForAllTail T P}
   end
end

proc {Pairs L E}
   case L of nil then skip
   []H|T then
      {Browse pair(H E)}
      {Pairs T E}
   end
end
{ForAllTail [a b c d] proc{$ Tail}{Pairs Tail.2 Tail.1} end}

declare
fun{GetElementsInOrder Tree}
   case Tree of tree(info:I left:nil right:nil) then [I]
   []tree(info:I left:L right:nil) then {Append {GetElementsInOrder L} [I]}
   []tree(info:I left:nil right:R) then {Append [I] {GetElementsInOrder R}}
   []tree(info:I left:L right:R) then {Append {Append{GetElementsInOrder L} [I]} {GetElementsInOrder R}}
   end
end

local Tree in
   Tree=tree(info:10 left:tree(info:7 left:nil right:nil) right:tree(info:18 left:tree(info:14 left:nil right:nil) right:nil))
   {Browse {GetElementsInOrder Tree}}
end

declare
fun{Fib X}
   if X==0 then 0
   elseif X<2 then 1
   else {Fib X-1}+{Fib X-2}
   end
end

{Browse {Fib 35}}

declare
fun{Fib X}
   fun{Fib X I Acc1 Acc2}
      if I=<X then {Fib X I+1 Acc2 Acc1+Acc2}
      else Acc2
      end
   end
in
   {Fib X 3 1 1}
end

{Browse {Fib 100}}

declare
fun{Add B1 B2}
   fun{In B1 B2}
      local Z in
	 case B1 of H1|nil then
	    Z={AddDigits H1 B2.1 0}
	    output(list:{Append [Z.sum] nil} carry:Z.carry)
	 []H1|T1 then
	    case B2 of H2|T2 then
	       local R Q in
		  R={In T1 T2}
		  Z={AddDigits H1 H2 R.carry}
		  output(list:{Append [Z.sum] R.list} carry:Z.carry)
	       end
	    end
	 end
      end
   end
in
   local X in
      X={In B1 B2}
      if X.carry==1 then
	 {Append [1] X.list}
      else
	 X.list
      end
   end
end
fun{AddDigits D1 D2 CI}
   local Sum in
      Sum=D1+D2+CI
      if Sum>1 then
	 output(sum:Sum mod 2 carry:1)
      else
	 output(sum:Sum mod 2 carry:0)
      end
   end
end

{Browse {Add [1 1 0 1 1 0] [0 1 0 1 1 1]}}