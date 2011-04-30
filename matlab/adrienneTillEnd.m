function [windowed, window, unwindowed, indices] = adrienneTillEnd(signal, preTriggerMilliseconds, samplerate)

startSamples = round(0.0005 * samplerate);


startWindow = blackmanHarrisHalf(-startSamples);

trigger = triggerMax(signal, 0.5, 3);
pretrigger = round(preTriggerMilliseconds / 1000 * samplerate);
start = trigger-pretrigger - startSamples;

flatSamples = length(signal) - length(startWindow) - start + 1;

%tanhwindow does not work with uneven lengths yet...
if mod(startSamples + flatSamples, 2)
	start = start - 1;
	flatSamples = flatSamples + 1;
end

window = [startWindow, ones(1, flatSamples)]';

unwindowed = signal(start : end);
windowed = unwindowed .* window;

indices = -startSamples : length(window) - startSamples - 1;

return

clf; hold on;
normalization = max(abs(unwindowed));
plot(indices, windowed / normalization, 'b');
plot(indices, window, 'r');
plot(indices, unwindowed / normalization, 'k');
hold off;
