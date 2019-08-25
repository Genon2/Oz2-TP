%Exercice 1.A
declare % le terme lazy après le fun détermine que la fonction n'est appelé que lorsqu'un autre thread lance {Wait}
fun lazy {Gen I}
    I|{Gen I+1}
end
X={Gen 5}
{Browse X}
{Wait X}
{Browse X.2.2.2.1}
%{List.take X 10 _} % Affiche les 10 premier élément de la liste X

%Exercice 1.B
{Browse [X.1 X.2.1 X.2.2.1]}

%Exercice 1.C
fun {GiveMeNth N L}
    case L of H|T then
        if N==0 then
            H
        else
            {GiveMeNth N-1 T} 
        end
    end
end

{Browse {GiveMeNth 5 X}}

%Exercice 2.A
declare
fun lazy {Primes I}
    if {Filter I} then
        I|{Primes I+1}
    else 
        {Primes I+1}
    end
end

fun lazy {Filter I} %Il fallait prendre la version original de Filter mais j'ai préféré tout changer :p
    fun {FilterB I Acc}
        if Acc>=I then true
        else
            if I mod Acc == 0 then false
            else {FilterB I Acc+1}
            end
        end
    end
in
    {FilterB I 2}
end

X={Primes 1}
{Browse X}
{List.take X 10 _}

%Exercice 2.B
declare
fun lazy {Gen I}
    I|{Gen I+1}
end

fun lazy {Filter Xs P}
    case Xs of nil then nil
    []X|Xr then
        if {P X} then
            X|{Filter Xr P}
        else
            {Filter Xr P}
        end
    end
end

fun lazy {Sieve Xs}
    case Xs of nil then nil
    [] X|Xr then 
        X|{Sieve {Filter Xr fun{$ Y} Y mod X\=0 end}}
    end
end

X={Gen 5}
Y={Sieve X}
{Browse Y}
{List.take Y 10 _}

%Exercice 3
declare
fun lazy {Primes I}
    if {Filter I} then
        I|{Primes I+1}
    else 
        {Primes I+1}
    end
end

fun lazy {Filter I} %Il fallait prendre la version original de Filter mais j'ai préféré tout changer :p
    fun {FilterB I Acc}
        if Acc>=I then true
        else
            if I mod Acc == 0 then false
            else {FilterB I Acc+1}
            end
        end
    end
in
    {FilterB I 2}
end

proc {ShowPrimes N}
    proc {ShowPrimesB N L}
        if N==0 then 
            skip
        else
            case L of H|T then
                {Browse H}
                {ShowPrimesB N-1 T}
            [] nil then skip
            end
        end
    end
in
    {ShowPrimesB N {Primes 1}}
end

{ShowPrimes 5}

%Exercice 4
declare
fun lazy {Gen I N}
    {Delay 500}
    if I==N then [I] else I|{Gen I+1 N} end
end
fun lazy {Filter L F}
    case L of nil then nil
    []H|T then 
        if {F H} then H|{Filter T F} else {Filter T F} end
    end
end
fun {Map L F}
    case L of nil then nil
    [] H|T then {F H}|{Map T F}
    end
end

Xs Ys Zs
% thread {Browse Zs} end
% thread {Gen 1 100 Xs} end
% thread {Filter Xs fun {$ X} (X mod 2)==0 end Ys} end
% thread {Map Ys fun {$ X} X*X end Zs} end

{Browse Zs}
{Gen 1 100 Xs}
{Filter Xs fun {$ X} (X mod 2)==0 end Ys}
{Map Ys fun {$ X} X*X end Zs}
{Wait Zs}

%Exercice 5.A
declare 
fun {Insert X Ys} % ??? Fleme 
    {Show 2}
    case Ys of nil then [X]
    []Y|Yr then
        if X<Y then X|Ys
        else Y|{Insert X Yr}
        end
    end
end

fun {InSort Xs} % N
    {Show 1}
    case Xs of nil then nil
    [] X|Xr then {Insert X {InSort Xr}}
    end
end
fun {Minimum Xs}
    {InSort Xs}.1
end

X={Minimum [3 2 1]} % On passe 6x dans Insert et 4x dans Insort
Y={Minimum [5 4 3 2 1]} % On passe 15x dans Insert et 6x dans Insort

%Exercice 5.B
declare 
fun lazy {Insert X Ys} % N-1 
    {Show 2}
    case Ys of nil then [X]
    []Y|Yr then
        if X<Y then X|Ys
        else Y|{Insert X Yr}
        end
    end
end

fun lazy {InSort Xs} % N
    {Show 1}
    case Xs of nil then nil
    [] X|Xr then {Insert X {InSort Xr}}
    end
end
fun lazy {Minimum Xs}
    {InSort Xs}.1
end

X={Minimum [3 2 1]} % On passe 3x dans Insert et 4x dans Insort
Y={Minimum [5 4 3 2 1]} % On passe 5x dans Insert et 6x dans Insort
% {Browse X}
% {Wait X}
{Browse Y}
{Wait Y}

%Exercice 6
declare %Etonnament, cela ne change rien d'implementer Insert et Insort de manière Lazy dans ce cas-ci
fun lazy {Insert X Ys} % Fleme 2
    {Show 2}
    case Ys of nil then [X]
    []Y|Yr then
        if X<Y then X|Ys
        else Y|{Insert X Yr}
        end
    end
end

fun lazy {InSort Xs} % N
    {Show 1}
    case Xs of nil then nil
    [] X|Xr then {Insert X {InSort Xr}}
    end
end

fun {Last Xs}
    case Xs of [X] then X
    [] X|Xr then {Last Xr}
    end
end
fun{Maximum Xs}
    {Last {InSort Xs}}
end

% Il me semble qu'on exécute la fonction après car on parcourt la liste qui correspond à Insort Xs

X={Maximum [3 2 1]} % On passe 6x dans Insert et 4x dans Insort
% Y={Maximum [5 4 3 2 1]} % On passe 15x dans Insert et 6x dans Insort
{Browse X}
{Wait X}
% {Browse Y}
% {Wait Y}

%Exercice 7
% Make sure you understood the exercise on thread termination from last week (specially the
% concurrent MapRecord). We are sorry to be so insistent, but we are the assistants, and in
% “The Secret Book of the Teaching Assistant” there is a rule that says we have to be a bit
% annoying. So, not our fault! Blame Canada!

% SO ... WTF ?! XD

%Exercice 8
declare
fun {Buffer In N}
    End=thread {List.drop In N} end
    fun lazy {Loop In End}
        case In of I|In2 then
            I|{Loop In2 thread End.2 end}
        end
    end
in 
    {Loop In End}
end

proc{DGenerate N Xs}
    case Xs of X|Xr then
        X=N
        {DGenerate N+1 Xr}
    end
end
fun{DSum01 ?Xs A Limit}
    {Delay {OS.rand} mod 10}
    if Limit>0 then
        X|Xr=Xs
    in
        {DSum01 Xr A+X Limit-1}
    else A end
end
fun{DSum02 ?Xs A Limit}
    {Delay {OS.rand} mod 10}
    if Limit>0 then
        X|Xr=Xs
    in
        {DSum02 Xr A+X Limit-1}
    else A end
end
local Xs Ys V1 V2 in
    thread {DGenerate 1 Xs} end
    thread {Buffer 4 Xs Ys} end
    thread V1={DSum01 Ys 0 1500} end
    thread V2={DSum02 Ys 2 1500} end
    {Browse [Xs Ys V1 V2]}
end