function [spectrum] = lowpass(f, sr, n, order)

fs = linspace(-sr/2,sr/2,n)';
spec = 1./(1+i*fs/f).^order;
spectrum = ifftshift(spec);

% t = linspace(0, n/sr, n);
% impulse = 2*pi*f*exp(-2*pi*f*t);
% spectrum = fft(impulse);