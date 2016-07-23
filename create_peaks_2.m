%function [y] = cp(fs,number_of_peaks,Q,peak_size_percent)
    clc
    clear all;
    close all;
    
    fs=10000;
    number_of_peaks=20;
    Q=0.03;
%     peak_size_percent=1;
    
    Vin=1;
    d= 100e-9;
    D= 30e-6*1e-6;
    R=276150/number_of_peaks; 
    R1=276150;
    I=Vin/R
    resistivity= 1.176; %NaCl solution resistivity
    r= -4*resistivity*d^3/(pi*D^4)
    i= abs((r/R1^2)*Vin)
    
%     peak_size= peak_size_percent/100;
%     v=peak_size*V; %change in amplifier output voltage

    k1= 0.00027; %proportionality constant
    period= k1/Q;
    f=1/period; %frequency of signal
    
    t = 0:1/fs:(period/2)*number_of_peaks; %duration of signal
    signal_filter= abs(sin(2*pi*f*t)*i);
    t1= 0:1/fs:5; 
    I2= ones(1,length(t1))*I;
    pulse_shape= ones(1,length(t1))*0;
   
    for j=1:length(t)
        pulse_shape(j+2*fs)= abs(sin(2*pi*f*t(j))*i);
    end
   
    signal= I2+pulse_shape;
    
    noise= 2e-12*sqrt(f);
    
    noisy_signal= signal + noise*randn(1, length(t1));
    
    C=conv(noisy_signal,signal_filter);
    t2= 0:1/fs:5+(period/2)*number_of_peaks;
    
%     figure
%     subplot(2,1,1), 
%     plot(t1,signal);
%     %ylim([I-10*i,I+10*i]);
%     xlabel('Time (sec)');
%     ylabel('Amplitude'); 
%     title('Signal with different no. of peaks');
%     subplot(2,1,2), plot(t1,noisy_signal);
%     xlabel('Time (sec)');
%     ylabel('Amplitude'); 
%     title('Noisy Signal');
    
    figure
    plot(t2,C);
    xlabel('Time (sec)');
    ylabel('Amplitude'); 
    title('Match filter output');
    