function window = tanhWindow(A,p1,p2,a)
% A is the signal on which the window has to be placed
% p1,p2: procentual cutoff points
% a: procentual width of decays

[rows,k] = size(A);
r = rows/2;

i1 = ((round(p1*r/100)));
i2 = ((round(p2*r/100)));
i3 = ((round(a*r/100)));
rij = (1:r)';

ww = (0.5*(1+tanh((rij-i1)/i3))) -(0.5*(1+tanh((rij-i2)/i3)));

specwindow = [ww; ww(length(ww):-1:1)];
window = specwindow*ones(1,k);