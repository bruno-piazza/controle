function C=compensador2P(LR,D)
%% Setup das variáveis
P=roots(D);
%Polo 1
Pr1=real(P(1));
Pr2=real(P(2));
%Polo 2
Pi1=imag(P(1));
Pi2=imag(P(2));
%Ponto de interesse =
LRr=real(LR);
LRi=imag(LR);

%% Cálculo do avanço da fase
phi=(180-abs(atand(LRi/(LRr-Pr1))))+(180-abs(atand(LRi/(LRr-Pr2))))-180;

%% Cálculo de ângulos importantes
theta=abs(atand(LRi/LRr));
bicetriz=(180-theta)/2;
angaux=bicetriz-(90-theta);
    
%% Cálculo do zero
Zc=LRr-(tand(angaux-phi/2)*LRi);

%% Cálculo do polo
Pc=LRr-(tand(angaux+phi/2)*LRi);

%% Cálculo do ganho
K=abs(polyval(D,LR)*polyval([1 -Pc],LR)/polyval([1 -Zc],LR));
% D(end-1)=D(end-1)+1;
% D(end)=D(end)+Pc
%% FT do compensador
C=tf(K*[1 -Zc],[1  -Pc]);