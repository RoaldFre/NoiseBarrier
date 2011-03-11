function trig = trigger(signal, silenceSamples, thresholdFactor, numAboveThreshold)
% Find the index of the sample where the actual signal starts.
%
% Parameters:
%
% signal:
%   The actual signal.
%
% silenceSamples:
%   The amount of samples at the beginning of the signal that are silence. 
%   Used to find the rms of the noise.
%
% thresholdFactor:
%   Regard a sample that has an amplutide that is higher than 
%   thresholdFactor times the rms of the noise as an actual signal.
%
% numAboveThreshold:
%   Number of required consecutive samples that are above the threshold in 
%   order to accept them as non-silence.
%
%
% Authors: Roald Frederickx, Elise Wursten.



noise = signal(1:silenceSamples);
noiseLevel = norm(noise)/sqrt(length(noise));
threshold = noiseLevel * thresholdFactor;

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
