clc
clear
close

addpath('Matrizes\')

A = importdata('matrix_A1lin.txt');
B = importdata('matrix_B1lin.txt');
C = importdata('matrix_C1.txt');
D = importdata('matrix_D1.txt');

Co = ctrb(A,B);
Ob = obsv(A,C);

polos = eig(A);

p = [-0.2+0.8i -0.2-0.8i -0.4+0.6i -0.4-0.6i -0.5 -0.6];
K = place(A,B,p);
B1 = [zeros(3,3);ones(3,3)];

sys = ss(A-B*K,B1,C,D);
pzmap(sys)

[y,t,x]=impulse(sys);

figure(2)
impulse(sys)

% figure(3)
% hold on
% plot(t,y(:,4,3),LineWidth=1.20)
% plot(t,y(:,5,3),LineWidth=1.20)
% plot(t,y(:,6,3),LineWidth=1.20)
% title("Velocidade angular: impulso aplicado")
% xlabel("Tempo [s]")
% ylabel("Velocidade angular [rad/s]")
% legend('w1','w2','w3')
% hold off
% 
% figure(4)
% hold on
% plot(t,y(:,1,3),LineWidth=1.20)
% plot(t,y(:,2,3),LineWidth=1.20)
% plot(t,y(:,3,3),LineWidth=1.20)
% title("Posição: impulso aplicado")
% xlabel("Tempo [s]")
% ylabel("Posição angular [rad]")
% legend('q1','q2','q3')
% hold off



