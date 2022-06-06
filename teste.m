clc
clear
close

addpath('Matrizes\')
A = importdata('matrix_A1lin.txt');
B = importdata('matrix_B1lin.txt');
C = importdata('matrix_C1.txt');
D = importdata('matrix_D1.txt');

sys = ss(A,B*0.001,C,D);
[y,t,x] = step(sys,20);

q0 = 0.9324;
q1 = y(:,1,1);
q2 = y(:,2,1);
q3 = y(:,3,1);

[psi,theta,phi] = quat2eulang(q0,q1,q2,q3,'ZXZ');


figure(5)
hold on
plot(t,psi,LineWidth=1.20)
plot(t,theta,LineWidth=1.20)
plot(t,phi,LineWidth=1.20)
title("Posição: Degrau aplicado")
xlabel("Tempo [s]")
ylabel("Posição angular [rad]")
legend('psi','theta','psi')
hold off

sys2 = ss(A,B,C,D);
t = [0:0.01:30];
y2 = lsim(sys2,[ones(length(t),1),zeros(length(t),2)],t)
