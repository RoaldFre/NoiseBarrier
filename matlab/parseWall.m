freeField = load('../data/scalemodel/vrije-veld/480hoog-150ver-notzoomed-nor-clipped0.dat');
savefile(freeField, 'scalemodel-freeField');


dir = '../data/scalemodel/achter-muur-30hoog-100ver-30stap-1200vonk/';
name = '30hoog-100ver-30stap-1200vonk';
n = 96;

measured = loadAsciiFiles([dir, name], n);
savefile(measured, 'achter-muur');

dir = '../data/scalemodel/voor-muur/';
name = '30hoog-40ver-40stap-2000vonk';
n = 96;
measured = loadAsciiFiles([dir, name], n);
savefile(measured, 'voor-muur');
