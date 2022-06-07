clc
clear all
close all

addpath('Matrizes\')

A = importdata('matrix_A1lin.txt');
B = importdata('matrix_B1lin.txt');
% C = importdata('matrix_C1.txt');
C=[eye(6)];
D=[zeros(6,3)];
% D = importdata('matrix_D1.txt');

sys_aloc = ss(A,B,C,D);
[y,t,x]=impulse(sys_aloc);

figure(1)
pzmap(sys_aloc)

figure(2)
impulse(sys_aloc)