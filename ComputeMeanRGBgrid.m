function F = ComputeMeanRGBgrid(img)

[rows,columns,RGBbands]= size(img);
k = size(img)/10;
k = floor(k);
n = k(1,1);
L = k(1,2);

cellSizeOne = n;
cellSizeTwo = L; 
fullCells = floor(rows / cellSizeOne);
cellVecA = [cellSizeOne * ones(1, fullCells), rem(rows, cellSizeOne)];
cellVecB = [cellSizeTwo * ones(1, fullCells), rem(columns, cellSizeTwo)];
cells = mat2cell(img, cellVecA, cellVecB,RGBbands);

F = [];
for n = 1 : size(cells, 1)
    for i = 1 : size(cells, 2)
        red=img(:,:,1);
        red=reshape(red,1,[]);
        average_red=mean(red);
        F = [F, average_red];
        
        green=img(:,:,2);
        green=reshape(green,1,[]);
        average_green=mean(green);
        F = [F, average_green];
        
        blue=img(:,:,3);
        blue=reshape(blue,1,[]);
        average_blue=mean(blue);
        F = [F, average_blue];
    end
end

end