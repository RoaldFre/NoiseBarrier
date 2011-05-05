function [data, time] = logsweep(fmin, fmax, T, rate)
% [data, time] = logsweep(fmin, fmax, T, rate)
%
% Generate a logsweep starting from frequency 'fmin' to frequency 'fmax' 
% with a total time 'T' at samplerate 'rate'.
%
% Authors: Roald Frederickx, Elise Wursten.
    time = linspace(0, T, T*rate)';
    f = (exp(time ./ T) - 1) / (exp(1) - 1) * (fmax - fmin) + fmin;
    data = sin(f .* time * 2 * pi);
end
