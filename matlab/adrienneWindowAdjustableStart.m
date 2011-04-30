function [windowed, window, unwindowed, indices] = adrienneWindowAdjustableStart(signal, startLengthInMilliseconds, lengthInMilliseconds, samplerate)

flatSamples = round(lengthInMilliseconds * samplerate / 1000);
startSamples = round(startLengthInMilliseconds * samplerate / 1000);
endSamples = round(flatSamples * 3 / 7);

%tanhwindow does not work with uneven lengths yet...
if mod(startSamples + flatSamples + endSamples, 2)
	flatSamples = flatSamples + 1;
end


startWindow = blackmanHarrisHalf(-startSamples);
flatWindow = ones(1, flatSamples);
endWindow = blackmanHarrisHalf(endSamples);


window = [startWindow, flatWindow, endWindow]';


trigger = triggerMax(signal, 0.5, 3);
pretrigger = round(0.0002 * samplerate);
start = trigger-pretrigger - startSamples;

unwindowed = signal(start : start + length(window) - 1);
windowed = unwindowed .* window;

indices = -startSamples : length(window) - startSamples - 1;

return


clf; hold on;
normalization = max(abs(unwindowed));
plot(indices, windowed / normalization, 'b');
plot(indices, window, 'r');
plot(indices, unwindowed / normalization, 'k');
hold off;
