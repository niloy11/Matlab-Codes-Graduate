clear all; close all; clc;

Fs = 8000; % sampling frequency
T = 1/Fs;

t = linspace(0,1,8000);
f1 = 1250; % freq1
f2 = 2550; % freq2
f3 = 5; % freq3
sig1 = 2*cos(2*pi*f1*t); %signal 1
sig2 = cos(2*pi*f2*t); %signal 2
sig3 = cos(2*pi*f3*t); %signal 3
noise = 100*randn(1,8000); % random Gaussian noise - change the factor at the beginning to change noise magnitude
% noise = 10*rand(1,8000); % there is a DC component

sigs = sig1+sig2+sig3+noise; %mixed signals and noise


figure(); plot(t, sigs); title('Mixed signals and noise');

L = 4000; %length of FFT
NFFT = 2^nextpow2(L); %make window into power of 2 (faster computational time);

sigs_fft = fft(sigs, NFFT)/L; % FFT of mixed signal and noise
% f = linspace(-NFFT/2,NFFT/2+1,NFFT);
f = Fs/2*linspace(-1,1,NFFT); % frequency axis
figure(); plot(f,(fftshift(abs(sigs_fft)))); title('FFT of mixed signals and noise');


% noise1 = randn(1,8000);
% noise2 = rand(1,8000);
% figure(); pwelch(noise1);
% figure(); pwelch(noise2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% low pass filter part
lp = fir1(200, 0.01); % FIR LPF 20 orders, cutoff at 0.1*4000 = 400 Hz
lp_fft = fft(lp, NFFT); % FFT of the filter
figure(); plot(f, fftshift(abs(lp_fft)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

recov_fft = lp_fft.*sigs_fft; % multiplying filter and mixed signals in frequency domain
recov = L*ifft(recov_fft); % recover the signal (any signal lower than 400 Hz in this case)
figure(); plot(abs(recov)); 
xlabel('change noise factor to zero to see the signal more clearly');
title('recovered 120 Hz signal and noise');
% change f3 to about 5 Hz to see clear signal;




%%

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
p= 1; %number of peaks
k1= 0.00027; %proportionality constant
period= k1/Q;
f2=1/period; %frequency of signal
pulse_shape= zeros(1,length(t));
noise= 2e-12*sqrt(f2);



d= 3e-6;

resistivity= 1.176; %NaCl solution resistivity
r= -4*resistivity*d^3/(pi*D^4);
delI= abs((r/R^2)*Iin);
    
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
