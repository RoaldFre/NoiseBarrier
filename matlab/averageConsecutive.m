function averaged = averageConsecutive(signal, singleLength, n, triggerThreshold, numAboveThreshold, numPreTrigger, ignoreFirstAndLast)
% averaged = averageConsecutive(signal, singleLength, n)
%
% Average 'n' consecutive measurements of length 'singleLength' (number of 
% samples). Triggering is done via 'triggermax.m'. This works best if the 
% signal is a series of impulse responses (obtained via an MLS 
% crosscorrelaiton or an deconvolution of the sent signal for a single 
% measurement padded with zeros).
%
% Authors: Roald Frederickx, Elise Wursten.

start = max(0, triggerMax(signal, triggerThreshold, numAboveThreshold) - numPreTrigger)

averaged = zeros(singleLength, 1);

if ignoreFirstAndLast
	steps = 1 : n-2;
else
	steps = 0 : n-1;
end

numberOfAverages = length(steps):

for i = steps
	averaged = averaged + signal(start + i*singleLength : start + (i+1)*singleLength - 1);
end

%averaged = averaged / n;
averaged = averaged / numberOfAverages;

