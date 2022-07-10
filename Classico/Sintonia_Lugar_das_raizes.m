%% Sintonia por Lugar das Ra�zes (Executar c�lula por c�lula)
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
N=tf(Num,1);
D=tf(Den,1);
s=tf([1 0],1);

Gc=compensador2P(-0.5+1i,Den);
sys=series(Gc,sys)

figure(643)
step(sys)
%% Sintonia proporcional
close all


figure(1)
rlocus(sys)

%% Sintonia proporcional (continua��o)
kp=-1; %Utilizar o mais adequado a partir do lugar das raizes anterior
Gkp=pid(kp,0,0); 
a=series(Gkp,sys); 
syskpmf=feedback(a,1);

figure(10)
pzmap(syskpmf);

figure(2)
step(syskpmf); 

%% Sintonia integrativa
syskima=(N/(s*(D+(kp*N))));

figure(3)
rlocus(syskima)

%% Sintonia integrativa (continua��o)
ki=0; %Utilizar o mais adequado a partir do lugar das raizes anterior
Gki=pid(kp,ki,0); 
a=series(Gki,sys); 
syskimf=feedback(a,1);

figure(4)
step(syskimf); 

%% Sintonia derivativa
syskdma=((N*(s^2))/(s*D+(kp*s*N)+(ki*N)));

figure(5)
rlocus(syskdma)

%% Sintonia derivativa (continua��o)
kd=-0.2; %Utilizar o mais adequado a partir do lugar das raizes anterior
Gkd=pid(kp,ki,kd); 
a=series(Gkd,sys); 
syskdmf=feedback(a,1);

figure(6)
step(syskdmf); 
