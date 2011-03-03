function [received, sent] = recordAveraged(signal, rate, depth, n)
% [received, sent] = recordAveraged(signal, rate, depth, n)
%
% Record the given signal at given rate and bitdepth by averaging n 
% succesive measurements.
% This is set up for the OCTA-CAPURE sound card. Connect the mic to port1 
% and loop the output to port2(??).
%
% Authors: Roald Frederickx, Elise Wursten.

samples = length(signal);

%Initialize soundcard. You may need to change this for your specific setup
ai0 = analoginput('winsound',0); %microphone signal
ai1 = analoginput('winsound',5); %loop-through signal (main)
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

received = zeros(samples,1);
sent = zeros(samples,1);
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

    if i ~= 1
        % Sync to the accumulated signal, or just the first? We'll use the 
        % accumulated for now...
        data0 = sync(received/i, data0);
        data1 = sync(sent/i, data1);
    end
    
	received = received + data0;
	sent = sent + data1;
end
delete(ai0);
delete(ai1);
delete(ao);

received = received / n;
sent = sent / n;
wavwrite([received,sent],rate,depth,'s2-h102-r100-plaattrans3.wav');
