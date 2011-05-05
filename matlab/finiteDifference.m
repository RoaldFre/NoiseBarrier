nr = 500; %number of rows
nc = 500; %number of columns

lr = 0.1; %length in the "rows direction" -> height (in meter)
lc = 0.1; %length in the "columns direction" -> width (in meter)
c = 340; %speed of sound, m/s
dt = 0.0000001; %timestep length (in seconds)

dr = lr / nr;
dc = lc / nc;

sourcer = round(nr *3/4);
sourcec = round(nc *1/4);

%excitation = sin(linspace(0,4*pi,10000));

%"free" delta
excitation = [1];

%delta, forced zero afterwards
%excitation = [1, zeros(1,10000000)];

%hanning
%excitation = hanning(20);


excitation_length = length(excitation);

c2 = c^2;

dt2 = dt^2;
dr2 = dr^2;
dc2 = dc^2;

p_grid = zeros(nr, nc);
p_grid_old = p_grid;

[shift10 shift_10 shift01 shift0_1]=circleshift_fast(p_grid);

imagesc(p_grid);

iteration = 0;
while 1
	iteration = iteration + 1;

	p_laplacian = (p_grid(shift_10{:}) + p_grid(shift10{:})) / dr2...
			+ (p_grid(shift0_1{:}) + p_grid(shift01{:})) / dc2...
			- 2 * (dr2 + dc2) / (dr2 * dc2) * p_grid;
				%last line: combined the -2*p_grid / dx^2 terms
	
	p_grid_old = p_grid;
	p_grid = c2 * p_laplacian * dt2   +   2 * p_grid   -   p_grid_old;

	%excitation
	if iteration <= excitation_length
		%point source:
		p_grid(sourcer, sourcec) = excitation(iteration);
		%big point source:
		p_grid(sourcer, sourcec+1) = excitation(iteration);
		p_grid(sourcer, sourcec-1) = excitation(iteration);

		p_grid(sourcer+1, sourcec) = excitation(iteration);
		p_grid(sourcer+1, sourcec+1) = excitation(iteration);
		p_grid(sourcer+1, sourcec-1) = excitation(iteration);

		p_grid(sourcer-1, sourcec+1) = excitation(iteration);
		p_grid(sourcer-1, sourcec-1) = excitation(iteration);
		p_grid(sourcer-1, sourcec) = excitation(iteration);
		%plane wave:
		%p_grid(1:end, sourcec) = excitation(iteration);
    end

	%barrier
	p_grid(round(nr/2):end, round(nc/3)-1) = -p_grid(round(nr/2):end, round(nc/3));
	p_grid(round(nr/2):end, round(nc/3)+1) = -p_grid(round(nr/2):end, round(nc/3));
	p_grid(round(nr/2):end, round(nc/3)) = 0;
	%floor
	p_grid(end, 1:end) = -p_grid(end-1, 1:end);


	if ~mod(iteration,30)
		imagesc(p_grid);
		%drawnow();
		pause(0.001);
    end

%	if iteration * dt * c >= lc/2
%		%we should have reached the other side already now!
%		return
%	endif
end
