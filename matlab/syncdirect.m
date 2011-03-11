function [shifted, rms] = syncdirect(master, slave, timePeriod, leadingSilence, samplerate, interpolationSteps)
% Authors: Roald Frederickx, Elise Wursten.


preWindow = 1; %amount of timePeriods to look ahead of trigger in order to sync
%TODO Make sure that this doesn't go too far "to the left" (in negative indices)


samplesInTimePeriod = round(timePeriod * samplerate);
preWindowSamples = round(preWindow * samplesInTimePeriod) + 1;

% try to find the end of the leading silence
threshold = 200; %trigger on signal larger than threshold*rms("noise")
noise = master(1:leadingSilence*samplerate);
noiseMaster = norm(noise)/length(noise)
noise = slave(1:leadingSilence*samplerate);
noiseSlave = norm(noise)/length(noise)
triggerLevelMaster = noiseMaster * threshold
triggerLevelSlave = noiseSlave * threshold

triggerFactor = 20;
triggerLevelMaster = max(abs(master)) / triggerFactor
triggerLevelSlave = max(abs(slave)) / triggerFactor

triggerMaster = 1;
while abs(master(triggerMaster)) < triggerLevelMaster
	triggerMaster = triggerMaster + 1;
end

triggerSlave = 1;
while abs(slave(triggerSlave)) < triggerLevelSlave
	triggerSlave = triggerSlave + 1;
end


%set up a window and shift it through
%TODO: this could be optimized (cross correlation?)
bestRms = inf;
masterWindow = master(triggerMaster - preWindowSamples
			: triggerMaster + samplesInTimePeriod);

for shift = -samplesInTimePeriod : samplesInTimePeriod
	shift = shift * 1;
	slaveWindow = slave(triggerSlave - preWindowSamples + shift
				: triggerSlave + samplesInTimePeriod + shift);
	rms = norm(masterWindow - slaveWindow)
	if rms < bestRms
		bestShift = shift;
		bestRms = rms;
	end
end




triggerMaster
triggerSlave

bestRms
bestShift
+triggerMaster - triggerSlave + bestShift
-triggerMaster + triggerSlave + bestShift

clf;
hold on;
plot(master,'ko');
plot(shiftInterpolation(slave, triggerMaster - triggerSlave - bestShift),'gx');
axis([triggerMaster - 2*preWindowSamples, triggerMaster + 2*samplesInTimePeriod, -0.1,0.1]);





