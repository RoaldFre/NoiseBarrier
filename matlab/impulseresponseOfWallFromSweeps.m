numPreTrigger = 1000;

dir = 'RandMuur';
signal = 'swp1x64';
numberOfAverages = 64;
sweep = logsweep(50,10000,1,96000);

flatLength = 8; %in ms

%free field
sweeps = loadfile([dir,'/',signal,'-vrij-h315-rsm300-gras-2']);
sweeps = sweeps(:,1);

IRfree = impulseResponseFromSweeps(sweeps, sweep, numberOfAverages, numPreTrigger, 20, 20e3, 20, 2e3, 96000);
[IRfreeWindowed, window, unwindowed] = adrienneWindow(IRfree, flatLength, 96000);

IRfreeWindowedPadded = postpad(IRfreeWindowed, length(IRfree));



sweeps = loadfile([dir,'/',signal,'-h315-rsm300-theta50-gras-1']);
sweeps = sweeps(:,1);

IR = impulseResponseFromSweeps(sweeps, sweep, numberOfAverages, numPreTrigger, 20, 20e3, 20, 2e3, 96000);

[IRwindowed, window, unwindowed] = adrienneWindow(IR, flatLength, 96000);


%% subtracting
IRsynced = syncdirect(IRfreeWindowed, IRwindowed, 0.0010, 0.0005, 96000, 5, false);

figure;
clf; hold on;
plot(IRsynced);
plot(IRfreeWindowed, 'g');
plot(IRsynced - IRfreeWindowed, 'k');
hold off;

IRsubtracted = IRsynced - IRfreeWindowed;

IRsubtractedWindowed = adrienneTillEnd(IRsubtracted, 0.0, 96000);

spectrum = abs(fft(IRsubtractedWindowed, length(IRwindowed)) ./ fft(IRfreeWindowed));
f = linspace(0, 96000, length(spectrum));
figure;
plot(f, spectrum, '-x');

axis([0, 10000, 0, 1], 'autoy');


%% deconvolve
IRwindowedPadded = prepad(IRwindowed, length(IRwindowed) * 1.1);
IRfreeWindowedPadded = postpad(IRfreeWindowed, length(IRwindowedPadded));

tanhWind = tanhWindow(50, 4000, 20, 1000, 96000, length(IRwindowedPadded));
IRdeconv = ifft(fft(IRwindowedPadded) ./ fft(IRfreeWindowedPadded));
IRdeconvTanh = ifft(fft(IRwindowedPadded) ./ fft(IRfreeWindowedPadded) .* tanhWind);



figure;
plot(real(IRdeconvTanh));


