function sysred=ReducaoDeOrdem(sys)
%%  Verifica��o dos polos n�o dominantes
[sysb,g]=balreal(sys);
g'

%% Defini��o dos polos a serem exclu�dos
poldel = input('Quais polos devem ser deletados? Vetor com o �ndice deles (ordem que aparece em g) ');

%% Redu��o da ordem
sysred=modred(sysb,poldel,'del')