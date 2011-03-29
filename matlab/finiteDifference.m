nr = 150; %number of rows
nc = 300; %number of columns

lr = 0.1; %length in the "rows direction" -> height (in meter)
lc = 0.1; %length in the "columns direction" -> width (in meter)
c = 340; %speed of sound, m/s
dt = 0.0000005; %timestep length (in seconds)

dr = lr / nr;
dc = lc / nc;

sourcer = round(nr *3/4);
sourcec = round(nc *1/4);;

%excitation = sin(linspace(0,4*pi,1000));

%delta, forced zero afterwards
%excitation = [1, zeros(1,100000)];

%"free" delta
excitation = [1];

%hanning
excitation = hanning(20);


excitation_length = length(excitation);

c2 = c^2;

dt2 = dt^2;
dr2 = dr^2;
dc2 = dc^2;

p_grid = zeros(nr, nc);
p_grid_old = p_grid;

[shift10 shift_10 shift01 shift0_1]=circleshift_fast(p_grid);

iteration = 0;
while 1
	iteration = iteration + 1;

	p_laplacian = (p_grid(shift_10{:}) + p_grid(shift10{:})) / dr2...
			+ (p_grid(shift0_1{:}) + p_grid(shift01{:})) / dc2...
			- 2 * (dr2 + dc2) / (dr2 * dc2) * p_grid;
	
	p_grid_old = p_grid;
	p_grid = c2 * p_laplacian * dt2   +   2 * p_grid   -   p_grid_old;

	%excitation
	if iteration <= excitation_length
		%point source:
		p_grid(sourcer, sourcec) = excitation(iteration);
		%plane wave:
		%p_grid(1:end, sourcec) = excitation(iteration);
	endif

	%barrier
	p_grid(round(nr/2):end, round(nc/3)) = 0;
	%floor
	p_grid(end, 1:end) = 0;


	if ~mod(iteration,200)
		imagesc(p_grid);
		pause(0.001);
	endif
endwhile