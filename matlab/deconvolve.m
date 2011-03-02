[speaker, fs,  bits] = wavread('s1-h100-r100-mat1.wav');
speaker = speaker(:,2);
[echo, fs,  bits] = wavread('s1-h100-r100-vloer1.wav');
echo = echo(:,2);
echo = prepad(echo(1:end-10000),length(echo));
%samplerate *MUST* be the same for both speaker and echo
dt = 1/fs;
T = length(speaker) * dt;
ts = linspace(0,T,length(speaker));

threshold = 0.05;
sent = speaker;
recv = echo;
sentspec = abs(fft(sent));
spec = fft(recv) ./ fft(sent);
spec = spec .* (abs(sentspec) > threshold * max(sentspec));

deconv = ifft(spec);

%subplot(3,1,1);
figure;
plot(ts, deconv);
%axis([0,0.02,0,1], 'autoy');
% subplot(3,1,2);
% plot(ts, abs(xcorr));
% axis([0,0.02,0,1], 'autoy');
% subplot(3,1,3);
% plot(ts, abs(xcorr2));
% axis([0,0.02,0,1], 'autoy');
