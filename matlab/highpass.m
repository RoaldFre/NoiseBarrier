function filtered = highpass(data, samplerate, cutoffFreq)
% http://stackoverflow.com/questions/1783633/matlab-apply-a-low-pass-or-high-pass-filter-to-an-array

%a = cutoffFreq / samplerate / (2*pi);
%filtered = filter([1-a a-1], [1 a-1], data);

tau = 1/(2*pi * cutoffFreq);
dt = 1 / samplerate;
a = tau / (tau + dt);

filtered = zeros(length(data),1);
filtered(1) = data(1);
prev = 0;
for i = 2:length(data)
	new = a * (prev + data(i) - data(i-1));
	filtered(i) = new;
	prev = new;
end

