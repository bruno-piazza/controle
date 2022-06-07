clc
clear
close all

addpath('Matrizes\')
A = importdata('matrix_A1lin.txt');
B1 = [zeros(3,6);zeros(3,3) eye(3,3)]*1;
B2 = importdata('matrix_B1lin.txt');
C = importdata('matrix_C1.txt');
D = importdata('matrix_D1.txt');

x_r = [pi/3 pi/4 pi/5 0 0 0];
seq = 'ZXZ';
q_r = angle2quat(x_r(1),x_r(2),x_r(3),seq);
xq_r = [q_r(2:4),x_r(4:6)];

p1 = -0.3+0.3i;
p2 = -0.4+0.3i;
p = [p1 conj(p1) p2 conj(p2) -0.5 -0.4];
K = place(A,B2,p);
F = A-B2*K;

A_r = [0 0 0 0 0 0;
    0 0 0 0 0 0;
    0 0 0 0 0 0; 
    0 0 0 0 0 0; 
    0 0 0 0 0 0; 
    0 0 0 0 0 0];
A_w = [0 0 0 0 0 0;
    0 0 0 0 0 0;
    0 0 0 0 0 0; 
    0 0 0 0 0 0; 
    0 0 0 0 0 0; 
    0 0 0 0 0 0];
A_z = zeros(length(A),length(A));
A_o = [A_w A_z;A_z A_r];

F2 = [B1 (A-A_r)];
C_bar = [eye(3),zeros(3,3)];
K_ex = inv(C_bar*inv(F)*B2)*C_bar*inv(F)*F2;

A_y = [B1 B2*K]-B2*K_ex;

A_bar = [F A_y;zeros(12,6) A_o];
x_bar_0 = [0 0 0 0 0 0 ...
    0 0 0 0 0 0 ...
    0 0 0 0 0 0]';

sys = ss(A_bar,x_bar_0,A_bar,x_bar_0);
[y,t]=step(sys);

figure(1)
plot(t,y(:,1))
figure(2)
plot(t,y(:,2))
figure(3)
plot(t,y(:,3))
figure(4)
plot(t,y(:,4))
figure(5)
plot(t,y(:,5))
figure(6)
plot(t,y(:,6))



