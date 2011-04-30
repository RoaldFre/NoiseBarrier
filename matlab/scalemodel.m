data = load('../data/scalemodel/vrije-veld/480hoog-150ver-notzoomed-nor-clipped0.dat');
t = data(:,1);
mic = normalize(data(:,2));

plot(t,mic);

micWithoutTrigger = mic(2000:end);

dt = t(2) - t(1);
freqs = linspace(0, 1/dt, length(micWithoutTrigger));
plot(freqs, abs(fft(micWithoutTrigger)));

