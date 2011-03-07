function [shifted] = shiftInterpolation(data, samples)
% Shift the given signal by the given amount of samples. "Samples" can be 
% fractional, the result will be fourier interpolated in that case.
%
% Authors: Roald Frederickx, Elise Wursten.

n = length(data);
freqs = linspace(-pi, pi, n)';
phaseDiff = fftshift(exp(i * samples * freqs));
shifted = ifft(fft(data) .* phaseDiff);

