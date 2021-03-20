Fs = 1000; %sampling frequency
T = 1/Fs; %sampling period
L = 1500; %length of signal
t = (0:L-1)*T; %time vector
S = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t); %signal as a sum of two sinusoids
figure 
plot(Fs*t(1:50), S(1:50));
title('Signal Corrupted with Zero-Mean Random Noise')
xlabel('t (milliseconds)')
ylabel('S(t)')