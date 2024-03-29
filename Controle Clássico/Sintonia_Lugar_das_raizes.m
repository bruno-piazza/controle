% Sintonia por Lugar das Ra�zes (Executar c�lula por c�lula)
clc
clear all
close all
%% Par�metros do sistema
addpath('Matrizes\')

A = importdata('matrix_A1lin.txt');
B = -importdata('matrix_B1lin.txt');
C = importdata('matrix_C1.txt');
D = importdata('matrix_D1.txt');

t = 0:0.01:10;
%% Constru��o do sistema via espa�o de estados
sysSS=ss(A,B,C,D);

%% Constru��o da fun��o de transfer�ncia de malha aberta (q3->Rot Pr�pria)
[Num,Den] = ss2tf(A,B,C,D,3);
Num=Num(3,:);

sys=tf(Num,Den);
N=tf(Num,1);
D=tf(Den,1);
s=tf([1 0],1);

% [Gc,Kc]=compensador2P(-0.5+1i,Den)
% sys=series(Gc,sys)


figure(1)
step(sys)
grid on

figure(2)
pzmap(sys)
%% Sintonia proporcional

figure(3)
rlocus(sys)

%% Sintonia proporcional (continua��o)
kp=0.01 %Utilizar o mais adequado a partir do lugar das raizes anterior
Gkp=pid(kp,0,0); 
a=series(Gkp,sys); 
syskpmf=feedback(a,1)

figure(4)
step(syskpmf);

figure(5)
pzmap(syskpmf);
 

%% Sintonia integrativa
syskima=(N/(s*(D+(kp*N))));

figure(6)
rlocus(syskima)

%% Sintonia integrativa (continua��o)
ki=0 %Utilizar o mais adequado a partir do lugar das raizes anterior
Gki=pid(kp,ki,0); 
a=series(Gki,sys); 
syskimf=feedback(a,1)

figure(7)
step(syskimf); 

figure(8)
pzmap(syskimf);

%% Sintonia derivativa
syskdma=((N*(s^2))/(s*D+(kp*s*N)+(ki*N)));

figure(9)
rlocus(syskdma)

%% Sintonia derivativa (continua��o)
kd=0.0199 %Utilizar o mais adequado a partir do lugar das raizes anterior
Gkd=pid(kp,ki,kd); 
a=series(Gkd,sys); 
syskdmf=feedback(a,1)

figure(10)
[yLR]=step(syskdmf,t); 
stepinfo(syskdmf)

figure(11)
pzmap(syskdmf); 
%% Com compensador
close all
[Gc,Kc]=compensador2P(-0.5+1i,Den);
sysKc=series(Gc,sys);
Numcomp=tf(Gc.Numerator{1},1);
Dencomp=tf(Gc.Denominator{1},1);

figure(12)
step(sysKc)
grid on

figure(13)
pzmap(sysKc)

%% Sintonia proporcional
figure(14)
rlocus(sysKc)

%% Sintonia proporcional (continua��o)
kpKc=0.04 %Utilizar o mais adequado a partir do lugar das raizes anterior
GkpKc=pid(kpKc,0,0); 
a=series(GkpKc,sysKc); 
syskpmfKc=feedback(a,1)

figure(15)
step(syskpmfKc);

figure(16)
pzmap(syskpmfKc);
 

%% Sintonia integrativa
syskimaKc=(Numcomp*N/(s*(Dencomp*D+(kpKc*Numcomp*N))));

figure(17)
rlocus(syskimaKc)

%% Sintonia integrativa (continua��o)
kiKc=0.025 %Utilizar o mais adequado a partir do lugar das raizes anterior
GkiKc=pid(kpKc,kiKc,0); 
a=series(GkiKc,sysKc); 
syskimfKc=feedback(a,1)

figure(18)
step(syskimfKc); 

figure(19)
pzmap(syskimfKc);

%% Sintonia derivativa
syskdmaKc=((Numcomp*N*(s^2))/(s*Dencomp*D+(kpKc*s*Numcomp*N)+(kiKc*Numcomp*N)));

figure(20)
rlocus(syskdmaKc)

%% Sintonia derivativa (continua��o)
kdKc=0.02 %Utilizar o mais adequado a partir do lugar das raizes anterior
GkdKc=pid(kpKc,kiKc,kdKc); 
a=series(GkdKc,sysKc); 
syskdmfKc=feedback(a,1)

figure(21)
[yLRKc]=step(syskdmfKc,t); 
stepinfo(syskdmfKc)

figure(22)
pzmap(syskdmfKc); 



%% Plots oficiais
close all

figure(23)
plot(t,yLR,'linewidth',1.3)
hold on
plot(t,yLRKc,'linewidth',1.3)
grid on
title('Resposta �entrada do tipo degrau')
xlabel('Tempo [s]')
ylabel('Posi��o angular [rad]')
legend('Sem compensador','Com compensador','location','southeast')
baseFileName = sprintf('Image_%s.png', "LR");
fullFileName = fullfile("Imagens\", baseFileName);
saveas(23, fullFileName);

figure(24)
bode(syskdmf,syskdmfKc)
grid on
legend('Sem compensador','Com compensador','location','northeast')
baseFileName = sprintf('Image_%s.png', "Bode_LR");
fullFileName = fullfile("Imagens\", baseFileName);
saveas(24, fullFileName);
grid on
baseFileName = sprintf('Image_%s.png', "Margem_ZN");
fullFileName = fullfile("Imagens\", baseFileName);
Fh = gcf;                                                   % Handle To Current Figure
Kids = Fh.Children;                                         % Children
AxAll = findobj(Kids,'Type','Axes');                        % Handles To Axes
Ax1 = AxAll(1);                                             % First Set Of Axes
LinesAx1 = findobj(Ax1,'Type','Line');                      % Handle To Lines
LinesAx1(2).LineWidth = 1.3;                                  % Set �LineWidth�
Ax2 = AxAll(2);  


figure(25)
% margin(syskdmf)
% hold on
margin(syskdmfKc)
grid on
%legend('Sem compensador','Com compensador','location','northeast')
grid on
Fh = gcf;                                                   % Handle To Current Figure
Kids = Fh.Children;                                         % Children
AxAll = findobj(Kids,'Type','Axes');                        % Handles To Axes
Ax1 = AxAll(1);                                             % First Set Of Axes
LinesAx1 = findobj(Ax1,'Type','Line');                      % Handle To Lines
LinesAx1(2).LineWidth = 1.3;                                  % Set �LineWidth�
Ax2 = AxAll(2);                                             % Second Set Of Axes
LinesAx2 = findobj(Ax2,'Type','Line');                      % Handle To Lines
LinesAx2(2).LineWidth = 1.3;                                  % Set �LineWidth�
Ax2 = AxAll(2);  
baseFileName = sprintf('Image_%s.png', "Margem_LR");
fullFileName = fullfile("Imagens\", baseFileName);
saveas(25, fullFileName);

figure(26)
pzmap(syskdmf)
baseFileName = sprintf('Image_%s.png', "PZ_LR");
fullFileName = fullfile("Imagens\", baseFileName);
saveas(26, fullFileName);

figure(27)
pzmap(syskdmfKc)
baseFileName = sprintf('Image_%s.png', "PZ_LR_comp");
fullFileName = fullfile("Imagens\", baseFileName);
saveas(27, fullFileName);