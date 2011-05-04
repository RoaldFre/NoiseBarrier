sourceHeight = 0.125;
sourceToWall = 1.2;
wallWidth = 0.06;
wallHeight = 0.212;

wallToRecord = 0.1;
sourceToRecord = sourceToWall + wallWidth + wallToRecord;
recordHeight = 0.03;

recordSideStep = 0.03;
recordUpStep = 0.03;

sideSteps = 12;
upSteps = 8;



bandBorders = [5e3, 10e3, 20e3, 40e3];
nbBands = length(bandBorders) - 1;
bandsGrid = zeros([sideSteps, upSteps, nbBands]);
order = 1; %order of butterworth bandpass filter for bands
% TODO octave only accepts order one?


c = 340;
