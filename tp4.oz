%1
declare
local X Y Z in
X = Y+Z
Y = 1
Z = 2
{Browse X}
end

declare
local X Y Z in
X = plus(Y Z)%a c est un record et ce n est pas bloquant les variables sont mise à jour et stockées pour le b faire un thread
Y = 1
Z = 2
{Browse X}
end

%2
declare
fun {Counter InS}
   fun {ListAdd L E}
      case L
      of nil then [E#1]
      [] H|T then
	 if H.1 == E then
	    E#(H.2+1)|T
	 else
	    H|{ListAdd T E}
	 end
      end
   end
   fun {Count InS Acc}
      case InS of
	 nil then nil
      [] H|T then Acc2 in
         Acc2 = {ListAdd Acc H}
	 Acc2|{Count T Acc2}
      end
   end
in
   thread {Count InS nil} end
end

local
   InS
in
   {Browse {Counter InS}}
   InS=e|m|e|c|_
end

%3
declare
proc {PassingTheToken Id Tin Tout}
   case Tin of H|T then X in
      {Show Id#H}
      {Delay 1000}
      Tout = H|X
      {PassingTheToken Id T X}
   [] nil then
      skip
   end
end
local X Y Z in
thread {PassingTheToken 1 1|X Y}end
thread {PassingTheToken 2 Y Z}end
thread {PassingTheToken 3 Z X}end
{Browse X}
end

%4
declare
fun {Foo Beers Table}
   case Beers
   of H|T then
      local Ta in
         {Delay 1200}
         Table = free|Ta
         empty|{Foo T Ta}
      end
   end
end
fun {Bar Table}
   case Table
   of H|T then
      {Delay 500}
      full|{Bar T}
   end
end

Table = 1|2|3|4|_
Beers = thread {Bar Table} end
Ground = thread {Foo Beers {List.drop Table 4}} end
{Browse Beers}
{Browse Ground}

%5
declare
proc {MapRecord R1 F R2}
   A={Record.arity R1}
   proc {Loop L}
      case L of nil then skip
      [] H|T then
	 thread R2.H={F R1.H} end
	 {Loop T}
      end
   end
in
   R2={Record.make {Record.label R1} A}
   {Loop A}
end
{Show {MapRecord '#'(a:1 b:2 c:3 d:4 e:5 f:6 g:7) fun {$ X} {Delay 1000} 2*X end}}