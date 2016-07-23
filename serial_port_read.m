clc 
clear all
close all

% fileID= fopen('arduino_data_250sps.txt','r');
% formatSpec='%f';
% x=fscanf(fileID, formatSpec);
% fclose(fileID);
% 
% plot(x);
% title('Sample rate 250sps');
% y=sqrt(x);
% rng default
% Fs = 500;
% t = 0:1/Fs:1-1/Fs;

% N = length(y);
% xdft = fft(y);
% xdft = xdft(1:N/2+0.5);
% psdx = (1/(Fs*N)) * abs(xdft).^2;
% psdx(2:end-1) = 2*psdx(2:end-1);
% freq = 0:Fs/length(x):Fs/2;
% psdx= sqrt(psdx);
% 
% figure
% loglog(freq,psdx);
% grid on
% title('Power Spectral Density')
% xlabel('Frequency (Hz)')
% ylabel('Voltasge/sqrt(frequency)(Volt/sqrt(Hz))')

fileID= fopen('arduino_data_3.5ksps.txt','r');
formatSpec='%f';
x=fscanf(fileID, formatSpec);
fclose(fileID);

plot(x);
title('Sample rate sps');
y=sqrt(x);
rng default
Fs = 7000;
t = 0:1/Fs:1-1/Fs;

% N = length(y);
% xdft = fft(y);
% xdft = xdft(1:N/2+1);
% psdx = (1/(Fs*N)) * abs(xdft).^2;
% psdx(2:end-1) = 2*psdx(2:end-1);
% freq = 0:Fs/length(x):Fs/2;

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
title('Power Spectral Density_3.5k');
xlabel('Frequency (Hz)')
ylabel('Voltasge/sqrt(frequency)(Volt/sqrt(Hz))')


% fileID= fopen('arduino_data_880sps.txt','r');
% formatSpec='%f';
% x=fscanf(fileID, formatSpec);
% fclose(fileID);
% 
% plot(x);
% title('Sample rate 880sps');
% y=sqrt(x);
% rng default
% Fs = 1760;
% t = 0:1/Fs:1-1/Fs;
% 
% N = length(y);
% xdft = fft(y);
% xdft = xdft(1:N/2+1);
% psdx = (1/(Fs*N)) * abs(xdft).^2;
% psdx(2:end-1) = 2*psdx(2:end-1);
% freq = 0:Fs/length(x):Fs/2;
% 
% figure
% semilogx(freq,10*log10(psdx))
% title('Noise Spectrum(880sps) Using FFT')
% xlabel('Frequency (Hz)')
% ylabel('Voltage/sqrt(Frequency) (dB/sqrt(Hz))')
% 
% fileID= fopen('arduino_data_2ksps.txt','r');
% formatSpec='%f';
% x=fscanf(fileID, formatSpec);
% fclose(fileID);
% 
% plot(x);
% title('Sample rate 2ksps');
% y=sqrt(x);
% rng default
% Fs = 4000;
% t = 0:1/Fs:1-1/Fs;
% 
% N = length(y);
% xdft = fft(y);
% xdft = xdft(1:N/2+0.5);
% psdx = (1/(Fs*N)) * abs(xdft).^2;
% psdx(2:end-1) = 2*psdx(2:end-1);
% freq = 0:Fs/length(x):Fs/2;
% 
% figure
% semilogx(freq,10*log10(psdx))
% title('Noise Spectrum(2k sps) Using FFT')
% xlabel('Frequency (Hz)')
% ylabel('Voltage/sqrt(Frequency) (dB/sqrt(Hz))')
% 
% fileID= fopen('arduino_data_3.5ksps.txt','r');
% formatSpec='%f';
% x=fscanf(fileID, formatSpec);
% fclose(fileID);
% 
% plot(x);
% title('Sample rate 3.5ksps');
% y=sqrt(x);
% rng default
% Fs = 7000;
% t = 0:1/Fs:1-1/Fs;
% 
% N = length(y);
% xdft = fft(y);
% xdft = xdft(1:N/2+1);
% psdx = (1/(Fs*N)) * abs(xdft).^2;
% psdx(2:end-1) = 2*psdx(2:end-1);
% freq = 0:Fs/length(x):Fs/2;
% 
% figure
% semilogx(freq,10*log10(psdx))
% title('Noise Spectrum(3.5k sps) Using FFT')
% xlabel('Frequency (Hz)')
% ylabel('Voltage/sqrt(Frequency) (dB/sqrt(Hz))')