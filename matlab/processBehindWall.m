function [measurements, time, spectra, measurementFreqs, freeFieldWindowed, deconvolved, measurementsCorrected, spectraCorrected, deconvolvedCorrected, bandsGrid] = processBehindWall

behindWallData;

%startIndex = 18000; %to get rid of triggerpeak
%WE NEED EXTRA LEADING SPACE TO KILL THE LOW FREQUENCIES WITH BUTTER!
startIndex = 08000; %to get rid of triggerpeak
additionalStart = 10000;
endIndex = 28200;
data = loadfile('achter-muur');
measurements = data(startIndex : endIndex, 2:end);
time = data(startIndex : endIndex, 1);
dt = time(2) - time(1);
samplerate = 1/dt;

%window to cut off unwanted reflection in some samples
fraction = linspace(0.80, 0.999, length(measurements(1,:)));
fraction(1) = 0.70;
fraction(2) = 0.70;
fraction(3) = 0.70;
fraction(9) = 0.70;
fraction(10) = 0.70;
fraction(11) = 0.70;
fraction(18) = 0.72;
fraction(26) = 0.70;
fraction(43) = 0.70;
fraction(44) = 0.70;
fraction(45) = 0.70;
fraction(54) = 0.72;
fraction(57) = 0.72;
fraction(65) = 0.72;

fLow = 400;
fHigh = 500000;
fNyq = samplerate/2;


reflectionWindow = windowTail(fraction, 0.05, length(measurements(additionalStart:end,1)));
for i=1:length(measurements(1,:))
	measurements(:,i) = measurements(:,i) - sum(measurements(:,i))/length(measurements(:,i));
	[b, a] = butter(1, [fLow/fNyq, fHigh/fNyq]); %in fraction of fNyq
	%measurementsW(:,i) = filter(b, a, measurements(:,i)) .* reflectionWindow(i,:)';
	%measurements(:,i) = filter(b, a, measurements(:,i)); %second order hack...
	%measurements2(:,i) = filter(b, a, measurements(additionalStart:end,i)) .* reflectionWindow(i,:)';
	measurements2(:,i) = measurements(additionalStart:end,i) .* reflectionWindow(i,:)';
end
measurements = measurements2;
time = time(additionalStart:end);
%hacks hacks, lots of hacks


len = length(measurements(:,1));
clear data;

freeField = loadfile('scalemodel-freeField');
freeFieldTime = freeField(:,1);
freeFieldSignal = freeField(:,2);

%spark-to-mic distance free field measurement
rFreeField = 0.15
%spark-to-mic distance for closest and highest measurement point
rMeasurement = sqrt(sourceToRecord^2 + (recordHeight + upSteps * recordUpStep - sourceHeight)^2)
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
windowStartLength = 0.51 / factor; %in milliseconds
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


failedx = [0, 8, 9,10,11];
failedy = [3, 4, 4, 4, 4];
failedi = failedx * upSteps + failedy + 1;


for x = 0 : sideSteps - 1
	for y = 0 : upSteps - 1
		i = 1 + upSteps*x + y;
		spectra(:,i) = fft(measurements(:,i)) ./ freeFieldSpectrum;
		spectraWindowed(:,i) = spectra(:,i) .* window;
		deconvolved(:,i) = real(ifft(spectraWindowed(:,i)));
		spectra(:,i) = abs(spectra(:,i));


		%spectraW(:,i) = fft(measurementsW(:,i)) ./ freeFieldSpectrum;
		%spectraWWindowed(:,i) = spectraW(:,i) .* window;
		%deconvolvedW(:,i) = real(ifft(spectraWWindowed(:,i)));


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
		clf; hold on;
		plot(distances, deconvolved(:,i)/max(abs(deconvolved(:,i))));
		%plot(distances, deconvolvedW(:,i)/max(abs(deconvolved(:,i))),'g');
		plot(distances, -1+measurements(:,i)/max(abs(measurements(:,i)))/2, 'r');
		%plot(distances, -2+measurementsW(:,i)/max(abs(measurements(:,i)))/2, 'r');
		plot(distances, reflectionWindow(i,:), 'k');
		hold off;
		%axis([1, 2, -1, 1],'autox');
		pause(1.5);
	end
	pause(1);
end


