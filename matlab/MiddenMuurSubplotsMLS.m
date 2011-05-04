addpath octave;
% figure;
% subplot(4,1,1);

numPreTrigger = 1000;

dir = 'MiddenMuur';
signal = 'mls16x64';
numberOfAverages = 64;
mls = loadfile('mls16.mat');

flatLength = 8; %in ms

%free field
mlss = loadfile([dir,slash,signal,'-h315-rsm300-vrij-gras-1']);
mlss = mlss(:,1);

IRfree = impulseResponseFromMLSs(mlss, mls, numberOfAverages, numPreTrigger);
[IRfreeWindowed, window, unwindowed] = adrienneWindow(IRfree, flatLength, 96000);

IRfreeWindowedPadded = postpad(IRfreeWindowed, length(IRfree));



mlss = loadfile([dir,slash,signal,'-h315-rsm300-theta90-gras-1']);
mlss = mlss(:,1);

IR = impulseResponseFromMLSs(mlss, mls, numberOfAverages, numPreTrigger);

[IRwindowed, window, unwindowed] = adrienneWindow(IR, flatLength, 96000);


%% subtracting
IRsynced = syncdirect(IRfreeWindowed, IRwindowed, 0.0010, 0.0005, 96000, 5, false);

% figure;
% hold on;
% plot(IRsynced);
% plot(IRfreeWindowed, 'g');
% plot(IRsynced - IRfreeWindowed, 'k');
% hold off;

IRsubtracted = IRsynced - IRfreeWindowed;

IRsubtractedWindowed = adrienneTillEnd(IRsubtracted, 0.0, 96000);

attenuationCorrection = correctDistanceAttenuation(IRfreeWindowed,3,96000);
% figure;
% plot(IRfreeWindowed.*attenuationCorrection);

spectrum = abs(fft(prepad(IRsubtractedWindowed, length(IRfreeWindowed)).*attenuationCorrection)...
    ./ fft(IRfreeWindowed.*attenuationCorrection));

[p,foct] = filtbank(prepad(IRsubtractedWindowed, length(IRfreeWindowed)).*attenuationCorrection,96000);
[pfree,ffree] = filtbank(IRfreeWindowed.*attenuationCorrection,96000);

ptot = p - pfree;
figure;
hold on;
semilogx(foct, 10.^(ptot/10),'r','linewidth',1.5);

psom = zeros(size(p));
psom = psom + p;

f = linspace(0, 96000, length(spectrum));
som = zeros(length(spectrum),1);
som = som + spectrum;
%spectrum = smoothBins(spectrum(2:end),5);

%figure;
%semilogx(f(2:end), 20*log10(spectrum), '.', f, zeros(length(f)));
% semilogx(f, spectrum.^2, '.', f, ones(length(f)));
% axis([100, 10000, 0.8, 1.2]);
% xlabel('Frequency (Hz)');
% ylabel('Amplitude (dB)');
% title('90');


%%

%subplot(4,1,2);

numPreTrigger = 1000;

dir = 'MiddenMuur';
signal = 'mls16x64';
numberOfAverages = 64;
mls = loadfile('mls16.mat');

flatLength = 8; %in ms

%free field
mlss = loadfile([dir,slash,signal,'-h315-rsm300-vrij-gras-1']);
mlss = mlss(:,1);

IRfree = impulseResponseFromMLSs(mlss, mls, numberOfAverages, numPreTrigger);
[IRfreeWindowed, window, unwindowed] = adrienneWindow(IRfree, flatLength, 96000);

IRfreeWindowedPadded = postpad(IRfreeWindowed, length(IRfree));



mlss = loadfile([dir,slash,signal,'-h315-rsm300-theta100-gras-1']);
mlss = mlss(:,1);

IR = impulseResponseFromMLSs(mlss, mls, numberOfAverages, numPreTrigger);

[IRwindowed, window, unwindowed] = adrienneWindow(IR, flatLength, 96000);


%% subtracting
IRsynced = syncdirect(IRfreeWindowed, IRwindowed, 0.0010, 0.0005, 96000, 5, false);

% figure;
% hold on;
% plot(IRsynced);
% plot(IRfreeWindowed, 'g');
% plot(IRsynced - IRfreeWindowed, 'k');
% hold off;

IRsubtracted = IRsynced - IRfreeWindowed;

IRsubtractedWindowed = adrienneTillEnd(IRsubtracted, 0.0, 96000);

attenuationCorrection = correctDistanceAttenuation(IRfreeWindowed,3,96000);
% figure;
% plot(IRfreeWindowed.*attenuationCorrection);

spectrum = abs(fft(prepad(IRsubtractedWindowed, length(IRfreeWindowed)).*attenuationCorrection)...
    ./ fft(IRfreeWindowed.*attenuationCorrection));

[p,f] = filtbank(prepad(IRsubtractedWindowed, length(IRfreeWindowed)).*attenuationCorrection,96000);
[pfree,ffree] = filtbank(IRfreeWindowed.*attenuationCorrection,96000);

ptot = p - pfree;
semilogx(foct, 10.^(ptot/10),'g','linewidth',1.5);

psom = psom + p;

f = linspace(0, 96000, length(spectrum));
som = som + spectrum;
%figure;
%spectrum = smoothBins(spectrum(2:end),5);
%semilogx(f(2:end), 20*log10(spectrum), '.', f, zeros(length(f)));
% semilogx(f, spectrum.^2, '.', f, ones(length(f)));
% axis([100, 10000, 0.8, 1.2]);
% xlabel('Frequency (Hz)');
% ylabel('Amplitude (dB)');
% title('100');


%%
%subplot(4,1,3);

numPreTrigger = 1000;

dir = 'MiddenMuur';
signal = 'mls16x64';
numberOfAverages = 64;
mls = loadfile('mls16.mat');

flatLength = 8; %in ms

%free field
mlss = loadfile([dir,slash,signal,'-h315-rsm300-vrij-gras-1']);
mlss = mlss(:,1);

IRfree = impulseResponseFromMLSs(mlss, mls, numberOfAverages, numPreTrigger);
[IRfreeWindowed, window, unwindowed] = adrienneWindow(IRfree, flatLength, 96000);

IRfreeWindowedPadded = postpad(IRfreeWindowed, length(IRfree));



mlss = loadfile([dir,slash,signal,'-h315-rsm300-theta110-gras-1']);
mlss = mlss(:,1);

IR = impulseResponseFromMLSs(mlss, mls, numberOfAverages, numPreTrigger);

[IRwindowed, window, unwindowed] = adrienneWindow(IR, flatLength, 96000);


%% subtracting
IRsynced = syncdirect(IRfreeWindowed, IRwindowed, 0.0010, 0.0005, 96000, 5, false);

% figure;
% hold on;
% plot(IRsynced);
% plot(IRfreeWindowed, 'g');
% plot(IRsynced - IRfreeWindowed, 'k');
% hold off;

IRsubtracted = IRsynced - IRfreeWindowed;

IRsubtractedWindowed = adrienneTillEnd(IRsubtracted, 0.0, 96000);

attenuationCorrection = correctDistanceAttenuation(IRfreeWindowed,3,96000);
% figure;
% plot(IRfreeWindowed.*attenuationCorrection);

spectrum = abs(fft(prepad(IRsubtractedWindowed, length(IRfreeWindowed)).*attenuationCorrection)...
    ./ fft(IRfreeWindowed.*attenuationCorrection));

[p,f] = filtbank(prepad(IRsubtractedWindowed, length(IRfreeWindowed)).*attenuationCorrection,96000);
[pfree,ffree] = filtbank(IRfreeWindowed.*attenuationCorrection,96000);

ptot = p - pfree;
semilogx(foct, 10.^(ptot/10),'b','linewidth',1.5);

psom = psom + p;

f = linspace(0, 96000, length(spectrum));
som = som + spectrum;
%spectrum = smoothBins(spectrum(2:end),5);
%figure;
%semilogx(f(2:end), 20*log10(spectrum), '.', f, zeros(length(f)));
% semilogx(f, spectrum.^2, '.', f, ones(length(f)));
% axis([100, 10000, 0.8, 1.2]);
% xlabel('Frequency (Hz)');
% ylabel('Amplitude (dB)');
% title('110');


%%
%subplot(4,1,4);

numPreTrigger = 1000;

dir = 'MiddenMuur';
signal = 'mls16x64';
numberOfAverages = 64;
mls = loadfile('mls16.mat');

flatLength = 8; %in ms

%free field
mlss = loadfile([dir,slash,signal,'-h315-rsm300-vrij-gras-1']);
mlss = mlss(:,1);

IRfree = impulseResponseFromMLSs(mlss, mls, numberOfAverages, numPreTrigger);
[IRfreeWindowed, window, unwindowed] = adrienneWindow(IRfree, flatLength, 96000);

IRfreeWindowedPadded = postpad(IRfreeWindowed, length(IRfree));



mlss = loadfile([dir,slash,signal,'-h315-rsm300-theta120-gras-1']);
mlss = mlss(:,1);

IR = impulseResponseFromMLSs(mlss, mls, numberOfAverages, numPreTrigger);

[IRwindowed, window, unwindowed] = adrienneWindow(IR, flatLength, 96000);

%% subtracting
IRsynced = syncdirect(IRfreeWindowed, IRwindowed, 0.0010, 0.0005, 96000, 5, false);

% figure;
% hold on;
% plot(IRsynced);
% plot(IRfreeWindowed, 'g');
% plot(IRsynced - IRfreeWindowed, 'k');
% hold off;

IRsubtracted = IRsynced - IRfreeWindowed;

IRsubtractedWindowed = adrienneTillEnd(IRsubtracted, 0.0, 96000);

attenuationCorrection = correctDistanceAttenuation(IRfreeWindowed,3,96000);
% figure;
% plot(IRfreeWindowed.*attenuationCorrection);

spectrum = abs(fft(prepad(IRsubtractedWindowed, length(IRfreeWindowed)).*attenuationCorrection)...
    ./ fft(IRfreeWindowed.*attenuationCorrection));
f = linspace(0, 96000, length(spectrum));
som = som + spectrum;
%figure;
%spectrum = smoothBins(spectrum(2:end),5)
%semilogx(f(2:end), 20*log10(spectrum), '.',f, zeros(length(f)));
% semilogx(f, spectrum.^2, '.', f, ones(length(f)));
% axis([100, 10000, 0.8, 1.2]);
% xlabel('Frequency (Hz)');
% ylabel('Amplitude (dB)');
% title('120');

average = som/4;
[p,foct] = filtbank(prepad(IRsubtractedWindowed, length(IRfreeWindowed)).*attenuationCorrection,96000);
[pfree,ffree] = filtbank(IRfreeWindowed.*attenuationCorrection,96000);

ptot = p - pfree;
semilogx(foct, 10.^(ptot/10),'c','linewidth',1.5);


psom = psom + p;

paverage = psom/4 - pfree;


semilogx(foct, 10.^(paverage/10),'k-o','linewidth',1.5)
semilogx(foct,ones(size(foct)),'k','linewidth',1.5);
hold off;
axis([200, 5000, 0, 2]);
legend('$90\degr$','$100\degr$','$110\degr$','$120\degr$','average');

	name=['wallmls'];
	destdir = '../latex/images';
	relImgDir = 'images';
	ylabrule='0.9cm';
	xlab='Frequency (Hz)';
	ylab='Reflection coefficient';
	width='500';
	height='400';
	makeGraph(name,destdir,relImgDir,xlab,ylab,ylabrule,width,height);

% [fcenter, spectrum] = octaveBands(f(1:64),average(1:64), 1/3);
% 
% figure;
% semilogx(fcenter, spectrum.^2,'.', f, ones(length(f)),f,average.^2,'*')
% axis([100, 10000, 0, 1.6]);
% xlabel('Frequency (Hz)');
% ylabel('Amplitude (dB)');
% title('MLS');
