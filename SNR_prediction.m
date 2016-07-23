clc
clear all;
close all;

el_length=10e-6;
h=10e-6;

sep= 15e-6; 
resistivity= 1.176; %NaCl solution resistivity
Rf=16900; %gain for transimpedance stage

Res=214210;

fs=14400; %sampling frequency
fc=500000;
bolt_constant=1.38e-23;
T=298;

Q= 0.08; %flow rate
d= 100e-9:100e-9:10e-6; %particle size
fin= 2; %number of finger
Vin= 1; %input voltage amplitude

k1= 0.00027; %proportionality constant
period= k1/Q;
f=1/period; %frequency of signal
t1= 0:1/fs:5;
pulse_shape= ones(1,length(t1))*0;
noise= 4*bolt_constant*T/Res*sqrt(fc);
t = 0:1/fs:(period/2)*(fin-1); %duration of signal
t2= 0:1/fs:5+(period/2)*(fin-1);
t3 = 1.5:1/fs:3.5;
t4 = 1.5:1/fs:2;

for i=1: length(d)
    R=Res/(fin-1);
    I=Vin/R;
    A=30e-6*h;
    D= 2*sqrt(A/pi); %diameter of the channel
    r= -4*resistivity*d(i)^3/(pi*D^4);
    delI= abs((r/(Res^2))*Vin);
%   signal_filter= abs(sin(2*pi*f*t));
         
        I2= ones(1,length(t1))*0;
        
        for k=1:length(t)
            pulse_shape(k+2*fs)= abs(sin(2*pi*f*t(k))*delI);
        end
   
        signal= I2 + pulse_shape;
        max(signal)
    
        noisy_signal= (signal + noise*randn(1, length(t1)))*Rf;
        %max(noisy_signal*1.1e6);
        noisy_signal_after_gain= noisy_signal*1e5 + 26.127e-3*randn(1, length(t1));
        
%         C=conv(noisy_signal,signal_filter);
            
            
        for k=1:length(t3)
            C_truncated(k)= noisy_signal_after_gain(1.5*fs+k-1);
        end
        
            
        for k=1:length(t4)
            C_baseline(k)= noisy_signal_after_gain(1.5*fs+k-1);
        end
        
        M= mean(C_baseline);
        maximum_signal = max(C_truncated);
        maximum_noise = max(C_baseline);
        peak_amplitude = maximum_signal - M;
        %noise_amplitude = maximum_noise - M;
        power_noise = var(C_baseline) %finding noise variance

        %SNR(i) = (peak_amplitude/noise_amplitude);
        SNR(i) = (peak_amplitude)/sqrt(power_noise); %finding SNR
end 
    
plot(d,SNR);
xlabel('particle diameter');
ylabel('SNR');
title('SNR (channel width 30 micrometer)');