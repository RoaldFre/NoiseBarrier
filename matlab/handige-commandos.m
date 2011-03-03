%Handige commandos
info = daqhwinfo('winsound')
ai = analoginput('winsound',0);
addchannel(ai,0);
ai.SampleRate = 10000;
ai.SamplesPerTrigger = 10000;

ao = analogoutput('winsound');
addchannel(ao,0);
ao.SampleRate = 1000;

putsample(ao,0)

% Generate an output test signal (1Hz sine wave) and load test signal into
% the analog output buffer.
outputSignal = sin(linspace(0,pi*2,ao.SampleRate)');
putdata(ao,outputSignal)

% Start the acquisition and generation.  These two operations are
% not coordinated by hardware.  Because of the order in the brackets, the
% analog input is simply started before the analog output.
start([ai,ao])

% Wait up to two seconds to allow the operations to complete,
% and retrieve the results from the toolbox.
wait([ai,ao],2)
[data,time] = getdata(ai);