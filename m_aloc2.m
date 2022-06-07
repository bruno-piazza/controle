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

p1=-0.6+0.5i;
p2=-0.8+0.5i;

p = [p1 conj(p1) p2 conj(p2) -0.6 -0.7];
% p = [-0.8+0.6i -0.8-0.6i -1.6+0.3i -1.6-0.3i -1.5 -1.8];
p = [-0.2+0.8i -0.2-0.8i -0.4+0.6i -0.4-0.6i -0.5 -0.6];
K = place(A,B,p);
B1 = B;

sys_aloc = ss(A-B*K,B1*0.025,C,D);
[y,t,x]=impulse(sys_aloc);

% figure(1)
% pzmap(sys_aloc)
% grid on
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
legend('q_1','q_2','q_3','Location','east')
hold off
grid on



