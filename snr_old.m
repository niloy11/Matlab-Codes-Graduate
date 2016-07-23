    clc
    clear all;
    close all;
    
    fs=10000; %sampling frequency
    Q=0.03; %flow rate
    d= [350e-9 400e-9 500e-9 600e-9 700e-9 800e-9 900e-9 1e-6 2e-6 3e-6 4e-6 5e-6 6e-6 7e-6 8e-6 9e-6 10e-6]; %particle size
    f= 20; %number of fingers
    ch= 10e-6: 5e-6 : 100e-6;
    Vin=1;
    Res=142100;
    k1= 0.00027; %proportionality constant
    period= k1/Q;
    f=1/period; %frequency of signal
    t1= 0:1/fs:5;
    pulse_shape= ones(1,length(t1))*0;
    noise= 2e-12*sqrt(f);
    
    
    for i=1: length(d)
        for j=1: length(ch)
            R=142100/(f-1); 
            I=Vin/R;
            resistivity= 1.176; %NaCl solution resistivity
            A=30e-6*ch(j);
            D= 2*sqrt(A/pi); %diameter of the channel
            r= -4*resistivity*d(i)^3/(pi*D^4);
            delI= abs((r/Res^2)*Vin);
    
            t = 0:1/fs:(period/2)*(f-1); %duration of signal
            signal_filter= abs(sin(2*pi*f*t)*delI);
         
            I2= ones(1,length(t1))*I;
        
            for k=1:length(t)
                pulse_shape(k+2*fs)= abs(sin(2*pi*f*t(k))*delI);
            end
   
            signal= I2+pulse_shape;
    
            noisy_signal= signal + noise*randn(1, length(t1));
    
            t2= 0:1/fs:5+(period/2)*(f-1);
            C=conv(noisy_signal,signal_filter);
            
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

            SNR(j,i) = 20*log(peak_amplitude/noise_amplitude);
        end   
    end
    
    [x,y]=meshgrid(d,ch);
    
    surf(x,y,SNR)
    colormap hsv
    colorbar
    view(2)
    
    xlabel('particle diameter(m)');
    ylabel('channel height'); 
    zlabel('SNR')
    title('design space');
    
%         [p,s,mu]=polyfit((1:nume1(C))',C,6);
%         f_y=polyval(p,(1:nume1(C))', [], mu);
%         
%         signal_detrend=C-f_y;
        
        
    
    