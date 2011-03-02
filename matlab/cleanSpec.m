function [spectrum, afkap] = cleanSpec(teller, noemer, threshold)
% teller en noemer stellen het tijdsignaal voor horende bij de te delen
% spectra.

noemerspec = abs(fft(noemer));
spectrum = fft(teller) ./ fft(noemer);
afkap = (abs(noemerspec) > threshold * max(noemerspec));
spectrum = spectrum .* afkap;
