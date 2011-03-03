function [shifted] = sync(master, slave)
% shifted = sync(master, slave)
%
% Syncronise the slave to the master by finding the peak in the 
% crosscorrelation and shifting accordingly. The signal gets padded with 
% zeros.
%
% Authors: Roald Frederickx, Elise Wursten.

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

%diff = master-shifted;
%rms = diff'*diff
