%% Sintonia por ITAE (Executar célula por célula)
clc
clear all
close all

%% Tempo
dt = 0.001;
tf = 90*60;
t = 0:dt:tf;

%% Planta 
addpath('Matrizes\')

A = importdata('matrix_A1lin.txt');
B = importdata('matrix_B1lin.txt');
B1 = -B;
C = [eye(3) zeros(3,3)];
sysma=ss(A,B,C,0);

p1 = -0.3+0.3i;
p2 = -0.4+0.3i;
p = [p1 conj(p1) p2 conj(p2) -0.5 -0.4];
K = place(A,B,p);

%% Seguidor de referência variável
%o distúrbio é causado pelo movimento da água e é simulado por deslocamentos senoidais em
%x e em y. Pode ser considerada uma corrente de velocidade constante fazendo omegad = 0
Adx = 0.1; %amplitude do distúrbio em x [m]
Ady = 0.2; %amplitude do distúrbio em y [m]
Adz = 0.0; %amplitude de distúrbio em z [rad]
omegad = 0.5; %frequência angular do distúrbio [rad/s]

%a referência é uma trajetória circular gerada pelas velocidades u e r ctes
Rr = 2; %raio da trajetória [m]
Tr = 30; %período da trajetória [s]

% Condições iniciais
xbarra0 = [0;0;0;0;0;0;1e-6;1e-6;1e-6;0;0;0;0;0;0];

%matriz dinâmica de referência
Ar = [1 0 0 0 0 0;
      0 1 0 0 0 0;
      0 0 1 0 0 0;
      0 0 0 0 0 0;
      0 0 0 0 0 0;
      0 0 0 0 0 0];

%matriz dinâmica de distúrbio
% Ad = [0 1 0 0 0 0;
%       -omegad^2 0 0 0 0 0;
%       0 0 0 1 0 0;
%       0 0 -omegad^2 0 0 0;
%       0 0 0 0 0 1;
%       0 0 0 0 -omegad^2 0];

Ad = 1/100*[-41.9938648159790	-35.9947506215021	-5795.14933552378;
        233304.083573796	199975.061457068	32195941.2600482;
        -1448.78938342553	-1241.82029553629	-199932.796599317];

%matriz de entrada de distúrbio
% B1 = [0 1 0 0 0 0;
%       0 0 0 1 0 0;
%       0 0 0 0 0 1;
%       0 0 0 0 0 0;
%       0 0 0 0 0 0;
%       0 0 0 0 0 0];
% B1 = [B1 zeros(6,3)];

%matriz singular (sistema quadrado)
Cbarra = [1 0 0 0 0 0;
          0 1 0 0 0 0;
          0 0 1 0 0 0];


%% Desenvolvimento
F = [B1 (A-Ar)];
F1 = A-B*K;
Kex = inv(Cbarra*inv(F1)*B)*Cbarra*inv(F1)*F;
A0 = [Ad zeros(3,6); zeros(6,3) Ar];
Ay = [B1 B*K]-B*Kex;
Abarra = [F1 Ay; zeros(9,6) A0];
C1 = eye(size(Abarra));
Bbarra = zeros(15,1);

sys2 = ss(Abarra,Bbarra,C1,0);

u=zeros(length(t),1);

[ys,ts,xbarra] = lsim(sys2,u,t,xbarra0);
% xbarra = step(sys2,t);

% plano s
[p_seg,z_seg]=pzmap(sys2);
pzmap(sys2)
grid on

figure(5);
plf=plot(t,xbarra(:,7),t,xbarra(:,8),t,xbarra(:,9));
legend('T_1','T_2','T_3');
xlabel('Tempo (s)');
ylabel('Distúrbios');

% figure(6);
% plf=plot(t,xbarra(:,10),t,xbarra(:,11),t,xbarra(:,12));
% legend('q_1','q_2','q_3');
% xlabel('Tempo (s)');
% ylabel('Referência posição');
% 
% figure(7);
% plf=plot(t,xbarra(:,13),t,xbarra(:,14),t,xbarra(:,15));
% legend('omega_1','omega_2','omega_3');
% xlabel('Tempo (s)');
% ylabel('Referência velocidade');

figure(8);
plf=plot(t,xbarra(:,1),t,xbarra(:,2),t,xbarra(:,3));
legend('q_1','q_2','q_3');
xlabel('Tempo (s)');
ylabel('Estado do sistema posições');

figure(9);
plf=plot(t,xbarra(:,4),t,xbarra(:,5),t,xbarra(:,6));
legend('omega_1','omega_2','omega_3');
xlabel('Tempo (s)');
ylabel('Estado do sistema velocidades');