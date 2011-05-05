i = 1 + upSteps*x + y

tMin = time(1);
tMax = time(end);

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
