function fftplot(t, y, plottitle)

samplerate = length(y)/(t(end)-t(1));
fnyq = samplerate/2;
f = linspace(-fnyq,fnyq,length(y));
spec = fftshift(fft(y));
semilogy(f,abs(spec));
xlabel('Frequentie (Hz)');
ylabel('Amplitude');
title(plottitle);