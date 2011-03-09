function window = tanhWindow(f1, f2, transitionWidth, samplerate, n)
% Tanh window.
% f1, f2:          Lower and upper frequency bounds.
% transitionWidth: Width of the transition, measured in frequency. Controls 
%                  the steepness of the window.
% samplerate:      Samplerate of signal.
% n:               Vumber of samples (should be even for the moment).

freqs = linspace(samplerate/n, samplerate/2, n/2)';
win = (0.5 + 0.5*tanh((freqs - f1)/transitionWidth)) ...
	- (0.5 + 0.5*tanh((freqs - f2)/transitionWidth));
window = [win; win(length(win):-1:1)];
