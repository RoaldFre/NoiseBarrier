function [measurements, time, spectra, measurementFreqs, freeFieldWindowed, deconvolved, measurementsCorrected, spectraCorrected, deconvolvedCorrected, bandsGrid] = processBeforeWall

beforeWallData;

startIndex = 1; %to get rid of triggerpeak
endIndex = 25000; %silence (and noise!) anyway
data = loadfile('voor-muur');
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
rMeasurement = sqrt((sourceToRecord + recordSideStep*sideSteps)^2 + (recordHeight + upSteps * recordUpStep - sourceHeight)^2)
%normalization
freeFieldSignal = freeFieldSignal * rFreeField; 
measurements = measurements * rMeasurement;

%correct air absorption
windowWidth = 400*dt; %length of hanning for correction of air absorption
T = 20; %degrees C
H = 50; %relative humidity
maxFreq = 1e5;
measurementsCorrected = zeros(size(measurements));
for i = 1 : length(measurements(1,:))
	measurementsCorrected(:,i) = correctAirAbsorption(measurements(:,i), time, windowWidth, T, H, maxFreq);
end

freeFieldSignalCorrected = correctAirAbsorption(freeFieldSignal, freeFieldTime, windowWidth, T, H, maxFreq);


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

failedx = [0];
failedy = [2];
failedi = failedx * upSteps + failedy + 1;

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


		if ismember(i, failedi)
			bandsGrid(x+1, y+1, :) = NaN;
		else
			bandsGrid(x+1, y+1, :) = powerInBands(deconvolvedCorrected(:,i), bandBorders, samplerate, order);
		end

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


