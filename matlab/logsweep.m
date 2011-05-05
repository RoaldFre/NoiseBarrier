function [data] = logsweep(fmin, fmax, T, rate)
% data = logsweep(fmin, fmax, T, rate)
%
% Generate a logsweep starting from frequency 'fmin' to frequency 'fmax' 
% with a total time 'T' at samplerate 'rate'.
%
% Authors: Roald Frederickx, Elise Wursten.
    t = linspace(0, T, T*rate)';
    f = (exp(t ./ T) - 1) / (exp(1) - 1) * (fmax - fmin) + fmin;
    data = sin(f .* t * 2 * pi);
end
