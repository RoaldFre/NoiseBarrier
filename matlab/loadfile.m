function [data] = loadfile(filename)
% Wrapper around the load command to easily load datasets in a seperate 
% directory, without having to dick around with unix vs windows slashes.

data = load(['..', slash, 'data', slash, filename]);
data = data.data;
