%function [mic, loop, main] = record2Averaged(signal, rate, depth, n)
function [mic, loop, main] = record2Averaged(signal, rate, depth, n)
% [received, sent] = recordAveraged(signal, rate, depth, n)
%
% Record the given signal at given rate and bitdepth by averaging n 
% succesive measurements.
% This is set up for the OCTA-CAPURE sound card. Connect the mic to port1 
% and loop the output to port2.
%
% Authors: Roald Frederickx, Elise Wursten.

samples = length(signal);

mic = zeros(samples,1);
loop = zeros(samples,1);
main = zeros(samples,1);

for i = 1:n
    fprintf('%d..',i);
	[recvdata, sentdata] = record2(signal,rate,depth);
    thismic = recvdata(:,1);
    %thisloop = recvdata(:,2);
    %thismain = sentdata;
    
    %only use only first main/loop, saves time from syncinc:
    if i == 1
        main = sentdata;
        loop = recvdata(:,2);
    end

    if i ~= 1
        % Sync to the accumulated signal, or just the first? We'll use the 
        % accumulated for now...
        thismic = sync(mic/i, thismic, 4);
        %thisloop = sync(loop/i, thisloop,5);
        % thismain = sync(main/i, thismain,5);
	%Don't waste time syncing loop and main.
    end
    
	mic = mic + thismic;
    %loop = loop + thisloop;
	%main = main + thismain;
end
fprintf('\n');

mic = mic/n;
%loop = loop/n;
%main = main/n;

% vim: ts=4:sw=4:expandtab
