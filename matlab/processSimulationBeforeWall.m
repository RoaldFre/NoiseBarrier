function [measurements, time, spectra, measurementFreqs, freeField, deconvolved, bandsGrid] = processSimulationBeforeWall

beforeWallData;

%load('../data/simulation/voorMuurGroffer/all');
load('../data/simulation/voorMuur/all');
measurements = Precord';
time = linspace(0, length(measurements(:,1))*dt, length(measurements(:,1)))';

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
freeField = Precord(1,:)';
freeFieldTime = linspace(0, length(freeField)*dt, length(freeField))';
freeField = from2Dto3D(freeField, freeFieldTime);

samplerate = 1/dt;



%manual hacks ... joy!


startTime = 5.9 * ones(1,length(measurements(1,:)));

startTime(4) = 5.96;
startTime(5) = 5.98;
startTime(6) = 6.00;
startTime(7) = 6.04;
startTime(8) = 6.14;

startTime = startTime / 1e3;

startIndex = round(startTime * samplerate);
measurementsFull = measurements;
padTo = ceil((time(end) - min(startTime)) * samplerate + 1);
for i = 1:length(measurements(1,:))
	measurements2(:,i) = prepad(measurementsFull(startIndex(i):end, i), padTo);
end
measurements = measurements2;

timeFull = time;
time = time(startIndex:end);
len = length(measurements(:,1));











%spark-to-mic distance free field measurement
xrecDist = xrec(1)*L/ndx;
zrecDist = zrec(1)*D/ndz;
rFreeField = sqrt((xrecDist - extx)^2 + (zrecDist - extz)^2)
%spark-to-mic distance for closest and highest measurement point
rMeasurement = sqrt((sourceToRecord + recordSideStep*sideSteps)^2 + (recordHeight + upSteps * recordUpStep - sourceHeight)^2)

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
%window = tanhWindow(5000, 40000, 100, 5000, samplerate, len);
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
		plot(time, measurements(:,i), 'r', timeFull, measurementsFull(:,i));
		title(['x = ',num2str(x),'   y = ',num2str(y),'   i = ',num2str(i)])

	       axis([0.004, 0.009, 0.001, 1],'autoy');

	       % subplot(4,1,3);
	       % loglog(measurementFreqs, spectraFloor(:,i));
	       % axis([1000, 50000, 0.001, 1]);
	       % subplot(4,1,4);
	       % plot(deconvolvedFloor(:,i));

	        pause(1);
	end
	pause(2);
end


