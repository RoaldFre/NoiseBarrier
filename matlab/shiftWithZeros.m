function shifted = shiftWithZeros(signal, amount)
% shifted = shiftWithZeros(signal, amount)
%
% Shift the signal, pad with zeroes.
%
% Authors: Roald Frederickx, Elise Wursten.

if amount >= 0
	shifted = [zeros(amount, 1); signal(1 : end - amount)];
else
	shifted = [signal(1 - amount : end); zeros(-amount, 1)];
end

