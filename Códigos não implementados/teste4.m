clc
clear all
close all

addpath('Matrizes\')

A = [0 1; 20.6 0];
B2 = [0; 1];
B1 = [0; 1];
C = [1 0];

Co = ctrb(A',C');
rank(Co);
Ob = obsv(A,C);
rank(Ob);

% polos alocados
p_sis = [-1.8+2.4i -1.8-2.4i];
p_obs = [-3.6+2.4i -3.6-2.4i];

K = place(A,B2,p_sis);
K_obs = transpose(place(A',C',p_obs)); 

O = (A-K_obs*C); 


sys_obs_aloc = ss(O,B1,C,0);

passo=0.001;
t=0:passo:4.5;
u=[1; 1; 1; zeros(length(t)-3,1)];
[y t x] = lsim(sys_obs_aloc,u,t,[0 1]);

n = length(A);

lambda = [A-B2*K B2*K;
          zeros(n,n)     A-K_obs*C];

m = 4.5/passo + 1;

reg_obsal=zeros(2*n,m);
reg_obsal(:,1)= [0 2 0 1];

for j1=1:m-1
    reg_obsal(:,j1+1) = expm(lambda*passo)*reg_obsal(:,j1);
end

%  figure(1)
%  pzmap(sys_obs)
%  grid on
% % 
% % figure(2)
% % step(sys_aloc)
% 
figure(3)
hold on
plot(t,x(:,1,1),LineWidth=1.20)
plot(t,x(:,2,1),LineWidth=1.20)
title("Velocidade angular: degrau aplicado")
xlabel("Tempo [s]")
ylabel("Velocidade angular [rad/s]")
legend('w_1','w_2','w_3','Location','east')
hold off
grid on

figure(4)
hold on
plot(t,reg_obsal(3,:),LineWidth=1.20)
% plot(t,x(:,2,1),LineWidth=1.20)
title("Velocidade angular: degrau aplicado")
xlabel("Tempo [s]")
ylabel("Velocidade angular [rad/s]")
legend('w_1','w_2','w_3','Location','east')
hold off
grid on