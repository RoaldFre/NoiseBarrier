numPreTrigger = 1000;

dir = 'RandMuur';
signal = 'swp1x64';
numberOfAverages = 64;
sweep = logsweep(50,10000,1,96000);

flatLength = 8; %in ms

sweeps = loadfile([dir,'/',signal,'-vrij-h315-rsm300-gras-1']);
sweeps = sweeps(:,1);

IRfree = impulseResponseFromSweeps(sweeps, sweep, numberOfAverages, numPreTrigger);
[IRfreeWindowed, window, unwindowed] = adrienneWindow(IRfree, flatLength, 96000);

IRfreeWindowedPadded = postpad(IRfreeWindowed, length(IRfree));



sweeps = loadfile([dir,'/',signal,'-h315-rsm300-theta50-gras-1']);
sweeps = sweeps(:,1);

IR = impulseResponseFromSweeps(sweeps, sweep, numberOfAverages, numPreTrigger);

[IRwindowed, window, unwindowed] = adrienneWindow(IR, flatLength, 96000);

tanhWind = tanhWindow(50, 10000, 10, 4000, 96000, length(IRwindowed));
IRdeconv = ifft(fft(IRwindowed) ./ fft(IRfreeWindowed));
IRdeconvTanh = ifft(fft(IRwindowed) ./ fft(IRfreeWindowed) .* tanhWind);

IRsynced = syncdirect(IRfreeWindowed, IRwindowed, 0.0010, 0.0005, 96000, 7, true);

clf; hold on;
plot(IRsynced);
plot(IRfreeWindowed, 'g');
plot(IRsynced - IRfreeWindowed, 'k');
hold off;

IRsubtracted = IRsynced - IRfreeWindowed;

IRsubtractedWindowed = adrienneTillEnd(IRsynced, 0.0, 96000);

spectrum = abs(fft(IRsubtractedWindowed, length(IRwindowed)) ./ fft(IRwindowed));
plot(spectrum, '-x');

axis([0, length(spectrum)/96000*10000, 0, 1], 'autoy');


