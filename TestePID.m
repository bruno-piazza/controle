clc
clear all
close all

addpath('Matrizes\')

A = importdata('matrix_A1lin.txt');
B = importdata('matrix_B1lin.txt');
C = importdata('matrix_C1.txt');
D = importdata('matrix_D1.txt');
sysss=ss(A,B,C,D);

[Num,Dem] = ss2tf(A,B,C,D,3);
Num=Num(3,:);
sys=tf(Num,Dem);
figure(1)
pzmap(sys)
figure(2)
pzmap(sysss)
figure(3)
rlocus(sys)