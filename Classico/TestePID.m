clc
clear all
close all
%% Par�metros do sistema
addpath('Matrizes\')

A = importdata('matrix_A1lin.txt');
B = -importdata('matrix_B1lin.txt');
C = importdata('matrix_C1.txt');
D = importdata('matrix_D1.txt');

%% Constru��o do sistema via espa�o de estados
sysSS=ss(A,B,C,D);

%% Constru��o da fun��o de transfer�ncia de malha aberta (q3->Rot Pr�pria)
[Num,Den] = ss2tf(A,B,C,D,3);
Num=Num(3,:);
sys=tf(Num,Den);

%% Mapa de polos e zeros
figure(2)
pzmap(sys)

figure(3)
pzmap(sysSS)

%% Margem de ganho e fase

figure(4)
margin(sys)
grid on

%% Diagrama de Nyquist
figure(5)
nyquist(sys)
figure(1)
Closed_Logarithmic_Nyquist(sys)

%% Lugar das ra�zes
figure(6)
rlocus(sys)

%% Resposta ao degrau
figure(7)
step(sys)
grid on
