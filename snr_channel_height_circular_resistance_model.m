    clc
    clear all;
    close all;
    
    fs=10000; %sampling frequency
    Q=0.03; %flow rate
    d= 100e-9: 100e-9: 10e-6; %particle size
    f= 20; %number of fingers
    ch= 1e-6: 1e-6 : 10e-6;
    Vin=1;
    Res=142100;
    R=142100/(f-1); 
    I=Vin/R;
    resistivity= 1.176; %NaCl solution resistivity
    k1= 0.00027; %proportionality constant
    period= k1/Q;
    f=1/period; %frequency of signal
    t1= 0:1/fs:5;
    pulse_shape= ones(1,length(t1))*0;
    noise= 2e-12*sqrt(f);
    t = 0:1/fs:(period/2)*(f-1); %duration of signal
    t2= 0:1/fs:5+(period/2)*(f-1);
    t3 = 1.5:1/fs:3.5;
    t4 = 1.5:1/fs:2;
    
    for i=1: length(d)
        for j=1: length(ch)
            A=30e-6*ch(j);
            D= 2*sqrt(A/pi); %diameter of the channel
            r= -4*resistivity*d(i)^3/(pi*D^4);
            delI= abs((r/Res^2)*Vin);
            signal_filter= abs(sin(2*pi*f*t)*delI);
         
            I2= ones(1,length(t1))*I;
        
            for k=1:length(t)
                pulse_shape(k+2*fs)= abs(sin(2*pi*f*t(k))*delI);
            end
   
            signal= I2+pulse_shape;
    
            noisy_signal= signal + noise*randn(1, length(t1));
    
            
            C=conv(noisy_signal,signal_filter);
            
            
            for k=1:length(t3)
                C_truncated(k)= C(1.5*fs+k-1);
            end
        
            
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
        
        
    
    