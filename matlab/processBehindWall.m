%function [measurements, time, spectra, measurementFreqs, freeFieldWindowed, deconvolved, sideSteps, upSteps, measurementsCorrected, spectraCorrected, deconvolvedCorrected, bandsGrid] = processBehindWall

sourceHeight = 0.125;
sourceToWall = 1.2;
wallWidth = 0.06;

wallToRecord = 0.1;
sourceToRecord = sourceToWall + wallWidth + wallToRecord;
recordHeight = 0.03;

recordSideStep = 0.03;
recordUpStep = 0.03;

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

%spark-to-mic distance free field measurement
rFreeField = 0.15
%spark-to-mic distance for closest and highest measurement point
rMeasurement = sqrt(sourceToRecord^2 + (recordHeight + upSteps * recordUpStep - sourceHeight)^2)
%normalization
freeFieldSignal = freeFieldSignal * rFreeField; 
measurements = measurements * rMeasurement;

%correct air absorption
windowWidth = 400*dt; %length of hanning for correction of air absorption
T = 22; %degrees C
H = 60; %relative humidity
maxFreq = 2e5;
measurementsCorrected = zeros(size(measurements));
for i = 1 : length(measurements(1,:))
	measurementsCorrected(:,i) = correctAirAbsorption(measurements(:,i), time, windowWidth, T, H, maxFreq);
end

freeFieldSignalCorrected = correctAirAbsorption(freeFieldSignal, freeFieldTime, windowWidth, T, H, maxFreq);

c = 340;


factor = 10;
windowStartLength = 0.5 / factor; %in milliseconds
windowFlatLength = 20 / factor;

freeFieldWindowed = adrienneWindowAdjustableStart(freeFieldSignal(650:end), windowStartLength, windowFlatLength, samplerate);
freeFieldWindowedCorrected = adrienneWindowAdjustableStart(freeFieldSignalCorrected(650:end), windowStartLength, windowFlatLength, samplerate);

freeFreqs = linspace(0, samplerate, length(freeFieldWindowed));

measurementFreqs = linspace(0, samplerate, len);


spectra = zeros(size(measurements));
spectraCorrected = zeros(size(measurements));
spectraWindowedCorrected = zeros(size(measurements));
deconvolved = zeros(size(measurements));
deconvolvedCorrected = zeros(size(measurements));

freeFieldSpectrum = fft(freeFieldWindowed, len);
freeFieldSpectrumCorrected = fft(freeFieldWindowedCorrected, len);
%window = tanhWindow(5000, 90000, 100, 5000, samplerate, len);
window = tanhWindow(4900, 42000, 100, 2000, samplerate, len);

bandBorders = [5e3, 10e3, 20e3, 40e3];
nbBands = length(bandBorders) - 1;
bandsGrid = zeros([sideSteps, upSteps, nbBands]);
order = 1; %order of butterworth bandpass filter
% TODO octave only accepts order one?

for x = 0 : sideSteps - 1
	for y = 0 : upSteps - 1
		i = 1 + upSteps*x + y;
		spectra(:,i) = fft(measurements(:,i)) ./ freeFieldSpectrum;
		spectraWindowed(:,i) = spectra(:,i) .* window;
		deconvolved(:,i) = real(ifft(spectraWindowed(:,i)));
		spectra(:,i) = abs(spectra(:,i));

		spectraCorrected(:,i) = fft(measurementsCorrected(:,i)) ./ freeFieldSpectrumCorrected;
		spectraWindowedCorrected(:,i) = spectraCorrected(:,i) .* window;
		deconvolvedCorrected(:,i) = real(ifft(spectraWindowedCorrected(:,i)));
		spectraCorrected(:,i) = abs(spectraCorrected(:,i));

		bandsGrid(x+1, y+1, :) = powerInBands(deconvolvedCorrected(:,i), bandBorders, samplerate, order);
	end
end


for i=1:nbBands
	imagesc(log(bandsGrid(:,:,i)))
	pause(5);
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


