clc
clear all
close all

addpath('Matrizes\')

A = importdata('matrix_A1lin.txt');
B = importdata('matrix_B1lin.txt');
C = importdata('matrix_C1.txt');
D = importdata('matrix_D1.txt');

Co = ctrb(A,B);
rank(Co);
Ob = obsv(A,C);
rank(Ob);

polos = eig(A);
% 
% p1=-0.3+0.3i;
% p2=-5.4+.3i;
% p = [p1 conj(p1) p2 conj(p2) -0.8 -0.4];
p = [-0.8+0.6i -0.8-0.6i -2.6+0.3i -2.6-0.3i -1. -0.8];
K = place(A,B,p);
B1 = -B*0.2;

sys_aloc = ss(A-B*K,B1*0.025,C,D);
[y,t,x]=step(sys_aloc);

 figure(1)
 pzmap(sys_aloc)
 grid on
% 
% figure(2)
% step(sys_aloc)

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
legend('q_1','q_2','q_3','Location','southeast')
hold off
grid on


Torq1=-K*y(:,:,1)';
Torq2=-K*y(:,:,2)';
Torq3=-K*y(:,:,3)';

figure(5)
plot(t,Torq1(1,:))
hold on
plot(t,Torq2(2,:))
plot(t,Torq3(3,:))
ylabel('Torque N.m')
legend('T_1','T_2','T_3','Location','east')
hold off
grid on
