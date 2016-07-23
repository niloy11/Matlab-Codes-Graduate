    clc
    clear all;
    close all;
    
el_length=10e-6;
h=10e-6;
l=0.25e-6:0.25e-6:el_length/2;

% for j=1:length(l)
%     x= -l(j)-7e-6:1e-9:7e-6+l(j);
%     a= 7.5e-6 +l(j);
%     b= (j^5)*l(j)/250000;
%     y= b*sqrt(a^2-x.^2)/a;
%     plot(x,y);
%     hold on;
% end
% hold off;

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
    
    D= 19.54e-6; %diameter of the channel
    p= 20; %number of peaks
    Vin=1;
    
    k1= 0.00027; %proportionality constant
    period= k1/Q;
    f=1/period; %frequency of signal
    t1= 0:1/fs:5;
    pulse_shape= ones(1,length(t1))*0;
    noise= 2e-12*sqrt(f);
    
    
    
    for i=1: length(h)
        for j=1: length(p)
            R=Res(i)/p(j);
            A=30e-6*h(i);
    D= 2*sqrt(A/pi); %diameter of the channel
        
            d= h(i); %particle size
             
            I(j,i)=Vin/R;
            resistivity= 1.176; %NaCl solution resistivity
            r= -4*resistivity*d(i)^3/(pi*D^4);
            delI(j,i)= abs((r/Res(i)^2)*Vin);
    
            t = 0:1/fs:(period/2)*p(j); %duration of signal
            signal_filter= abs(sin(2*pi*f*t)*delI);
         
            I2= ones(1,length(t1))*I;
        
            for k=1:length(t)
                pulse_shape(k+2*fs)= abs(sin(2*pi*f*t(k))*delI);
            end
   
            signal= I2+pulse_shape;
    
            noisy_signal= signal + noise*randn(1, length(t1));
    
            t2= 0:1/fs:5+(period/2)*p(j);
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
    
    current= I+delI
    
%     [x,y]=meshgrid(d,p);
%     
%     surf(x,y,SNR)
%     colormap hsv
%     colorbar
%     view(2)
%     xlabel('particle diameter(m)');
%     ylabel('number of peaks= number of fingers-1'); 
%     zlabel('SNR')
%     title('design space');
    
        
    
    