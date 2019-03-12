declare
fun{Numbers N I J}
   local X Y in
      X={OS.rand}
      Y=(X mod J-I)+I
      {Delay 500}
      if N==0 then nil
      else
	 Y|{Numbers N-1 I J}
      end
   end
end


proc{SumAndCount L R1 R2}
   fun{SumAndCount L A1 A2}
      {Delay 250}
      case L of nil then A1|A2|nil
      []H|T then
	 local X Y in
	    X=H+A1
	    Y=A2+1
	    {SumAndCount T X Y}
	 end
      end
   end
in
   local X in
      X={SumAndCount L 0 0}
      R1=X.1
      R2=X.2.1
   end
end

fun{FilterList Xs Ys}
   fun{Filter H Ys}
      case Ys of nil then true
      [] C|T then
	 if C==H then false
	 else
	    {Filter H T}
	 end
      end
   end
in
   case Xs of nil then nil
   [] H|T then
      if {Filter H Ys} then
	 H|{FilterList T Ys}
      else
	 {FilterList T Ys}
      end
   end
end

local R1 R2 L1 L2 in
   L1={Numbers 10 0 9}
   {Browse L1}
   L2={FilterList L1 0|2|4|nil}
   {Browse L2}
   {SumAndCount L2 R1 R2}
   {Browse R1}
   {Browse R2}
end

declare
fun{NotGate Xs}
   case Xs of nil then nil
   [] H|T then
      if H = 1 then 0|{NotGate T}
      else 1
      end
   end
end
fun{OrGate Xs Ys}
   case Xs of nil then nil
   [] H|T then
      case Ys of nil then nil
      [] X|Y then
	 if X==1 orelse Y==1 then
	    1|{OrGate T Y}
	 else
	    0|{OrGate T Y}
	 end
      end
   end
end
fun{AndGate Xs Ys}
   case Xs of nil then nil
   [] H|T then
      case Ys of nil then nil
      [] X|Y then
	 if X==1 andthen Y==1 then
	    1|{AndGate T Y}
	 else
	    0|{AndGate T Y}
	 end
      end
   end
end
fun{Simulate G Ss}
   if {String.toInt G.value}=={String.toInt 'or'} then
      case G.2 of gate then {Simulate G.2 Ss}
      []input then
	 if {String.toInt input.1}=={String.toInt 'x'} then
	    
   elseif {String.toInt G.value}=={String.toInt 'and'} then
      {Simulate G.2 {AndGate Ss.x Ss.y}}
   else
      {Simulate G.2 {NotGate Ss.}}
   end
end

local G in
      G=gate(value:'or' gate(value:'and' input(x) input(y)) gate(value:'not' input(z)))
      {Browse {Simulate G input(x:1|0|1|0|nil y:0|1|0|1|nil z:1|1|0|0|nil)}}
end   