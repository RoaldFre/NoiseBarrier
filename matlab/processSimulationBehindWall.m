function [measurements, time, spectra, measurementFreqs, freeField, deconvolved, sideSteps, upSteps] = processSimulationBehindWall

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

load('../data/simulation/achterMuur/all');
measurements = Precord';
len = length(measurements(:,1));
time = linspace(0, len*dt, len);

%dir = '../data/simulation/vrijAchterMuurGroffer/';
%filename = [dir,'freeFieldFloor_Texc',num2str(Texc),'_nexp',num2str(nexpx),'_exSize',num2str(exSize),'_dx',num2str(dx),'_all']
%load(filename);
%middleFreeFieldIndex = ceil((overshootSteps + widthSteps)/2);
%freeFieldFloor = Precord(middleFreeFieldIndex, :)';

dir = '../data/simulation/freefield/';
filename = [dir,'freeField_Texc',num2str(Texc),'_nexp',num2str(nexpx),'_exSize',num2str(exSize),'_dx',num2str(dx),'_all'];
load(filename);
freeField = Precord(1,:)';

samplerate = 1/dt;

%spark-to-mic distance free field measurement
xrecDist = xrec(1)*L/ndx;
zrecDist = zrec(1)*D/ndz;
rFreeField = sqrt((xrecDist - extx)^2 + (zrecDist - extz)^2);
%spark-to-mic distance for closest and highest measurement point
rMeasurement = sqrt(sourceToRecord^2 + (recordHeight + upSteps * recordUpStep - sourceHeight)^2);
%normalization
freeField = freeField * rFreeField; 
measurements = measurements * rMeasurement;

c = 340;


factor = 10;
windowStartLength = 0.5 / factor; %in milliseconds
windowFlatLength = 20 / factor;

freeFreqs = linspace(0, samplerate, length(freeField));
measurementFreqs = linspace(0, samplerate, len);


spectra = zeros(size(measurements));
deconvolved = zeros(size(measurements));
%deconvolvedFloor = zeros(size(measurements));
freeFieldSpectrum = fft(freeField, len);
%freeFieldFloorSpectrum = fft(freeFieldFloor, len);
window = tanhWindow(5000, 40000, 100, 5000, samplerate, len);
for x = 0 : sideSteps - 1
	for y = 0 : upSteps - 1
		i = 1 + upSteps*x + y;
		spectra(:,i) = fft(measurements(:,i)) ./ freeFieldSpectrum;
		%spectraFloor(:,i) = fft(measurements(:,i)) ./ freeFieldFloorSpectrum;
		deconvolved(:,i) = real(ifft(spectra(:,i) .* window));
		%deconvolvedFloor(:,i) = real(ifft(spectraFloor(:,i) .* window));
		spectra(:,i) = abs(spectra(:,i));
		%spectraFloor(:,i) = abs(spectraFloor(:,i));
	end
end


return


for x = 0 : sideSteps - 1
	for y = 0 : upSteps - 1
		i = 1 + upSteps*x + y;
		subplot(2,1,1);
		loglog(measurementFreqs, spectra(:,i));
		title(['x = ',num2str(x),'   y = ',num2str(y),'   i = ',num2str(i)])
		axis([1000, 50000, 0.001, 1]);
		subplot(2,1,2);
		plot(deconvolved(:,i));

	       % subplot(4,1,3);
	       % loglog(measurementFreqs, spectraFloor(:,i));
	       % axis([1000, 50000, 0.001, 1]);
	       % subplot(4,1,4);
	       % plot(deconvolvedFloor(:,i));

	        pause(2);
	end
	pause(2);
end

