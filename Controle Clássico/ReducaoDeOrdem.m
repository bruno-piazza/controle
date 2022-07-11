function sysred=ReducaoDeOrdem(sys)
%%  Verificação dos polos não dominantes
[sysb,g]=balreal(sys);
g'

%% Definição dos polos a serem excluídos
poldel = input('Quais polos devem ser deletados? Vetor com o índice deles (ordem que aparece em g) ');

%% Redução da ordem
sysred=modred(sysb,poldel,'del')