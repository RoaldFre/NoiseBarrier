startIndex = 18000; %to get rid of triggerpeak
endIndex = 28200;
data = loadfile('achter-muur');
measurements = data(startIndex : endIndex, 2:end);
len = length(measurements(:,1));
time = data(startIndex : endIndex, 1);
dt = time(2) - time(1);
samplerate = 1/dt;
freqs = linspace(0,samplerate, len);


meas1 = measurements(:,1);
meas8 = measurements(:,8);


clf; hold on;
normalization = max(abs(meas8));
meas1 = meas1 / normalization;
meas8 = meas8 / normalization;
plot(1e3*time, meas1 - 0.5, 'r');
plot(1e3*time, meas8);
axis([3.8, 5.5, -0.8, 1.1]);
hold off;

name='measurementsRightBehindWall';
destdir = '../latex/images';
relImgDir = 'images';
ylabrule='0.9cm';
xlab='$t$ (ms)';
ylab='$p$ (arb units)';
width='500';
height='400';
makeGraph(name,destdir,relImgDir,xlab,ylab,ylabrule,width,height);



%spec1 = abs(fft(meas1)).^2;
%spec8 = abs(fft(meas8)).^2;
spec1 = abs(fft(meas1));
spec8 = abs(fft(meas8));
normalization = max(spec8(10:100));
spec1 = spec1 / normalization;
spec8 = spec8 / normalization;
clf; hold on;
plot(freqs/1e3, spec1, 'r');
plot(freqs/1e3, spec8);
hold off;
axis([0,200, 0, 1.2])

name='spectraMeasurementsRightBehindWall';
destdir = '../latex/images';
relImgDir = 'images';
ylabrule='0.9cm';
xlab='$f$ (kHz)';
ylab='amplitude (linear, arb units)';
width='500';
height='400';
makeGraph(name,destdir,relImgDir,xlab,ylab,ylabrule,width,height);











endIndex = 28200;
data = loadfile('achter-muur');
measurements = data(1 : endIndex, 2:end);
len = length(measurements(:,1));
time = data(1 : endIndex, 1);
dt = time(2) - time(1);
samplerate = 1/dt;
freqs = linspace(0,samplerate, len);

meas = normalize(measurements(:,44)); %x=5, y=4 (starting from 0)
normalization = max(abs(meas(1000:end)));
meas = meas / normalization;
plot(1e3*time, meas);
title(num2str(i))
axis([-0.1, 5.5, -1.2, 0.8]);

% for i=1:95
%         meas = normalize(measurements(:,i));
%         normalization = max(abs(meas));
%         meas = meas / normalization;
%         plot(1e3*time, meas);
%         title(num2str(i))
%         axis([0, 5.5, -0.5, 1.1]);
%         pause(1);
% end

name='measurementsLowFreqNoise';
destdir = '../latex/images';
relImgDir = 'images';
ylabrule='0.9cm';
xlab='$t$ (ms)';
ylab='$p$ (arb units)';
width='500';
height='400';
makeGraph(name,destdir,relImgDir,xlab,ylab,ylabrule,width,height);
