function power = powerInBandFromSpectrum(spectrum, samplerate, fMin, fMax)
% spectrum is plain linear as returned by fft, can still be complex or already abs

len = length(spectrum);
lowerIndex = round(fMin / samplerate * (len-1))+1;
upperIndex = round(fMax / samplerate * (len-1))+1;

power = sum(abs(spectrum(lowerIndex:upperIndex)).^2) / (upperIndex - lowerIndex + 1);

