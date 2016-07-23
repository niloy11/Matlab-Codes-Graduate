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
noise = 0*randn(1,8000); % random Gaussian noise - change the factor at the beginning to change noise magnitude
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
lp = fir1(20, 0.1); % FIR LPF 20 orders, cutoff at 0.1*4000 = 400 Hz
lp_fft = fft(lp, NFFT); % FFT of the filter
figure(); plot(f, fftshift(abs(lp_fft)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

recov_fft = lp_fft.*sigs_fft; % multiplying filter and mixed signals in frequency domain
recov = L*ifft(recov_fft); % recover the signal (any signal lower than 400 Hz in this case)
figure(); plot(abs(recov)); 
xlabel('change noise factor to zero to see the signal more clearly');
title('recovered 120 Hz signal and noise');
% change f3 to about 5 Hz to see clear signal;
