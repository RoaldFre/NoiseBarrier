clear all;

[simulated, simTime, simSpectra, simFreqs, simFreeField, simDeconvolved] = processSimulationBehindWall;
[measurements, time, spectra, measurementFreqs, freeField, deconvolved, measurementsCorrected, spectraCorrected, deconvolvedCorrected] = processBehindWall;

behindWallData;

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

xs = [6,6,6,6];
ys = [1,3,5,7];

for n = 1:length(xs)
	x = xs(n);
	y = ys(n);
	i = 1 + upSteps*x + y;
	
	ylabrule='0.9cm';
	name=['behind-x',num2str(x),'-y',num2str(y)];
	destdir = '../latex/images';
	relImgDir = 'images';

	clf;
	subplot(2,1,1);
	hold on;
	semilogx(measurementFreqs / 1e3, 20*log10(spectra(:,i)), 'r', 'linewidth',1.1);
	semilogx(measurementFreqs / 1e3, 20*log10(spectraCorrected(:,i)), 'g', 'linewidth',1.1);
	semilogx(simFreqs / 1e3, 20*log10(simSpectra(:,i)), 'k', 'linewidth',1.1);
	%title(['x = ',num2str(x),'   y = ',num2str(y),'   i = ',num2str(i)])
	axis([2, 50, -60, 20]);
	logAxis(2, 50, 2);
	set(gca,'YTick',-60:20:20);
	
	xlabel('frequency (kHz)');
	ylabel(['\rule{0pt}{',ylabrule,'}','intensity (dB)']);

	hold off;
	subplot(2,1,2);
	hold on;
	fact = 50;
	plot(time * 1e3, -0.75 + fact*deconvolved(:,i), 'r', 'linewidth',1.1);
	plot(time * 1e3, -0.75 + fact*deconvolvedCorrected(:,i), 'g', 'linewidth',1.1);
	plot(simTime * 1e3, fact*simDeconvolved(:,i), 'k', 'linewidth',1.1);
	%axis([tMin, tMax, -0.004, 0.006],'autoy');
	axis([tMin * 1e3, tMax * 1e3, -1.0, 1]);
	%axis([tMin, tMax, -0.6, 1.1]);
	%set(gca,'YTick',[-0.9, -0.6, -0.3, 0, 0.3, 0.6, 0.9]);

	xlab='time (ms)';
	ylab='amplitude (a. u.)';
	width='500';
	height='550';
	makeGraph(name,destdir,relImgDir,xlab,ylab,ylabrule,width,height);
	hold off;
end

clf;
