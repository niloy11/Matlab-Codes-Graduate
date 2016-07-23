clc
clear all;
close all;

Vin=1;
fs=40000;
t=0:1/fs:5;
f1=10000;
V=Vin*cos(2*pi*f1*t);
p= 10; %number of peaks
R=214210/p;
I=V/R;
Iin=Vin/R;

Rf=10000;

Q=0.003; %flow rate
    
D= 2*sqrt(30e-6*10e-6/pi); %diameter of the channel

k1= 0.00027; %proportionality constant
period= k1/Q;
f2=1/period; %frequency of signal
pulse_shape= ones(1,length(t))*0;
noise= 2e-12*sqrt(f2);

d= 3e-6;
Res= 214210;
resistivity= 1.176; %NaCl solution resistivity
r= -4*resistivity*d^3/(pi*D^4);
delI= abs((r/Res^2)*Iin)*100;
    
t1 = 0:1/fs:(period/2)*p; %duration of signal
         
for k=1:length(t1)
    pulse_shape(k+2*fs)= abs(sin(2*pi*f2*t1(k))*delI);
end
   
signal= I+pulse_shape;
signal_V= signal*Rf;
plot(t,signal_V);

noisy_signal_I= signal + noise*(randn(1, length(t)));

noisy_signal_V=noisy_signal_I*Rf;


% L = 10000; %length of FFT
% NFFT = 2^nextpow2(L); %make window into power of 2 (faster computational time);
% 
% sigs_fft = fft(noisy_signal_V, NFFT)/L; % FFT of mixed signal and noise
% % f = linspace(-NFFT/2,NFFT/2+1,NFFT);
% f = fs/2*linspace(-1,1,NFFT); % frequency axis
% figure(); plot(f,(fftshift(abs(sigs_fft)))); title('FFT of noisy signal');

% % low pass filter part
% lp = fir1(20, 0.1); % FIR LPF 20 orders, cutoff at 0.1*4000 = 400 Hz
% lp_fft = fft(lp, NFFT); % FFT of the filter
% figure(); plot(f, fftshift(abs(lp_fft)));
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% recov_fft = lp_fft.*sigs_fft; % multiplying filter and mixed signals in frequency domain
% recov = L*ifft(recov_fft); % recover the signal (any signal lower than 400 Hz in this case)
% figure(); plot(abs(recov)); 


 C1= noisy_signal_V.*cos(2*pi*f1*t);  
 C2= lowpassfilter(C1);
 plot(t,C2);

signal_filter= abs(sin(2*pi*f2*t1)*delI);
signal_filter_V= signal_filter*Rf;
    
t2= 0:1/fs:5+(period/2)*p;
C=conv(C2,signal_filter_V);
figure
plot(t2,C);
            
            