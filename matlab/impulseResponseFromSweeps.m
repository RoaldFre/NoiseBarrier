function impulseResponse = impulseResponseFromSweeps(signal, sweep, n, numPreTrigger, cutoffFreq1, cutoffFreq2, cutoffWidth1, cutoffWidth2, samplerate)

window = tanhWindow(cutoffFreq1, cutoffFreq2, cutoffWidth1, cutoffWidth2, samplerate, length(signal));
impulseResponses = real(ifft(fft(signal) ./ fft(sweep, length(signal) .* window)));

impulseResponse = averageConsecutive(impulseResponses, length(sweep), n, 0.5, 2, numPreTrigger, false);
