%% Sintonia por Lugar das Raízes (Executar célula por célula)
clc
clear
close all
%% Parâmetros do sistema
addpath('Matrizes\')
A = importdata('matrix_A1lin.txt');
B = -importdata('matrix_B1lin.txt');
C = importdata('matrix_C1.txt');
D = importdata('matrix_D1.txt');
t = 0:0.01:10;

%% Construção do sistema via espaço de estados
sysSS=ss(A,B,C,D);

%% Construção da função de transferência de malha aberta (q3->Rot Própria)
[Num,Den] = ss2tf(A,B,C,D,3);
Num=Num(3,:);
sys=tf(Num,Den);
N=tf(Num,1);
D=tf(Den,1);
s=tf([1 0],1);

%% Escolha dos polos
p1 = -1 + 0.3i;
p2 = conj(p1);
p3 = 0;
p4 = 0;
p5 = 0;
p6 = 0;
p7 = 0;

%% Cálculo dos ganhos pelo método dos mínimos quadrados

Num = flip(Num);
Den = flip(Den);

a = [Num(1) 0 0;...
    Num(2) Num(1) 0;...
    Num(3) Num(2) Num(1);...
    Num(4) Num(3) Num(2);...
    Num(5) Num(4) Num(3);...
    0 Num(5) Num(4);...
    0 0 Num(5)];


b = [(p1*p2*p3*p4*p5*p6*p7)*Den(7);...
    (p1*p2*p3*p4*p5*p6 + p2*p3*p4*p5*p6*p7)*(Den(7)-Den(1));...
    (p1*p2*p3*p4*p5 + p2*p3*p4*p5*p6 + p3*p4*p5*p6*p7)*(Den(7)-Den(2));...
    (p1*p2*p3*p4 + p2*p3*p4*p5 + p3*p4*p5*p6 + p4*p5*p6*p7)*(Den(7)-Den(3));...
    (p1*p2*p3 + p2*p3*p4 + p3*p4*p5 + p4*p5*p6 + p5*p6*p7)*(Den(7)-Den(4));...
    (p1*p2 + p2*p3 + p3*p4 + p4*p5 + p5*p6 + p6*p7)*(Den(7)-Den(5));...
    (p1 + p2 + p3 + p4 + p5 + p6 + p7)*(Den(7)-Den(6))];

Ks = lsqr(a,b);
ki_lsqr = norm(Ks(1));
kp_lsqr = norm(Ks(2));
kd_lsqr = norm(Ks(3));

%% Cálculo dos ganhos de forma analítica
ki_ana = (1/Num(5))*(-p1*p2*p3 - p1*p2*p4 - p1*p3*p4 - p2*p3*p4 - p1*p2*p5 -... 
  p1*p3*p5 - p2*p3*p5 - p1*p4*p5 - p2*p4*p5 - p3*p4*p5 - p1*p2*p6 - ...
  p1*p3*p6 - p2*p3*p6 - p1*p4*p6 - p2*p4*p6 - p3*p4*p6 - p1*p5*p6 - ...
  p2*p5*p6 - p3*p5*p6 - p4*p5*p6 - p1*p2*p7 - p1*p3*p7 - p2*p3*p7 - ...
  p1*p4*p7 - p2*p4*p7 - p3*p4*p7 - p1*p5*p7 - p2*p5*p7 - p3*p5*p7 - ...
  p4*p5*p7 - p1*p6*p7 - p2*p6*p7 - p3*p6*p7 - p4*p6*p7 - p5*p6*p7);
kp_ana = (1/Num(5))*(p1*p2 + p1*p3 + p2*p3 + p1*p4 + p2*p4 + p3*p4 + p1*p5 + p2*p5 +... 
   p3*p5 + p4*p5 + p1*p6 + p2*p6 + p3*p6 + p4*p6 + p5*p6 + p1*p7 + ...
   p2*p7 + p3*p7 + p4*p7 + p5*p7 + p6*p7);
kd_ana = (-p1 - p2 - p3 - p4 - p5 - p6 - p7)/Num(5);

%% Simulação

Gc_lsqr = pid(kp_lsqr,ki_lsqr,kd_lsqr); 
u_lsqr = series(Gc_lsqr,sys); 
sys_lsqr = feedback(u_lsqr,1);
y_lsqr = step(sys_lsqr,t);

Gc_ana = pid(kp_ana,ki_ana,kd_ana); 
u_ana = series(Gc_ana,sys); 
sys_ana = feedback(u_ana,1);
y_ana = step(sys_ana,t);

figure(1)
plot(t,y_lsqr)
hold on
plot(t,y_ana)
grid on
title('Resposta à entrada do tipo degrau')
xlabel('Tempo [s]')
ylabel('Posição angular [rad]')
legend("Least Square","Analítico")

baseFileName = sprintf('Image_%s.png', "aloc_class");
fullFileName = fullfile("Imagens\", baseFileName);
saveas(1, fullFileName);

%% Mapa de polos e zeros
figure(2)
pzmap(sys_ana)

baseFileName = sprintf('Image_%s.png', "aloc_class_polos");
fullFileName = fullfile("Imagens\", baseFileName);
saveas(2, fullFileName);
%% Margem de ganho e fase

figure(3)
margin(sys_ana)
grid on

baseFileName = sprintf('Image_%s.png', "aloc_class_ganho_fase");
fullFileName = fullfile("Imagens\", baseFileName);
saveas(3, fullFileName);

%% Diagrama de Nyquist
figure(4)
nyquist(sys_ana)

