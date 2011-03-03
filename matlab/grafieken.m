% Bestanden inlezen
[speaker, sf,  bits] = wavread('s2-h102-r100-mat1.wav');
[vloer, vsf, vbits] = wavread('s2-h102-r100-vloer1.wav');

% data inlezen
sp = speaker(:,1);
sploop = speaker(:,2);
vl = vloer(:,1);
vlloop = vloer(:,2);
spdt = 1/sf;
spT = length(sp) * spdt;
spts = linspace(0, spT, length(sp));
vldt = 1/vsf;
vlT = length(vl) * vldt;
vlts = linspace(0, vlT, length(vl));

%Shiften van het microfoon signaal tov de sweep. Verschuiving van 5000.
sp = prepad(sp(1:end-5000), length(sp));
vl = prepad(vl(1:end-5000), length(vl));

% Grafieken van de opgenomen signalen
figure;
subplot(2,1,1);
plot(spts,sploop,spts,sp);
xlabel('Tijd (s)');
ylabel('Amplitude');
title('Uitgestuurde sweep en opgenomen signaal');
subplot(2,1,2);
plot(vlts,vlloop,vlts,vl);
xlabel('Tijd (s)');
ylabel('Amplitude');
title('Uitgestuurde sweep en opgenomen signaal met vloerreflectie');

% Spectra van de gedeelde signalen zonder correctie voor delen door 0.
spspec = abs(fft(sp) ./ fft(sploop));
vlspec = abs(fft(vl) ./ fft(vlloop));
spfreq = linspace(-sf/2,sf/2,length(sp));
vlfreq = linspace(-vsf/2,vsf/2,length(vl));
figure;
subplot(2,1,1);
plot(spfreq,fftshift(spspec));
xlabel('Frequentie (Hz)');
ylabel('amplitude');
title('Spectrum speaker zonder correctie');
subplot(2,1,2);
plot(vlfreq,fftshift(vlspec));
xlabel('Frequentie (Hz)');
ylabel('amplitude');
title('Spectrum speaker + vloer zonder correctie');

% Spectra van de gedeelde signalen met correctie voor delen door 0.
[spspec,spafkap] = cleanSpec(sp,sploop,0.05);
[vlspec,vlafkap] = cleanSpec(vl,vlloop,0.05);
figure;
subplot(2,1,1);
plot(spfreq,fftshift(abs(spspec)),spfreq,fftshift(spafkap));
xlabel('Frequentie (Hz)');
ylabel('amplitude');
title('Spectrum speaker met correctie');
subplot(2,1,2);
plot(vlfreq,fftshift(abs(vlspec)),vlfreq,fftshift(vlafkap));
xlabel('Frequentie (Hz)');
ylabel('amplitude');
title('Spectrum speaker + vloer met correctie');


% Impulsrespons voor beide.
spimp = ifft(spspec);
vlimp = ifft(vlspec);
figure;
subplot(2,1,1);
plot(spts,spimp);
xlabel('Tijd (s)');
ylabel('Amplitude');
title('Impulsrespons van de speaker');
subplot(2,1,2);
plot(vlts,vlimp);
xlabel('Tijd (s)');
ylabel('Amplitude');
title('Impulsrespons van de vloer + speaker');

% Gedeconvolueerd signaal (hierbij worden de oorspronkelijke signalen gebruikt).
[deconvspec, afkapimp] = cleanSpec(vl,sp,0.05);
deconvimp = ifft(deconvspec);
figure;
plot(spfreq, fftshift(abs(deconvspec)),spfreq, fftshift(afkapimp));
xlabel('Frequentie (Hz)');
ylabel('Amplitude');
title('Spectrum van de vloer gedeconvolueerd met het signaal van de speaker');
figure;
plot(spts, real(deconvimp));
axis([0,0.012,0,1], 'autoy');
xlabel('Tijd (s)');
ylabel('Amplitude');
title('Impulsrespons van de vloer (gedeconvolueerd met het signaal van de speaker)');

% Handmatig knippen
vloerrespons = deconvimp(5300:end);
vloerspectrum = fft(vloerrespons);
figure;
fftplot(spts(5300:end),vloerrespons);

figure;
subplot(3,1,1);
semilogy(vlfreq,fftshift(abs(fft(vl))));
xlabel('Frequentie (Hz)');
ylabel('Amplitude');
title('Spectrum van de vloer+speaker');
subplot(3,1,2);
semilogy(spfreq,fftshift(abs(fft(sp))));
xlabel('Frequentie (Hz)');
ylabel('Amplitude');
title('Spectrum van de speaker');
subplot(3,1,3);
semilogy(spfreq,fftshift(abs(fft(vl) ./ fft(sp))));
xlabel('Frequentie (Hz)');
ylabel('Amplitude');
title('Gedeeld spectrum van de vloer');

