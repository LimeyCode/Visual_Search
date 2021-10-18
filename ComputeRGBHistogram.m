 function F = ComputeRGBHistogram(img,Q)


qimg=double(img)./1.0039;

qimg=floor(qimg.*Q);
bin = qimg(:,:,1)*Q^2 + qimg(:,:,2)*Q^1 + qimg(:,:,3);

vals=reshape(bin,1,size(bin,1)*size(bin,2));

F = hist(vals,Q^3);

F = F ./sum(F);

return;