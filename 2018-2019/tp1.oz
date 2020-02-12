declare
% Exercice 2
{Browse 'Hello Nurse'}
{Browse "Hello Nurse"} % Donne le code ASCII de chaque caractère

%Exercice 3
local 
    X=x Y=y Z=z
in
    {Browse X|Y|Z|nil} % Utilise une liste pour afficher plusieurs chose dans un Browse
end

%Exercice 4
local
    F1  = fun {$ X} X*X end
    F2  = fun {$ X} X+X end
in
    {Browse (({F1 3} - {F2 3}) + 4)} % Il faut changer 4.0 en 4 car il y a une erreur dans l'addition d'Integer avec les Float
end

%Exercice 5
local L
    fun{Roots X Y Z}
        local A B C D in
            A=(Y*Y)-(4*X*Z)
            B={Float.toInt {Sqrt {Int.toFloat A}}} % Sqrt se trouve dans la librairie de Float et ne travaille qu'avec eux. On doit donc changer la valeurs en float pour calculer la racine et ensuite on la caste en Integer pour continuer les calcule.
            C= (~Y - B) div (2*X)
            D= (~Y + B) div (2*X)
            [C D]
        end
    end
in
    L={Roots 1 5 ~150}
    {Browse L}
end

%Exercice 6
local X in % On réassigne une valeur au même X
    X = a
    X = b
end


local X in % On assigne une valeur à un X différent car le local crée un nouveau X 
    X = a
    local X in
        X = b
    end
end
 
local
    Y = 1
    X = 1
in
    local
        Y=2
    in
        {Browse [X Y]} % Affiche le X et Y le plus proche, càd X=1 et Y=2 et Y=1 est oublié dans ce local.
    end
{Browse [X Y]} % Affiche le X et Y le plus proche X=1 et Y=1 et non Y=2 car il n'existe plus à ce stade
end

%Exercice 7
% a:3 
% b:1 car c'est une liste dans une liste 
{Browse {List.length [[1 2 3]]}}
%c 
local 
    L=[[1 2 3]]
in
    {Browse L.1.2.1}
end
%d 
local 
    L=[[1 2 3]]
in
    {Browse {Nth {Nth L 1} 2}}
end
%e On obtient "true" car on obtient la même liste, chaque élément qui n'a pas de nom obtient un chiffre qui correspond à sa position dans l'assignement
%f
local 
    R='#'(a [b '#'(c d) e] f)
in
    {Browse R.2.2.1.2}
end

%Exercice 8
declare
    X=a(1 X) % Puisque X s'appelle lui même, il se rédéfinit lui-même à l'infini
    {Browse X}

%Exercice 9
local X Y in
    X=1|2|Y
    X=Y
    {Browse X.2.2.1}
end

local X Y Z in % Z se trouvera à la fin de la liste sinon ce n'est que des 1
    X=1|X
    Y=X|Z
    Z=2|3|4|nil
    {Browse Y.1.2.1}
end

local X Y Z in % On aura que des b avec e f g h à la fin de la liste 
    X=a(b X)
    Y=c(X Z)
    Z=d(e f g h)
    {Browse Y.1.2.1}
end