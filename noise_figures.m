clc
clear all
close all

load 'Baseline_with_4_micro_litre_PBS_with_LPF.csv';
x=Baseline_with_4_micro_litre_PBS_with_LPF(:,2);
t=Baseline_with_4_micro_litre_PBS_with_LPF(:,1);
plot(t,x,'b');

ylabel('Voltage (Volt)');
xlabel('time (sec)');
hold on

load 'Baseline_with_6_micro_litre_PBS_with_LPF.csv';
x=Baseline_with_6_micro_litre_PBS_with_LPF(:,2);
plot(t,x,'c');

hold on

% load 'Baseline_with_6_micro_litre_PBS_with_LPF_2nd_time.csv';
% x=Baseline_with_6_micro_litre_PBS_with_LPF_2nd_time(:,2);
% plot(x,'g');
% 
% hold on

load 'Baseline_with_4_micro_litre_Beads_2nd_time_with_LPF.csv';
x=Baseline_with_4_micro_litre_Beads_2nd_time_with_LPF(:,2);
plot(t,x,'r');

hold on

legend('Baseline with 4 micro litre PBS','Baseline with 6.5 micro litre PBS','Baseline with 4 micro litre Beads');