depth = 32;
rate = 96000;
signal = logsweep(50,10000,2,96000);
samples = length(signal);



ao = analogoutput('winsound',0);
ao.SampleRate = rate;
ao.BitsPerSample = depth;
addchannel(ao,1);




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



putdata(ao,signal);
start([ai0,ai1,ai2,ai3,ao]);
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

delete(ai0);
delete(ai1);
delete(ai2);
delete(ai3);

subplot(4,2,1);
plot(data0(:,1));
subplot(4,2,2);
plot(data0(:,2));
subplot(4,2,3);
plot(data1(:,1));
subplot(4,2,4);
plot(data1(:,2));
subplot(4,2,5);
plot(data2(:,1));
subplot(4,2,6);
plot(data2(:,2));
subplot(4,2,7);
plot(data3(:,1));
subplot(4,2,8);
plot(data3(:,2));


