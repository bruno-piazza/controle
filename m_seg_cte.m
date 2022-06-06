clc
clear
close

addpath('Matrizes\')
A = importdata('matrix_A1lin.txt');
B = importdata('matrix_B1lin.txt');
C = importdata('matrix_C1.txt');
D = importdata('matrix_D1.txt');

x_ref = [pi/4 pi/3 pi/5 0 0 0];
seq = 'ZXZ';
q_ref = angle2quat(x_ref(1),x_ref(2),x_ref(3),seq);
xq_ref = [q_ref(2:4),x_ref(4:6)];

p = [-0.2+0.8i -0.2-0.8i -0.4+0.6i -0.4-0.6i -0.5 -0.6];
K = place(A,B,p);
F = A-B*K;

Gamma = [A,B;C,D];
B_ls = [zeros(6,6);eye(3,6);zeros(3,6)];
N = linsolve(Gamma,B_ls);
Nx = N(1:6,:);
Nu = N(7:9,:);

u_rp = (Nu+K*Nx)*xq_ref';
B2 = B;
B2(4:6,:) = B2(4:6,:).*u_rp;

sys_aloc = ss(F,B2,C,D);
[y,t,x]=step(sys_aloc,45);
% step(sys_aloc)

q0 = q_ref(1);
q1 = y(:,1,1)+0;
q2 = y(:,2,2)+0;
q3 = y(:,3,3)+0;
w1 = y(:,4,1);
w2 = y(:,5,2);
w3 = y(:,6,3);

figure(3)
hold on
plot(t,w1,LineWidth=1.20)
plot(t,w2,LineWidth=1.20)
plot(t,w3,LineWidth=1.20)
title("Velocidade angular: Degrau aplicado")
xlabel("Tempo [s]")
ylabel("Velocidade angular [rad/s]")
legend('w1','w2','w3')
hold off

figure(4)
hold on
plot(t,q1,LineWidth=1.20)
plot(t,q2,LineWidth=1.20)
plot(t,q3,LineWidth=1.20)
title("Posição: Degrau aplicado")
xlabel("Tempo [s]")
ylabel("Posição angular [rad]")
legend('q1','q2','q3')
hold off

[psi,theta,phi] = quat2eulang(q0,q1,q2,q3,seq);

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