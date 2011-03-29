function [shift10 shift_10 shift01 shift0_1]=circleshift_fast(ux)

sizeA    = size(ux);
numDimsA = ndims(ux);

p10=[1 0];
p_10=[-1 0];
p01=[0 1];
p0_1=[0 -1];
shift10 = cell(1, numDimsA);
shift_10 = cell(1, numDimsA);
shift01 = cell(1, numDimsA);
shift0_1 = cell(1, numDimsA);
for k = 1:numDimsA
    m      = sizeA(k);
    shift10{k} = mod((0:m-1)-p10(k), m)+1;
    shift_10{k} = mod((0:m-1)-p_10(k), m)+1;
    shift01{k} = mod((0:m-1)-p01(k), m)+1;
    shift0_1{k} = mod((0:m-1)-p0_1(k), m)+1;    
end