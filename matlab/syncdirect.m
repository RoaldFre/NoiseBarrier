function shifted = syncdirect(master, slave, timePeriod, leadingSilence, samplerate, interpolationSteps, normalizeAmplitude)
% shifted = syncdirect(master, slave, timePeriod, leadingSilence, 
%                      samplerate, interpolationSteps)
%
% Syncronise the slave to the master based on the first 'timePeriod' 
% seconds of non-silence. This is used to syncronised free field 
% measurements with measurements that also have echoes, based on the first 
% few miliseconds of direct sound only.
% Any DC offsets will be ignored.
%
% Returns the shifted slave. The signal gets padded 
% with zeroes when shifting.
%
% Warning: This method only works well if:
%  - the signals are padded in leading and trailing silence
%  - the signals are recorded at the same sensitivity
%
%
% Parameters:
%
% master, slave:
%   The signals. Slave will be synced to overlap with master.
%
% timePeriod:
%   Amount of seconds of non-silence that will be used to sync the 
%   signals.
%
% leadingSilence:
%   Amount of seconds of leading silence of the signals. Used to find out 
%   where the silence stops and the actual signal begins.
%   
% samplerate:
%   Samplerate of the recording
%
% interpolationSteps
%   Steps to interpolate *per direction*, for a total of
%   (2 * interpolationSteps + 1) actual interpolations. Set this to 0 if 
%   you don't want to do fourier interpolation (it may add artefacts)
%
% normalizeAmplitude
%   Set to true if you want to try and normalize the amplitude of the slave to 
%   the master. Set to false to leave amplitude unchanged.
%
%
% Authors: Roald Frederickx, Elise Wursten.


%amount of timePeriods to look ahead of trigger in order to sync
%TODO Make sure that this doesn't go too far "to the left" (in negative 
%indices)
preWindow = 0.2;

%trigger when the signal gets higher than thresholdFactor times the rms of 
%the leading noise
thresholdFactor = 4;

%trigger when the signal has numAboveThreshold successive samples above the 
%threshold
numAboveThreshold = 10;

samplesInTimePeriod = round(timePeriod * samplerate);
preWindowSamples = round(preWindow * samplesInTimePeriod) + 1;
silenceSamples = leadingSilence * length(master);

triggerMaster = trigger(master, silenceSamples, thresholdFactor, numAboveThreshold);
triggerSlave  = trigger(slave,  silenceSamples, thresholdFactor, numAboveThreshold);



if normalizeAmplitude
	% Try guess the amplitude of the signals as best as we can
	% Set up a preliminary window with only direct sound
	masterWindow = master(triggerMaster - preWindowSamples...
				: triggerMaster + samplesInTimePeriod);
	slaveWindow = slave(triggerSlave - preWindowSamples...
				: triggerSlave + samplesInTimePeriod);
	guessedFactor = max(abs(masterWindow)) / max(abs(slaveWindow))
	amplitudeFactors = guessedFactor * linspace(0.82, 1.18, 300);
				%TODO: tweak here or ask as argument
else
	amplitudeFactors = [1];
end






% Set up a window twice as large and shift this through on fractional 
% samples. The extra size is to avoid edge effects from the fourier 
% interpolation, and from the fact that this actualy does a *rotate* 
% instead of a *shift*.
masterWindow = master(triggerMaster - 2*preWindowSamples...
		: triggerMaster + 2*samplesInTimePeriod);
slaveWindow = slave(triggerSlave - 2*preWindowSamples...
		: triggerSlave + 2*samplesInTimePeriod);

width = samplesInTimePeriod / 10 + 2; %amount of samples to shift to left and 
                                      %right in search space
				      %TODO tweak this, or ask as argument
totalnum = width * 2 * interpolationSteps + 1; %total number of interpolations
shifts = linspace(-width, width, totalnum);

bestRms = inf;
bestShift = 0;
bestFactor = 1;
bestOffset = 0;
for shift = shifts
	shifted = shiftInterpolation(slaveWindow, shift);
	for factor = amplitudeFactors
		scaled = shifted * factor;
		% calculate the rms, but throw away the extra windowsize:
		diff = masterWindow(preWindowSamples : end - samplesInTimePeriod)...
			- scaled(preWindowSamples : end - samplesInTimePeriod);
		offsets = mean(diff);
		diff = diff - offset; %We don't care about DC offsets!
		rms = norm(diff);
		
		if rms < bestRms
			bestShift = shift;
			bestFactor = factor;
			bestRms = rms;
			bestOffset = offset;
		end
	end
end

bestRms
bestShift
bestFactor
bestOffset

shiftedToNearest = shiftWithZeros(slave, triggerMaster - triggerSlave + round(bestShift));
shifted = shiftInterpolation(shiftedToNearest, bestShift - round(bestShift));
shifted = shifted * bestFactor;



figure;
hold on;
plot(master,'ko');
plot(shifted - bestOffset,'rx');
plot(master - shifted + bestOffset,'g-');
axis([triggerMaster - preWindowSamples, triggerMaster + samplesInTimePeriod, -0.1,0.1]);
hold off;

