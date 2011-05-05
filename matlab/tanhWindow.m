function window = tanhWindow(f1, f2, width1, width2, samplerate, n)
% Tanh window.
% f1, f2:         Lower and upper frequency bounds.
% width1, width2: Width of the transition, measured in frequency. Controls 
%                 the steepness of the window.
%                 If width = 0, don't put a window on this end
% samplerate:     Samplerate of signal.
% n:              Number of samples (should be even for the moment).

if mod(n,2)
	freqs = (-(n-1)/2 : (n-1)/2) / n * samplerate; % N odd
else
	freqs = (-n/2 : n/2-1) / n * samplerate; % N even
end
freqs = ifftshift(freqs)';


if width1 != 0
	left = (0.5 + 0.5*tanh((abs(freqs) - f1)/width1));
else
	left = ones(size(freqs));
end

if width2 != 0
	right = (0.5 + 0.5*tanh(-(abs(freqs) - f2)/width2));
else
	right = ones(size(freqs));
end

window = right .* left;

return

figure;
plot(window)
