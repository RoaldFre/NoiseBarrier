function [measurements, time, spectra, measurementFreqs, freeField, deconvolved, bandsGrid] = processSimulationBehindWall

behindWallData;

%load('../data/simulation/achterMuurGroffer/all');
load('../data/simulation/achterMuur/all');
measurements = Precord';
len = length(measurements(:,1));
time = linspace(0, len*dt, len)';

for i=1:length(measurements(1,:))
	measurements(:,i) = from2Dto3D(measurements(:,i), time);
end

%dir = '../data/simulation/vrijAchterMuurGroffer/';
%filename = [dir,'freeFieldFloor_Texc',num2str(Texc),'_nexp',num2str(nexpx),'_exSize',num2str(exSize),'_dx',num2str(dx),'_all']
%load(filename);
%middleFreeFieldIndex = ceil((overshootSteps + widthSteps)/2);
%freeFieldFloor = Precord(middleFreeFieldIndex, :)';

dir = '../data/simulation/freefield/';
filename = [dir,'freeField_Texc',num2str(Texc),'_nexp',num2str(nexpx),'_exSize',num2str(exSize),'_dx',num2str(dx),'_all'];
load(filename);

freeFieldStart = 1;

freeField = Precord(1,freeFieldStart:end)';
freeFieldTime = linspace(0, length(freeField)*dt, length(freeField))';
freeField = from2Dto3D(freeField, freeFieldTime);

samplerate = 1/dt;

%spark-to-mic distance free field measurement
xrecDist = xrec(1)*L/ndx;
zrecDist = zrec(1)*D/ndz;
rFreeField = sqrt((xrecDist - extx)^2 + (zrecDist - extz)^2)
%spark-to-mic distance for closest and highest measurement point
rMeasurement = sqrt(sourceToRecord^2 + (recordHeight + upSteps * recordUpStep - sourceHeight)^2)

%normalization
%freeFieldRaw = freeField;
%measurementsRaw = measurements;
freeField = freeField * rFreeField; 
measurements = measurements * rMeasurement;

freeFreqs = linspace(0, samplerate, length(freeField));
measurementFreqs = linspace(0, samplerate, len);

spectra = zeros(size(measurements));
deconvolved = zeros(size(measurements));


%deconvolvedFloor = zeros(size(measurements));
freeFieldSpectrum = fft(freeField, len);
%freeFieldFloorSpectrum = fft(freeFieldFloor, len);
window = tanhWindow(4900, 42000, 100, 2000, samplerate, len);
window = tanhWindow(4900, 40000, 100, 5000, samplerate, len);
window = tanhWindow(80, 42000, 10, 2000, samplerate, len);
window = tanhWindow(500, 42000, 50, 2000, samplerate, len);
for x = 0 : sideSteps - 1
	for y = 0 : upSteps - 1
		i = 1 + upSteps*x + y;
		spectra(:,i) = fft(measurements(:,i)) ./ freeFieldSpectrum;
		%spectraFloor(:,i) = fft(measurements(:,i)) ./ freeFieldFloorSpectrum;
		deconvolved(:,i) = real(ifft(spectra(:,i) .* window));
		%deconvolvedFloor(:,i) = real(ifft(spectraFloor(:,i) .* window));
		spectra(:,i) = abs(spectra(:,i));
		%spectraFloor(:,i) = abs(spectraFloor(:,i));

		%bandsGrid(x+1, y+1, :) = powerInBands(deconvolved(:,i), bandBorders, samplerate, order);
		bandsGrid(x+1, y+1, :) = powerInBandsFromSpectrum(spectra(:,i), bandBorders, samplerate, order);
	end
end


return


for x = 0 : sideSteps - 1
	for y = 0 : upSteps - 1
		i = 1 + upSteps*x + y;
		title(['x = ',num2str(x),'   y = ',num2str(y),'   i = ',num2str(i)])
		hold on;
		plot(measurements(:,i) - 1.5, 'r');
		clf; hold off;

	       % subplot(4,1,3);
	       % loglog(measurementFreqs, spectraFloor(:,i));
	       % axis([1000, 50000, 0.001, 1]);
	       % subplot(4,1,4);
	       % plot(deconvolvedFloor(:,i));

	        pause(2);
	end
	pause(2);
end



