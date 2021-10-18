%% EEE3032 - Computer Vision and Pattern Recognition (ee3.cvpr)
%%
%% cvpr_visualsearch.m
%% Skeleton code provided as part of the coursework assessment
%%
%% This code will load in all descriptors pre-computed (by the
%% function cvpr_computedescriptors) from the images in the MSRCv2 dataset.
%%
%% It will pick a descriptor at random and compare all other descriptors to
%% it - by calling cvpr_compare.  In doing so it will rank the images by
%% similarity to the randomly picked descriptor.  Note that initially the
%% function cvpr_compare returns a random number - you need to code it
%% so that it returns the Euclidean distance or some other distance metric
%% between the two descriptors it is passed.
%%
%% (c) John Collomosse 2010  (J.Collomosse@surrey.ac.uk)
%% Centre for Vision Speech and Signal Processing (CVSSP)
%% University of Surrey, United Kingdom

close all;
clear all;

%% Edit the following line to the folder you unzipped the MSRCv2 dataset to
DATASET_FOLDER = 'C:\Users\admin\Desktop\CVPR Coursework\MSRC_ObjCategImageDatabase_v2';

%% Folder that holds the results...
DESCRIPTOR_FOLDER = 'C:\Users\admin\Desktop\CVPR Coursework\descriptors';
%% and within that folder, another folder to hold the descriptors
%% we are interested in working with
DESCRIPTOR_SUBFOLDER='globalRGBhisto';


%% 1) Load all the descriptors into "ALLFEAT"
%% each row of ALLFEAT is a descriptor (is an image)

ALLFEAT=[];
ALLFILES=cell(1,0);
ctr=1;
allfiles=dir (fullfile([DATASET_FOLDER,'/Images/*.bmp']));
for filenum=1:length(allfiles)
    fname=allfiles(filenum).name;
    imgfname_full=([DATASET_FOLDER,'/Images/',fname]);
    img=double(imread(imgfname_full))./255;
    thesefeat=[];
    featfile=[DESCRIPTOR_FOLDER,'/',DESCRIPTOR_SUBFOLDER,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    load(featfile,'F');
    ALLFILES{ctr}=imgfname_full;
    ALLFEAT=[ALLFEAT ; F];
    ctr=ctr+1;
end
 
ALLFEATChange = ALLFEAT';
size(ALLFEATChange)
e = Eigen_Build(ALLFEATChange);
e.val
e = Eigen_Deflate(e,'keepn', 3);
ALLFEATPCA = Eigen_Project(ALLFEATChange, e)';
size(ALLFEATPCA)

figure 
plot3(ALLFEATPCA(:,1),ALLFEATPCA(:,2),ALLFEATPCA(:,3),'bx');
xlabel('eigenvector 1');
ylabel('eigenvector 2');
zlabel('eigenvector 3');
%% 2) Pick an image at random to be the query
NIMG=size(ALLFEAT,1);           % number of images in collection
% queryimg=floor(rand()*NIMG);    % index of a random image
queryimg = 348;
MAPV = [];
BESTimg = [];


%%Comment this for loop and queryimg = i; to use only one queryimg at a
%time
for i=1:591
    tic
    queryimg = i;

%% 3) Compute the distance of image to the query
queryFeatPCA = ALLFEATPCA(queryimg,:); 
dst=[];
for i=1:NIMG
    candidate=ALLFEAT(i,:);
    query=ALLFEAT(queryimg,:);
    %thedst=cvpr_compare(query,candidate);
    %%Uncomment below to use PCA space and Malahanobis distance 
    candidateFeatPCA = ALLFEATPCA(i,:);
    thedst=mahalnobisDistance(queryFeatPCA,candidateFeatPCA, e.val);
    dst=[dst ; [thedst i]];
end
dst=sortrows(dst,1);  % sort the results

SHOW=15; % Show top 15 results
showFif=dst(1:SHOW,:);
queryName=allfiles(queryimg).name;
outdisplay=[];
j = 0;

for i=1:size(showFif,1)
   img=imread(ALLFILES{showFif(i,2)});
   name=allfiles(showFif(i,2)).name;
   img=img(1:2:end,1:2:end,:); % make image a quarter size
   img=img(1:81,:,:); % crop image to uniform size vertically (some MSVC images are different heights)
   outdisplay=[outdisplay img];
end

Precision = [];
Pn = [];
Recall = [];
dst = dst(2:end,:);
for n=1:size(dst,1)
   name=allfiles(dst(n,2)).name;
   b = name(1:2);
   b = strrep(b, '_', '');
   q = queryName(1:2);
   q = strrep(q,'_','');
   if q == b
       j = j + 1;
   end
   
   P = j/n;
if q == '10'
    R = j/32;
else if q == '12'
        R = j/34;
    else if q == '15'
            R = j/24;
        else if q == '20'
                R =j/21;
            else
                R = j/30;
            end
        end
    end
end
Precision = [Precision, P];
if q==b
Pn = [Pn,P];  
end
Recall = [Recall, R];
end

sizePN = size(Pn);
RelDoc = sizePN(1,2);
AP = sum(Pn)/RelDoc;
MAPV = [MAPV,AP];
BESTimg =[BESTimg ; [AP queryimg]];
toc
end
BestAP = sortrows(BESTimg,1);
sizeMAPV = size(MAPV);
MAPmax = sizeMAPV(1,2);
MAP = sum(MAPV)/591;
imshow(outdisplay);
axis off;
figure 
plot(Recall,Precision);title('PR Curve');ylabel('Precision');xlabel('Recall');
