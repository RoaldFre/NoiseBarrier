function impulseResponse = impulseResponseFromSweeps(signal, sweep, n, numPreTrigger)

%sweepPadded = postpad(sweep, length(signal));
%impulseResponses = real(ifft(fft(signal) ./ fft(sweepPadded)));
impulseResponses = real(ifft(fft(signal) ./ fft(sweep, length(signal))));
impulseResponse = averageConsecutive(impulseResponses, length(sweep), n, 0.5, 2, numPreTrigger, false);
