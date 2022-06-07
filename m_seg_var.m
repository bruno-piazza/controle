clc
clear
close

addpath('Matrizes\')
A = importdata('matrix_A1lin.txt');
B = importdata('matrix_B1lin.txt');
C = importdata('matrix_C1.txt');
D = importdata('matrix_D1.txt');

x_r = [pi/3 pi/4 pi/5 0 0 0];
seq = 'ZXZ';
q_r = angle2quat(x_r(1),x_r(2),x_r(3),seq);
xq_r = [q_r(2:4),x_r(4:6)];

p = [-0.2+0.8i -0.2-0.8i -0.4+0.6i -0.4-0.6i -0.5 -0.6];
K = place(A,B,p);
B1 = [zeros(3,3);eye(3,3)];

T1 = 45;
T2 = 60;
T3 = 90;
A_r = [1/T1 0 0 0 0 0; 0 1/T2 0 0 0 0; 0 0 1/T3 0 0 0; 0 0 0 0 0 0; 0 0 0 0 0 0; 0 0 0 0 0 0];
