clc
clear all
close all

addpath('Matrizes\')
addpath("Imagens\Controle Moderno\")

A = importdata('matrix_A1lin.txt');
B2 = importdata('matrix_B1lin.txt');
B1 = -B2;
C = [eye(3) zeros(3,3)];

% Definição das matrizes Q e P

Q_obs = 1*[1 0 0 0 0 0    %Aumenta a ação de controle em q1
            0 1 0 0 0 0     %Aumenta a ação de controle em q2
            0 0 1 0 0 0     %Aumenta a ação de controle em q3
            0 0 0 30 0 0     %Diminui a amplitude da velocidade, mas aumenta a duração do sinal em q1
            0 0 0 0 30 0     %Diminui a amplitude da velocidade, mas aumenta a duração do sinal em q2
            0 0 0 0 0 35];
P_obs = 1/40*[1.5 0 0
                0 2 0
                0 0 5];

% Q_obs = 5000*[.20 0 0 0 0 0    %Aumenta a ação de controle em q1
%     0 .15 0 0 0 0     %Aumenta a ação de controle em q2
%     0 0 .05 0 0 0     %Aumenta a ação de controle em q3
%     0 0 0 .25 0 0     %Diminui a amplitude da velocidade, mas aumenta a duração do sinal em q1
%     0 0 0 0 .25 0     %Diminui a amplitude da velocidade, mas aumenta a duração do sinal em q2
%     0 0 0 0 0 0.35];
% P_obs = 10*[1 0 0
%            0 1 0
%            0 0 5];

K_obs = lqr(A',C',Q_obs,P_obs);
K_obs = K_obs';

O = (A-K_obs*C); 

sys_obs_lqr = ss(O,B1,C,0);

pole(sys_obs_lqr)

dt = 0.001;
tf = 10;
t = 0:dt:tf;

u=zeros(length(t),3);
u(1:5000,2)=ones(5000,1)*0.0;

e0 = [0 0 0 1 1 1];

[ys,ts,xs] = lsim(sys_obs_lqr,u,t,e0);


figure(2)
hold on
plot(t,xs(:,4),LineWidth=1.20)
plot(t,xs(:,5),LineWidth=1.20)
plot(t,xs(:,6),LineWidth=1.20)
title(["Erro de observação em velocidade angular-","LQR"])
xlabel("Tempo [s]")
ylabel("Velocidade angular [rad/s]")
legend('\omega_1','\omega_2','\omega_3','Location','east')
hold off
grid on
saveas(2, "obs_lqr_vel.png");

figure(3)
hold on
plot(t,xs(:,1),LineWidth=1.20)
plot(t,xs(:,2),LineWidth=1.20)
plot(t,xs(:,3),LineWidth=1.20)
title("Posições angulares - LQR")
xlabel("Tempo [s]")
ylabel("Posição angular [rad]")
legend('q_1','q_2','q_3','Location','east')
hold off
grid on
saveas(3, "obs_lqr_pos.png");