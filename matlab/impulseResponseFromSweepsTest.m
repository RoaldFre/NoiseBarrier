sweeps = loadfile('RandMuur/swp1x64-h315-rsm300-theta90-gras-1');
sweeps = sweeps(:,1);
sweep = logsweep(50,10000,1,96000);

numPreTrigger = 1000;
impulseResponse = impulseResponseFromMLSs(sweeps, sweep, 64, numPreTrigger);

t = linspace(0,length(impulseResponse)/96000, length(impulseResponse));

plot(t, impulseResponse);

%axis([0,0.05,0,1],'autoy');
