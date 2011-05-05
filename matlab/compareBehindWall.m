clear all;

[simulated, simTime, simSpectra, simFreqs, simFreeField, simDeconvolved] = processSimulationBehindWall;
[measurements, time, spectra, measurementFreqs, freeField, deconvolved, measurementsCorrected, spectraCorrected, deconvolvedCorrected] = processBehindWall;

behindWallData;

simLen = length(simulated(:,1));
len = length(measurements(:,1));

tMin = time(1);
tMax = time(end);
c = 340;

%normalize
factor = max(abs(deconvolvedCorrected(:,8)));
%measurements = measurements / factor;
%deconvolved = deconvolved / factor;
%deconvolvedCorrected = deconvolvedCorrected / factor;

simFactor = max(abs(simDeconvolved(:,8)));
%simulated = simulated / simFactor;
%simDeconvolved = simDeconvolved / simFactor;

for x = 0 : sideSteps - 1
	for y = 0 : upSteps - 1
		i = 1 + upSteps*x + y;
		
		clf;
		subplot(2,1,1);
		hold on;
		semilogx(measurementFreqs, 20*log10(spectra(:,i)), 'r');
		semilogx(measurementFreqs, 20*log10(spectraCorrected(:,i)), 'g');
		semilogx(simFreqs, 20*log10(simSpectra(:,i)), 'k');
		title(['x = ',num2str(x),'   y = ',num2str(y),'   i = ',num2str(i)])
		axis([2000, 50000, -60, 20]);
		
		subplot(2,1,2);
		hold on;
		plot(time, deconvolved(:,i), 'r');
		plot(time, deconvolvedCorrected(:,i), 'g');
		plot(simTime, simDeconvolved(:,i), 'k');
		axis([tMin, tMax, -0.004, 0.006],'autoy');
		axis([tMin, tMax, -0.6, 1.1],'autoy');

		pause(1.5);
	end
	pause(1);
end
hold off;

