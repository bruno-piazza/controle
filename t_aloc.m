clc
clear
close

addpath('Matrizes\')

A = importdata('matrix_A1lin.txt');
B = importdata('matrix_B1lin.txt');
C = importdata('matrix_C1.txt');
D = importdata('matrix_D1.txt');

p = [-0.2+0.8i -0.2-0.8i -0.4+0.6i -0.4-0.6i -0.5 -0.6];
K = place(A,B,p);
B1 = [zeros(3,3);eye(3)];

t = [0:0.01:30];
u = u_selector([1,1,1],[0,0,0],[1,1,1],t);
x_0 = [0 0 0 1 1 1];
[y_t] = transition_matrix(A-B*K,B1,t,x_0,u.');

figure(4)
hold on
plot(t,y_t(1,:),LineWidth=1.20)
plot(t,y_t(2,:),LineWidth=1.20)
plot(t,y_t(3,:),LineWidth=1.20)


