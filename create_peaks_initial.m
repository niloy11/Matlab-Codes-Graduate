%function [y] = cp(fs,number_of_peaks,Q,peak_size_percent)

    fs=10000;
    number_of_peaks=1;
    Q=0.03;
    peak_size_percent=1;

    V=0.5; 
    peak_size= peak_size_percent/100;
    v=peak_size*V; %change in amplifier output voltage

    k1= 0.00027; %proportionality constant
    period= k1/Q;
    f=1/period; %frequency of signal
    
    t = 0:1/fs:(period/2)*number_of_peaks; %duration of signal
    signal_filter= abs(sin(2*pi*f*t)*v);
    t1= 0:1/fs:5; 
    V2= ones(1,length(t1))*V;
    pulse_shape= ones(1,length(t1))*0;
   
    for i=1:length(t)
        pulse_shape(i+2*fs)= abs(sin(2*pi*f*t(i))*v);
    end
   
    signal= V2+pulse_shape;
    
    noisy_signal= signal + v*randn(1, length(t1));
    
    C=conv(noisy_signal,signal_filter);
    t2= 0:1/fs:5+(period/2)*number_of_peaks;
    
    figure
    subplot(2,1,1), plot(t1,signal);
    ylim([0.5-3*v,0.5+3*v]);
    xlabel('Time (sec)');
    ylabel('Amplitude'); 
    title('Signal with different no. of peaks');
    subplot(2,1,2), plot(t1,noisy_signal);
    xlabel('Time (sec)');
    ylabel('Amplitude'); 
    title('Noisy Signal');
    
    figure
    plot(t2,C);
    xlabel('Time (sec)');
    ylabel('Amplitude'); 
    title('Match filter output');
    