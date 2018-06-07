%Assignment 3.1
%Authors: Stefan Riedel 1330219
clc
clear all
close all

%d)

%generate modulated carrier wave s*c
f_s = 16000;                                % sampling frequency
f = 100;                                    % baseband sinusoid frequency
n = 1:2000;                                 % time index
s = sin(2*pi*f*n/f_s);                      % baseband signal
f_c = 7800;                                 % carrier frequency
c = exp(i*n/f_s*2*pi*f_c);                  % carrier
r = s.*c;                                   % modulated carrier

na=4;                                      %number of antennas, increase for
                                            %sharper beams

%generate phase shift vector h

for jj=1:180
theta = jj;                                     % DOA from 1 to 180
theta = theta/360*2*pi;
j = 1:na;                                       % beamformer with 4 antennas
H(j,jj) = (exp(i*2*pi/5*cos(theta))).^(j-1);    % phase shift matrix        
end

%generate noise matrix

V = randn(na,n(end))*0.2;

% compute antenna signals
Y = ones(na,length(n));

for jj=1:180
A = H(:,jj)*r + V;
Y = [Y , A];
end



% beamformer

theta0 =30;                                       % angle of unit response 
theta0 = theta0/360*2*pi;
j=1:na;
h0(j) = (exp(i*2*pi/5*cos(theta0))).^(j-1);       % phase shift vector 
h0=h0.';             

Ryy = ones(length(j));
for jj=1:180    
B = corr( Y(:, (jj*length(n)+1):(length(n)*jj+length(n)))'); 
Ryy = [Ryy , B];
end

for jj=1:180
C0(jj,:) = h0'*Ryy(:, (length(j)*jj+1): (length(j)*jj+length(j)))^(-1)/(h0'*Ryy(:, (length(j)*jj+1): (length(j)*jj+length(j)))^(-1)*h0);
end

for jj=1:180
Shat(jj,:)= C0(jj,:)*Y(:, (jj*length(n)+1):(length(n)*jj+length(n)));
end

for jj=1:180
    sqrsum = 0;    
    for ll=1:length(n)
    sqrsum = sqrsum + (abs(real(Shat(jj,ll))))^2;
    end
    P(jj) = 1/length(n)*sqrsum;
end

for jj=1:180
    G(jj) = (10*log10(P(jj)));
end

G=G-max(G)+20; 
G(find(G<0))=0; 

theta_polar = 1/360*2*pi:1/360*2*pi:pi;             %polar plot 
figure
polar(theta_polar , G)
    
