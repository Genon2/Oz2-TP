declare
A={NewCell 0}
B={NewCell 0}
T1=@A
T2=@B
{Show A==B} %False car designe un endroit dans la mémoire différent
{Show T1==T2} %True car désigne le même contenu
{Show T1=T2} % 0 qui est le réassignement de T1
A:=@B
{Show A==B} % False car il désigne toujours un espace memoire différent
{Show @A==@B}