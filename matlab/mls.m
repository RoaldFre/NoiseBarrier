%guess where the sync pulse stops
start=37000;

mlseq = loadfile('mls16');
mic = loadfile('mls16-h99-r150-plaat3-n30.mat');
mic=mic(:,1);

micSpek = fft(mic(start:end));
mlsPad = postpad(mlseq, length(micSpek));
mlsPadRev = mlsPad(end:-1:1);
mlsPadRevSpek = fft(mlsPadRev);

impulseplaat = ifft(micSpek .* mlsPadRevSpek);








mlseq = loadfile('mls16');
mic = loadfile('mls16-h99-r150-mat2-n30.mat');
mic=mic(:,1);

micSpek = fft(mic(start:end));
mlsPad = postpad(mlseq, length(micSpek));
mlsPadRev = mlsPad(end:-1:1);
mlsPadRevSpek = fft(mlsPadRev);

impulsemat = ifft(micSpek .* mlsPadRevSpek);






plot(ifft(fft(impulseplaat) ./ fft(impulsemat)));
