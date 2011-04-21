mlss = loadfile('RandMuur/mls16x64-h315-rsm300-theta90-gras-2');
mlss = mlss(:,1);
mls16 = loadfile('mls16');

numPreTrigger = 1000;
impulseResponse = impulseResponseFromMLSs(mlss, mls16, 64, numPreTrigger);

t = linspace(0,length(impulseResponse)/96000, length(impulseResponse));

plot(t, impulseResponse);

%axis([0,0.05,0,1],'autoy');
