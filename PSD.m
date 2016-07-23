clc
clear all
close all
%%
load 'circuit_noise.csv';
load 'low_pass_filtered.csv'
%%
A=circuit_noise;B=low_pass_filtered;
x=A(:,2);x2=B(:,2);
y=sqrt(x);y2=sqrt(x2);
figure(1);
subplot(211)
plot(y);title('Unfiltered')
subplot(212)
plot(y2);title('Filtered')
%%
rng default
Fs = 1.11e3;
N = length(x);
t=((-N/2):(N/2-1))*Fs/N;
% t = 0:1/Fs:1-1/Fs;
figure(2)
xdft = abs(fftshift(fft(x)));
plot(t,10*log(xdft));
grid on
title('Spectrum Unfiltered')
xlabel('Frequency (Hz)')
ylabel('Voltage/dB')
 
psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);


% N = length(y);
% xdft = fft(y);
% xdft = xdft(1:N/2+1);
% psdx = (1/(Fs*N)) * abs(xdft).^2;
% psdx(2:end-1) = 2*psdx(2:end-1);
% freq = 0:Fs/length(x):Fs/2;
% 
figure(3)
% semilogx(freq,10*log10(psdx))
plot(t,10*log10(psdx))
grid on
title('PSD Using FFT')
xlabel('Frequency (Hz)')
ylabel('Voltage/sqrt(Frequency) (dB/sqrt(Hz))')
%%
figure
semilogx(freq,sqrt(psdx))
grid on
title('PSD Using FFT')
xlabel('Frequency (Hz)')
ylabel('Voltage/sqrt(Frequency) (V/sqrt(Hz))')