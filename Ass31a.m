%Assignment 3.1
%Authors: Stefan Riedel 1330219
clc
clear all
close all

%a)

%generate modulated carrier wave s*c
f_s = 16000;                                % sampling frequency
f = 50:100:4950;                            % baseband sinusoid frequencies
n = 1:2000;                                 % time index

for jj=1:50
S(jj,:) = sin(2*pi*f(jj)*n/f_s);                      % baseband signals
end

f_c = 7800;                                 % carrier frequency
c = exp(i*n/f_s*2*pi*f_c);  

for jj=1:50
R(jj,:) = S(jj,:).*c;                                   % modulated carrier
end

% figure()
% plot(n,real(r))

%generate phase shift vector h
theta_d = 30;                                 % DOA 
theta_r = theta_d/360*2*pi;
j = 1:4;                                    % beamformer with 4 antennas
h(j) = (exp(i*2*pi/5*cos(theta_r))).^(j-1);   % phase shift vector        
h=h.'; 

%generate noise matrix

V = randn(4,n(end))*0.2;

% compute antenna signals
Y = ones(4,length(n));

for jj=1:50
A = h*R(jj,:) + V;
Y = [Y , A];
end

freq = 50;
jj = freq/50;
figure()
plot(n,Y(1,(length(n)*jj+1):(length(n)*jj+length(n))),'m')
hold on
plot(n,Y(2,(length(n)*jj+1):(length(n)*jj+length(n))),'g')
hold on 
plot(n,Y(3,(length(n)*jj+1):(length(n)*jj+length(n))),'b')
hold on
plot(n,Y(4,(length(n)*jj+1):(length(n)*jj+length(n))),'r')
title(['antenna signals for f= ' num2str(freq) ' Hz and DOA = ' num2str(theta_d) '??'])

%% 






% beamformer

theta0_d =30;                              % angle of unit response 
theta0_r = theta0_d/360*2*pi;
h0(j) = (exp(i*2*pi/5*cos(theta0_r))).^(j-1); % phase shift vector 
h0=h0.';             

Ryy = ones(length(j));
for jj=1:50    
B = corr( Y(:, (jj*length(n)+1):(length(n)*jj+length(n)))'); 
Ryy = [Ryy , B];
end

for jj=1:50
C0(jj,:) = h0'*Ryy(:, (length(j)*jj+1): (length(j)*jj+length(j)))^(-1)/(h0'*Ryy(:, (length(j)*jj+1): (length(j)*jj+length(j)))^(-1)*h0);
end

for jj=1:50
Shat(jj,:)= C0(jj,:)*Y(:, (jj*length(n)+1):(length(n)*jj+length(n)));
end 

freq = 50;
jj = freq/50;
figure
plot(real(Shat(jj,:)))
hold on
plot(real(S(jj,:)))
title([' b-former output and baseband signal , DOA = ' num2str(theta_d) ' ?? Unit = ' num2str(theta0_d) ' ?? '])




