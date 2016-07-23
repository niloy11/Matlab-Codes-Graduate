clc
clear all; 
close all;

% d= 15; %unit is in micron
% A= 30e-12;
% resistivity= 1.176; %NaCl solution resistivity
% 
% for i=1:10
%     L(i)=pi*((d+2*(i-1))*1e-6)/2;
%     R(i)= resistivity*L(i)/A;
% end
% 
% Rp(1)=R(1);
% 
% for i=1:9
%     Rp(i+1)=Rp(i)*R(i+1)/(Rp(i)+R(i+1));
% end

% d= 15e-6; %unit is in micron
% A= 30e-6*0.5e-6;
% resistivity= 1.176; %NaCl solution resistivity
% 
% for i=1:20
%     L(i)=pi*((d+(i-1)*1e-6))/2;
%     R(i)= resistivity*L(i)/A;
% end
% 
% Rp(1)=R(1);
% 
% for i=1:19
%     Rp(i+1)=Rp(i)*R(i+1)/(Rp(i)+R(i+1));
% end

d= 15e-6; %unit is in micron
A= 30e-6*1e-7;
resistivity= 1.176; %NaCl solution resistivity

for i=1:100
    L(i)=pi*((d+2*(i-1)*1e-7))/2;
    R(i)= resistivity*L(i)/A;
end

Rp(1)=R(1);

for i=1:99
    Rp(i+1)=Rp(i)*R(i+1)/(Rp(i)+R(i+1));
end