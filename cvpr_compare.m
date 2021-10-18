function dst=cvpr_compare(F1, F2)
%Euclidean Distance

n=F1 - F2;
n = n.^2;
j = sum(n);
dst = (j)^(1/2);


return;
