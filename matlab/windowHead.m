function window = windowHead(fraction, fractionalWidth, n)

x = linspace(0,1,n);
for i = 1:length(fraction)
	if fraction(i) >= 1
		window(i,:) = ones(length(x),1);
	else
		window(i,:) = 0.5 + 0.5*tanh((x - fraction(i))./fractionalWidth);
	end
end

