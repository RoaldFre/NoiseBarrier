% Laten we eens een plotje maken van de hoekafhankelijkheid van het
% speakerspectrum!

samplerate = 96000;
fmax = 10000;
combinedSamples = 3;

hoogtes = 150:5:230;
theta = atan((hoogtes-150)./120);

naam = 's10-h150-r120-theta0-hmic150-n10.mat';
data = loadfile(naam);
[r,k] = size(data);
aantalRijen = round(r/samplerate*fmax);
f = linspace(0,fmax,aantalRijen/combinedSamples);
attenuationCorrection = sqrt(150^2+(hoogtes-150).^2)/150;

Z = zeros(aantalRijen/combinedSamples,length(hoogtes));
for i=150:5:230
    naam = ['s10-h150-r120-theta0-hmic', int2str(i),'-n10.mat'];
    data = loadfile(naam);
    speaker = data(:,1);
    main = data(:,3);
    spectrum = log(abs(fft(speaker) ./ fft(main))*attenuationCorrection);
    spectrum = combineBins(spectrum(1:aantalRijen), combinedSamples);
    Z(:,(i-145)/5) = spectrum;
end

figure;
polarmeshc(f, theta, Z);

% figure;
% polarcontourf(f, theta, Z, 100);

% figure;
% polarcont(f, theta, Z, 20);

