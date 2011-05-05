clear; clearvars;

X = logsweep(50,10000,1,96000);
X = [X;X];
X = [X;X];
X = [X;X];
X = [X;X];
X = [X;X];
X = [X;X];

signal = [zeros(10000,1); X; zeros(24000,1)];

[mic, loop, main] = record2Averaged(signal,96000,32,1);
data = [mic, loop, main];
savefile(data, 'Helmholtz\swp1x64-h140-r160-theta60-moussebox-1.mat');



clear; clearvars;

X = logsweep(50,10000,60,96000);


signal = [zeros(10000,1); X; zeros(24000,1)];

[mic, loop, main] = record2Averaged(signal,96000,32,1);
data = [mic, loop, main];
savefile(data, 'Helmholtz\swp60x1-h140-r160-theta60-moussebox-1.mat');



clear; clearvars;

X = loadfile('mls16.mat');
X = [X;X];
X = [X;X];
X = [X;X];
X = [X;X];
X = [X;X];
X = [X;X];

signal = [zeros(10000,1); X; zeros(24000,1)];

[mic, loop, main] = record2Averaged(signal,96000,32,1);
data = [mic, loop, main];
savefile(data, 'Helmholtz\mls16x64-h140-r160-theta60-moussebox-1.mat');


clear; clearvars;

X = loadfile('mls18.mat');
X = [X;X];
X = [X;X];
X = [X;X];
X = [X;X];

signal = [zeros(10000,1); X; zeros(24000,1)];

[mic, loop, main] = record2Averaged(signal,96000,32,1);
data = [mic, loop, main];
savefile(data, 'Helmholtz\mls18x16-h140-r160-theta60-moussebox-1.mat');