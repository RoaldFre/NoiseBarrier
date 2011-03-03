data = load('s2-h102-r100-plaattrans2-n30.mat');
data=data.data;
mic = data(1:end/3);
loop = data(end/3+1:end/3*2);
main = data(end/3*2+1:end);

micspec = fft(mic);
mainspec = fft(main);

micspec = nozero(micspec,0.1);

deconspec = cleanSpec(ifft(mainspec.^2),mic,0.05);
decon = ifft(deconspec);
% figure;
% subplot(3,1,1);
% plot(fftshift(abs(micspec)));
% subplot(3,1,2);
% plot(fftshift(abs(mainspec)));
% subplot(3,1,3);
% plot(fftshift(abs(deconspec)));
% 
% figure;
% plot(decon);

data = record8(decon,96000,32);
subplot(3,1,1);
plot(decon);
subplot(3,1,2);
plot(fftshift(abs(deconspec)));
subplot(3,1,3);
plot(fftshift(abs(fft(data(:,1)))));