function [shifted] = shiftInterpolation(data, samples)
% Shift the given signal by the given amount of samples. "Samples" 
% can be fractional, the result will be fourier interpolated in that case.
%
% Actually, the signal gets "rotated" instead of shifted: everything that 
% gets pushed over the end is added at the beginning of the signal. 
%
% Authors: Roald Frederickx, Elise Wursten.

if (samples == fix(samples))
	%no need to do fourier interpolation
	%can shift exactly and avoid artefacts
	shifted = circshift(data, samples);
	return;
end
	
%fractional shift, need to interpolate
n = length(data);
freqs = linspace(-pi, pi, n)';
phaseDiff = fftshift(exp(-i * samples * freqs));
shifted = ifft(fft(data) .* phaseDiff);

