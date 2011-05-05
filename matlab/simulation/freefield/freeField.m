%function freeField(dx)

%this script performs a finite difference calculation on SCK-CEN interest
%samples

close all
more off
clc


%% material parameters
rho = 1.3;
c = 340;
%% grid parameters
D = 0.4;  %y in m
L = 0.4;  %x in m !!!x-y coordinate system

dz = dx;

%simt = 1e-2;%total simulation time in s
simt = 1.15e-3;%total simulation time in s

%excitation
Texc = 25e-6;
nexpx = 71;
nexpz = 71;
exSize = 0.003; %this is 2*sigma of the gaussian

extx = 0.15;
extz = 0.2;


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




%% record points
xrec = [0.25, 0.24, 0.26];
zrec = 0.2 * ones(size(xrec));

xrec = round(xrec/L*ndx);
zrec = round(zrec/D*ndz);


%% initiate matrices
vx = zeros(ndx,ndz);
vz = zeros(ndx,ndz);
P = zeros(ndx,ndz);

recordstep = 1;
Precord = zeros(length(xrec), floor(ndt/recordstep));






vis = 1
visualizeSteps = 30;
counter = 1;
counterM = 1;
counterrec = 1;
%% visualize setting (recordpoints, source, freefield)
if vis
	fig = real(P);
	for i = 1:length(xrec)
		fig(xrec(i), zrec(i)) = 1;
	end
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
    
    P = P - c^2*rho*dt*((vx - vx([end,1:end-1],:))/dx ...
                     +  (vz - vz(:,[2:end,1]))/dz);
    
    %save data for visualization and further analysis
    if ~mod(t,recordstep)
	for i = 1:length(xrec)
		Precord(i, counterrec) = P(xrec(i), zrec(i));
	end
	counterrec = counterrec+1;
    end
    
    counter = counter+1;
    
    %visualize during calculation
    if vis && ~mod(counter, visualizeSteps)
        fig = real(P);
	for i = 1:length(xrec)
		fig(xrec(i), zrec(i)) = Inf;
	end
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


clear P dists_sq fig f t tvec vx vxx vz vzz xdists xvec zdists zvec

filename = ['freeField_Texc',num2str(Texc),'_nexp',num2str(nexpx),'_exSize',num2str(exSize),'_dx',num2str(dx)]
save([filename,'_all'], '-V7');
save([filename,'_Precord'], 'Precord', '-V7');
