function combined = combineBins(data, samplesPerBin)

combined = zeros(ceil(length(data)/samplesPerBin), 1);

for k = samplesPerBin * (0 : (floor(length(data)/samplesPerBin) - 1))
	total = 0;
	for j = 1:samplesPerBin
		total = total + data(k + j);
	end
	combined(k / samplesPerBin + 1) = total / samplesPerBin;
end

remaining = mod(length(data), samplesPerBin);
if remaining
	combined(end) = sum(data(end-remaining+1 : end)) / remaining;
end

