function [mic, loop, main] = recordAveraged(signal, rate, depth, n)
% [received, sent] = recordAveraged(signal, rate, depth, n)
%
% Record the given signal at given rate and bitdepth by averaging n 
% succesive measurements.
% This is set up for the OCTA-CAPURE sound card. Connect the mic to port1 
% and loop the output to port2(??).
%
% Authors: Roald Frederickx, Elise Wursten.

samples = length(signal);

mic = zeros(samples,1);
loop = zeros(samples,1);
main = zeros(samples,1);

for i = 1:n
    fprintf('%d..',i);
	[recvdata, sentdata] = record8(signal,rate,depth);
    thismic = recvdata(:,1);
    thisloop = recvdata(:,2);
    thismain = sentdata;

    if i ~= 1
        % Sync to the accumulated signal, or just the first? We'll use the 
        % accumulated for now...
        thismic = sync(mic/i, thismic);
        thisloop = sync(loop/i, thisloop);
        thismain = sync(main/i, thismain);
    end
    
	mic = mic + thismic;
	loop = loop + thisloop;
    main = main + thismain;
end
fprintf('\n');

mic = mic/n;
loop = loop/n;
main = main/n;