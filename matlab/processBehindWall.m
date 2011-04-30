function [measurements, time, spectra, measurementFreqs, freeFieldWindowed, deconvolved, sideSteps, upSteps] = processBehindWall

sourceHeight = 0.125;
sourceToWall = 1.2;
wallWidth = 0.06;

wallToRecord = 0.1;
sourceToRecord = sourceToWall + wallWidth + wallToRecord;
recordHeight = 0.03;

recordSideStep = 0.03;
recondUpStep = 0.03;

sideSteps = 12;
upSteps = 8;

startIndex = 18000; %to get rid of triggerpeak
endIndex = 28000;
data = loadfile('achter-muur');
measurements = data(startIndex : endIndex, 2:end);
time = data(startIndex : endIndex, 1);
len = length(measurements(:,1));
clear data;

freeField = loadfile('scalemodel-freeField');
freeFieldTime = freeField(:,1);
freeFieldSignal = freeField(:,2);
dt = freeFieldTime(2) - freeFieldTime(1);
samplerate = 1/dt;

c = 340;


factor = 10;
windowStartLength = 0.5 / factor; %in milliseconds
windowFlatLength = 20 / factor;

freeFieldWindowed = adrienneWindowAdjustableStart(freeFieldSignal(650:end), windowStartLength, windowFlatLength, samplerate);

freeFreqs = linspace(0, samplerate, length(freeFieldWindowed));

measurementFreqs = linspace(0, samplerate, len);


spectra = zeros(size(measurements));
spectraWindowed = zeros(size(measurements));
deconvolved = zeros(size(measurements));
freeFieldSpectrum = fft(freeFieldWindowed, len);
window = tanhWindow(5000, 40000, 100, 5000, samplerate, len);
for x = 0 : sideSteps - 1
	for y = 0 : upSteps - 1
		i = 1 + upSteps*x + y;
		spectra(:,i) = fft(measurements(:,i)) ./ freeFieldSpectrum;
		spectraWindowed(:,i) = spectra(:,i) .* window;
		deconvolved(:,i) = real(ifft(spectraWindowed(:,i)));
		spectra(:,i) = abs(spectra(:,i));
		spectraWindowed(:,i) = abs(spectraWindowed(:,i));
	end
end



return


for x = 0 : sideSteps - 1
	for y = 0 : upSteps - 1
		i = 1 + upSteps*x + y;
		subplot(2,1,1);
		loglog(measurementFreqs, spectra(:,i));
		title(['x = ',num2str(x),'   y = ',num2str(y),'   i = ',num2str(i)])
		axis([5000, 50000, 0.0001, 0.5]);
		subplot(2,1,2);
		distances = linspace(0, len / samplerate * 340, len);
		plot(distances, deconvolved(:,i));
		axis([1, 2, -0.0003, 0.0008],'autox');
		pause(2);
	end
	pause(3);
end


