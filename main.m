clc
clear
close

A = importdata('matrix_A1lin.txt');
B = importdata('matrix_B1lin.txt');
C = importdata('matrix_C1.txt');
D = importdata('matrix_D1.txt');

p = [-3+1i -3-1i -5+1i -5-1i -3 -4];
K=place(A,B,p);
sys = ss(A-B*K,B,C,D);

figure(1)
step(sys)

figure(2)
impulse(sys)

