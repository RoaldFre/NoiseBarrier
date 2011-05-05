function [received, sent] = record2(signal, rate, depth)
% [received, sent] = record(signal, rate, depth)
%
% Record the given signal at given rate and bitdepth 
% This is set up for the OCTA-CAPURE sound card.
% 'received': Holds 2 columns, corresponding to the first 2 input channels 
%             of the OCTA-CAPTURE soundcard.
% 'sent':     Holds the signal that was sent to the outut.
%
% Authors: Roald Frederickx, Elise Wursten.

samples = length(signal);

%set up the output (mono)
ao = analogoutput('winsound',0);
ao.SampleRate = rate;
ao.BitsPerSample = depth;
addchannel(ao,1);

%set up all the input channels
ai0 = analoginput('winsound',0);
addchannel(ai0,1);
addchannel(ai0,2);
ai0.SampleRate = rate;
ai0.BitsPerSample = depth;
ai0.SamplesPerTrigger = samples;

%the Octa-Capture soundcard seems to provide its own loop through 
%interface. This is probably just a literal copy of what we sent in (TODO: 
%verify this).
main = analoginput('winsound',5);
addchannel(main,1);
main.SampleRate = rate;
main.BitsPerSample = depth;
main.SamplesPerTrigger = samples;



putdata(ao,signal);
start([ai0,main,ao]);
%start([ai0,ai1,ai3,ao]);
% Just running wait([ai1,ai2,ao]) or any other combination seemed 
% to crash(?) -- So quick hack: just pause with a margin of one 
% second
%pause(samples/rate + 1);
wait([ai0,ao],5*samples/rate);
stop([ai0,ao]);

data0 = getdata(ai0);
datamain = getdata(main);

%close off nicely. otherwise Matlab won't like you
delete(ai0);
delete(main);


sent = datamain;
received = data0;
