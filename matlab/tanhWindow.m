function window = tanhWindow(f1, f2, width1, width2, samplerate, n)
% Tanh window.
% f1, f2:         Lower and upper frequency bounds.
% width1, width2: Width of the transition, measured in frequency. Controls 
%                 the steepness of the window.
% samplerate:     Samplerate of signal.
% n:              Number of samples (should be even for the moment).

if mod(n,2)
	freqs = -(n-1)/2 : (n-1)/2; % N odd
else
	freqs = -n/2 : n/2-1; % N even
end
freqs = ifftshift(freqs)';

window = (0.5 + 0.5*tanh((abs(freqs) - f1)/width1)) ...
	.* (0.5 + 0.5*tanh(-(abs(freqs) - f2)/width2));

figure;
plot(window)
