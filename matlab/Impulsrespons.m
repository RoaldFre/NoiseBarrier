[speaker, fs,  bits] = wavread('s1-h100-r100-mat3.wav');
shifted = prepad(speaker(1:end-10000,2),length(speaker(:,1)));
deconv = abs(fft(shifted) ./ fft(speaker(:,1)));
dt = 1/fs;
T = length(speaker) * dt;
ts = linspace(0,T,length(speaker));
plot(ts, deconv);
axis([0,0.02,0,1], 'autoy');

threshold = 0.15;
sent = speaker(:,1);
recv = shifted;

sentspec = abs(fft(sent));
spec = fft(recv) ./ fft(sent);
length(spec)
spec = spec .* (abs(sentspec) > threshold * max(sentspec));
%lp = lowpass(48000, 96000, length(spec));length(lp)
%spec = spec .* lp;


deconv = ifft(spec);

subplot(3,1,1);
plot(abs(fft(speaker(:,1))))
subplot(3,1,2);
plot(abs(fft(shifted)));
subplot(3,1,3);
plot(ts, abs(spec));
%axis([0,0.02,0,1], 'autoy');

