%load 'AuxIn.csv';
A=AuxIn;
x=AuxIn(:,3);
plot(x);

rng default
Fs = 1000;
t = length(x);

N = length(x);
xdft = fft(x);
xdft = xdft(1:N/2+1);
psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:Fs/length(x):Fs/2;

plot(freq,10*log10(psdx))
grid on
title('Periodogram Using FFT')
xlabel('Frequency (Hz)')
ylabel('Power/Frequency (dB/Hz)')

periodogram(x,rectwin(length(x)),length(x),Fs)
mxerr = max(psdx'-periodogram(x,rectwin(length(x)),length(x),Fs))