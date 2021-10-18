function dst = mahalnobisDistance(F1, F2, val)
n=F1 - F2;
n = n.^2;
val = val';
n = n./val;
j = sum(n);
dst = (j)^(1/2);

return;