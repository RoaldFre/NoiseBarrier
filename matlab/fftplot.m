function fftplot(t, y, title)

samplerate = length(y)/(t(end)-t(1));
fnyq = samplerate/2;
f = linspace(-fnyq,fnyq,length(y));
spec = fftshift(fft(y));
plot(f,abs(spec));
xlabel('Frequentie (Hz)');
ylabel('amplitude');