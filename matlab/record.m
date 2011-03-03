function [received, sent] = record(signal, rate, depth)
% [received, sent] = record(signal, rate, depth)
%
% Record the given signal at given rate and bitdepth 
% This is set up for the OCTA-CAPURE sound card.
% 'received': Holds 8 columns, corresponding to the 8 input channels of the 
%             OCTA-CAPTURE soundcard.
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

ai1 = analoginput('winsound',6);
addchannel(ai1,1);
addchannel(ai1,2);
ai1.SampleRate = rate;
ai1.BitsPerSample = depth;
ai1.SamplesPerTrigger = samples;

ai2 = analoginput('winsound',3);
addchannel(ai2,1);
addchannel(ai2,2);
ai2.SampleRate = rate;
ai2.BitsPerSample = depth;
ai2.SamplesPerTrigger = samples;

ai3 = analoginput('winsound',7);
addchannel(ai3,1);
addchannel(ai3,2);
ai3.SampleRate = rate;
ai3.BitsPerSample = depth;
ai3.SamplesPerTrigger = samples;

%the Octa-Capture soundcard seems to provide its own loop through 
%interface. This is probably just a literal copy of what we sent in (TODO: 
%verify this).
main = analoginput('winsound',5);
addchannel(main,1);
addchannel(main,2);
main.SampleRate = rate;
main.BitsPerSample = depth;
main.SamplesPerTrigger = samples;



putdata(ao,signal);
start([ai0,ai1,ai2,ai3,main,ao]);
%start([ai0,ai1,ai3,ao]);
% Just running wait([ai1,ai2,ao]) or any other combination seemed 
% to crash(?) -- So quick hack: just pause with a margin of one 
% second
pause(samples/rate + 1);
stop([ai0,ai1,ai2,ai3,ao]);

data0 = getdata(ai0);
data1 = getdata(ai1);
data2 = getdata(ai2);
data3 = getdata(ai3);
datamain = getdata(main);

%close off nicely. otherwise Matlab won't like you
delete(ai0);
delete(ai1);
delete(ai2);
delete(ai3);
delete(main);


sent = main;
received = [data0; data1; data2; data3];
