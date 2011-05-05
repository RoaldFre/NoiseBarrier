function logAxis(low, high, factor)
%Change the x axis of the plot to an exponential axis startin from low and going to high by steps of the given factor 
tickmarks = low * factor.^(0:floor(log(high/low)/log(factor)));
set(gca,'XTick',tickmarks);
set(gca, 'xticklabel', sprintf('%d|', tickmarks));
