function combined = combineBins(data, samplesPerBin)
% length(data) must be devidable by samplesPerBin!

combined = zeros(ceil(length(data)/samplesPerBin), 1);

for k = samplesPerBin * (0 : (floor(length(data)/samplesPerBin) - 1))
	total = 0;
	for j = 1:samplesPerBin
		total = total + data(k + j);
	endfor
	combined(k / samplesPerBin + 1) = total / samplesPerBin;
endfor

