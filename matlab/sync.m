function [shifted, rms] = sync(master, slave, interpolationSteps)
% [shifted, rms] = sync(master, slave, interpolationSteps)
%
% Syncronise the slave to the master by finding the peak in the 
% crosscorrelation and shifting accordingly. The signal gets padded with 
% zeros.
% An additional step will be carried out to synchronize on a sub-sample 
% timescale by using fourier interpolation. We will check for 
% 'interpolationSteps' steps in the range of one sample to the left and 
% right of the ideal shift found by the crosscorrelation.
% Zero means no interpolation, one means: check halve a sample to the left 
% and halve a sample to the right.
%
% This method only works well if the signals are padded in leading and 
% trailing silence!
%
% Returns:
%  shifted: the shifted signal
%  rms:     the error between the master and the shifted signal
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

bestRms = inf;
bestShifted = shifted;

totalnum = 2*interpolationSteps + 1; %total number of interpolations
deltaSamples = linspace(-1+1/totalnum, 1-1/totalnum, totalnum);
		%no need to check one full sample to the left and right, as 
		%the xcorr would have selected those if they were better 
		%then the current shift.

for delta = deltaSamples
	thisShifted = shiftInterpolation(shifted, delta);
	thisRms = norm(master - thisShifted);
	if thisRms < bestRms
		bestShifted = thisShifted;
		bestRms = thisRms;
		delta
	end
end

shifted = bestShifted;
rms = bestRms;
