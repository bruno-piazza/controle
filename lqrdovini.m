clc
clear all
close all
%% Par�metros do sistema
addpath('Matrizes\')

A = importdata('matrix_A1lin.txt');
B = importdata('matrix_B1lin.txt');
C = importdata('matrix_C1.txt');
D = importdata('matrix_D1.txt');

%% Matrizes de ganho
Q=[.1 0 0 0 0 0    %Aumenta a ação de controle em q1
    0 .1 0 0 0 0     %Aumenta a ação de controle em q2
    0 0 .1 0 0 0     %Aumenta a ação de controle em q3
    0 0 0 .01 0 0     %Diminui a amplitude da velocidade, mas aumenta a duração do sinal em q1
    0 0 0 0 .01 0     %Diminui a amplitude da velocidade, mas aumenta a duração do sinal em q2
    0 0 0 0 0 0.01];
P = [1 0 0
    0 1 0
    0 0 50];

K = lqr(A,B,Q,P);
B1 = -B*0.2;
sys_lqr = ss(A-B*K,B1*0,C,D);

%% Simula��o do sistema
[y,t,x]=step(sys_lqr);

Torq1=-K*y(:,:,1)';
Torq2=-K*y(:,:,2)';
Torq3=-K*y(:,:,3)';

%% Plots

figure(1)
pzmap(sys_lqr)
grid on
baseFileName = sprintf('Image_%s.png', "lqr_pol");
fullFileName = fullfile("Imagens\Controle Moderno", baseFileName);
saveas(1, fullFileName);

figure(2)
step(sys_lqr,5)

figure(3)
hold on
plot(t,y(:,4,1),LineWidth=1.20)
plot(t,y(:,5,2),LineWidth=1.20)
plot(t,y(:,6,3),LineWidth=1.20)
title("Velocidade angular: degrau aplicado")
xlabel("Tempo [s]")
ylabel("Velocidade angular [rad/s]")
legend('\omega_1','\omega_2','\omega_3','Location','east')
hold off
grid on

figure(4)
hold on
plot(t,y(:,1,1),LineWidth=1.20)
plot(t,y(:,2,2),LineWidth=1.20)
plot(t,y(:,3,3),LineWidth=1.20)
title("Posição: degrau aplicado")
xlabel("Tempo [s]")
ylabel("Posição angular [rad]")
legend('q_1','q_2','q_3','Location','east')
hold off
grid on

figure(5)
plot(t,Torq1(1,:),LineWidth=1.20)
hold on
plot(t,Torq2(2,:),LineWidth=1.20)
plot(t,Torq3(3,:),LineWidth=1.20)
title("Torque: degrau aplicado")
ylabel('Torque [N.m]')
xlabel('Tempo [s]')
legend('T_1','T_2','T_3','Location','east')
hold off
grid on