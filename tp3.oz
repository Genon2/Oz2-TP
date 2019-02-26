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