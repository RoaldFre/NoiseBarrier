function savefile(data, filename)
% Wrapper around the save command to easily save datasets in a seperate 
% directory, without having to dick around with unix vs windows slashes.

save ['../data/',filename] -V7 data;
%save ['..\data\',filename] -V7 data;
