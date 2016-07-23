    clc
    clear all;
    close all;
    
el_length=10e-6;
h=1e-6;
l=0.25e-6:0.25e-6:el_length/2;

sep= 15e-6; 
A= 30e-6*l(1);
resistivity= 1.176; %NaCl solution resistivity

for i=1:length(h)
    for j=1:length(l)
        a= (sep/2) +l(j);
        b= (j^5)*l(j)/250000;
        if b>h(i)
           break
        end
        L(j)=(pi/2)*(3*(a+b)-sqrt((3*a+b)*(a+3*b)));
        R(j)= resistivity*L(j)/A;
    end
    
    Rp(1)=R(1);

    for k=1:j-2
        Rp(k+1)=Rp(k)*R(k+1)/(Rp(k)+R(k+1));
    end
    Res(i)= Rp(j-1);
end
Res    
    fs=10000; %sampling frequency
    Q=0.03; %flow rate
    
    
    p= 20; %number of peaks
    Vin=1;
    
    k1= 0.00027; %proportionality constant
    period= k1/Q;
    f=1/period; %frequency of signal
    t1= 0:1/fs:5;
    pulse_shape= ones(1,length(t1))*0;
    noise= 2e-12*sqrt(f);
    
    
    
    
            R=Res/p;
            A=30e-6*h;
            D= 2*sqrt(A/pi); %diameter of the channel
        
            d= 100e-9; %particle size
             
            I=Vin/R;
            resistivity= 1.176; %NaCl solution resistivity
            r= -4*resistivity*d^3/(pi*D^4);
            delI= abs((r/Res^2)*Vin);
    
            t = 0:1/fs:(period/2)*p; %duration of signal
            signal_filter= abs(sin(2*pi*f*t)*delI);
         
            I2= ones(1,length(t1))*I;
        
            for k=1:length(t)
                pulse_shape(k+2*fs)= abs(sin(2*pi*f*t(k))*delI);
            end
   
            signal= I2+pulse_shape;
    
            noisy_signal= signal + noise*randn(1, length(t1));
    
            t2= 0:1/fs:5+(period/2)*p;
            C=conv(noisy_signal,signal_filter);
            
            figure
            plot(t2,C);
            
            t3 = 1.5:1/fs:3.5;
            for k=1:length(t3)
                C_truncated(k)= C(1.5*fs+k-1);
            end
        
            t4 = 1.5:1/fs:2;
            for k=1:length(t4)
                C_baseline(k)= C(1.5*fs+k-1);
            end
        
            M= mean(C_baseline);
            maximum_signal = max(C_truncated);
            maximum_noise = max(C_baseline);
            peak_amplitude = maximum_signal - M;
            noise_amplitude = maximum_noise - M;

            SNR = 20*log10(peak_amplitude/noise_amplitude)
        
