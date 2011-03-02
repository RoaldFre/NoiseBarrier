rate = 48000;
dt = 1/rate;

speaker = load("rugby-matje-clean.txt");
echo = load("rugby-vloer-lager1-clean.txt");

l = length(echo);
ts = linspace(0,l*dt,l);
trigger = 0.05;

%shift to get rid of the leading silence
%should throw this in a separate fuction. but meh
peak = max(speaker);
threshold = peak * trigger;
for i = 1:length(speaker)
	if abs(speaker(i)) > threshold
		speakershifted = speaker(i:length(speaker));
		speakershifted = postpad(speakershifted, length(speaker));
		break
	endif
endfor

peak = max(echo);
threshold = peak * trigger;
for i = 1:length(echo)
	if abs(echo(i)) > threshold
		echoshifted = echo(i:length(echo));
		echoshifted = postpad(echoshifted, length(echo));
		break
	endif
endfor


clf; hold on;
plot(speakershifted);
plot(echoshifted + 2*peak);
axis([-10,2000,0,1],"autoy");
hold off;

clean = abs(ifft(fft(echo) ./ fft(speakershifted)));
clf; hold on;
plot(ts, -echo/max(abs(echo)));
plot(ts, clean/max(abs(clean)) + 1.2);
axis([0,0.02,0,1],"autoy");
hold off;
