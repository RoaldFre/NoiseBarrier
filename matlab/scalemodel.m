data = load('../data/scalemodel.mat');
data = normalize(data.meetresultaten); %clipping of scope == +/xInf in dataset

hold on;
plot(data(:,1), data(:,100), 'r');
plot(data(:,1), highpass(data(:,100),25e6, 4e3)); %cut off at 4kHz
