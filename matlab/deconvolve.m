[speaker, fs,  bits] = wavread("s1-h100-r100-mat1.wav");
speaker = speaker(:,2);
[echo, fs,  bits] = wavread("s1-h100-r100-vloer1.wav");
echo = echo(:,2);

%samplerate *MUST* be the same for both speaker and echo
dt = 1/fs;
T = length(speaker) * dt;
ts = linspace(0,T,length(speaker));

deconv = real(ifft(fft(echo) ./ fft(speaker)));
xcorr = ifft(fft(echo) .* conj(fft(speaker)));
xcorr2 = ifft(fft(echo) .* (fft(speaker(length(speaker):-1:1))));

subplot(3,1,1);
plot(ts, deconv);
axis([0,0.02,0,1], 'autoy');
subplot(3,1,2);
plot(ts, abs(xcorr));
axis([0,0.02,0,1], 'autoy');
subplot(3,1,3);
plot(ts, abs(xcorr2));
axis([0,0.02,0,1], 'autoy');
