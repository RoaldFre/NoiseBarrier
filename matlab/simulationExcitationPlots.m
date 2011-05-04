Texc = 2.5e-5;
nexpx = 71;
exSize = 3e-3;
dx = 0.25e-3;
dir = '../data/simulation/freefield/';
filename = [dir,'freeField_Texc',num2str(Texc),'_nexp',num2str(nexpx),'_exSize',num2str(exSize),'_dx',num2str(dx),'_all'];
load(filename);
freeField = Precord(1,:)';
freeFieldTime = linspace(0, length(freeField)*dt, length(freeField))';
freeField = from2Dto3D(freeField, freeFieldTime);


samplerate = 1/dt;
len = length(freeField);

freqs = linspace(0,samplerate,len);

trig = triggerMax(freeField, 0.3, 3);
indices = (1:len) - trig;
triggerTime = indices*dt;


plot(triggerTime * 1e3, freeField);
axis([-0.1,0.5,0,1],'autoy');

name='simuImpulseResponse';
destdir = '../latex/images';
relImgDir = 'images';
ylabrule='0.9cm';
xlab='$t$ (ms)';
ylab='$p$ (arb. units)';
width='500';
height='400';
makeGraph(name,destdir,relImgDir,xlab,ylab,ylabrule,width,height);



spectrum = abs(fft(freeField));
spectrum = spectrum/max(spectrum(1:end-100));
spectrum = smoothBins(spectrum,5);
semilogx(freqs, 20*log(spectrum));
axis([1000,400e3,0,1],'autoy');

name='simuSpectrum';
destdir = '../latex/images';
relImgDir = 'images';
ylabrule='0.9cm';
xlab='$f$ (Hz)';
ylab='Intensity (dB)';
width='500';
height='400';
makeGraph(name,destdir,relImgDir,xlab,ylab,ylabrule,width,height);
