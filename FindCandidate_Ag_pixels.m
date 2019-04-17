function [bw_1] = FindCandidate_Ag_pixels(lst, ndvi, albedo, Ag_filter, Igood,landsattype,lstupperlimit,lstlowerlimit,ff_open)

%% This is a part of the code published in https://www.sciencedirect.com/science/article/pii/S0034425717302018
% written by- Nishan Bhattarai (University of Michigan)
% Contact: nbbhattar@umich.edu/nbhattar@syr.edu)
% This code find candidate pixels within an image that are further filtered
% to identify hot and cold pixels in SEBAL/METRIC Model.
%% ### Citation ##################################################################################
% Bhattarai, Nishan, Lindi J. Quackenbush, Jungho Im, and Stephen B. Shaw.
% "A new optimized algorithm for automating endmember pixel selection in the SEBAL and METRIC models."
% Remote Sensing of Environment 196 (2017): 178-192.
% https://www.sciencedirect.com/science/article/pii/S0034425717302018
%% ####################################################################
%% OUTPUT
%bw_1:                  good area for finding potential hot and cold pixels

%% INPUT
% landsattype:          0;5 or 7, 0 = MODIS
% lst:                  lst in K
% ndvi:                 ndvi (unitless)
% albedo:               albedo (unitless)
% Ag_filter:            Binary map (1= ag, 0= no ag)
% lstupperlimit:        upper max  value of lst K), default is 330K
% lstlowerlimit:        min value of lst (K), default is 275 K
% Igood=                cloud filter, 1=good, 0 = cloud
% ff_open :             number of pixels for removing small areas; if the pixel
% size is large, this value is smaller, default is 50 (Landsat), 10 for
% MODIS
%% Check number of inputs and use defaults if necessary
if nargin > 9
    error('myfuns:somefun2:TooManyInputs', ...
        'requires at most 9 (5 optional) inputs');
end

% define defualts values
defaults = {0,330, 275, 50};
switch nargin
    case 5
        [landsattype, lstupperlimit, lstlowerlimit, ff_open] = defaults{:};
    case 6
        [lstupperlimit, lstlowerlimit, ff_open] = defaults{2:end};
    case 7
        [lstlowerlimit,ff_open] = defaults{3:end};
    case 8
        ff_open = defaults{end};
end

% area to open- choose small area for MODIS
if landsattype ==0
    ff_open = 10;
    
end

[m,n] = size(lst);
% figure(); imagesc(Ag_filter);colorbar;
%figure(); imagesc(lst);caxis([270 330]);colorbar;
%% Homogenity in thermal pixels
if landsattype ==7||landsattype ==8||landsattype ==0
    NHOOD = ones(3,3);
    %      h=fspecial('average', [3 3]);
else
    NHOOD = ones(7,7);
    %     h=fspecial('average', [7 7]);
end
OutSDlst= stdfilt(lst, NHOOD);
%figure(),imagesc(OutSDlst);colorbar;

% OutMnlst= imfilter(lst, h);
%
%
% OutCVlst = 100* OutSDlst./OutMnlst;
% figure(); imagesc(OutCVlst);caxis ([0 100]);colorbar; title ('CV-LST');

% SD > 1K is filtered
lst_filter = zeros(m,n);

%  lst_filter (OutSDlst <1) = 1;
lst_filter (Ag_filter==1)= 1;
lst_filter (OutSDlst >1.5) = 0;


%figure(); imagesc(lst_filter);colorbar;

% lST thresholds
% lst_con = ones(m,n);
lst_filter(lst > lstupperlimit)= 0;
lst_filter(lst < lstlowerlimit)= 0; %probably cloud pixels



%% filter edges of agricultural field by removing edges- Homogenity in NDVI pixels
if landsattype ==7||landsattype ==8||landsattype ==0
    NHOOD = ones(3,3);
    h=fspecial('average', [3 3]);
else
    NHOOD = ones(7,7);
    h=fspecial('average', [7 7]);
end
OutSDndvi= stdfilt(ndvi, NHOOD);
% figure(),imagesc(OutSDndvi);colorbar; title ('SD-NDVI');

OutMnndvi= imfilter(ndvi, h);
% figure(),imagesc(OutMnndvi);colorbar; title ('Mean-NDVI');

OutCVndvi = 100* OutSDndvi./OutMnndvi;
% figure(); imagesc(OutCVndvi);caxis ([0 100]);colorbar; title ('CV-NDVI');
%
%
%  figure(); imagesc(ndvi);caxis ([0 1]);colorbar;
%

% CV > 10% is consiered mixed pixel.
ndvi_filter = zeros(m,n);
ndvi_filter (Ag_filter==1) = 1;
ndvi_filter (OutCVndvi >25) = 0;


ndvi_filter (ndvi < 0.05) = 0; % a minimum value of 0.1 is allowed.
%figure(); imagesc(ndvi_filter);colorbar;

%% ALbedo threshold and homogenity
alb_th1 = albedo;
alb_th1 (albedo > 0.40)=0;
alb_th1 (albedo < 0.05)=0;
%figure(); imagesc(alb_th1);colorbar;


if landsattype ==7||landsattype ==8||landsattype ==0
    NHOOD = ones(3,3);
    h=fspecial('average', [3 3]);
else
    NHOOD = ones(7,7);
    h=fspecial('average', [7 7]);
end
OutSDalb= stdfilt(alb_th1, NHOOD);
% figure(),imagesc(OutSDalb);colorbar; title ('SD-NDVI');

OutMnalb= imfilter(alb_th1, h);
% figure(),imagesc(OutMnalb);colorbar; title ('Mean-NDVI');

OutCValb = 100* OutSDalb./OutMnalb;
% figure(); imagesc(OutCValb);caxis ([0 100]);colorbar; title ('CV-NDVI');


% CV > 10% is consiered mixed pixel.
alb_filter = zeros(m,n);
% alb_filter (OutCValb <15) = 1;
alb_filter (Ag_filter==1) = 1;
alb_filter (OutCValb >25) = 0;
%figure(); imagesc(alb_filter);colorbar;

%% Now work with the cloud mask data
% figure();imagesc(Igood);colorbar; % Igood =1= good, Igood=0 = cloud

%[m,n] = size(Igood);
% Mask = ones(7,7);
% [a,b] = size (Mask);
% [x,y] = size(Igood);
%
% [m,n] = size(Igood);
% Igood1 = ones(m,n);

clouds = zeros(m,n);
clouds (Igood==0) = 1;


% 7 by 7 neighborhood pixel around cloud = cloud
[m,n] = size(clouds);

cloudarea = zeros(m,n);
cloudarea(Igood==0)=1;

% if landsattype==7
%     cloudarea = imdilate(cloudarea,strel('square', 3));
% else
cloudarea = imdilate(cloudarea,strel('square', 5));
% end

Igood1= zeros(m,n);
Igood1(cloudarea ~=1) =1;
clear ('clouds','cloudarea');


% figure();imagesc(Igood);colorbar;
% figure();imagesc(Igood1);colorbar;

%% FInd the intersection of all crieteria
% multiply CLassified binary images with conditions and agricultural land
mul1 = lst_filter .*alb_filter;
mul2 = double(Ag_filter .* (ndvi_filter .*Igood1));

All_fil =mul1 .* mul2;

% remove small areas
bw_1= bwareaopen(All_fil,ff_open,8);
bw_1(isnan(lst)==1)=0;


%figure();imagesc(bw_1); colorbar; title('bw_1');
%% Find a group of cold pixels
% bw_1(find(lst > lstupperlimit))=NaN;
% bw_1(find(lst > lstlowerlimit))=NaN;
%
% lst_new = lst .* bw_1;
% lst_new(find(lst_new==0)) = NaN;
% figure();imagesc(lst_new); colorbar; title ('lst of selected Ag pixels');

% filename = (['lst_selected_',int2str(landsattype),'_',int2str(yeardoy),'.tif']);
% geotiffwrite(filename,  lst_new,Rsub,'GeoKeyDirectoryTag', info_sub.GeoTIFFTags.GeoKeyDirectoryTag);



end

