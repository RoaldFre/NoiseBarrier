function [spectrum] = nozero(spectrum, factor)

threshold = max(abs(spectrum)) * factor;

for i=1:length(spectrum)
    if abs(spectrum(i)) < threshold
        spectrum(i) = threshold * spectrum(i)/abs(spectrum(i));
    end
end