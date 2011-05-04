numPreTrigger = 1000;

dir = 'Helmholtz';
signal = 'mls16x64';
numberOfAverages = 64;
mls = loadfile('mls16.mat');

flatLength = 10; %in ms

%free field
mlss = loadfile([dir,slash,signal,'-h140-r160-theta120-moussebox-1']);
mlss = mlss(:,1);

IRfree = impulseResponseFromMLSs(mlss, mls, numberOfAverages, numPreTrigger);
[IRfreeWindowed, window, unwindowed] = adrienneWindow(IRfree, flatLength, 96000);
%figure;
%plot(IRfreeWindowed);
IRfreeWindowedPadded = postpad(IRfreeWindowed, length(IRfree));



mlss = loadfile([dir,slash,signal,'-h140-r160-theta120-helmholtz-1']);
mlss = mlss(:,1);

IR = impulseResponseFromMLSs(mlss, mls, numberOfAverages, numPreTrigger);

[IRwindowed, window, unwindowed] = adrienneWindow(IR, flatLength, 96000);


%% subtracting
IRsynced = syncdirect(IRfreeWindowed, IRwindowed, 0.0010, 0.0005, 96000, 5, false);

maxvalue = -max(abs(IRfreeWindowed));

t = linspace(0, length(IRsynced)/96,length(IRsynced));
figure; hold on;
plot(t,window,'b');
plot(t,IRsynced/maxvalue,'r');
plot(t,IRfreeWindowed/maxvalue, 'g');
plot(t,(IRsynced - IRfreeWindowed)/maxvalue, 'k');
axis([0 14 -0.6 1.2])
hold off;

name='helmsub';
destdir = '../latex/images';
relImgDir = 'images';
ylabrule='0.9cm';
xlab='Time (ms)';
ylab='Amplitude (arb. units)';
width='500';
height='400';
makeGraph(name,destdir,relImgDir,xlab,ylab,ylabrule,width,height);

IRsubtracted = IRsynced - IRfreeWindowed;
%figure;
%plot(IRsubtracted);
IRsubtractedWindowed = adrienneTillEnd(IRsubtracted, 0.2, 96000);

attenuationCorrection = correctDistanceAttenuation(IRfreeWindowed,1.6,96000);

IRfreeWindowedcorr = IRfreeWindowed.*attenuationCorrection;
IRfreeWindowedwithoutceiling = adrienneWindow(IRfreeWindowedcorr, 400/96, 96000);

spectrum = fft(prepad(IRsubtractedWindowed, length(IRfreeWindowed)).*attenuationCorrection)...
    ./ fft(IRfreeWindowedwithoutceiling, length(IRfreeWindowed));
f = linspace(0, 96000, length(spectrum));


spectrumabs = smoothBins(abs(spectrum), 5);


figure;
tanhWind = tanhWindow(100, 6500, 20, 1000, 96000, length(spectrum));
semilogx(f, 20*log10(spectrumabs), f, 20*log10(tanhWind));
axis([100, 10000, -30, 20]);
xlabel('Frequency (Hz)');
ylabel('Amplitude (dB)');

name='helmspec';
destdir = '../latex/images';
relImgDir = 'images';
ylabrule='0.9cm';
xlab='Frequency (Hz)';
ylab='Amplitude (dB)';
width='500';
height='400';
makeGraph(name,destdir,relImgDir,xlab,ylab,ylabrule,width,height);

figure;
tanhWind = tanhWindow(100, 6500, 20, 1000, 96000, length(spectrum));
impulseresponse = real(ifft(spectrum.*tanhWind));
impulseresponse = impulseresponse / max(abs(impulseresponse));
plot(t,impulseresponse);
axis([0 14 -0.6 1.2])


name='helmimp';
destdir = '../latex/images';
relImgDir = 'images';
ylabrule='0.9cm';
xlab='Time (ms)';
ylab='Amplitude (arb. units)';
width='700';
height='400';
makeGraph(name,destdir,relImgDir,xlab,ylab,ylabrule,width,height);

% figure;
% semilogx(f, spectrumabs.^2);
% axis([100, 10000, 0, 1]);
% xlabel('Frequency (Hz)');
% ylabel('Amplitude');
% title('Reflection coefficient');
% 
% figure;
% semilogx(f, 1-(spectrumabs).^2);
% axis([100, 10000, 0, 1]);
% xlabel('Frequency (Hz)');
% ylabel('Amplitude');
% title('Absorption coefficient');
