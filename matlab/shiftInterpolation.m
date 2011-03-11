function [shifted] = shiftInterpolation(data, samples)
% [shifted] = shiftInterpolation(data, samples)
% Shift the given signal by the given amount of samples. "Samples" 
% can be fractional, the result will be fourier interpolated in that case.
%
% Actually, the signal gets "rotated" instead of shifted: everything that 
% gets pushed over the end is added at the beginning of the signal. 
%
% Authors: Roald Frederickx, Elise Wursten.

% Rotate to nearest sample
data = circshift(data, round(samples));
if (samples == round(samples))
	%no need to do fourier interpolation
	%can shift exactly and avoid artefacts
	shifted = data;
	return;
end
	
%fractional shift, need to interpolate
samples = samples - round(samples);
n = length(data);
freqs = linspace(-pi, pi, n)';
phaseDiff = fftshift(exp(-i * samples * freqs));
plot(angle(phaseDiff));
shifted = real(ifft(fft(data) .* phaseDiff));
%TODO: is there an error here? This does not seem to work without without 
%the 'real' -- hovewer, there should not be any imaginary components!
