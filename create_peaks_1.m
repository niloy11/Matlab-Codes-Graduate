function [y] = create_peaks(fs,number_of_peaks,Q,peak_size_percent)

clc
close all;
clear all;

R=10000; %resistance of the solution
peak_size= peak_size_percent/100;
r=peak_size*R; %change in resistance

k1= 0.025; %proportionality constant
period= k1/Q;
f=1/period; %frequency of signal
k2=0.6;
st=k2/Q;
t = st:1/fs:st+(period/2)*number_of_peaks; %duration of signal
R2= ones(1,length(t))*R;
pulse_shape= abs(sin(2*pi*f*t)*r);
signal= R2+pulse_shape;

figure
plot(t,signal);
ylim([10^4-2*r,10^4+2*r]);
xlabel('Time (sec)');
ylabel('Amplitude'); 
title('Signal with different no. of peaks');
