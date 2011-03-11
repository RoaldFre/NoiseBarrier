function shifted = syncdirect(master, slave, timePeriod, leadingSilence, samplerate, interpolationSteps)
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
% This method only works well if the signals are padded in leading and 
% trailing silence!
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



%set up a window and shift it through
%TODO: this could be optimized (cross correlation?)
bestRms = inf;
bestShift = 0;
masterWindow = master(triggerMaster - preWindowSamples
			: triggerMaster + samplesInTimePeriod);

for shift = -samplesInTimePeriod : samplesInTimePeriod
	shift = shift * 1;
	slaveWindow = slave(triggerSlave - preWindowSamples + shift
				: triggerSlave + samplesInTimePeriod + shift);
	rms = norm(masterWindow - slaveWindow);
	if rms < bestRms
		bestShift = shift;
		bestRms = rms;
	end
end


shiftToNearestSample = triggerSlave - triggerMaster + bestShift;

% Set up a window twice as large and shift this through on fractional 
% samples. The extra size is to avoid edge effects from the fourier 
% interpolation.

masterWindow = master(triggerMaster - 2*preWindowSamples
		: triggerMaster + 2*samplesInTimePeriod);
slaveWindow = slave(triggerSlave - 2*preWindowSamples + bestShift
		: triggerSlave + 2*samplesInTimePeriod + bestShift);

totalnum = 2 * interpolationSteps + 1; %total number of interpolations
deltaSamples = linspace(-1+1/totalnum, 1-1/totalnum, totalnum);
rms = inf;
bestDelta = 0;
for delta = deltaSamples
	shifted = real(shiftInterpolation(slaveWindow, delta));
	rms = norm(masterWindow - shifted);
	
	if rms < bestRms
		bestDelta = delta;
		bestRms = rms;
	end
end


shifted = shiftInterpolation(shiftWithZeros(slave, -shiftToNearestSample), bestDelta);


clf;
hold on;
plot(master,'ko');
plot(shifted,'gx');
axis([triggerMaster - 2*preWindowSamples, triggerMaster + 2*samplesInTimePeriod, -0.1,0.1]);
hold off;





