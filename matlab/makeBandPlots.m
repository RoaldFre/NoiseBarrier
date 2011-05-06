numJet = 200;
black = [0 0 0];
white = [1 1 1];
map = [black; jet(numJet); white];

dBmin = -100;
dBmax = -dBmin / numJet * 2;


colormap(map);

loadfiles = 1
normalizeSeperately = 0;

if loadfiles
	[_, _, _, _, _, _, _, _, _, bandsGridBefore] = processBeforeWall;
	[_, _, _, _, _, _, _, _, _, bandsGridBehind] = processBehindWall;
	[_, _, _, _, _, _, bandsGridBeforeSim] = processSimulationBeforeWall;
	[_, _, _, _, _, _, bandsGridBehindSim] = processSimulationBehindWall;
end

normalizationMeas = max(max(max(max(bandsGridBehind))), max(max(max(bandsGridBefore))))* (1 + 2/numJet);
normalizationSim = max(max(max(max(bandsGridBehindSim))), max(max(max(bandsGridBeforeSim))))* (1 + 2/numJet);

normalization = max(normalizationSim, normalizationMeas);

if normalizeSeperately
	bandsGridBeforeNorm = bandsGridBefore / normalizationMeas;
	bandsGridBehindNorm = bandsGridBehind / normalizationMeas;
	bandsGridBehindSimNorm = bandsGridBehindSim / normalizationSim;
	bandsGridBeforeSimNorm = bandsGridBeforeSim / normalizationSim;
else
	bandsGridBeforeNorm = bandsGridBefore / normalization;
	bandsGridBehindNorm = bandsGridBehind / normalization;
	bandsGridBehindSimNorm = bandsGridBehindSim / normalization;
	bandsGridBeforeSimNorm = bandsGridBeforeSim / normalization;
end


bandPlots(bandsGridBeforeNorm, bandsGridBehindNorm, 'bands', dBmin, dBmax, normalization);
bandPlots(bandsGridBeforeSimNorm, bandsGridBehindSimNorm, 'bandsSim', dBmin, dBmax, normalization);
