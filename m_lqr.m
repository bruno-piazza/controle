clc
clear
close

addpath('Matrizes\')

A = importdata('matrix_A1lin.txt');
B = importdata('matrix_B1lin.txt');
C = importdata('matrix_C1.txt');
D = importdata('matrix_D1.txt');

Q = eye(6); %ajustar
P = eye(3); %ajustar
K = lqr(A,B,Q,P);
B1 = [zeros(3,3);eye(3,3)];
sys_lqr = ss(A-B*K,B1,C,D);
[y,t,x]=impulse(sys_lqr);

figure(1)
pzmap(sys_lqr)
grid on

figure(2)
impulse(sys_lqr)