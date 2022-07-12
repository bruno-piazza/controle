%% Sintonia por ITAE (Executar célula por célula)
clc
clear all
close all
%% Parâmetros do sistema
addpath('Matrizes/')

A = importdata('matrix_A1lin.txt');
B = -importdata('matrix_B1lin.txt');
C = importdata('matrix_C1.txt');
D = importdata('matrix_D1.txt');
t = 0:0.005:15;

%% Construção do sistema via espaço de estados
sysSS=ss(A,B,C,D);

%% Construção da função de transferência de malha aberta (q3->Rot Própria)
[Num,Den] = ss2tf(A,B,C,D,3);
Num=Num(3,:);
sys=tf(Num,Den);
N=tf(Num,1);
D=tf(Den,1);
s=tf([1 0],1);


%% Polinômio ITAE

wn = 1.2; %valor arbitrado de omega_n

tab = [1 1.783*wn 2.172*wn^2 wn^3]; %tabela de coeficientes

a = Num(3);
kd = tab(2)/a;
kp = tab(3)/a;
ki = tab(4)/a;

itae_ref = tf([wn^3], tab);

%% Sintonia sem pré-compensador
Gkd = pid(kp,ki,kd); 
a_t = series(Gkd,sys); 
sys_itae = feedback(a_t,1);

y_sys = step(sys_itae,t);
y_itae = step(itae_ref,t);

figure(10)
pzmap(sys);

%% Sintonia com pré-compensador

[num, den] = tfdata(sys_itae);

num_comp = num{1}(4:8);
den_comp = den{1}(1:8);

FT_comp = tf(num_comp, den_comp);

y_sys_comp = step(FT_comp,t);


%% Plots

figure(1)
plot(t,y_sys,LineWidth=1.3)
hold on
plot(t,y_itae,LineWidth=1.3)
grid on
title('Resposta à entrada do tipo degrau - sem pré-compensador')
xlabel('Tempo [s]')
ylabel('Posição angular [rad]')
legend("PID - ITAE sem pré-compensador","ITAE referência",Location="southeast")
baseFileName = sprintf('Image_%s.png', "itae_sem_comp");
fullFileName = fullfile("Imagens/", baseFileName);
saveas(1, fullFileName);

figure(2)
plot(t,y_sys_comp,LineWidth=1.3)
hold on
plot(t,y_itae,LineWidth=1.3)
grid on
title('Resposta à entrada do tipo degrau - com pré-compensador')
xlabel('Tempo [s]')
ylabel('Posição angular [rad]')
legend("PID - ITAE com pré-compensador","ITAE referência",Location="southeast")
baseFileName = sprintf('Image_%s.png', "itae_com_comp");
fullFileName = fullfile("Imagens/", baseFileName);
saveas(2, fullFileName);

%% Step Info
stepinfo(sys_itae)
stepinfo(FT_comp)

%% Diagramas

% Mapa de polos e zeros
figure(3)
pzmap(FT_comp)
baseFileName = sprintf('Image_%s.png', "itae_pole_map");
fullFileName = fullfile("Imagens/", baseFileName);
saveas(3, fullFileName);

% Margem de ganho e fase
figure(4)
margin(FT_comp)
% hold on
% margin(sys_itae)
grid on
baseFileName = sprintf('Image_%s.png', "itae_margin");
fullFileName = fullfile("Imagens/", baseFileName);
saveas(4, fullFileName);

figure(5)
rlocus(FT_comp)

figure(6)
rlocus(sys_itae)