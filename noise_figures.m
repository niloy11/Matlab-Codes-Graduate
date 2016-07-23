clc
clear all
close all

load 'with_biosensor_no_fluid.csv';
x=with_biosensor_no_fluid(:,2);
y=sqrt(x);

rng default
Fs = 200000;
t = 0:1/Fs:1-1/Fs;

N = length(y);
xdft = fft(y);
xdft = xdft(1:N/2+0.5);
psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:Fs/length(x):Fs/2;
psdx1= sqrt(psdx);

load 'with_biosensor_with_fluid.csv';
x=with_biosensor_with_fluid(:,2);
y=sqrt(x);

N = length(y);
xdft = fft(y);
xdft = xdft(1:N/2+0.5);
psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
psdx2= sqrt(psdx);

load 'no_resistance.csv';
x=no_resistance(:,2);
y=sqrt(x);

N = length(y);
xdft = fft(y);
xdft = xdft(1:N/2+0.5);
psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
psdx3= sqrt(psdx);

load 'with_bare_resistor.csv';
x=with_bare_resistor(:,2);
y=sqrt(x);

N = length(y);
xdft = fft(y);
xdft = xdft(1:N/2+0.5);
psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
psdx4= sqrt(psdx);

load 'noise_of_daq_2nd_time.csv';
x=noise_of_daq_2nd_time(:,2);
y=sqrt(x);

N = length(y);
xdft = fft(y);
xdft = xdft(1:N/2+0.5);
psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
psdx5= sqrt(psdx);

figure
loglog(freq,psdx3,'c',freq,psdx1,'g',freq,psdx4,'b',freq,psdx2,'y',freq,psdx5,'r');
grid on
title('Power Spectral Density')
xlabel('Frequency (Hz)')
ylabel('Voltasge/sqrt(frequency)(Volt/sqrt(Hz))')
legend ('noise of circuit with no sensor connected','noise of circuit with biosensor having no fluid in it','noise of circuit with 10k ohm input resistor in place of biosensor','noise of circuit with biosensor having fluid in it','noise of Analog to Digital Converter');