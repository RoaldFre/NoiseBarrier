function window = blackmanHarrisHalf(length)
% Half a B-H window. Negative length == leading part; positive length == 
% trailing part.

if length < 0
	length = -length;
	x = pi * linspace(0.5, length-0.5, length)/length;
else
	x = pi * (1 + linspace(0.5, length-0.5, length)/length);
end

a0 = 0.35875;
a1 = 0.48829;
a2 = 0.14128;
a3 = 0.01168;

window = a0 - a1*cos(x) + a2*cos(2*x) - a3*cos(3*x);

