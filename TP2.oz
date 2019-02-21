%Exercice 1.A
declare
proc{Max L R1}
   local
      proc{MaxLoop L M R2}
	 case L of nil then R2=M
	 []H|T then
	    if M>H then {MaxLoop T M R2}
	    else {MaxLoop T H R2} end
	 end
      end
   in
      if L==nil then R1=error
      else {MaxLoop L.2 L.1 R1}
      end
   end
end

% Exerice 1b
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

% Exercice 2a
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

% Exercice 2
% La fonction n'est pas tail récursive car on a un "H|{Append ...}"
% Non tail-recursive :
declare
fun{Sum N}
   fun{Sumb N Acc}
      if N==0 then Acc
      else
	 {Sumb N-1 N+Acc}
      end
   end
in
   {Sumb N 0}
end
{Browse {Sum 5}}

%Exercice 2.B
declare
%Code du cours de Oz1
fun  {Append Xs Ys Zs}
   case Xs
   of nil then Zs=Ys
   [] X|Xr then
      local Zr in
	 Zs=X|Zr
	 {Append Xr Ys Zr}
      end
   end
end  

%Exercice 4.A
declare
proc {Pairs L E}
   case L of nil then skip
   [] H|T then
      {Browse pair(H E)}
      {Pairs T E}
   end
end

proc{ForAllTail Xs P}
   case Xs of nil then skip
   []H|T then
      {P Xs}
      {ForAllTail T P}
   end
end
{ForAllTail [a b c d] proc {$ Tail}
			 {Pairs Tail.2 Tail.1}
		      end}

%Exercice 4b
declare
fun{GetElementsInOrder Tree}
   case Tree
   of tree(info:I left:nil right:nil) then [I]
   [] tree(info:I left:nil right:R) then {Append [I] {GetElementsInOrder R}}
   [] tree(info:I left:L right:nil) then {Append {GetElementsInOrder L} [I]}
   [] tree(info:I left:L right:R) then
      {Append {Append {GetElementsInOrder L} [I]} {GetElementsInOrder R}}
   end     
end

{Browse {GetElementsInOrder tree(info:10
				 left:tree(info:7
					   left:nil
					   right:tree(info:9
						      left:nil
						      right:nil))
				 right:tree(info:18
					    left:tree(info:14
						      left:nil
						      right:nil)
					    right:nil))}}

%Exercice 5
declare
fun{Fib1 N}
   if N==0 then 0
   elseif N==1 then 1
   else {Fib N-1}+{Fib N-2}
   end
end
{Browse {Fib1 100}}

fun{Fib2 N}
   fun{Fibb N I Acc1 Acc2}
      if N==0 then 0
      elseif N=<2 then 1
      elseif I=<N then {Fibb N I+1 Acc2 Acc1+Acc2}
      else Acc2
      end
   end
in
   {Fibb N 3 1 1}
end

{Browse {Fib2 100}}

%Exercice 6
declare
fun{AddDigits D1 D2 CI}
   local Sum in
      Sum = (D1+D2+CI)
      if Sum > 1 then
	 output(sum:Sum mod 2 carry:1)
      else
	 output(sum:Sum mod 2 carry:0)
      end
   end
end
{Browse {AddDigits 1 0 0}}
{Browse {AddDigits 1 1 0}}
{Browse {AddDigits 1 0 1}}
{Browse {AddDigits 1 1 1}}