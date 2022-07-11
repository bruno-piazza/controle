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
[Num1,Den1] = ss2tf(A,B,C,D,3);
Num1=Num1(3,:);
sys=tf(Num1,Den1);
N=tf(Num1,1);
D=tf(Den1,1);
s=tf([1 0],1);

%% Escolha dos polos
p1 = -1 + 0.3i;
p2 = conj(p1);
p3 = 0;
p4 = 0;
p5 = 0;
p6 = 0;
p7 = 0;

%% Cálculo dos ganhos de forma analítica
Num = flip(Num1);
Den = flip(Den1);

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
