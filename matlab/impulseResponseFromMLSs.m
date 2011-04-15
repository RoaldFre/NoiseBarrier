function impulseResponse = impulseResponseFromMLSs(signal, mls, n, numPreTrigger)

mlsPadded = postpad(mls, length(signal));
impulseResponses = real(ifft(fft(signal) .* fft(mlsPadded(end:-1:1))));
impulseResponse = averageConsecutive(impulseResponses, length(mls), n, 0.5, 2, numPreTrigger);
