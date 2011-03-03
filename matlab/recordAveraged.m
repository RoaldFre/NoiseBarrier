function [received, sent] = recordAveraged(signal, rate, depth, n)
% [received, sent] = recordAveraged(signal, rate, depth, n)
%
% Record the given signal at given rate and bitdepth by averaging n 
% succesive measurements.
% This is set up for the OCTA-CAPURE sound card. Connect the mic to port1 
% and loop the output to port2(??).
%
% Authors: Roald Frederickx, Elise Wursten.

samples = length(signal);

received = zeros(samples,1);
sent = zeros(samples,1);
for i = 1:n
	
    if i ~= 1
        % Sync to the accumulated signal, or just the first? We'll use the 
        % accumulated for now...
        data0 = sync(received/i, data0);
        data1 = sync(sent/i, data1);
    end
    
	received = received + data0;
	sent = sent + data1;
end
delete(ai0);
delete(ai1);
delete(ao);

received = received / n;
sent = sent / n;
