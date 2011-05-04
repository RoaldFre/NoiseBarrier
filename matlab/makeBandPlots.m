dBmin = -70;

colormap(gray);

[_, _, _, _, _, _, _, _, _, bandsGridBefore] = processBeforeWall;
[_, _, _, _, _, _, _, _, _, bandsGridBehind] = processBehindWall;
bandPlots(bandsGridBefore, bandsGridBehind, 'bands', dBmin)


[_, _, _, _, _, _, bandsGridBeforeSim] = processSimulationBeforeWall;
[_, _, _, _, _, _, bandsGridBehindSim] = processSimulationBehindWall;
bandPlots(bandsGridBeforeSim, bandsGridBehindSim, 'bandsSim', dBmin)
