function [shifted] = sync(master, slave)
% shifted = sync(master, slave)
%
% Syncronise the slave to the master by finding the peak in the 
% crosscorrelation and shifting accordingly. The signal gets padded with 
% zeros.
%
% This only works well if the signals are padded in leading and trailing 
% silence!
%
% Authors: Roald Frederickx, Elise Wursten.

%rolling our own crosscorrelation to keep Octave compatibilty
xcorr = ifft(fft(master) .* (fft(slave(length(slave):-1:1))));
%plot(xcorr);
n = length(xcorr);


shiftInd = find(abs(xcorr) == max(abs(xcorr)));
%amount of positions to shift the slave. Can be "negative"!
if shiftInd < n/2
	shifted = [zeros(shiftInd, 1); slave(1 : n-shiftInd)];
else
	shiftInd = n - shiftInd;
	shifted = [slave(shiftInd+1 : n); zeros(shiftInd,1)];
end


% The above should have synced the signals to the nearest time sample 
% "bin". We can shift the signal in between these bins by tweaking the 
% phase.
% This is effectively doing fourier interpolation.
%
% Could not do a linear regression on the difference of the phase spectra 
% reliably to get the difference immediately, so brute forcing and 
% minimizing the error:


bestRms = -inf;
bestShifted = shifted;

deltaSamples = linspace(-1,1,20);
for delta = deltaSamples
	thisShifted = shiftInterpolation(shifted, delta);
	thisRms = norm(master - thisShifted);
	if thisRms < bestRms
		bestShifted = shifted;
	end
end

shifted = bestShifted;

