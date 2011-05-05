function power = powerInBandFromSpectrum(spectrum, samplerate, fMin, fMax, order)
% spectrum is plain linear as returned by fft, can still be complex or already abs

len = length(spectrum);
lowerIndex = round(fMin / samplerate * len);
upperIndex = round(fMax / samplerate * len);

power = sum(abs(spectrum(lowerIndex:upperIndex)).^2) / (upperIndex - lowerIndex + 1);

power = 2*power; %because we only looked at 1 side of the spectrum (positive frequencies)
