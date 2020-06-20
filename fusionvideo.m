function [] = fusionvideo(framerate,threshold)
% Create a video writer object
writerObj = VideoWriter('Fusionvideo.avi');
% Set frame rate
writerObj.FrameRate = framerate;
% Open video writer object and write frames sequentially
open(writerObj)
format short
% Read the tif image sequence exported from imageJ
Files=dir('*.tif');
for k=1:length(Files)
   Filename=Files(k).name;
   image=imread(Filename);
% Convert images to binary with a particular threshold
    BW=im2bw(image,threshold);
    BW = ~BW;
    im = imshow(image);
    BBs = [];
% Create a bounding box containing the fusing drops
    measurements = regionprops(BW, 'BoundingBox', 'Area');
    for k = 1 : length(measurements)
        thisBB = measurements(k).BoundingBox;
        BBs = [BBs;thisBB];
    end
% Sort all the widths of these bounding boxes in descending order    
    BBwidths = BBs(:,3);
    [sortedwidths,sortingindices] = sort(BBwidths,'descend');
% Choose the largest bounding box width. Everything else is noise.
    fusionindex = sortingindices(1);
    D = BBs(fusionindex,3);
% Convert to microns
    D = D*86.6/1000;
% Draw the bounding box and report the width onto the image
    x = BBs(fusionindex,1); y = BBs(fusionindex,2); w = BBs(fusionindex,3); h = BBs(fusionindex,4); 
    X = [x x+w];
    Y = [y+h y+h];
    line(X,Y,'Color',[0.0 1.0 0.0],'LineWidth',4) 
    text(120,225,[num2str(round(D,2)) '\mum'],'Color',[0.0 1.0 0.0],'FontSize',25,'Fontweight','bold')
% Export new tif series annotated with the bounding box and width value
    frame2 = [num2str(Filename) '-out.tif'];
    saveas(im,frame2)
% Write a new video with the annotated tif series
    input = imread(frame2);
    writeVideo(writerObj, input);
end
close(writerObj);
end