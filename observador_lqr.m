clc
clear all
close all

addpath('Matrizes\')
addpath("Imagens\Controle Moderno\")

A = importdata('matrix_A1lin.txt');
B2 = importdata('matrix_B1lin.txt');
B1 = -B2*0.2;
C = [eye(3) zeros(3,3)];


% polos alocados LQR
p = [-0.8+0.6i -0.8-0.6i -2.6+0.3i -2.6-0.3i -1. -0.8];

k = 2;
p_obs = p - k;

K_obs = transpose(place(A',C',p_obs)); 

O = (A-K_obs*C); 



sys_obs_aloc = ss(O,B1,C,0);



dt = 0.001;
tf = 10;
t = 0:dt:tf;

u=zeros(length(t),3);
u(1:5000,2)=ones(5000,1)*0.025;

e0 = [1 1 1 1 1 1];

[ys,ts,xs] = lsim(sys_obs_aloc,u,t,e0);


figure(2)
hold on
plot(t,xs(:,1),LineWidth=1.20)
plot(t,xs(:,2),LineWidth=1.20)
plot(t,xs(:,3),LineWidth=1.20)
title(["Erro de observação em posição angular com alocação de polo-","posições angulares"])
xlabel("Tempo [s]")
ylabel("Posição angular [rad]")
legend('q_1','q_2','q_3','Location','east')
hold off
grid on
baseFileName = sprintf('Image_%s.png', "errobs_aloc_ang");
fullFileName = fullfile("Imagens\Controle Moderno", baseFileName);
saveas(2, fullFileName);

figure(3)
hold on
plot(t,xs(:,4),LineWidth=1.20)
plot(t,xs(:,5),LineWidth=1.20)
plot(t,xs(:,6),LineWidth=1.20)
title(["Erro de observação em posição angular com alocação de polo-","velocidades angulares"])
xlabel("Tempo [s]")
ylabel("Velocidade angular [rad/s]")
legend('\omega_1','\omega_2','\omega_3','Location','east')
hold off
grid on
baseFileName = sprintf('Image_%s.png', "errobs_aloc_vel");
fullFileName = fullfile("Imagens\Controle Moderno", baseFileName);
saveas(3, fullFileName);
