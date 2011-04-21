numPreTrigger = 1000;

dir = 'RandMuur';
signal = 'swp1x64';
sweep = logsweep(50,10000,1,96000);
t = linspace(0,length(impulseResponse)/96000, length(impulseResponse));


sweeps = loadfile([dir,'/',signal,'-vrij-h315-rsm300-gras-1']);
sweeps = sweeps(:,1);

IRfree = impulseResponseFromMLSs(sweeps, sweep, 64, numPreTrigger);
[IRfreeWindowed, window, unwindowed] = adrienneWindow(IRfree, 8, 96000);

return;

sweeps = loadfile([dir,'/',signal,'-h315-rsm300-theta90-gras-1']);
sweeps = sweeps(:,1);

IR = impulseResponseFromMLSs(sweeps, sweep, 64, numPreTrigger);

IRdeconv = ifft(fft(IR) ./ fft(IRfree));

plot(t, IRdeconv);
