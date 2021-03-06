function bandPlots(bandsGridBefore, bandsGridBehind, filename, dBmin, dBmax)


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

yWallVec = [0 0 0 0 0 0 0 Inf]';
yWallVecs = yWallVec * ones(1, 4);

left = min(xvec) - recordSideStep/2;
right = max(xvec) + recordSideStep/2;
down = 0
up = max(yvec) + recordUpStep/2;

hold off; clf;

for i=1:nbBands
	bandsGrid = [bandsGridBefore(end:-1:1, :, i)', yWallVecs, bandsGridBehind(:,:,i)'];
	bandsGrid = real(10*log(bandsGrid));
	bandsGrid(find(isnan(bandsGrid))) = Inf;
	imagesc(100*xvec, 100*yvec, bandsGrid, [dBmin, dBmax]);

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
	width='620';
	height='190';
	makeGraph(name,destdir,relImgDir,xlab,ylab,ylabrule,width,height);
end

clf;

