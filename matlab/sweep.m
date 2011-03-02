rate = 96000;
depth = 32;
swp = logsweep(50,10000,2,rate);
swp = [swp; zeros(rate,1)];

name = 's1-h167-r100-mat';

%0 = input 1
%3 = input 3
ai0 = analoginput('winsound',0);
ai1 = analoginput('winsound',3);
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
ai0.SamplesPerTrigger = length(swp);
ai1.SamplesPerTrigger = length(swp);

putdata(ao,swp);
start([ai0,ai1,ao]);
pause(5);
stop(ao);
data0=getdata(ai0);
data1=getdata(ai1);

clf;
subplot(2,1,1);
plot(data0);
subplot(2,1,2);
plot(data1);

wavwrite([data0,data1],rate,depth,[name,'1.wav']);





%0 = input 1
%3 = input 3
ai0 = analoginput('winsound',0);
ai1 = analoginput('winsound',3);
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
ai0.SamplesPerTrigger = length(swp);
ai1.SamplesPerTrigger = length(swp);

putdata(ao,swp);
start([ai0,ai1,ao]);
pause(5);
stop(ao);
data0=getdata(ai0);
data1=getdata(ai1);

clf;
subplot(2,1,1);
plot(data0);
subplot(2,1,2);
plot(data1);

wavwrite([data0,data1],rate,depth,[name,'2.wav']);




%0 = input 1
%3 = input 3
ai0 = analoginput('winsound',0);
ai1 = analoginput('winsound',3);
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
ai0.SamplesPerTrigger = length(swp);
ai1.SamplesPerTrigger = length(swp);

putdata(ao,swp);
start([ai0,ai1,ao]);
pause(5);
stop(ao);
data0=getdata(ai0);
data1=getdata(ai1);

clf;
subplot(2,1,1);
plot(data0);
subplot(2,1,2);
plot(data1);

wavwrite([data0,data1],rate,depth,[name,'3.wav']);




%0 = input 1
%3 = input 3
ai0 = analoginput('winsound',0);
ai1 = analoginput('winsound',3);
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
ai0.SamplesPerTrigger = length(swp);
ai1.SamplesPerTrigger = length(swp);

putdata(ao,swp);
start([ai0,ai1,ao]);
pause(5);
stop(ao);
data0=getdata(ai0);
data1=getdata(ai1);

clf;
subplot(2,1,1);
plot(data0);
subplot(2,1,2);
plot(data1);

wavwrite([data0,data1],rate,depth,[name,'4.wav']);




%0 = input 1
%3 = input 3
ai0 = analoginput('winsound',0);
ai1 = analoginput('winsound',3);
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
ai0.SamplesPerTrigger = length(swp);
ai1.SamplesPerTrigger = length(swp);

putdata(ao,swp);
start([ai0,ai1,ao]);
pause(5);
stop(ao);
data0=getdata(ai0);
data1=getdata(ai1);

clf;
subplot(2,1,1);
plot(data0);
subplot(2,1,2);
plot(data1);

wavwrite([data0,data1],rate,depth,[name,'5.wav']);




%0 = input 1
%3 = input 3
ai0 = analoginput('winsound',0);
ai1 = analoginput('winsound',3);
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
ai0.SamplesPerTrigger = length(swp);
ai1.SamplesPerTrigger = length(swp);

putdata(ao,swp);
start([ai0,ai1,ao]);
pause(5);
stop(ao);
data0=getdata(ai0);
data1=getdata(ai1);

clf;
subplot(2,1,1);
plot(data0);
subplot(2,1,2);
plot(data1);

wavwrite([data0,data1],rate,depth,[name,'6.wav']);




