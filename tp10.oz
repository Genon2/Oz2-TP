%Exercice 2 
%Lift.oz mieux indenté pour VScode
fun {Timer}
   {NewPortObject2
   proc {$ Msg}
      case Msg of starttimer(T Pid) then
	  		thread {Delay T} {Send Pid stoptimer} end
      end
   end}
end

fun {Controller Init}
   Tid = {Timer}
   Cid = {NewPortObject Init
	  	fun {$ state(Motor F Lid) Msg}
	     	case Motor
	     	of running then
				case Msg
				of stoptimer then
                    {Send Lid 'at'(F) }
                    state(stopped F Lid)
                end
	     	[] stopped then
				case Msg
				of step(Dest) then
                    if F==Dest then
                        state(stopped F Lid)
                    elseif F < Dest then
                        {Send Tid starttimer(1000 Cid)}
                        state(running F+1 Lid)
                    else
                        {Send Tid starttimer(1000 Cid)}
                        state(running F-1 Lid)
                    end
				end
	   	    end
	  	end}
in Cid end

fun {Floor Num Init Lifts}
   Tid= {Timer}
   Fid= {NewPortObject Init
	 fun {$ state(Called) Msg}
	    	case Called
	    	of notcalled then Lran in
                case Msg
                of arrive(Ack) then
                        {Browse 'Lift at floor '#Num#': open doors'}
                        {Send Tid starttimer(2000 Fid)}
                        state(doorsopen(Ack))
                [] call then
                        {Browse 'Floor '#Num#' calls a lift!'}
                        Lran=Lifts.(1+{OS.rand} mod {Width Lifts})
                        {Send Lran call(Num)}
                        state(called)
                end
	    	[] called then
                case Msg
                of arrive(Ack) then
                    {Browse 'Lift at floor'#Num#': open doors'}
                    {Send Tid starttimer(2000 Fid)}
                    state(doorsopen(Ack))
                [] call then
                    state(called)
                end
	    	[] doorsopen(Ack) then
		  		case Msg
		  		of stoptimer then
		     		{Browse 'Lift at floor '#Num#': close doors'}
		     		Ack=unit
		     		state(notcalled)
		  		[] arrive(A) then
		     		A = Ack
		     		state(doorsopen(Ack))
		  		[] call then
		     		state(doorsopen(Ack))
		  		end
	        end
	    end}
in Fid end

fun {ScheduleLast L N}
   if L\=nil andthen {List.last L} == N then L
   else {Append L [N]} end
end

fun {Lift Num Init Cid Floors}
   {NewPortObject Init
    fun {$ state(Pos Sched Moving) Msg}
		case Msg
		of call(N) then
			{Browse 'Lift '#Num#' needed at floor '#N}
			if N==Pos andthen {Not Moving} then
				{Browse 'At '#N#' floor!'} 
				{Wait {Send Floors.Pos arrive($)}}
				state(Pos Sched false)
			else Sched2 in
				Sched2={ScheduleLast Sched N}
				if {Not Moving} then
				{Send Cid step(N)} end
				state(Pos Sched2 true)
			end
		[] 'at'(NewPos) then
			{Browse 'Lift '#Num#' at floor '#NewPos}
			case Sched
			of S|Sched2 then
				if NewPos==S then 
					{Wait {Send Floors.S arrive($)}}
					if Sched2==nil then
						state(NewPos nil false)
					else
						{Send Cid step(Sched2.1)}
						state(NewPos Sched2 true)
					end
				else
					{Send Cid step(S)}
					state(NewPos Sched Moving)
				end
			end
		end
   end}
end

declare
proc {Building FN LN ?Floors ?Lifts}
    Lifts={MakeTuple lifts LN}
    for I in 1..LN do Cid in
        Cid= {Controller state(stopped 1 Lifts.I)}
        Lifts.I={Lift I state(1 nil false) Cid Floors}
    end
    Floors={MakeTuple floors FN}
    for I in 1..FN do
        Floors.I={Floor I state(notcalled) Lifts}
    end
end

%Nouvelle version de {Building} question théorique
proc {Building FN LN ?Floors ?Lifts} C in
    {Controller C}
    Lifts={MakeTuple lifts LN}
    for I in 1..LN do Cid in
        Lifts.I={Lift I state(1 nil false) C Floors}
    end
    Floors={MakeTuple floors FN}
    for I in 1..FN do
        Floors.I={Floor I state(notcalled) Lifts}
    end
end
% Il y a deux réponces : Soit le code ne fonctionne pas car C n'est pas définit
% Si il n'y avait pas d'erreur, il n'y aurait qu'un seul lift qui serait controlé par Controller


%Exercice 3,4,5,6,7 -> Théorie