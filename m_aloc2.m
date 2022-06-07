clc
clear all
close all

addpath('Matrizes\')
addpath("Imagens\Controle Moderno\")



passo=0.01;
t=0:passo:10;
u=ones(size(t));

A = importdata('matrix_A1lin.txt');
B = importdata('matrix_B1lin.txt');
C = importdata('matrix_C1.txt');
D = importdata('matrix_D1.txt');

Co = ctrb(A,B);
rank(Co);
Ob = obsv(A,C);
rank(Ob);

polos = eig(A);
% 
% p1=-0.3+0.3i;
% p2=-5.4+.3i;
% p = [p1 conj(p1) p2 conj(p2) -0.8 -0.4];
p = [-0.8+0.6i -0.8-0.6i -2.6+0.3i -2.6-0.3i -1. -0.8];
K = place(A,B,p);
B1 = -B*0.2;

sys_aloc = ss(A-B*K,B1*0.025,C,D);
[y,t,x]=step(sys_aloc);

figure(1)
pzmap(sys_aloc)
grid on
baseFileName = sprintf('Image_%s.png', "aloc_pol");
fullFileName = fullfile("Imagens\Controle Moderno", baseFileName);
saveas(1, fullFileName);



% figure(3)
% hold on
% plot(t,y(:,4,2),LineWidth=1.20)
% plot(t,y(:,5,2),LineWidth=1.20)
% plot(t,y(:,6,2),LineWidth=1.20)
% title("Velocidade angular: degrau aplicado")
% xlabel("Tempo [s]")
% ylabel("Velocidade angular [rad/s]")
% legend('w_1','w_2','w_3','Location','east')
% hold off
% grid on
% % baseFileName = sprintf('Image_%s.png', "aloc_vel");
% % fullFileName = fullfile("Imagens\Controle Moderno", baseFileName);
% % saveas(3, fullFileName);
% 
% 
% figure(4)
% hold on
% plot(t,y(:,1,2),LineWidth=1.20)
% plot(t,y(:,2,2),LineWidth=1.20)
% plot(t,y(:,3,2),LineWidth=1.20)
% title("Posição: degrau aplicado")
% xlabel("Tempo [s]")
% ylabel("Posição angular [rad]")
% legend('q_1','q_2','q_3','Location','southeast')
% hold off
% grid on
% baseFileName = sprintf('Image_%s.png', "aloc_pos");
% fullFileName = fullfile("Imagens\Controle Moderno", baseFileName);
% saveas(4, fullFileName);


Torq1=-K*y(:,:,1)';
Torq2=-K*y(:,:,2)';
Torq3=-K*y(:,:,3)';

figure(5)
plot(t,Torq1(1,:))
hold on
plot(t,Torq2(2,:))
plot(t,Torq3(3,:))
ylabel('Torque N.m')
legend('T_1','T_2','T_3','Location','east')
hold off
grid on

% 
% figure(3)
% hold on
% plot(t,y(:,4,1),LineWidth=1.20)
% plot(t,y(:,5,2),LineWidth=1.20)
% plot(t,y(:,6,3),LineWidth=1.20)
% title("Velocidade angular: degrau aplicado")
% xlabel("Tempo [s]")
% ylabel("Velocidade angular [rad/s]")
% legend('w_1','w_2','w_3','Location','east')
% hold off
% grid on
% baseFileName = sprintf('Image_%s.png', "aloc_vel");
% fullFileName = fullfile("Imagens\Controle Moderno", baseFileName);
% saveas(3, fullFileName);
% 
% 
% figure(4)
% hold on
% plot(t,y(:,1,1),LineWidth=1.20)
% plot(t,y(:,2,2),LineWidth=1.20)
% plot(t,y(:,3,3),LineWidth=1.20)
% title("Posição: degrau aplicado")
% xlabel("Tempo [s]")
% ylabel("Posição angular [rad]")
% legend('q_1','q_2','q_3','Location','southeast')
% hold off
% grid on
% baseFileName = sprintf('Image_%s.png', "aloc_pos");
% fullFileName = fullfile("Imagens\Controle Moderno", baseFileName);
% saveas(4, fullFileName);

q=[1 0 0 0 0 0 0];


passo=0.001;
t=0:passo:15;
u=zeros(length(t),3);
u(1:5000,2)=ones(5000,1);
% u(:,1)=zeros(length(t),1);
% u(:,3)=zeros(length(t),1);
[y]=lsim(sys_aloc,u,t,q(2:end));



figure(6)
hold on
plot(t,y(:,4),LineWidth=1.20)
plot(t,y(:,5),LineWidth=1.20)
plot(t,y(:,6),LineWidth=1.20)
title("Velocidade angular: degrau aplicado")
xlabel("Tempo [s]")
ylabel("Velocidade angular [rad/s]")
legend('w_1','w_2','w_3','Location','northeast')
hold off
grid on
baseFileName = sprintf('Image_%s.png', "aloc_u2_vel");
fullFileName = fullfile("Imagens\Controle Moderno", baseFileName);
saveas(6, fullFileName);

figure(7)
hold on
plot(t,y(:,1),LineWidth=1.20)
plot(t,y(:,2),LineWidth=1.20)
plot(t,y(:,3),LineWidth=1.20)
title("Posição: degrau aplicado")
xlabel("Tempo [s]")
ylabel("Posição angular [rad]")
legend('q_1','q_2','q_3','Location','northeast')
hold off
grid on
baseFileName = sprintf('Image_%s.png', "aloc_u2_pos");
fullFileName = fullfile("Imagens\Controle Moderno", baseFileName);
saveas(7, fullFileName);


% 
% [psi,theta,phi] = quat2eulang(q(1),y(:,1),y(:,2),y(:,3),'ZXZ');
% 
% figure(8)
% hold on
% plot(t,psi,LineWidth=1.20)
% plot(t,theta,LineWidth=1.20)
% plot(t,phi,LineWidth=1.20)
% title("Posição: degrau aplicado")
% xlabel("Tempo [s]")
% ylabel("Posição angular [rad]")
% legend('psi','theta','phi','Location','southeast')
% hold off
% grid on