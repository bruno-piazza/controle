% Sintonia por Lugar das Raízes (Executar célula por célula)
clc
clear all
close all
%% Parâmetros do sistema
addpath('Matrizes\')

A = importdata('matrix_A1lin.txt');
B = -importdata('matrix_B1lin.txt');
C = importdata('matrix_C1.txt');
D = importdata('matrix_D1.txt');

T=0:0.01:10;
%% Construção do sistema via espaço de estados
sysSS=ss(A,B,C,D);

%% Construção da função de transferência de malha aberta (q3->Rot Própria)
[Num,Den] = ss2tf(A,B,C,D,3);
Num=Num(3,:);

% Num=[1 1];
% Den=[1 3 12 -16 0]

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

figure(11)
rlocus(sys)

%% Sintonia proporcional (continuação)
kp=0.01 %Utilizar o mais adequado a partir do lugar das raizes anterior
Gkp=pid(kp,0,0); 
a=series(Gkp,sys); 
syskpmf=feedback(a,1)

figure(12)
step(syskpmf);

figure(13)
pzmap(syskpmf);
 

%% Sintonia integrativa
syskima=(N/(s*(D+(kp*N))));

figure(31)
rlocus(syskima)

%% Sintonia integrativa (continuação)
ki=0 %Utilizar o mais adequado a partir do lugar das raizes anterior
Gki=pid(kp,ki,0); 
a=series(Gki,sys); 
syskimf=feedback(a,1)

figure(32)
step(syskimf); 

figure(33)
pzmap(syskimf);

%% Sintonia derivativa
syskdma=((N*(s^2))/(s*D+(kp*s*N)+(ki*N)));

figure(41)
rlocus(syskdma)

%% Sintonia derivativa (continuação)
kd=0.0199 %Utilizar o mais adequado a partir do lugar das raizes anterior
Gkd=pid(kp,ki,kd); 
a=series(Gkd,sys); 
syskdmf=feedback(a,1)

figure(42)
[yLR]=step(syskdmf,T); 
stepinfo(syskdmf)

figure(43)
pzmap(syskdmf); 
%% Com compensador
close all
[Gc,Kc]=compensador2P(-0.5+1i,Den);
sysKc=series(Gc,sys);
Numcomp=tf(Gc.Numerator{1},1);
Dencomp=tf(Gc.Denominator{1},1);

figure(101)
step(sysKc)
grid on

figure(102)
pzmap(sysKc)
%% Sintonia proporcional
figure(111)
rlocus(sysKc)

%% Sintonia proporcional (continuação)
kpKc=0.04 %Utilizar o mais adequado a partir do lugar das raizes anterior
GkpKc=pid(kpKc,0,0); 
a=series(GkpKc,sysKc); 
syskpmfKc=feedback(a,1)

figure(112)
step(syskpmfKc);

figure(113)
pzmap(syskpmfKc);
 

%% Sintonia integrativa
syskimaKc=(Numcomp*N/(s*(Dencomp*D+(kpKc*Numcomp*N))));

figure(131)
rlocus(syskimaKc)

%% Sintonia integrativa (continuação)
kiKc=0.025 %Utilizar o mais adequado a partir do lugar das raizes anterior
GkiKc=pid(kpKc,kiKc,0); 
a=series(GkiKc,sysKc); 
syskimfKc=feedback(a,1)

figure(132)
step(syskimfKc); 

figure(133)
pzmap(syskimfKc);

%% Sintonia derivativa
syskdmaKc=((Numcomp*N*(s^2))/(s*Dencomp*D+(kpKc*s*Numcomp*N)+(kiKc*Numcomp*N)));

figure(141)
rlocus(syskdmaKc)

%% Sintonia derivativa (continuação)
kdKc=0.02 %Utilizar o mais adequado a partir do lugar das raizes anterior
GkdKc=pid(kpKc,kiKc,kdKc); 
a=series(GkdKc,sysKc); 
syskdmfKc=feedback(a,1)

figure(142)
[yLRKc]=step(syskdmfKc,T); 
stepinfo(syskdmfKc)

figure(143)
pzmap(syskdmfKc); 



%% Plots oficiais
close all

figure(51)
plot(T,yLR,'linewidth',1.3)
hold on
plot(T,yLRKc,'linewidth',1.3)
grid on
title('Resposta à entrada do tipo degrau')
xlabel('Tempo [s]')
ylabel('Posição angular [rad]')
legend('Sem compensador','Com compensador','location','southeast')
baseFileName = sprintf('Image_%s.png', "LR");
fullFileName = fullfile("Imagens\", baseFileName);
saveas(51, fullFileName);

figure(52)
bode(syskdmf,syskdmfKc)
grid on
legend('Sem compensador','Com compensador','location','northeast')
baseFileName = sprintf('Image_%s.png', "Bode_LR");
fullFileName = fullfile("Imagens\", baseFileName);
saveas(52, fullFileName);
grid on
baseFileName = sprintf('Image_%s.png', "Margem_ZN");
fullFileName = fullfile("Imagens\", baseFileName);
Fh = gcf;                                                   % Handle To Current Figure
Kids = Fh.Children;                                         % Children
AxAll = findobj(Kids,'Type','Axes');                        % Handles To Axes
Ax1 = AxAll(1);                                             % First Set Of Axes
LinesAx1 = findobj(Ax1,'Type','Line');                      % Handle To Lines
LinesAx1(2).LineWidth = 1.3;                                  % Set ‘LineWidth’
Ax2 = AxAll(2);  


figure(2)
margin(syskdmf)
hold on
margin(syskdmfKc)
grid on
legend('Sem compensador','Com compensador','location','northeast')
baseFileName = sprintf('Image_%s.png', "Margem_LR");
fullFileName = fullfile("Imagens\", baseFileName);
saveas(2, fullFileName);
grid on
baseFileName = sprintf('Image_%s.png', "Margem_ZN");
fullFileName = fullfile("Imagens\", baseFileName);
Fh = gcf;                                                   % Handle To Current Figure
Kids = Fh.Children;                                         % Children
AxAll = findobj(Kids,'Type','Axes');                        % Handles To Axes
Ax1 = AxAll(1);                                             % First Set Of Axes
LinesAx1 = findobj(Ax1,'Type','Line');                      % Handle To Lines
LinesAx1(2).LineWidth = 1.3;                                  % Set ‘LineWidth’
Ax2 = AxAll(2);  

% 
% figure(1)
% Closed_Logarithmic_Nyquist(syskdmf)

% figure(3)
% Closed_Logarithmic_Nyquist(syskdmfKc)

figure(4)
pzmap(syskdmf)
baseFileName = sprintf('Image_%s.png', "PZ_LR");
fullFileName = fullfile("Imagens\", baseFileName);
saveas(4, fullFileName);


figure(5)
pzmap(syskdmfKc)
baseFileName = sprintf('Image_%s.png', "PZ_LR_comp");
fullFileName = fullfile("Imagens\", baseFileName);
saveas(5, fullFileName);