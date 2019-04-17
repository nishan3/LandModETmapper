function [FVC] = FVC_fromNDVI(landsattype,ndvi, Ag_filter, Igood,ndviupperlimit,ndvilowerlimit,ff_open)
%% This function comoutes FVC based on Carlson and Ripley;
% AGfilter is a binay map (1= ag, 0= non ag)
% Igood = cloud binary, 1=good no cloud
%ff_open = min size allowed in terms of pixels
% landsattype = 5;

% written by Nishan Bhattarai, nbhattar@syr.edu/nbhattar@umich.edu
% Date: Nov 5, 2015
%% filter edges of agricultural field by removing edges- Homogenity in NDVI pixels
if isnan(nanmean(nanmean(ndvi)))==1
    FVC = NaN(size(ndvi));
else
    
    if landsattype ==7
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
    
    % CV > 10% is consiered mixed pixel.
    [m,n] = size(ndvi);
    ndvi_filter = zeros(m,n);
    %  ndvi_filter (OutCVndvi <15 & lst < 305) = 1;
    %  ndvi_filter (Ag_filter==1 & lst > 305) = 1;
    ndvi_filter (OutCVndvi <15) = 1;
    ndvi_filter (Ag_filter==1) = 1;
    
    ndvi_filter (ndvi < 0.05) = 0; % a minimum value of 0.1 is allowed.
    
    %figure(); imagesc(ndvi_filter);colorbar;
    
    %% Now work with the cloud mask data
    % figure();imagesc(Igood);colorbar; % Igood =1= good, Igood=0 = cloud
    
    cloudarea = zeros(m,n);
    cloudarea(Igood==0)=1;
    cloudarea = imdilate(cloudarea,strel('square', 7));
    
    Igood1 = ones(m,n);
    Igood1(cloudarea==1)=0;
    
    % %[m,n] = size(Igood);
    % Mask = ones(7,7);
    % [a,b] = size (Mask);
    % % [x,y] = size(Igood);
    %
    % [m,n] = size(Igood);
    % Igood1 = ones(m,n);
    % % flagr 7x7 pixels around cloud as cloud
    % for i=1+(a-1)/2:(m-(a-1)/2);
    %     for j= 1+(b-1)/2:(n-(b-1)/2);
    %         if Igood(i,j) == 0;
    %             Igood1(i-(a-1)/2:i+(a-1)/2, j-(a-1)/2:j+(a-1)/2) = 0;
    %         else
    %             Igood1(i,j)=1;
    %         end
    %     end
    % end
    %
    % figure();imagesc(Igood);colorbar;
    % figure();imagesc(Igood1);colorbar;
    % figure();imagesc(ndvi);colorbar;
    
    %% FInd the intersection of all crieteria
    % multiply CLassified binary images with conditions and agricultural land
    All_fil = double(Ag_filter .* (ndvi_filter .*Igood1));
    
    % bw_1 = bwlabel(All_fil);
    % remove cells having pixels less than 20
    bw_1= bwareaopen(All_fil,ff_open,8);
    
    %% Now make histograms of NDVI and get top 1% and bottom 1% for FVC
    ndvi_new = ndvi .* bw_1;
    ndvi_new(ndvi_new ==0)= NaN;
    % ndvi_new(disMat > dis_allowed) = NaN;
    
    % adjust upper and lower NDVI limits according to the image
    ndviupperlimit = min(ndviupperlimit,max(max(ndvi_new))); %lstupperlimit is usually larger- Also ignores extreme values
    ndvilowerlimit = max(ndvilowerlimit,nanmin(nanmin(ndvi_new))); %lstlowerlimit is usually smaller - Also ignores extreme low values
    
    ndvi_new(ndvi_new >ndviupperlimit)= NaN; % limit the ndvi value to ndviupperlimit.
    
    % imagesc(ndvi_new);caxis([0 1]); colorbar; title('NDVI values for filtered Ag pixels');
    
    
    [m,n] = size(ndvi);
    matrixA_n = reshape(ndvi_new,m*n,1);
    
    % list unique, non NaN ndvi values in ascending order
    % ndvi_list = un_sort_ndvi(1:ccn_ndvi,1);
    % ndviupperlimit = 0.85;ndvilowerlimit = 0.05;
    ndvi_bins = ndvilowerlimit:0.01:ndviupperlimit;
    
    % NDVI bins and counts
    % [counts_n,centers_n] = hist(un_sort_ndvi,ndvi_bins);
    [counts_n,centers_n] = hist(matrixA_n,ndvi_bins);
    cent_counts_n = horzcat(centers_n',counts_n');
    
    [ind1,~] = find(cent_counts_n(:,2) > 50); % select bins that have atleast 50 pixels
    cent_counts_n1 = cent_counts_n(ind1,:);
    
    if isempty(ind1) ==1
        [ind1,~] = find(cent_counts_n(:,2) > 25); % select bins that have atleast 25 pixels
        cent_counts_n1 = cent_counts_n(ind1,:);
        
    end
    
    if isempty(ind1) ==1
        [ind1,~] = find(cent_counts_n(:,2) > 10); % select bins that have atleast 10 pixels
        cent_counts_n1 = cent_counts_n(ind1,:);
        
    end
    
    if isempty(ind1) ==1
        [ind1,~] = find(cent_counts_n(:,2) > 5); % select bins that have atleast 5 pixels
        cent_counts_n1 = cent_counts_n(ind1,:);
        
    end
    
    
    
    %
    % figure();
    % hist(matrixA_n,ndvi_bins);
    % title ('NDVI from candidate pixels','FontName','Times','fontsize', 20);
    % xlabel('NDVI','FontName','Times','fontsize', 20);
    %
    
    % Get maxNDVI- top1%
    ind1_couN = length(cent_counts_n1); % total count
    ind1_topN = ceil(1/100 * ind1_couN); % 1% count
    
    if ind1_topN ==1
        maxndvi_list = cent_counts_n1 (end, 1); % max ndvi
    else
        maxndvi_list = cent_counts_n1 (end-ind1_topN:end, 1); % max ndvi
    end
    % Get minNDVI- bottom1%
    minndvi_list = cent_counts_n1 (1:ind1_topN, 1); % min ndvi
    
    max_ndvi = mean(maxndvi_list); % full cover
    min_ndvi = mean(minndvi_list); % soil
    
    %FVC
    FVC = ((ndvi-min_ndvi) ./(max_ndvi-min_ndvi)).^2;
    
    FVC(FVC>1)=1;
    FVC(FVC<0)=0;
    %FVC(Iwater==1)=0; % 0 for water
    
    %figure(); imagesc(FVC);colorbar;
    %figure(); imagesc(ndvi);colorbar;
end

end

