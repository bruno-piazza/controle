% Sintonia por ZIEGLER-NICHOLS
clc
clear all
close all
%% Par�metros do sistema
addpath('Matrizes\')

A = importdata('matrix_A1lin.txt');
B = -importdata('matrix_B1lin.txt');
C = importdata('matrix_C1.txt');
D = importdata('matrix_D1.txt');


sample_rate = 100;
t = 0:1/sample_rate:10;
n = length(t);
%% Constru��o da fun��o de transfer�ncia de malha aberta (q3->Rot Pr�pria)
[Num,Den] = ss2tf(A,B,C,D,3);
Num=Num(3,:);

sys=tf(Num,Den);
N=tf(Num,1);
D=tf(Den,1);
s=tf([1 0],1);

%% Determina��o do ganho cr�tico
rlocus(sys)
kcrit=0.75 %Utilizar o mais adequado a partir do lugar das raizes anterior
Gkcrit=pid(kcrit,0,0); 
a=series(Gkcrit,sys); 
syskcrit=feedback(a,1)

%% Determina��o do per�odo de oscila��o harm�nica
figure(2)
step(syskcrit,t)
y=step(syskcrit,t)

[~,peaklocs] = findpeaks(y);
Pcrit = t(round(mean(diff(peaklocs))));

%% Determina��o do controlador
Ti=Pcrit/2;
Td=.125*Pcrit;

kp=.6*kcrit;
ki=kp/Ti;
kd=Td*kp;

GcZN=pid(kp,ki,kd); 
a=series(GcZN,sys); 
sysZN=feedback(a,1)

figure(42)
step(sysZN,t);
grid on
stepinfo(sysZN)

figure(5)
pzmap(sysZN)