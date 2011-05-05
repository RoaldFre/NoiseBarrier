signal = [zeros(10000,1); logsweep(50,10000,3,96000); zeros(5000,1)];
[mic,loop,main] = recordAveraged(signal,96000,32,30);
data = [mic,loop,main];
save 'creative-s2-h70-r116-plaatachter-n30.mat' -V7 data;

semilogy(fftshift(abs(fft(mic))));