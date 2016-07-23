clear all; close all ; clc;

Vin=1;
fs=20000;
t=0:1/fs:5;
f1=10000;
V=Vin*cos(2*pi*f1*t);
R=214210;
I=V/R;
Iin=Vin/R;

Rf=10000;

Q=0.03; %flow rate
    
D= 19.54e-6; %diameter of the channel
p= 20; %number of peaks
k1= 0.00027; %proportionality constant
period= k1/Q;
f2=1/period; %frequency of signal
pulse_shape= zeros(1,length(t));
noise= 2e-12*sqrt(f2);

d= 3e-6;

resistivity= 1.176; %NaCl solution resistivity
r= -4*resistivity*d^3/(pi*D^4);
delI= abs((r/R^2)*Vin);
    
t1 = 0:1/fs:(period/2)*p; %duration of signal
         
for k=1:length(t1)
    pulse_shape(k+2*fs)= abs(sin(2*pi*f2*t1(k))*delI);
end

% sig = delI*10000*cos(2*pi*150*t);

signal= I+pulse_shape; % there is one pulse at about 100 samples
    
noisy_signal_I= signal + noise*(randn(1, length(t)));

noisy_signal_V=noisy_signal_I*Rf;

C1= noisy_signal_V.*cos(2*pi*f1*t);  
% C2= lowpassfilter(C1);

figure();
plot(t,C1);

% fil = gui_lpf(C1);



%%%%%%%%%
len = length(C1);
NFFT = 2^nextpow2(len);
f = fs/2*linspace(-1,1,NFFT); % frequency axis
c1_fft = fft(C1,NFFT)/len;
figure(); plot(f, fftshift(abs(c1_fft))); hold on;


%%%%% FILTER %%%%%

tap = 800;
% lp = fir1(tap, [0.008 0.02], 'DC-0'); % FIR LPF 20 orders, cutoff at 0.1*4000 = 400 Hz
lp = fir1(tap, 0.012);
lp_fft = fft(lp, NFFT); % FFT of the filter
plot(f, fftshift(abs(lp_fft)), 'r'); title('FFT sigs and filter');

recov_fft = lp_fft.*c1_fft;
plot(f, fftshift(abs(recov_fft)), 'c'); hold off;
legend('orig fft', 'filter', 'recov fft')

recov = len*ifft(recov_fft);
recov = recov(:,1:len - tap);
% recov = [recov C1(:, end-tap+1:end)];
figure(); plot(abs(recov)); title('FFT recovered signals');

%%%%%%%%

signal_filter= abs(sin(2*pi*f2*t1)*delI);
signal_filter_V= signal_filter*Rf;
    
t2= 0:1/fs:length(abs(recov))+(period/2)*p;
C=conv(abs(recov),signal_filter_V);
figure
plot(t2,C);
