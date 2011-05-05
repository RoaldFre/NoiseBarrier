%guess where the sync pulse stops
start=37000;

mls = loadfile('mls16');

micSpek = fft(mic(start:end));
mlsPad = postpad(mls, length(micSpek);
mlsPadRev = mlsPad(end:-1:1);
mlsPadRevSpek = fft(mlsPadRev);

impulse = ifft(micSpek .* mlsPadRevSpek);

