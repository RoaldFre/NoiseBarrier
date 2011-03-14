function shifted = syncdirect(master, slave, timePeriod, leadingSilence, samplerate, interpolationSteps, normalizeAmplitude)
% shifted = syncdirect(master, slave, timePeriod, leadingSilence, 
%                      samplerate, interpolationSteps)
%
% Syncronise the slave to the master based on the first 'timePeriod' 
% seconds of non-silence. This is used to syncronised free field 
% measurements with measurements that also have echoes, based on the first 
% few miliseconds of direct sound only.
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
	% Try to normalize the signals as best as we can
	% Set up a preliminary window with only direct sound and normalize the 
	% maxima. Note that this can fail if the maximum is at the edge of the 
	% window!.
	masterWindow = master(triggerMaster - preWindowSamples...
				: triggerMaster + samplesInTimePeriod);
	slaveWindow = slave(triggerSlave - preWindowSamples...
				: triggerSlave + samplesInTimePeriod);
	slave = slave * max(abs(masterWindow)) / max(abs(slaveWindow));
	%still need to refine!
	%TODO: check if at edge of window
end



%set up a window and shift it through to optimize the time difference
%TODO: this could be optimized (cross correlation?)
bestRms = inf;
bestShift = 0;
masterWindow = master(triggerMaster - preWindowSamples...
			: triggerMaster + samplesInTimePeriod);

for shift = -samplesInTimePeriod : samplesInTimePeriod
	slaveWindow = slave(triggerSlave - preWindowSamples + shift...
				: triggerSlave + samplesInTimePeriod + shift);
	rms = norm(masterWindow - slaveWindow);
	if rms < bestRms
		bestShift = shift;
		bestRms = rms;
	end
end

shiftToNearestSample = triggerSlave - triggerMaster + bestShift;



if normalizeAmplitude
	% Refine the amplitudes further now that we are at the nearest sample
	bestRms = inf;
	bestFactor = 1;
	masterWindow = master(triggerMaster - 2*preWindowSamples...
			: triggerMaster + 2*samplesInTimePeriod);
	slaveWindow = slave(triggerSlave - 2*preWindowSamples + bestShift...
			: triggerSlave + 2*samplesInTimePeriod + bestShift);
	for factor = linspace(0.7, 1.3, 600)
		scaledSlaveWindow = slaveWindow * factor;
		rms = norm(masterWindow - scaledSlaveWindow);
		if rms < bestRms
			bestFactor = factor;
			bestRms = rms;
		end
	end

	slave = slave * bestFactor;
end



% Set up a window twice as large and shift this through on fractional 
% samples. The extra size is to avoid edge effects from the fourier 
% interpolation, and from the fact that this actualy does a *rotate* 
% instead of a *shift*.
% We shift width (=two) samples wide, as the renormalisation above may have 
% changed the ideal shift somewhat
width = 2;
masterWindow = master(triggerMaster - 2*preWindowSamples...
		: triggerMaster + 2*samplesInTimePeriod);
slaveWindow = slave(triggerSlave - 2*preWindowSamples + bestShift...
		: triggerSlave + 2*samplesInTimePeriod + bestShift);

totalnum = width * 2 * interpolationSteps + 1; %total number of interpolations
%deltaSamples = linspace(-1 + 1/totalnum, 1 - 1/totalnum, totalnum);
deltaSamples = linspace(-width, width, totalnum);
rms = inf;
bestDelta = 0;
for delta = deltaSamples
	shifted = shiftInterpolation(slaveWindow, delta);
	% calculate the rms, but throw away the extra windowsize:
	rms = norm(masterWindow(preWindowSamples : end - samplesInTimePeriod)...
		- shifted(preWindowSamples : end - samplesInTimePeriod));
	
	if rms < bestRms
		bestDelta = delta;
		bestRms = rms;
	end
end

shifted = shiftInterpolation(shiftWithZeros(slave, -shiftToNearestSample), bestDelta);







%clf;
%hold on;
%plot(master,'ko');
%plot(shifted,'rx');
%axis([triggerMaster - preWindowSamples, triggerMaster + samplesInTimePeriod, -0.1,0.1]);
%hold off;

