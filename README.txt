To run the program, open all .m files. 
Change the file paths to you own.
First go to 'cvpr_computedescriptors' and either comment or uncomment one of 'F = ComputeRGBHistogram(img,Q);' or 'F = ComputeMeanRGBgrid(img);'
let that .m run and complete.

Second go to 'cvpr_visualsearch.m' there is a for loop after the eigen model. This can be commented to run only one img (dont forget to comment the 'end' at the bottom of the file as well).
If let uncommented the for loop will calculate all query images to produce a MAP value in the workspace.

To test different distances 

'thedst=cvpr_compare(query,candidate);' can be uncommented for Euclidean distance

'candidateFeatPCA = ALLFEATPCA(i,:);
 thedst=mahalnobisDistance(queryFeatPCA,candidateFeatPCA, e.val);' can be uncommented for Mahalanobis distance. 
Remeber to keep one commented when using the other.