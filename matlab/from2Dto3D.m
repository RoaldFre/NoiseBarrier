function transformed = from2Dto3D(signal, time)
%correct the 1/sqrt(r) pressure attenuation in 2D to a 1/r attenuation in 3D

c = 340;
minDist = 1e-6;

transformed = signal ./ max(sqrt(time * c), minDist);

%plot(time,signal, time,transformed,'g');
%pause(0.1)
