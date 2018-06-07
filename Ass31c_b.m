%Assignment 3.1c)
clc
clear all
close all

k = 1:4;
r(k) = 0.85.^(k-1);                          %autocorrelation function

Rvv = toeplitz(r);

P = chol(Rvv, 'lower');                     %Cholesky-factorization

n = 1:2000;                                  % time index
E = randn(4,n(end))*0.2;                     %property of whiteness

V = P*E

%repeating b)

f_s = 16000;                                % sampling frequency
f_c = 7800;                                 % carrier frequency
c = exp(i*n/f_s*2*pi*f_c);  

%create baseband signal as sum of sinusoids
f1 = 50;
f2 = 2*f1;
s1 = cos(2*pi*f1*n/f_s);                      % baseband component f1
s2 = sin(2*pi*f2*n/f_s);                  % baseband component f2  
r1 = s1.*c;
r2 = s2.*c;

%generate phase shift vector h1
theta = 30;                                 % DOA 
theta = theta/360*2*pi;
j = 1:4;                                    % beamformer with 4 antennas
h1(j) = (exp(i*2*pi/5*cos(theta))).^(j-1);   % phase shift vector        
h1=h1.'; 

%generate phase shift vector h2
theta = 45;                                 % DOA 
theta = theta/360*2*pi;
j = 1:4;                                    % beamformer with 4 antennas
h2(j) = (exp(i*2*pi/5*cos(theta))).^(j-1);   % phase shift vector        
h2=h2.'; 

% compute antenna signals for the two arriving components

Y1 = h1*r1;
Y2 = h2*r2;  
Ysum = Y1 + Y2 + V;

% compute beamformer

theta0 =30;                              % angle of unit response 
theta0 = theta0/360*2*pi;
h0(j) = (exp(i*2*pi/5*cos(theta0))).^(j-1); % phase shift vector 
h0=h0.';             

Ryy= corr(Ysum'); 

c0=h0'*Ryy^(-1)/(h0'*Ryy^(-1)*h0)

shat= c0*Ysum; 

figure
plot(n,s1, 'g')
hold on
plot(n,s2, 'r')
title('baseband signals')

figure()
plot(n,Ysum(1,:),'m')
hold on
plot(n,Ysum(2,:),'r')
hold on
plot(n,Ysum(3,:),'g')
hold on
plot(n,Ysum(4,:),'b')
title('arriving signals at the antennas')

figure
plot(real(shat))
hold on
plot(n,s1, 'g')
hold on
plot(n,s2, 'r')
title('beamformer output and baseband signals')