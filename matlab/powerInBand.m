function power = powerInBand(signal, samplerate, fMin, fMax, order)
% Return power of signal in spectral band (butterworth filter of given 
% order), normalised to 1 for a unity signal.

fNyq = samplerate/2;
wMin = fMin/fNyq;
wMax = fMax/fNyq;

[b, a] = butter(order, [wMin, wMax]);
filtered = filter(b, a, signal);
power = sum(filtered.^2) / length(filtered);
