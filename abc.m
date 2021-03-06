function y = abc(x)
%ABC Filters input x and returns output y.

%
% MATLAB Code
% Generated by MATLAB(R) 7.14 and the Signal Processing Toolbox 6.17.
%
% Generated on: 09-Oct-2014 11:37:00
%

persistent Hd;

if isempty(Hd)
    
    Fpass = 50;    % Passband Frequency
    Fstop = 80;    % Stopband Frequency
    Apass = 1;     % Passband Ripple (dB)
    Astop = 150;   % Stopband Attenuation (dB)
    Fs    = 4000;  % Sampling Frequency
    
    h = fdesign.lowpass('fp,fst,ap,ast', Fpass, Fstop, Apass, Astop, Fs);
    
    Hd = design(h, 'equiripple', ...
        'MinOrder', 'any', ...
        'StopbandShape', 'flat');
    
    
    
    set(Hd,'PersistentMemory',true);
    
end

y = filter(Hd,x);


% [EOF]
