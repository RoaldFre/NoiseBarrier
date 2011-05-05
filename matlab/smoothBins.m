function smoothed = smoothBins(data, samplesPerBin)

n = length(data);
smoothed = zeros(n, 1);


% do tail
combined = 0;
for k = 1:samplesPerBin
	combined = combined + data(n - k + 1);
	smoothed(n - k + 1) = combined / k;
end

% do head
combined = 0;
for k = 1:samplesPerBin
	combined = combined + data(k);
	smoothed(k) = combined / k;
end

% do rest
% combined is now the sum of the first samplesPerBin samples
for k = samplesPerBin + 1 : (n - samplesPerBin)
	combined = combined + data(k) - data(k - samplesPerBin);
	smoothed(k) = combined / samplesPerBin;
end

