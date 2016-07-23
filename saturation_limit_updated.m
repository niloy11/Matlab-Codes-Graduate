clc
clear all;
close all;
    
el_width=1e-6; %electrode width
h=2e-6; %channel height
ch_width= 30e-6; %channel width
sp_el= 1e-6; %electrode spacing

resistivity= 1.176; %NaCl solution resistivity
Res= resistivity*sp_el/(ch_width*el_width)

    fs=10000; %sampling frequency
    Q=0.03; %flow rate
    
    fin= 1:300; %number of fingers
   
    Vin=0.1; %input voltage
    d= h; %particle size is equal to channel height
    
        for j=1: length(fin-1)
            R=Res/(fin(j)-1);
            A=30e-6*h;
            D= 2*sqrt(A/pi); %diameter of the channel
        
            
             
            I(j)=Vin/R;
            r= -4*resistivity*d^3/(pi*D^4);
            delI(j)= abs((r/Res^2)*Vin);
        end   
    
    
    current= I+delI
    
    for i=1: length(fin)
        if current(i)>1e-4
           break;
        end
    end
    
    max_finger=i-1 %maximum finger
    

    