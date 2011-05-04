%[simulated, simTime, simSpectra, simFreqs, simFreeField, simDeconvolved] = processSimulationBeforeWall;
%[measurements, time, spectra, measurementFreqs, freeField, deconvolved, measurementsCorrected, spectraCorrected, deconvolvedCorrected] = processBeforeWall;

beforeWallData;

tMin = time(1);
tMax = time(end);
c = 340;

%for x = 0 : sideSteps - 1
for x = 10 : sideSteps - 1
	for y = 0 : upSteps - 1
		i = 1 + upSteps*x + y;
		iMeasurement = i; 
		iSimulation = i-upSteps;
		
		clf;
		subplot(2,1,1);
		hold on;
		semilogx(measurementFreqs, 20*log10(spectra(:,iMeasurement)), 'r');
		semilogx(measurementFreqs, 20*log10(spectraCorrected(:,iMeasurement)), 'g');
		semilogx(simFreqs, 20*log10(simSpectra(:,iMeasurement)), 'k');
		title(['x = ',num2str(x),'   y = ',num2str(y),'   i = ',num2str(iMeasurement)])
		axis([2000, 50000, -60, 20]);
		
		subplot(2,1,2);
		hold on;
		plot(time, deconvolved(:,iSimulation), 'r');
		plot(time, deconvolvedCorrected(:,iSimulation), 'g');
		plot(simTime, simDeconvolved(:,iSimulation), 'k');
		axis([tMin, tMax, -0.004, 0.006],'autoy');

		pause(2);
	end
	pause(3);
end
hold off;

