function bandPlots(bandsGridBefore, bandsGridBehind, filename, dBmin)

beforeWallData;

xvecBef = -wallToRecord + (0:sideSteps-1)*recordSideStep;
yvecBef = (0:upSteps-1)*recordUpStep + recordHeight;
xStepsBef = sideSteps;

behindWallData;

xvecBeh = (0:sideSteps-1)*recordSideStep + wallToRecord;
yvecBeh = (0:upSteps-1)*recordUpStep + recordHeight; %MUST BE EQUAL TO xvecBef!!!
xStepsAft = sideSteps;


xvec = [xvecBef(end:-1:1), 0, 0.001, wallWidth-0.001, wallWidth, wallWidth + xvecBeh];
yvec = ((0:upSteps-1)*recordUpStep + recordHeight);

yWallVec = [0 0 0 0 0 0 0 1]';
yWallVecs = yWallVec * ones(1, 4);

left = min(xvec) - recordSideStep/2;
right = max(xvec) + recordSideStep/2;
down = 0
up = max(yvec) + recordUpStep/2;

normalization = max(max(max(max(bandsGridBehind))), max(max(max(bandsGridBefore))));

for i=1:nbBands
	bandsGrid = [bandsGridBefore(end:-1:1, :, i)', yWallVecs, bandsGridBehind(:,:,i)'] / normalization;
	size(bandsGrid)
	imagesc(100*xvec, 100*yvec, 10*log(bandsGrid), [dBmin,0]);
	axis xy;
	%axis equal;
	colorbar;

	%axis(100*[left, right, down, up]);

	name=[filename,num2str(i)];
	destdir = '../latex/images';
	relImgDir = 'images';
	ylabrule='0.9cm';
	xlab='$x$ (cm)';
	ylab='$y$ (cm)';
	width='575';
	height='160';
	makeGraph(name,destdir,relImgDir,xlab,ylab,ylabrule,width,height);
end



