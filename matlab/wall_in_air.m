%this script performs a finite difference calculation on SCK-CEN interest
%samples

clear all
close all
clc

%% material parameters
rho=1.3;
c=340;
%% grid parameters
fac=10;
D=0.6;  %in m
L=1.0;  %in m !!!x-y coordinate system

dx=1e-4*fac;
dz=dx;

ndx=round(L/dx);
ndz=round(D/dz);

%dt=1/real(c)/sqrt(1/dx^2+1/dz^2);
dt=1/real(c)/sqrt(1/dx^2+1/dz^2)  *  0.5;

xvec=linspace(0,L,ndx);
zvec=linspace(0,D,ndz);

simt=2e-3;%total simulation time in s
ndt=round(simt/dt);
tvec=linspace(0,simt,ndt);


%% excitation parameters
Texc=simt/100;
fexc=1/Texc;
next=round(Texc/dt);
ext=hanning(next);
%ext = [ext; zeros(1000,1)];
nexpx=21;
nexpz=21;

sigma = 4;
xdists = ones(nexpz,1) * linspace(-sigma, sigma, nexpx);
zdists = linspace(-sigma, sigma, nexpz)' * ones(1,nexpx);
dists_sq = xdists.^2 + zdists.^2;
exxz = exp(-dists_sq/2);

%exx=hanning(nexpx);
%exz=hanning(nexpz);
%exxz=(exx*ones(1,nexpz)).*(ones(nexpx,1)*exz.');

expointx=round(ndx/4);
expointz=round(ndz/4);

%%%hh=figure;
%%%texc=linspace(0,nT*Texc,next);
%%%plot(texc,sin(2*pi*fexc*texc).*ext.')
%% defect parameters
% %defect boundaries
lengthD=0.06;
heigthD=0.21;
Dleft=L/2-lengthD/2;
Dright=L/2+lengthD/2;
Dtop=D-heigthD;
Dbottom=D;

Dlength=abs(Dright-Dleft);
Ddepth=abs(Dbottom-Dtop);

left=round(Dleft/L*ndx);
right=round(Dright/L*ndx);
top=ndz-round(Dtop/D*ndz);
bottom=ndz-round(Dbottom/D*ndz)+1;

%no defect
% left=[];
% right=[];
% top=[];
% bottom=[];

%% record points
xrec=Dright+20*dx;
zrec=D-Dtop+20*dz;
xrec=round(xrec/L*ndx);
zrec=round(zrec/D*ndz);

%% initiate matrices
vxold=zeros(ndx,ndz);
vzold=zeros(ndx,ndz);
vx=zeros(ndx,ndz);
vz=zeros(ndx,ndz);
Pold=zeros(ndx,ndz);
P=zeros(ndx,ndz);
uxold=zeros(ndx,ndz);
ux=zeros(ndx,ndz);

recn=10; %number of frames
M1=zeros(ndx,ndz,recn);
M2=zeros(ndx,ndz,recn);

recordstep=1;
Precord=zeros(1,ndt/recordstep);
vxrecord=zeros(1,ndt/recordstep);

%% running loop
vis=1;
counter=1;
counterM=1;
counterrec=1;
if vis
    h=figure;
    %maximize(gcf)
end
for t=1:ndt
    if t<=next
        %P(expointx:expointx+nexpx-1,expointz:expointz+nexpz-1)=exxz*sin(2*pi*fexc*t*dt)*ext(t);
        P(expointx:expointx+nexpx-1,expointz:expointz+nexpz-1) = exxz * ext(t);
        %%%figure(hh);
        hold on
        %%%plot(t*dt,sin(2*pi*fexc*t*dt)*ext(t),'*k');
    end   

    %calculate differences
    %pressure to position, for velocities
    Px=1/(dx)*(P([2:end,1],:)-P);
    Pz=1/(dz)*(P(:,[end,1:end-1])-P);
    %calculate new velocities
    vx=-dt/rho*Px+vxold;
    vz=-dt/rho*Pz+vzold;
    
    Pold=P;
    
    %boundary conditions-> material boundaries
    %top
    vz(:,1)=zeros;
    %bottom
    vz(:,end)=zeros;
    %left
    vx(1,:)=zeros;
    %right
    vx(end,:)=zeros;
    %vx(end,:)=zeros;
    
    %boundary conditions-> defect boundaries
    %displacement zero at defect's boundaries
    %left
    vx(left,bottom:top)=zeros;
    %right
    vx(right,bottom:top)=zeros;
    %bottom
    vz(left:right,bottom)=zeros;
    %top
    vz(left:right,top)=zeros;
    
    %calculate velocity position differences
    vxx=1/(dx)*(vx-vx([end,1:end-1],:));
    vzz=1/(dz)*(vz-vz(:,[2:end,1]));
    %calculate new pressure
    P=-c^2*rho*dt*(vxx+vzz)+Pold;
    
    %calculate displacements
    ux=vx*dt+uxold;
    
    vxold=vx;
    vzold=vz;
       
    uxold=ux;
    
    %save data for visualization and further analysis
    if ~mod(t,recordstep)
        Precord(:,counterrec)=P(xrec,zrec);
        vxrecord(:,counterrec)=vx(xrec,zrec);
        counterrec=counterrec+1;
    end
    
    %save imagesc
    if ~mod(counter-1,round(ndt/recn))
        M1(:,:,counterM)=vx;
        M2(:,:,counterM)=vz;
        counterM=counterM+1;
    end
    
    counter=counter+1;
    
    %visualize during calculation
    if vis && ~mod(counter, 50)
        fig=real(P);
        %fig(left:right,bottom:top)=zeros;
        fig(left:right,bottom:top)=-Inf;
        figure(h)
        imagesc(xvec,zvec,fig.')
        axis xy
        axis tight
        title(['t = ',num2str(t*dt),' of ',num2str(ndt*dt)])
        pause(0.0001)
    end
    
    %visualize progress
    if~mod(round(t/ndt*100),10)
        if ~(round(t/ndt*100)==round((t-1)/ndt*100))
            fprintf('%.f \n',round(t/ndt*100))
        end
    end
    
end


%% visualize
visM=M2;
h=figure;
%maximize(h)
cmax=max(max(max(visM(2:end-1,2:end-1,:))));
cmin=min(min(min(visM(2:end-1,2:end-1,:))));
for ii=1:size(visM,3);
    fig=squeeze(visM(2:end-1,2:end-1,ii));
    imagesc(xvec,zvec,fig.');
    axis xy
    axis equal
    axis tight
    caxis([cmin,cmax])
    hold on
    plot(xrec/ndx*L,zrec/ndz*D,'*k')
    pause(0.1)
    hold off
end

%% visualize surface
figure
vis=Precord;
stepm=100;
plot(tvec,vis)
xlabel('time (s)')
ylabel('amplitude (a.u.)')




