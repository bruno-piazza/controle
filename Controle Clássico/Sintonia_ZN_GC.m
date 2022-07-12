% Sintonia por ZIEGLER-NICHOLS
clc
clear all
close all
%% Parâmetros do sistema
addpath('Matrizes\')

A = importdata('matrix_A1lin.txt');
B = -importdata('matrix_B1lin.txt');
C = importdata('matrix_C1.txt');
D = importdata('matrix_D1.txt');


sample_rate = 100;
t = 0:1/sample_rate:10;
n = length(t);
%% Construção da função de transferência de malha aberta (q3->Rot Própria)
[Num,Den] = ss2tf(A,B,C,D,3);
Num=Num(3,:);

sys=tf(Num,Den);
N=tf(Num,1);
D=tf(Den,1);
s=tf([1 0],1);


%% Determinação do ganho crítico
rlocus(sys)
kcrit=2.5 %Utilizar o mais adequado a partir do lugar das raizes anterior
Gkcrit=pid(kcrit,0,0); 
a=series(Gkcrit,sys); 
syskcrit=feedback(a,1)

%% Determinação do período de oscilação harmônica
figure(2)
step(syskcrit,t)
ycrit=step(syskcrit,t)

[~,peaklocs] = findpeaks(ycrit);
Pcrit = t(round(mean(diff(peaklocs))));

%% Determinação do controlador
Ti=Pcrit/2;
Td=.125*Pcrit;

kp=.6*kcrit;
ki=kp/Ti;
kd=Td*kp;

GcZN=pid(kp,ki,kd); 
a=series(GcZN,sys); 
sysZN=feedback(a,1)

y=step(sysZN,t);
stepinfo(sysZN)



%% Plots oficiais
close all

figure(51)
plot(t,y,'linewidth',1.3)
grid on
title('Resposta à entrada do tipo degrau')
xlabel('Tempo [s]')
ylabel('Posição angular [rad]')
baseFileName = sprintf('Image_%s.png', "ZN_step");
fullFileName = fullfile("Imagens\", baseFileName);
saveas(51, fullFileName);

figure(52)
bode(sysZN)
grid on
baseFileName = sprintf('Image_%s.png', "Bode_ZN");
fullFileName = fullfile("Imagens\", baseFileName);
Fh = gcf;                                                   % Handle To Current Figure
Kids = Fh.Children;                                         % Children
AxAll = findobj(Kids,'Type','Axes');                        % Handles To Axes
Ax1 = AxAll(1);                                             % First Set Of Axes
LinesAx1 = findobj(Ax1,'Type','Line');                      % Handle To Lines
LinesAx1(2).LineWidth = 1.3;                                  % Set ‘LineWidth’
Ax2 = AxAll(2);                                             % Second Set Of Axes
LinesAx2 = findobj(Ax2,'Type','Line');                      % Handle To Lines
LinesAx2(2).LineWidth = 1.3;                                  % Set ‘LineWidth’
saveas(52, fullFileName);




figure(2)
margin(sysZN)
grid on
baseFileName = sprintf('Image_%s.png', "Margem_ZN");
fullFileName = fullfile("Imagens\", baseFileName);
Fh = gcf;                                                   % Handle To Current Figure
Kids = Fh.Children;                                         % Children
AxAll = findobj(Kids,'Type','Axes');                        % Handles To Axes
Ax1 = AxAll(1);                                             % First Set Of Axes
LinesAx1 = findobj(Ax1,'Type','Line');                      % Handle To Lines
LinesAx1(2).LineWidth = 1.3;                                  % Set ‘LineWidth’
Ax2 = AxAll(2);                                             % Second Set Of Axes
LinesAx2 = findobj(Ax2,'Type','Line');                      % Handle To Lines
LinesAx2(2).LineWidth = 1.3;
saveas(2, fullFileName);

% 
% figure(1)
% Closed_Logarithmic_Nyquist(syskdmf)

% figure(3)
% Closed_Logarithmic_Nyquist(syskdmfKc)

figure(4)
pzmap(sysZN)
baseFileName = sprintf('Image_%s.png', "PZ_ZN");
fullFileName = fullfile("Imagens\", baseFileName);
saveas(4, fullFileName);

figure(5)
plot(t,ycrit,'linewidth',1.3)
grid on
title('Resposta à entrada do tipo degrau')
xlabel('Tempo [s]')
ylabel('Posição angular [rad]')
baseFileName = sprintf('Image_%s.png', "ZN");
fullFileName = fullfile("Imagens\", baseFileName);
saveas(5, fullFileName);


%% Plot malha aberta
yma=step(sys,t);
figure(6)
plot(t,yma,'linewidth',1.3)
grid on
title('Resposta à entrada do tipo degrau')
xlabel('Tempo [s]')
ylabel('Posição angular [rad]')
baseFileName = sprintf('Image_%s.png', "MA-step");
fullFileName = fullfile("Imagens\", baseFileName);
saveas(6, fullFileName);

rlocus(sys)
