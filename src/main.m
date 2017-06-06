%% STARTING

% function main
 clear all, close all
 
%importing labels from txt
load vesselLabels.txt;
%vesselsLabels(100,2);

% ------------------- START Const ------------------- %

stepRoi = 50;

baseBkg = 13; % Initial Frame: 0 %
baseNum = 13;

% To use txt values use nVesselLabels = nFrames + 1 %
% nVesselLabels start in 1 and nFrames starts in 0  %
nTotalFrames = 1533; % Total: 1533
nInitialFrame = 12;  % Initial Boat: 12

thr = 10; % 30
thr_global = 180;
thr_diff = 18;

minArea = 100;  % 100
maxArea = 1000; % 1000
alfa = 0.10;    % 0.10

nFrameBkg = 1000;   

mainFigure = figure(1);

numKeyFrames = 0;

se = strel('disk',3);

% -------------------- END Const -------------------- %

% --------------------------------------------------- %

% -------------------- ROI -------------------------- %
% Remove object intersection
% Faz as caixinhas

for k = nInitialFrame : stepRoi : nTotalFrames  
    imgfrNew = imread(sprintf('../Frames/frame%.4d.jpg', ...
                    baseNum + k));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    sprintf('ROI %d',k);
    hold off

    %imshow(imgfrNew); %% Caminho rectangulos amarelos - Background 
    hold on

    imgdif = (abs(double(imgfrNew(:,:,1)))>thr_global) | ...
        (abs(double(imgfrNew(:,:,2))-double(imgfrNew(:,:,1)))>thr_diff) | ...
        (abs(double(imgfrNew(:,:,3))-double(imgfrNew(:,:,1)))>thr_diff);


    bw = imclose(imgdif,se);
    str = sprintf('Frame: %d',k); title(str);

    % ----------------------------------------------------------- %
    imshow(bw);  %%Mete Background preto ao mesmo tempo
    % ----------------------------------------------------------- %

    %imshow(bw)
    [lb num]=bwlabel(bw);
    regionProps = regionprops(lb,'area','FilledImage','Centroid');

    %inds = find(minArea < [regionProps.Area] < maxArea);
    inds = [];
    for k = 1 : length(regionProps)
        if find([regionProps(k).Area] < maxArea & [regionProps(k).Area] > minArea)
            inds = [ inds k ];
        end
    end

    regnum = length(inds);

    if regnum
        for j=1:regnum
            [lin, col]= find(lb == inds(j));
            upLPoint = min([lin col]);
            dWindow  = max([lin col]) - upLPoint + 1;

            rectangle('Position',[fliplr(upLPoint) fliplr(dWindow)],'EdgeColor',[1 1 0],...
                'linewidth',2);
        end
    end

    drawnow

end