function trig = triggerMax(signal, thresholdFactor, numAboveThreshold)
% Find the index of the sample where the actual signal starts.
%
% Parameters:
%
% signal:
%   The actual signal.
%
% thresholdFactor:
%   Fraction of the maxmium. Above this == considered as non-noise. 
%
% numAboveThreshold:
%   Number of required consecutive samples that are above the threshold in 
%   order to accept them as non-silence.
%
%
% Authors: Roald Frederickx, Elise Wursten.



threshold = max(abs(signal)) * thresholdFactor;

numAbove = 0;
for i=1:length(signal)
	if abs(signal(i)) > threshold
		numAbove = numAbove + 1;
		if numAbove >= numAboveThreshold
			trig = i - numAboveThreshold + 1;
			return
		end
	else
		numAbove = 0;
	end
end

trig = -1;
