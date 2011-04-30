function meetresultaten = loadAsciiFiles(name, number)
%return [first column of first file, second column of all files]


data = load([name, '0.dat']);
meetresultaten = zeros(length(data(:,1)),number);
meetresultaten(:,1) = data(:,1);

for i=0:number-1
	path = [name, int2str(i),'.dat'];
	data = load(path);
	meetresultaten(:,i+2) = data(:,2);
end

