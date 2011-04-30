%this script performs a finite difference calculation on SCK-CEN interest
%samples

clear all
close all
more off
clc


%% material parameters
rho = 1.3;
c = 340;
%% grid parameters
D = 1.3;  %in m
L = 2.8;  %in m !!!x-y coordinate system

%dx = 0.5e-3;
dx = 0.25e-3;
dz = dx;

%simt = 1e-2;%total simulation time in s
simt = 7e-3;%total simulation time in s

%excitation
Texc = 25e-6;
nexpx = 71;
nexpz = 71;
exSize = 0.003; %this is 2*sigma of the gaussian

extx = 0.6;
extz = 0.125;

% defect boundaries
lengthD = 0.060;
heigthD = 0.212;
Dleft = extx + 1.2;
Dright = Dleft + lengthD;
Dtop = D-heigthD;
Dbottom = D;



ndx = round(L/dx);
ndz = round(D/dz);

%dt = 1/real(c)/sqrt(1/dx^2+1/dz^2);
dt = 1/real(c)/sqrt(1/dx^2+1/dz^2)

xvec = linspace(0,L,ndx);
zvec = linspace(0,D,ndz);

ndt = round(simt/dt);
tvec = linspace(0,simt,ndt);


%% excitation parameters
fexc = 1/Texc
next = round(Texc/dt)
ext = hanning(next);
%ext = [ext; zeros(1000,1)];


expointx = round(extx/L*ndx - nexpx/2);
expointz = round(extz/D*ndz - nexpz/2);

sigma = exSize / 2;
xdists = ones(nexpz,1) * linspace(-nexpx/2, nexpx/2, nexpx) * dx;
zdists = linspace(-nexpz/2, nexpz/2, nexpz)' * dz * ones(1,nexpx);
dists_sq = xdists.^2 + zdists.^2;
exxz = exp(-dists_sq / 2 / sigma^2);
clear dists_sq xdists zdists;

%exx = hanning(nexpx);
%exz = hanning(nexpz);
%exxz = (exx*ones(1,nexpz)).*(ones(nexpx,1)*exz.');



Dlength = abs(Dright-Dleft);
Ddepth = abs(Dbottom-Dtop);

left = round(Dleft/L*ndx);
right = round(Dright/L*ndx);
top = ndz-round(Dtop/D*ndz);
bottom = ndz-round(Dbottom/D*ndz)+1;





%% record points
nrecx = 12;
nrecz = 8;
stepx = 0.03;
stepz = 0.03;
for i = 0 : (nrecx*nrecz - 1)
	xrecGrid(i+1) = floor(i/nrecz) * stepx;
	zrecGrid(i+1) = mod(i, nrecz) * stepz;
end
xrecStart = Dright + 0.10;
zrecStart = 0.03;

xrec = xrecStart + xrecGrid;
zrec = zrecStart + zrecGrid;

xrec = round(xrec/L*ndx);
zrec = round(zrec/D*ndz);

%freeFieldx = 2;
freeFieldx = extx + 0.5;
freeFieldz = extz;
freeFieldx = round(freeFieldx / L * ndx);
freeFieldz = round(freeFieldz / D * ndz);






%% initiate matrices
vx = zeros(ndx,ndz);
vz = zeros(ndx,ndz);
P = zeros(ndx,ndz);

recordstep = 1;
Precord = zeros(length(xrec), floor(ndt/recordstep));
freeFieldRecord = zeros(1, floor(ndt/recordstep));






vis = false
visualizeSteps = 30;
counter = 1;
counterM = 1;
counterrec = 1;
%% visualize setting (recordpoints, source, freefield)
if vis
	fig = real(P);
	%fig(left:right,bottom:top) = zeros;
	fig(left:right,bottom:top) = -1;
	for i = 1:length(xrec)
		fig(xrec(i), zrec(i)) = 1;
	end
	fig(freeFieldx, freeFieldz) = 1;
	fig(expointx:expointx+nexpx-1,expointz:expointz+nexpz-1) = exxz;
	imagesc(xvec,zvec,fig')
	axis xy
end

if vis
    h = figure;
    %maximize(gcf)
end

%% running loop
for t = 1:ndt
    if t<=next
        %P(expointx:expointx+nexpx-1,expointz:expointz+nexpz-1) = exxz*sin(2*pi*fexc*t*dt)*ext(t);
        P(expointx:expointx+nexpx-1,expointz:expointz+nexpz-1) += exxz * ext(t);
	%XXX XXX += instead of = !!!
        %%%figure(hh);
        %hold on
        %%%plot(t*dt,sin(2*pi*fexc*t*dt)*ext(t),'*k');
    end   

    %calculate differences
    %calculate new velocities
    vx = vx  -  dt/rho * ((P([2:end,1],:) - P)/dx);
    vz = vz  -  dt/rho * ((P(:,[end,1:end-1]) - P)/dz);
    
    %boundary conditions-> material boundaries
    %top
    vz(:,1) = zeros;
    %bottom
    vz(:,end) = zeros;
    %left
    vx(1,:) = zeros;
    %right
    vx(end,:) = zeros;
    %vx(end,:) = zeros;
    
    %boundary conditions-> defect boundaries
    %displacement zero at defect's boundaries
    %left
    vx(left,bottom:top) = zeros;
    %right
    vx(right,bottom:top) = zeros;
    %bottom
    vz(left:right,bottom) = zeros;
    %top
    vz(left:right,top) = zeros;
    
    %%calculate velocity position differences
    %vxx = 1/(dx)*(vx-vx([end,1:end-1],:));
    %vzz = 1/(dz)*(vz-vz(:,[2:end,1]));
    %%calculate new pressure
    %P = -c^2*rho*dt*(vxx+vzz)+P;
    %calculate new pressure
    P = P - c^2*rho*dt*((vx - vx([end,1:end-1],:))/dx ...
                     +  (vz - vz(:,[2:end,1]))/dz);
    
    %save data for visualization and further analysis
    if ~mod(t,recordstep)
	for i = 1:length(xrec)
		Precord(i, counterrec) = P(xrec(i), zrec(i));
	end
	freeFieldRecord(counterrec) = P(freeFieldx, freeFieldz);
	counterrec = counterrec+1;
    end
    
    counter = counter+1;
    
    %visualize during calculation
    if vis && ~mod(counter, visualizeSteps)
        fig = real(P);
        %fig(left:right,bottom:top) = zeros;
        fig(left:right,bottom:top) = -Inf;
	for i = 1:length(xrec)
		fig(xrec(i), zrec(i)) = Inf;
	end
	fig(freeFieldx, freeFieldz) = Inf;
        figure(h)
        imagesc(xvec,zvec,fig.')
        axis xy
        axis tight
        title(['t = ',num2str(t*dt),' of ',num2str(ndt*dt)])
        pause(0.0001)
    end
    
    %visualize progress
    if~mod(round(t/ndt*100),1)
        if ~(round(t/ndt*100) == round((t-1)/ndt*100))
            fprintf('%.f \n',round(t/ndt*100))
        end
    end
    
end


t = (0 : counterrec-2) * dt;
%plot(t, freeFieldRecord);
f = linspace(0,1/dt,length(freeFieldRecord));
%plot(f, abs(fft(freeFieldRecord)));

clear P dists_sq fig f t tvec vx vxx vz vzz xdists xvec zdists zvec

save -V7 /tmp/all
save -V7 /tmp/freeFieldRecord freeFieldRecord
save -V7 /tmp/Precord Precord

save -V7 all
save -V7 freeFieldRecord freeFieldRecord
save -V7 Precord Precord
