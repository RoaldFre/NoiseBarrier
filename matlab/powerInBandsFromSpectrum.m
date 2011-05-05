function powers = powerInBandsFromSpectrum(spectrum, bandBorders, samplerate, order)

nbBands = length(bandBorders) - 1;
powers = zeros(1,nbBands);
for i=1:nbBands
	powers(i) = powerInBandFromSpectrum(spectrum, samplerate, bandBorders(i), bandBorders(i+1), order);
end