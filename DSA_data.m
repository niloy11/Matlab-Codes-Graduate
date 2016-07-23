clc 
clear all
close all

load 'Dynamic_Signal_analyzer_data.csv';

A= Dynamic_Signal_analyzer_data;
B= Dynamic_Signal_analyzer_data(:,1);
C= Dynamic_Signal_analyzer_data(:,2);
D= Dynamic_Signal_analyzer_data(:,3);

E= 10.^(C/20);
F= 10.^(D/20);
G= sqrt(F.^2-E.^2);

figure
loglog(B,E);
xlabel('frequency(Hz)');
ylabel('Vrms/sqrt(Hz)');
title('PSD of Inrinsic noise of Dynamic Signal Analyzer');

figure
loglog(B,F);
xlabel('frequency(Hz)');
ylabel('Vrms/sqrt(Hz)');
title('PSD of Inrinsic noise of Dynamic Signal Analyzer+ Lock in amplifier circuit at 500 kHz freq');

figure
loglog(B,G);
xlabel('frequency(Hz)');
ylabel('Vrms/sqrt(Hz)');
title('PSD of Lock in amplifier circuit at 500 kHz freq');
