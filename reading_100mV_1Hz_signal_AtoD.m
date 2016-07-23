clc 
clear all
close all

fileID= fopen('100mV_1Hz_signal.txt','r');
formatSpec='%f';
x=fscanf(fileID, formatSpec);
fclose(fileID);

plot(x);
title('Sample rate 2k sps');
y=sqrt(x);
rng default
Fs = 4000;
t = 0:1/Fs:1-1/Fs;

N = length(y);
xdft = fft(y);
xdft = xdft(1:N/2+1);
psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:Fs/length(x):Fs/2;
psdx= sqrt(psdx);

figure
loglog(freq,psdx);
grid on
title('Power Spectral Density_2ksps');
xlabel('Frequency (Hz)');
ylabel('Voltasge/sqrt(frequency)(Volt/sqrt(Hz))');