function normalized = normalize(data)
% change +/- Inf with the max/min occuring 'normal' number

infIndices = isinf(data);
nonInf = data(~infIndices);
maximum = max(nonInf);
minimum = min(nonInf);

for i = find(infIndices)
	if data(i) < 0
		data(i) = minimum;
	else
		data(i) = maximum;
	end
end

normalized = data;

