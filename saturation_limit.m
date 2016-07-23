    clc
    clear all;
    close all;
    
el_length=10e-6;
h=1e-6:1e-6:10e-6;
l=0.25e-6:0.25e-6:el_length/2;

for j=1:length(l)
    x= -l(j)-7e-6:1e-9:7e-6+l(j);
    a= 7.5e-6 +l(j);
    b= (j^5)*l(j)/250000;
    y= b*sqrt(a^2-x.^2)/a;
    plot(x,y);
    hold on;
end
hold off;

sep= 15e-6; 
A= 30e-6*l(1);
resistivity= 1.176; %NaCl solution resistivity

for i=1:length(h)
    for j=1:length(l)
        a= (sep/2) +l(j);
        b= (j^5)*l(j)/250000;
        if b>h(i)
           break
        end
        L(j)=(pi/2)*(3*(a+b)-sqrt((3*a+b)*(a+3*b)));
        R(j)= resistivity*L(j)/A;
    end
    
    Rp(1)=R(1);

    for k=1:j-2
        Rp(k+1)=Rp(k)*R(k+1)/(Rp(k)+R(k+1));
    end
    Res(i)= Rp(j-1);
end
Res  

    fs=10000; %sampling frequency
    Q=0.03; %flow rate
    
    p= 1:30; %number of peaks
    Vin=1;
    
    for i=1: length(h)
        for j=1: length(p)
            R=Res(i)/p(j);
            A=30e-6*h(i);
            D= 2*sqrt(A/pi); %diameter of the channel
        
            d= h(i); %particle size
             
            I(i,j)=Vin/R;
            resistivity= 1.176; %NaCl solution resistivity
            r= -4*resistivity*d^3/(pi*D^4);
            delI(i,j)= abs((r/Res(i)^2)*Vin);
    

        end   
    end
    
    current= I+delI
    

    