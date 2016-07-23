clc
clear all;
close all;

Vin=1;
fs=40000;
t=0:1/fs:5;
f1=10000;
V=Vin*cos(2*pi*f1*t);
p= 10; %number of peaks
R=214210/p;
I=V/R;
Iin=Vin/R;

Rf=10000;

Q=0.003; %flow rate
    
D= 2*sqrt(30e-6*10e-6/pi); %diameter of the channel

k1= 0.00027; %proportionality constant
period= k1/Q;
f2=1/period; %frequency of signal
pulse_shape= ones(1,length(t))*0;
noise= 2e-12*sqrt(f2);

d= 3e-6;
Res= 214210;
resistivity= 1.176; %NaCl solution resistivity
r= -4*resistivity*d^3/(pi*D^4);
delI= abs((r/Res^2)*Iin);
    
t1 = 0:1/fs:(period/2)*p; %duration of signal
         
for k=1:length(t1)
    pulse_shape(k+2*fs)= abs(sin(2*pi*f2*t1(k))*delI);
end
   
signal= I+pulse_shape;
signal_V= signal*Rf;
plot(t, signal_V);
    
noisy_signal_I= signal + noise*(randn(1, length(t)));

noisy_signal_V=noisy_signal_I*Rf;
figure
plot(t, noisy_signal_V);
plot(t,noisy_signal_V);

%  C1= noisy_signal_V.*cos(2*pi*f1*t);  
%  C2= lowpassfilter(C1);
%  plot(t,C2);
% 
% signal_filter= abs(sin(2*pi*f2*t1)*delI);
% signal_filter_V= signal_filter*Rf;
%     
% t2= 0:1/fs:5+(period/2)*p;
% C=conv(C2,signal_filter_V);
% figure
% plot(t2,C);