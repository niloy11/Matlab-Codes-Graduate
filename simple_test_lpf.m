clc
clear all;
close all;

fs=80000;
t=0:1/fs:5;
fc=10000;

Q=0.003; %flow rate

D= 19.54e-6; %diameter of the channel

Vin=1;
k1= 0.00027; %proportionality constant
period= k1/Q;
f=1/period; %frequency of signal
pulse_shape= ones(1,length(t))*0;
noise= 2e-12*sqrt(f);
Res= 214210;
p=20;
R= Res/p;
Rf=10000;
Iin=Vin/R;
d= 3e-6;

resistivity= 1.176; %NaCl solution resistivity
r= -4*resistivity*d^3/(pi*D^4);
delI= abs((r/Res^2)*Vin);
    
t1 = 0:1/fs:(period/2)*p; %duration of signal
         
for k=1:length(t1)
    pulse_shape(k+2*fs)= abs(sin(2*pi*f*t1(k))*delI);
end

figure
subplot(2,2,1), plot(t,pulse_shape);
title('pulse shape');

noisy_signal= pulse_shape + noise*(randn(1, length(t)));
noisy_signal_V= noisy_signal*Rf;

subplot(2,2,2), plot(t,noisy_signal_V);
title('noisy signal');

y1= ammod(noisy_signal_V,fc,fs);
subplot(2,2,3), plot(t,y1);
title('amplitude modulation');

y2= amdemod(y1,fc,fs);
subplot(2,2,4),plot(t,y2);
title('amplitude demodulation');

% signal_filter= abs(sin(2*pi*f2*t1)*delI);
% signal_filter_V= signal_filter*Rf;
%     
% t2= 0:1/fs:5+(period/2)*p;
% C=conv(C2,signal_filter_V);
% 
% figure
% plot(t2,C);
% title('match filtered signal');


