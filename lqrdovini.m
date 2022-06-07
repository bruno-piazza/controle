clc
clear all
close all

addpath('Matrizes\')

A = importdata('matrix_A1lin.txt');
B = importdata('matrix_B1lin.txt');
C = importdata('matrix_C1.txt');
D = importdata('matrix_D1.txt');

% %Condição de igualdade
% % P = [1 0 0
% %     0 1 0
% %     0 0 65]
% 
Q=[.1 0 0 0 0 0    %Aumenta a ação de controle em q1
    0 .1 0 0 0 0     %Aumenta a ação de controle em q2
    0 0 .1 0 0 0     %Aumenta a ação de controle em q3
    0 0 0 .01 0 0     %Diminui a amplitude da velocidade, mas aumenta a duração do sinal em q1
    0 0 0 0 .01 0     %Diminui a amplitude da velocidade, mas aumenta a duração do sinal em q2
    0 0 0 0 0 3];
P = [1 0 0
    0 1 0
    0 0 15]*800;


% % Aumentar em Q e diminuir em P ao msm tempo mantem o estado final, mas
% % aumenta a amplitude gera oscilação e diminui o tempo de convergência (gera
% % uma componente imaginária não nula).
% % (pouca diferença de 100 pra cima)
% Q = [1000000000000 0 0 0 0 0    %Aumenta a ação de controle em q1
%     0 1/100 0 0 0 0     %Aumenta a ação de controle em q2
%     0 0 1 0 0 0     %Aumenta a ação de controle em q3
%     0 0 0 1/100000 0 0     %Diminui a amplitude da velocidade, mas aumenta a duração do sinal em q1
%     0 0 0 0 1/1000 0     %Diminui a amplitude da velocidade, mas aumenta a duração do sinal em q2
%     0 0 0 0 0 1];   %Diminui a amplitude da velocidade, mas aumenta a duração do sinal em q3
% 
% 
% 
% P = [1000000000000 0 0          %Diminui a ação de controle em q1
%     0 1/100 0           %Diminui a ação de controle em q2
%     0 0 65]*10;    %Diminui a ação de controle em q3
K = lqr(A,B,Q,P);
B1 = -B*0.2;
sys_lqr = ss(A-B*K,B1*0.025,C,D);
[y,t,x]=step(sys_lqr);

figure(1)
pzmap(sys_lqr)

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
legend('w_1','w_2','w_3','Location','east')
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

Torq1=-K*y(:,:,1)';
Torq2=-K*y(:,:,2)';
Torq3=-K*y(:,:,3)';

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