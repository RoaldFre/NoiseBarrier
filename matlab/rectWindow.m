function [window] = rectWindow(spectrum,samplerate,leftcutoff,rightcutoff)
% rectWindow returns a window which is 
%   1 if the frequency lies between 'leftcutoff' and 'rightcutoff' 
%   0 otherwise.
fnyq = samplerate/2;
f = linspace(-fnyq,fnyq,length(spectrum))';
f = fftshift(f);

window = (leftcutoff < abs(f)) .* (abs(f) < rightcutoff);

