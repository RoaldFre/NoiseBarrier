function corrected = correctAirAbsorption(signal, time, windowWidth, temperatureC, humidity, maxFreq)

samplerate = 1/(time(2) - time(1));

n = length(signal);


c = 340;


windowSamples = round(windowWidth * samplerate);
if (mod(windowSamples,2))
	windowSamples = windowSamples + 1;
end
window = hanning(windowSamples);
freqs = (-windowSamples/2 : windowSamples/2-1) / windowSamples * samplerate;
freqs = ifftshift(freqs)';

%dB/s for 20 degrees C
%dBdelta = 85/humidity * freqs.^2 * 1e-10 * c;

To = 293.15;
T = temperatureC + 273.15;
pr = 101325; %referece pressure
pa = 101325; %atmospheric pressure

x = 1/(10 * log10((exp(1)^2)));
To1 = 273.16; %triple-point isotherm temp
psat = pr * 10^(-6.8346 * (To1/T)^1.261 + 4.6151);
h = humidity * (psat / pa);
frO = (pa/pr) * (24 + 4.04e4 * h * ((0.02 + h)/(0.391 + h)));
frN = (pa/pr) / sqrt(T/To) * (9 + 280 * h * exp(-4.170 * ((T/To)^(-1/3) - 1)));
z = 0.1068 * exp(-3352/T) ./ (frN + freqs.^2/frN);
y = (T/To)^(-5/2) * (0.01275 * exp(-2239.1/T) ./ (frO + freqs.^2/frO) + z);
a = 8.686 * freqs.^2 .* ((1.84e-11 * (pr / pa) * sqrt(T/To)) + y);

corrected = zeros(size(signal));
segment = zeros(size(window));
correctedSegment = zeros(size(window));

%first (half) window
segment = signal(1 : windowSamples/2);
t = time(1 : windowSamples/2);
correction = exp(x .* a(1 : windowSamples/2) .* c.*t);
correction = min(correction, correction(round(maxFreq / samplerate * windowSamples/2)));
correctedSegment = ifft(fft(segment) .* correction);
corrected(1 : windowSamples/2) = corrected(1 : windowSamples/2) + correctedSegment;

%middle bits (full windows)
start = 1;
clipIndex = round(maxFreq / samplerate * windowSamples);
while (start <= n - windowSamples + 1)
	segment = signal(start : start + windowSamples - 1);
	t = time(start + windowSamples/2);
	%correction = 10.^(t * dBdelta / 20);
	correction = exp(x .* a .* c.*t);
	correction = min(correction, correction(clipIndex));
	%plot(freqs, correction);
	%pause(0.05)
	correctedSegment = ifft(fft(segment) .* correction);
	corrected(start : start + windowSamples - 1) = ...
			corrected(start : start + windowSamples - 1) + correctedSegment;
	start = start + windowSamples / 2;
end
%ending window
segment = signal(start : end);
t = time(start + floor(end - start)/2);
correction = exp(x .* a(1 : n-start+1) .* c.*t);
correction = min(correction, correction(round(maxFreq / samplerate * (n - start))));
correctedSegment = ifft(fft(segment) .* correction);
corrected(start : end) = corrected(start : end) + correctedSegment;
	
corrected = real(corrected);
