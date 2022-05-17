clc
clear
close

A = importdata('matrix_A1lin.txt');
B = importdata('matrix_B1lin.txt');
C = importdata('matrix_C1.txt');
D = importdata('matrix_D1.txt');

Co = ctrb(A,B);
Ob = obsv(A,C);

polos = eig(A);

p = [-10 -30 -5 -2 -5 -10];
K=place(A,B,p);
sys = ss(A-B*K,B,C,D);

figure(1)
step(sys)
% 
% figure(2)
% impulse(sys)

