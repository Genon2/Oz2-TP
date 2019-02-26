% Exercice 5
declare
fun {Prod N}
   N|{Prod N+1}
end
fun {Trans S1 Acc}
   case S1 of X|T1 then
      X+Acc|{Trans T1 X+Acc}
   end   
end
proc {Disp S2}
   case S2 of X|T2 then
      {Browse X}
      {Disp T2}
   end
end

declare S1 S2 in
thread S1={Prod 1} end
thread S2={Trans S1 0} end
thread {Disp S2} end

%Exercice 6
declare
fun {Prod N}
   N|{Prod N+1}
end
fun {Filter S3}
   case S3 of X|T1 then
      if X mod 2 == 1 then X|{Filter T1}
      else {Filter T1}
      end
   end
   
end
fun {Trans S1 Acc}
   case S1 of X|T1 then
      X+Acc|{Trans T1 X+Acc}
   end   
end
proc {Disp S2}
   case S2 of X|T2 then
      {Browse X}
      {Disp T2}
   end
end

declare S1 S2 S3 in
thread S1={Prod 1} end
thread S2={Filter S1} end
thread S3={Trans S2 0} end
thread {Disp S3} end