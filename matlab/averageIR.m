function [IR] = averageIR(signal, rate, depth, n)
% [IR] = averageIR(signal, rate, depth, n)
%
% Determine the average Impulse Response by calculating n IRs of n succesive measurements.
% This is set up for the OCTA-CAPURE sound card. Connect the mic to port1 
% and loop the output to port2(??).
%
% Authors: Roald Frederickx, Elise Wursten.

samples = length(signal);

%Initialize soundcard. You may need to change this for your specific setup
ai0 = analoginput('winsound',0); %microphone signal
ai1 = analoginput('winsound',3); %loop-through signal
ao = analogoutput('winsound',0);
addchannel(ai0,1);
addchannel(ai1,1);
addchannel(ao,1);

ai0.SampleRate = rate;
ai1.SampleRate = rate;
ao.SampleRate = rate;
ai0.BitsPerSample = depth;
ai1.BitsPerSample = depth;
ao.BitsPerSample = depth;

ai0.SamplesPerTrigger = samples;
ai1.SamplesPerTrigger = samples;

IRs = zeros(samples,1);
for i = 1:n
	putdata(ao,signal);
	start([ai0,ai1,ao]);
	% Just running wait([ai1,ai2,ao]) or any other combination seemed 
	% to crash(?) -- So quick hack: just pause with a margin of one 
	% second
	pause(samples/rate + 1);
	stop([ao, ai0, ai1]);
	data0 = getdata(ai0);
	data1 = getdata(ai1);

	IRs += ifft(fft(data0) ./ fft(data1));
end

IR = IRs/n;