clc
clear all
close all
%% Parâmetros do sistema
addpath('Matrizes\')

A = importdata('matrix_A1lin.txt');
B = importdata('matrix_B1lin.txt');
C = importdata('matrix_C1.txt');
D = importdata('matrix_D1.txt');

%% Construção do sistema via espaço de estados
sysss=ss(A,B,C,D);

%% Construção da função de transferência de malha aberta (q3->Rot Própria)
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



%% Lugar das raízes
figure(5)
rlocus(sys)
