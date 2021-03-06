function y = lowpassfilter(x)
%LOWPASSFILTER Filters input x and returns output y.

%
% MATLAB Code
% Generated by MATLAB(R) 7.14 and the Signal Processing Toolbox 6.17.
%
% Generated on: 02-Oct-2014 10:55:17
%

persistent Hd;

if isempty(Hd)
    
    Fpass = 120;   % Passband Frequency
    Fstop = 150;   % Stopband Frequency
    Apass = 1;     % Passband Ripple (dB)
    Astop = 160;    % Stopband Attenuation (dB)
    Fs    = 8000;  % Sampling Frequency
    
    h = fdesign.lowpass('fp,fst,ap,ast', Fpass, Fstop, Apass, Astop, Fs);
    
    Hd = design(h, 'equiripple', ...
        'MinOrder', 'any', ...
        'StopbandShape', 'flat');
    
    
    
    set(Hd,'PersistentMemory',true);
    
end

y = filter(Hd,x);


% [EOF]
