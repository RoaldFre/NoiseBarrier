function window = tanhWindow(f1, f2, width1, width2, samplerate, n)
% Tanh window.
% f1, f2:         Lower and upper frequency bounds.
% width1, width2: Width of the transition, measured in frequency. Controls 
%                 the steepness of the window.
% samplerate:     Samplerate of signal.
% n:              Number of samples (should be even for the moment).

freqs = linspace(samplerate/n, samplerate/2, n/2)';
win = (0.5 + 0.5*tanh((freqs - f1)/width1)) ...
	- (0.5 + 0.5*tanh((freqs - f2)/width2));
if mod(n, 2)
	%window = [win; 0; win(length(win):-1:1)];
	error 'uneven lengths make tanhwindow sad!'
	window = [];
else
	window = [win; win(length(win):-1:1)];
end
