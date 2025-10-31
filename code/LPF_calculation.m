clear all;

close all;

clc;

Fc=1e6;%环路带宽

Kvco=2*pi*1e9;%VCO增益

Icp=100e-6;%电荷泵电流

Kpd=Icp/(2*pi);% PFD/CP 增益 (V/rad)

N=40;%分频比

PM=50;%相位裕度

%==========================================================

w0=2*pi*Fc;%  带宽频率

fai=(pi/180)*PM; % 相位裕度rad

t1=(1/cos(fai)-tan(fai))/w0;%时间常数1

t2=1/(w0*w0*t1);%时间常数2


a = sqrt(((w0*t2)^2+1)/((w0*t1)^2+1));
b=(Kpd*Kvco)/(N*w0*w0);

C2=(t1/t2)*b*a;

C1=C2*(t2/t1-1);

R=t2/C1;



Fs=tf([t2,1],[t1,1,0])/(C2+C1);%滤波器传递函数

OLs=(Kpd*Kvco/N)*Fs*tf(1,[1 0]);%开环传递函数

%===================开环传递函数波特图======================

figure(1)

bode(OLs,{2*pi*1e4,2*pi*1e8})

grid on;

disp(['C1 = ', num2str(C1), ' F'])
disp(['C2 = ', num2str(C2), ' F'])
disp(['R  = ', num2str(R),  ' Ohm'])

[Gm, Pm, Wcg, Wcp] = margin(OLs);

disp(['Gain crossover freq = ', num2str(Wcp/(2*pi)), ' Hz'])
disp(['Phase margin = ', num2str(Pm), ' deg'])
