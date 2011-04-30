clear all;

[simulated, simTime, simSpectra, simFreqs, simFreeField, simDeconvolved] = processSimulationBehindWall;
[measurements, time, spectra, measurementFreqs, freeField, deconvolved, sideSteps, upSteps] = processBehindWall;

simLen = length(simulated(:,1));
len = length(measurements(:,1));

tMin = time(1);
tMax = time(end);
c = 340;

for x = 0 : sideSteps - 1
	for y = 0 : upSteps - 1
		i = 1 + upSteps*x + y;

		subplot(4,1,1);
		loglog(measurementFreqs, spectra(:,i));
		title(['x = ',num2str(x),'   y = ',num2str(y),'   i = ',num2str(i)])
		axis([5000, 50000, 0.0001, 0.5]);
		subplot(4,1,2);
		plot(time, deconvolved(:,i));
		axis([tMin, tMax, -0.0003, 0.0008]);

		subplot(4,1,3);
		loglog(simFreqs, simSpectra(:,i));
		title(['x = ',num2str(x),'   y = ',num2str(y),'   i = ',num2str(i)])
		axis([5000, 50000, 0.0001, 0.5]);
		subplot(4,1,4);
		plot(simTime, simDeconvolved(:,i));
		axis([tMin, tMax, -0.004, 0.006]);

		pause(2);
	end
	pause(3);
end

