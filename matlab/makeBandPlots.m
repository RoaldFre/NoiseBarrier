numJet = 1000;
black = [0 0 0];
white = [1 1 1];
map = [black; jet(numJet); white];

dBmin = -70;
dBmax = -dBmin / numJet * 2;


colormap(map);

[_, _, _, _, _, _, _, _, _, bandsGridBefore] = processBeforeWall;
[_, _, _, _, _, _, _, _, _, bandsGridBehind] = processBehindWall;
bandPlots(bandsGridBefore, bandsGridBehind, 'bands', dBmin, dBmax);

[_, _, _, _, _, _, bandsGridBeforeSim] = processSimulationBeforeWall;
[_, _, _, _, _, _, bandsGridBehindSim] = processSimulationBehindWall;
bandPlots(bandsGridBeforeSim, bandsGridBehindSim, 'bandsSim', dBmin, dBmax);
