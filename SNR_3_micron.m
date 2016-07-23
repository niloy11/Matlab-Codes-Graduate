clc
clear all;
close all;
    
el_length=10e-6; %electrode length 10 micron
h=10e-6; %channel height 10 micron
l=0.25e-6:0.25e-6:el_length/2; %taking 0.25 micron length small portion of electrode to develop the elliptical model

sep= 15e-6; %electrode seperation 15 micron
A= 30e-6*l(1); %cross sectional area for each small portion of electrode where length is 0.25 micron and width of channel is 30 micron
resistivity= 1.176; %NaCl solution resistivity

%developing the elliptical model
    for j=1:length(l)
        a= (sep/2) +l(j); %horizontal radius
        b= (j^5)*l(j)/250000; %vertical radius using the equation of ellipse. Here I approximated the equation to get same electrical flux profile as Gerwen et al.
        if b>h %I do this for only finding the electrical fluxes those are within the 10 micron high channel and get rid of the fluxes those are cut off
           break
        end
        L(j)=(pi/2)*(3*(a+b)-sqrt((3*a+b)*(a+3*b))); %calculating the length of the electrical flux tube 
        R(j)= resistivity*L(j)/A; %calculating radius
    end
    
    % calculating parallel resistance
    Rp(1)=R(1);

    for k=1:j-2
        Rp(k+1)=Rp(k)*R(k+1)/(Rp(k)+R(k+1));
    end
    Res= Rp(j-1)

fs=10000; %sampling frequency
Q=0.1; %flow rate
    
fin= 1:0.1:25; %number of finger
d=100e-9:40e-9:10e-6; %particle diameter
Vin=0.1; %input signal voltage 100mV
Rf=10000; %gain for transimpedance stage 10k V/A
 

resistivity= 1.176; %NaCl solution resistivity
k1= 0.00027; %proportionality constant
period= k1/Q; %period for the signal peak created by passing cell
f=1/period; %frequency of signal peak
t1= 0:1/fs:5; %total time period
pulse_shape= ones(1,length(t1))*0; %we add zero for rest of the time period other than signal peak so this is just a zero line for the total time period
noise= 2e-12*sqrt(f); %noise calculation

t3 = 1.5:1/fs:3.5; %time period to find maximum of peak signal
t4 = 1.5:1/fs:2; %time period to get baseline voltage
    
for i=1: length(d)
    for j=1: length(fin)
        R=Res/(fin(j)-1); %parallel resistance
        I=Vin/R; %current
        A=30e-6*h; %cross sectional area of the channel
        D= 2*sqrt(A/pi); %diameter of the channel
        r= -4*resistivity*d(i)^3/(pi*D^4); %resistance change due to passing of cell
        delI= abs((r/Res^2)*Vin); %current change due to passing of cell
        t = 0:1/fs:(period/2)*(fin(j)-1); %duration of signal peak, it changes with number of fingers
        signal_filter= abs(sin(2*pi*f*t)); %filter that we get using flow rate infrmation which gives us f. We use this for match filtering
         
        I2= ones(1,length(t1))*I; %baseline current
        
        for k=1:length(t)
            pulse_shape(k+2*fs)= abs(sin(2*pi*f*t(k))*delI); %signal peak
        end
   
        signal= I2+pulse_shape; %adding signal peak with baseline current
    
        noisy_signal= (signal + noise*randn(1, length(t1)))*Rf; %adding random noise and converting current to voltage by multiplying with gain
            
        C= conv(noisy_signal,signal_filter); %convolution of noisy signal with filter to do the match filtering
                
        for k=1:length(t3)
            C_truncated(k)= C(1.5*fs+k-1); %considering a portion of signal to find the maximum peak
        end
            
        for k=1:length(t4)
            C_baseline(k)= C(1.5*fs+k-1); %considering a portion of signal to find baseline voltage
        end
        
        M = mean(C_baseline); %finding baseline voltage of the convoluted signal
        maximum_signal = max(C_truncated); %finding signal peak
        power_noise = var(C_baseline); %finding noise variance
        peak_amplitude = maximum_signal - M; %finding amplitude of the peak

        SNR(j,i) = 10*log10((peak_amplitude)^2/power_noise); %finding power SNR
    end   
end

    [x,y]=meshgrid(d,fin);
    figure
    surf(x,y,SNR)
    colormap hsv
    colorbar
    view(2)
    
    xlabel('particle diameter(m)');
    ylabel('number of electrode fingers'); 
    zlabel('SNR')
    title('design space');
    