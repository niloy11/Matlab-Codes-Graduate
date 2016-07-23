clc 
clear all
close all

% fileID= fopen('7.8125Hz.txt','r');
% formatSpec='%f';
% x1=fscanf(fileID, formatSpec);
% fclose(fileID);
% 
% figure
% plot(x1);
% title('Sample rate 7.8125 sps');

fileID= fopen('test1.txt','r');
formatSpec='%f';
x2=fscanf(fileID, formatSpec);
fclose(fileID);

figure
plot(x2);
title('Sample rate 16.125 sps');
% 
% fileID= fopen('31.25Hz.txt','r');
% formatSpec='%f';
% x3=fscanf(fileID, formatSpec);
% fclose(fileID);
% figure
% plot(x3);
% title('Sample rate 31.25 sps');

% fileID= fopen('62.5Hz.txt','r');
% formatSpec='%f';
% x4=fscanf(fileID, formatSpec);
% fclose(fileID);
% figure
% plot(x4);
% title('Sample rate 62.5 sps');
% 
% fileID= fopen('125Hz.txt','r');
% formatSpec='%f';
% x5=fscanf(fileID, formatSpec);
% fclose(fileID);
% figure
% plot(x5);
% title('Sample rate 125 sps');

% fileID= fopen('250Hz.txt','r');
% formatSpec='%f';
% x6=fscanf(fileID, formatSpec);
% fclose(fileID);
% figure
% plot(x6);
% title('Sample rate 250 sps');

% fileID= fopen('500Hz.txt','r');
% formatSpec='%f';
% x7=fscanf(fileID, formatSpec);
% fclose(fileID);
% figure
% plot(x7);
% title('Sample rate 500 sps');

% fileID= fopen('1kHz.txt','r');
% formatSpec='%f';
% x8=fscanf(fileID, formatSpec);
% fclose(fileID);
% figure
% plot(x8);
% title('Sample rate 1k sps');

% fileID= fopen('2kHz_with_cap.txt','r');
% formatSpec='%f';
% x9=fscanf(fileID, formatSpec);
% fclose(fileID);
% 
% plot(x9);
% title('Sample rate 2k sps');
% 
% fileID= fopen('4kHz.txt','r');
% formatSpec='%f';
% x10=fscanf(fileID, formatSpec);
% fclose(fileID);
% 
% plot(x10);
% title('Sample rate 4k sps');