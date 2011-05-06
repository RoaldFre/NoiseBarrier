freeField = loadfile('scalemodel-freeField');
freeFieldTime = freeField(:,1);
freeFieldSignal = freeField(2000:end,2);
freeFieldSignal = freeFieldSignal / max(abs(freeFieldSignal));
dt = freeFieldTime(2) - freeFieldTime(1);
samplerate = 1/dt;
len = length(freeFieldSignal);

freqs = linspace(0,samplerate,len);


trig = trigger(freeFieldSignal, 10, 5, 3);

indices = (1:len) - trig;
triggerTime = indices*dt;

windowed = adrienneWindow(freeFieldSignal, 20, samplerate/10);
time = (0:length(windowed)-1) * dt;
freqsWin = linspace(0,samplerate,length(windowed));
%plot(time * 1e3, windowed);
%axis([0,1.2,0,1],'autoy');



plot(triggerTime * 1e3, freeFieldSignal, 'linewidth', 1.5);
axis([-0.1,1.0,0,1],'autoy');

name='sparkImpulseResponse';
destdir = '../latex/images';
relImgDir = 'images';
ylabrule='0.9cm';
xlab='$t$ (ms)';
ylab='$p$ (arb. units)';
width='500';
height='280';
makeGraph(name,destdir,relImgDir,xlab,ylab,ylabrule,width,height);



spectrum = abs(fft(windowed));
spectrum = spectrum/max(spectrum(1:end-100));
spectrum = smoothBins(spectrum,5);
semilogx(freqsWin / 1e3, 20*log(spectrum), 'linewidth', 1.5);
axis([1,400,0,1],'autoy');
logAxis(1, 400, 2);

name='sparkSpectrum';
destdir = '../latex/images';
relImgDir = 'images';
ylabrule='0.9cm';
xlab='$f$ (kHz)';
ylab='Intensity (dB)';
width='500';
height='280';
makeGraph(name,destdir,relImgDir,xlab,ylab,ylabrule,width,height);
