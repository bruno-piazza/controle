clc
clear
close

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

p = [-0.2+0.8i -0.2-0.8i -0.4+0.6i -0.4-0.6i -0.5 -0.6];
% p = [-0.8+0.6i -0.8-0.6i -1.6+0.3i -1.6-0.3i -1.5 -1.8];
K = place(A,B,p);
B1 = [zeros(3,3);eye(3,3)];

sys_aloc = ss(A-B*K,B1,C,D);
[y,t,x]=step(sys_aloc);

figure(1)
pzmap(sys_aloc)
grid on

figure(2)
step(sys_aloc)

figure(3)
hold on
plot(t,y(:,4,1),LineWidth=1.20)
plot(t,y(:,5,2),LineWidth=1.20)
plot(t,y(:,6,3),LineWidth=1.20)
title("Velocidade angular: impulso aplicado")
xlabel("Tempo [s]")
ylabel("Velocidade angular [rad/s]")
legend('w1','w2','w3')
hold off

figure(4)
hold on
plot(t,y(:,1,1),LineWidth=1.20)
plot(t,y(:,2,2),LineWidth=1.20)
plot(t,y(:,3,3),LineWidth=1.20)
title("Posição: impulso aplicado")
xlabel("Tempo [s]")
ylabel("Posição angular [rad]")
legend('q1','q2','q3')
hold off



