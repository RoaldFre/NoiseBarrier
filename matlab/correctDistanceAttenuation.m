function [correction] = correctDistanceAttenuation(IR, distanceToSource, samplerate)

speedOfSound = 340;

trig = triggerMax(IR, 0.5, 2);
valueAtBegin = distanceToSource/speedOfSound - trig/samplerate;
valueAtEnd = valueAtBegin + length(IR)/samplerate;
correction = linspace(valueAtBegin, valueAtEnd, length(IR))';
