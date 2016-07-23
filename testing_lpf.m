clear
Fs=10000;
Ts=1/Fs;		
tinc=Ts;
N=50;
V=N*Ts;
fm=1500;
finc=Fs/N;
t=0:tinc:V-tinc;
f=0:finc:Fs-finc;
%Generate the impulse Response of the low-pass filter.
Wn=(2*fm)/Fs;
h=fir1(N-1,Wn);
%Plot the impulse response h(t).
plot(t,h)
grid
xlabel('Time in Seconds')
ylabel('Magnitude')
title('Impulse Response of Low-pass filter')
pause
%Compute the Fourier transform of the impulse response.
fh=fft(h);
mfh=abs(fh);        %Obtain Magnitude of Spectrum.
plot(f,mfh)
grid
xlabel('Frequency in Hz')
ylabel('Magnitude')
title('Frequency Response H(f) of Low-pass filter')
pause
afh=angle(fh);      %Obtain Argument of Spectrum.
plot(f,afh)
grid
xlabel('Frequency in Hz')
ylabel('Angle, Phase, or Argument')
title('Frequency Response H(f) of Low-pass filter')
pause
%Use of intrinsic function "fftshift" to obtain standard spectrum.
sfh=fftshift(fh);
sf=-Fs/2:finc:Fs/2-finc;
msfh=abs(sfh);
plot(sf,msfh)
grid
xlabel('Frequency in Hz')
ylabel('Magnitude')
title('Standard Plot of Frequency Response H(f) of Low-pass filter')
pause
asfh=angle(sfh);
plot(sf,asfh)
grid
xlabel('Frequency in Hz')
ylabel('Angle, Phase, or Argument')
title('Standard Plot of Frequency Response H(f) of Low-pass filter')
