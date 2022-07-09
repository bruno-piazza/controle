clc
clear
close


%Definição do tempo
DateString = '01-September-2010';
formatIn = 'dd-mmm-yyyy';
time = datenum(DateString,formatIn);

%Definição da longitude
inclination = 80*pi/180;
v_longitude = 0:1:360;

%Definição da latitude
v_latitude = atan(tan(inclination)*sin(v_longitude*pi/180))*180/pi;

%Definição da Altitude 
altitude = 500 + 6400;

%Definição das coordenadas
coord = 'geocentric';

[Bx, By, Bz] = igrf(time, v_latitude, v_longitude, altitude, coord);
B = [Bx By Bz]*1e-9

figure(1)
plot(v_longitude,Bx)
hold on
plot(v_longitude,By)
plot(v_longitude,Bz)
