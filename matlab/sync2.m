function [shifted] = sync2(master, slave)
% shifted = sync(master, slave)
%
% Syncronise the slave to the master by finding the peak in the 
% crosscorrelation and shifting accordingly. The signal gets padded with 
% zeros.
%
% Authors: Roald Frederickx, Elise Wursten.

kcorr = xcorr(master,slave);
n = length(kcorr);

shiftInd = find(kcorr == max(kcorr));
if shiftInd < n/2
    shiftInd = length(slave) - shiftInd;
    shifted = [slave(shiftInd+1 : end); zeros(shiftInd, 1)];
else
    shiftInd = shiftInd - length(slave);
    shifted = [zeros(shiftInd,1); slave(1 : end-shiftInd)];
end
