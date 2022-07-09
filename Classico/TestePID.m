clc
clear all
close all
%% Par�metros do sistema
addpath('Matrizes\')

A = importdata('matrix_A1lin.txt');
B = importdata('matrix_B1lin.txt');
C = importdata('matrix_C1.txt');
D = importdata('matrix_D1.txt');

%% Constru��o do sistema via espa�o de estados
sysss=ss(A,B,C,D);

%% Constru��o da fun��o de transfer�ncia de malha aberta (q3->Rot Pr�pria)
[Num,Dem] = ss2tf(A,B,C,D,3);
Num=Num(3,:);
sys=tf(Num,Dem);

RouthHurwitz(Dem)

%% Mapa de polos e zeros
figure(1)
pzmap(sys)

figure(2)
pzmap(sysss)

%% Margem de ganho e fase

figure(3)
margin(sys)
grid on



%% Lugar das ra�zes
figure(5)
rlocus(sys)
