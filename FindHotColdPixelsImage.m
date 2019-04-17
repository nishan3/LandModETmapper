function [lsthotx,lsthoty,lstcoldx,lstcoldy,lstcold,lsthot,cent_counts_l1,cent_counts_n1,coldrow,coldcol,hotrow,hotcol,...
    per_conLcold, per_conNcold,per_conLhot, per_conNhot,count_lstcold_len,count_lsthot_len,...
    min_lstmean,max_ndvimean, max_lstmean,min_ndvimean] = FindHotColdPixelsImage(bw_1,subCx,subCy,pixelsize,...
    lst,ndvi,lstupperlimit,lstlowerlimit,ndviupperlimit,ndvilowerlimit,pixellimit_bins,pixellimit_counts,lstwindow, ndviwindow,lststep, ndvistep)

%% This is a part of the code published in https://www.sciencedirect.com/science/article/pii/S0034425717302018
%% This function automatically finds hot and cold pixel for use in SEBAL/METRIC procedure in an optimized way.
%% This code is the 3rd version (see https://www.sciencedirect.com/science/article/pii/S0034425717302018; section 2.3.2) no nearest station needs to be defined).
% written by- Nishan Bhattarai (University of Michigan)
% Contact: nbbhattar@umich.edu/nbhattar@syr.edu)

%% ### Citation ##################################################################################
% Bhattarai, Nishan, Lindi J. Quackenbush, Jungho Im, and Stephen B. Shaw.
% "A new optimized algorithm for automating endmember pixel selection in the SEBAL and METRIC models."
% Remote Sensing of Environment 196 (2017): 178-192.
% https://www.sciencedirect.com/science/article/pii/S0034425717302018
%% ####################################################################

%% INPUT
% bw_1                      = selected pixels for ag lands using morphogical operations and some
                                % preprocessing (1= candidate pixel, 0 = not a candidate pixel).
% disMat                    = distance from ET station - Not used in this version
% pixellimit_bins           = min number of pixels for histogram
% pixellimit_counts         = min number of pixels for hot and cold pixel selection
                                % maxPer and minPer are percentiles of histogram selected for hot and cold
                            % pixel selection
% subCx and subCy are upper UTMx and UTMy of the input landsat image
% lstwindow and ndviwindow are the values for windows when searching a
% particular lst and ndvi values respectively.
% dis_allowed               = 30000; % distance from station in m - Not used in this version
%lststep                    = bin value of lst used to create LST histograms (default is 0.5 K)
%ndvistep                   = bin value of NDVI used to create LST histograms (default is 0.01)

%% OUTPUT
% per_considered, 1st row = cold pixel, 2nd row = hot pixel
% col1 = % LST, col2 = NDVI%,  col3 = number of pixels, col4 = lst, col5 =
% NDVI
% lsthotx, lsthoty, are UTMX & UTMY for hot pixel,respectively.
% lstcoldx, lstcoldy, are UTMX & UTMY for cold pixel,respectively.
% cent_counts_l1= LST values and number of pixels,
% cent_counts_n1= NDVI values and number of pixels,
% coldrow,coldcol are row and col for cold pixels, respectively
% hotrow,hotcol are row and col for hot pixels, respectively
% hot_min_dis and cold_min_dis are distances from ET station



%% Use default values if the variables are not defined
if nargin < 6
    error('One of six required input is missing');
end

%SetDefaultValue(position, argName, defaultValue)

if nargin < 7 || isempty(lstupperlimit) % lstupper limit
    lstupperlimit = 330;
end

if nargin < 8 || isempty(lstlowerlimit) %lstlowerlimit
    lstlowerlimit = 275;
end
if nargin < 9 || isempty(ndvilowerlimit) %
    ndvilowerlimit = 0.05;
end

if nargin < 10 || isempty(ndvilowerlimit)
    ndvilowerlimit = 0.05;
end
if nargin < 11 || isempty(pixellimit_bins)
    pixellimit_bins = 50;
end
if nargin < 12 || isempty(pixellimit_counts)
    pixellimit_counts = 10;
end

if nargin < 13 || isempty(lstwindow)
    lstwindow = 0.25;
end
if nargin < 14 || isempty(ndviwindow)
    ndviwindow = 0.01;
end

if nargin < 15 || isempty(lststep)
    lststep = 0.5;
end


if nargin < 16 || isempty(ndvistep)
    ndvistep = 0.01;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Processing Starts
% Ignore the boundry pixels
lst(1,:) = NaN;
lst(:,1)= NaN;

lst(end,:)= NaN;
lst(:,end) = NaN;



%% LST BINS
[m,n] = size(lst);
lst_new = bw_1 .*lst;


lst_new(lst_new ==0) = NaN;
matrixA = reshape(lst_new,m*n,1);

% adjust upper and lower LST limits according to the image
lstupperlimit = min(lstupperlimit,max(max(matrixA))); %lstupperlimit is usually larger- Also ignores extreme values
lstlowerlimit = max(lstlowerlimit,nanmin(nanmin(matrixA))); %lstlowerlimit is usually smaller - Also ignores extreme low values

% figure();imagesc(lst_new); colorbar;title('filtered LST values for Ag pixels');
% figure();imagesc(lst); colorbar;title('LST values for Ag pixels');

%LST values in ascending order
sort_lst = sort(matrixA);
% get unique values
un_sort_lst = unique(sort_lst); % for figure
lst_bins = lstlowerlimit:lststep:lstupperlimit;

%lst bins and counts
[counts,centers] = hist(matrixA,lst_bins);
cent_counts_l = horzcat(centers',counts');

% Remove smallareas. % number of pixels limits
% pixellimit_bins = 50;
[ind1,~] = find(cent_counts_l(:,2) > pixellimit_bins);
cent_counts_l1 = cent_counts_l(ind1,:);

%% NDVI Bins
%NDVI for selected ag pixels
ndvi_new = ndvi .* bw_1;
ndvi_new(ndvi_new ==0)= NaN;

% adjust upper and lower NDVI limits according to the image
ndviupperlimit = min(ndviupperlimit,max(max(ndvi_new))); %lstupperlimit is usually larger- Also ignores extreme values
ndvilowerlimit = max(ndvilowerlimit,nanmin(nanmin(ndvi_new))); %lstlowerlimit is usually smaller - Also ignores extreme low values

ndvi_new(ndvi_new >ndviupperlimit)= NaN; % limit the ndvi value to ndviupperlimit.

% imagesc(ndvi_new);caxis([0 1]); colorbar; title('NDVI values for filtered Ag pixels');


[m,n] = size(ndvi);
matrixA_n = reshape(ndvi_new,m*n,1);

%ndvi values in ascending order
sort_ndvi = sort(matrixA_n);
% get unique values
un_sort_ndvi = unique(sort_ndvi); % for figure
% ccn_ndvi = length(find(isnan(un_sort_ndvi) ==0));


% list unique, non NaN ndvi values in ascending order
% ndvi_list = un_sort_ndvi(1:ccn_ndvi,1);
% ndviupperlimit = 0.85;ndvilowerlimit = 0.05;
ndvi_bins = ndvilowerlimit:ndvistep:ndviupperlimit;

% NDVI bins and counts
% [counts_n,centers_n] = hist(un_sort_ndvi,ndvi_bins);
[counts_n,centers_n] = hist(matrixA_n,ndvi_bins);
cent_counts_n = horzcat(centers_n',counts_n');

[ind1,~] = find(cent_counts_n(:,2) > pixellimit_bins);
cent_counts_n1 = cent_counts_n(ind1,:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PLOT
% set(0,'DefaultAxesFontSize',20)
%
% % % aa = get(gca,'XTickLabel');
% % % set(gca,'XTickLabel',aa,'FontName','Times','fontsize',20)
% % % bb = get(gca,'YTickLabel');
% % % set(gca,'YTickLabel',bb,'FontName','Times','fontsize',20)
%
% figure();
% mainplot(1,2,1)
% set(gca, 'XTick', ndvi_bins, 'FontName','Times','fontsize', 20);
% hist(matrixA_n,ndvi_bins);
% title ('NDVI from candidate pixels','FontName','Times','fontsize', 20);
% xlabel('NDVI','FontName','Times','fontsize', 20);
%
% % bar(centers_n,100*counts_n./sum(counts_n),.25,'hist'); % <- percentage cum dist
% %      ylabel('normalized histogram');
%
%
% % set(gca, 'YTick', 0:0.1:1.1, 'fontsize', 20);
%
% subplot (1,2,2)
% set(gca, 'XTick', lst_bins,'FontName','Times', 'fontsize', 20);
% hist(matrixA,lst_bins);
% xlabel('\it{T}\rm_s (K)','FontName','Times','fontsize', 20);
% title ('\it{T}\rm_s from candidate pixels','FontName','Times','fontsize', 20);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % of pixels considered to finding max and min LST values, 1= top 1% and
% bottom 1% values.
% LmaxPer = 20;
% NmaxPer = 10;
% per_conLs = 1:1:LmaxPer;
% per_conNs = 1:1:NmaxPer;
% combs = allcomb(per_conLs,per_conNs);
% combs_len = length(combs);

%combs = allcomb(per_conLs,per_conNs);
%combs(:,[1,2]) = combs(:,[2,1]); % swap col1 (for lst) and col2(for ndvi)


% tic
% pixellimit_counts= 10;
%% FOR COLD PIXEL
% disp('Starting cold pixel selction process.....');
count_lstcold_len = 0;
ii_min=1;
conMore = 0; % indicates condition when additional % of NDVI or LST or both are need to be added. start with 0
%pixelbin_limit_forcold = pixellimit_bins;
% follwing combination lengths will be modified in the loop
%conMore1 =0;
%conMore2 =0;
coldpixel_countlimit = pixellimit_counts;
sel_per = 10:5:25; % Per in Bins
runcold = 1;

NmaxPer = sel_per(1,runcold); %start with 10%
LmaxPer = sel_per(1,runcold); %start with 10%
per_conLs = 1:1:LmaxPer;
per_conNs = 1:1:NmaxPer;
combs = allcomb(per_conLs,per_conNs);
combs_len = length(combs);

inc1 =5; % increment
while count_lstcold_len < coldpixel_countlimit
    
    % The loop below is for condition when no good  cold pixels were found
    if ii_min > combs_len && runcold <= 4% the max NDVI can vary by a lot., starting with ii_min <1, i.e. less than combs_len
        conMore = 1;
        %msgbox('Increase the max % for LST bins (LmaxPer) to cover more LST values');
        %error('myApp:argChk', 'Increase the max percentage value for LST bins (LmaxPer) to cover more LST values')
        % pixellimit_counts = 5;
        NmaxPer1 = sel_per(1,runcold); % by 5%
        LmaxPer1 = sel_per(1,runcold);% by 5%
        %         disp(['Cold pixels (10) not found within top ',int2str(10), '% NDVI and bottom ', int2str(NmaxPer), '% LST; Hence, increasing search area to ', int2str(NmaxPer1),'% with 1% increment......']);
        %modify combs
        per_conLs1 = 1:1:LmaxPer1;% [5, 10, 15, 20]; % take top 5% 10% 15% 20% to save some time
        per_conNs1 = 1:1:NmaxPer1;
        %         combs = allcomb(per_conLs1,per_conNs1);
        combs = allcomb(per_conLs1,per_conNs1);
        %         combs(:,[1,2]) = combs(:,[2,1]);
        combs_len = length(combs);
        %combs_len1 = combs_len;
        ii_min = 1; % start again with the new set of max NDVI %ages
        %         disp(LmaxPer1)
    end
    
    if ii_min >= combs_len && conMore>=1 && runcold >=5
        
        %Increase LST to 15% (bottom) and NDVI to top 20% (top 20%)
        %pixels are found
        conMore =2;
        %count_lstcold_len = 0;
        ii_min=1; % reset
        NmaxPer2 = NmaxPer1+inc1;
        LmaxPer2 = LmaxPer1+inc1;
        %modify combs
        per_conLs2 = sel_per(end-1)+inc1:1:LmaxPer2;%sel_per(end-1)+inc1= 25 and then keeps increasing
        per_conNs2 = sel_per(end-1)+inc1:1:NmaxPer2; %upto 20% NDVI % 25:1:NmaxPers
        %         disp(['No sutiable cold pixels: increasing search area to', int2str(NmaxPer2),'% with 1% increment......']);
        combs = allcomb(per_conLs2,per_conNs2);
        combs_len = length(combs);
        %combs_len2 = length(combs);
        inc1 = inc1 + 5; % keep adding 5%
    end
    
    if ii_min == combs_len && conMore==2
        %         msgbox(['No good Cold pixels (10) found within bottom ', int2str(LmaxPer2), 'LST of histogram, decrease pixellimits, check input images and cloud cover']);
        break
        
    end
    
    per_conLcold = combs(ii_min,1);
    per_conNcold = combs(ii_min,2);
    
    % Now get the top per_con% max and bottom per_con (i.e. min) LST values
    ind1_couL = length(cent_counts_l1);
    ind1_topL = ceil((per_conLcold * ind1_couL)/100);
    
    ind1_couN = length(cent_counts_n1);
    ind1_topN = ceil(per_conNcold/100 * ind1_couN);
    
    
    % Top per_ndvi% max ndvi value
    minlst_list = cent_counts_l1(1:ind1_topL, 1); % min n% LST
    
    if ind1_topN ==1
        maxndvi_list = cent_counts_n1 (end, 1); % max ndvi
    else
        %         ind1_topN_adj = max(size(cent_counts_n1,1)-ind1_topN_adj,1); % avoid 0 indexing
        %         maxndvi_list = cent_counts_n1 (end-ind1_topN_adj:end, 1); % max ndvi
        
        maxndvi_list = cent_counts_n1 (end-ind1_topN:end, 1); % max ndvi
    end
    
    % get the mean value
    min_lstmean = mean(minlst_list); % get max value out of the minimum list
    max_ndvimean = mean(maxndvi_list);
    
    [uu_c,~] = size(maxndvi_list);
    [pp_c, ~] = size(minlst_list);
    
    %         if conMore == 1;
    %             std_minlst = std(minlst_list);
    %             min_lstmean = max(minlst_list);%-std_minlst; % get max value out of the minimum list
    %         end
    
    if conMore==1 %&& isempty(minlst_list)==0
        ind_lstmin = find (bw_1 == 1 & lst < minlst_list(pp_c)+lstwindow & lst >  minlst_list(1)-lstwindow.....
            & ndvi < maxndvi_list (uu_c)+ ndviwindow & ndvi >  maxndvi_list (1)-ndviwindow);
        count_lstcold_len = length(ind_lstmin);
        
    else
        ind_lstmin = find (bw_1 == 1 & lst < min_lstmean+ lstwindow & lst >  min_lstmean-lstwindow.....
            & ndvi < max_ndvimean+ ndviwindow & ndvi >  max_ndvimean-ndviwindow);
        count_lstcold_len = length(ind_lstmin);
        
    end
    
    %         if length (ind_lstmin)==1
    ii_min = ii_min+1;
    %         end
    %     end
    
    if count_lstcold_len >=  coldpixel_countlimit
        %         disp(['Cold pixels found within bottom ', int2str(per_conLcold), '% LST and top ', int2str(per_conNcold),...
        %             '% NDVI with LST ~', num2str(min_lstmean),'K and NDVI ~', num2str(max_ndvimean,3)])
    end
    
    if count_lstcold_len >=  coldpixel_countlimit && per_conLcold > 25
        %         disp('LST from Cold pixels are not within botton 25%, consider modifications to pixel limits, check input images......');
    end
    
    if count_lstcold_len >=  coldpixel_countlimit && per_conNcold > 25
        %         disp('NDVI from Cold pixels are not within top 25%, consider modifications to pixel limits, check input images......');
    end
    
    if ii_min == length(combs) % whole combination of %s values tried
        runcold = runcold+1; % add 1
    end
    
end
% disp('.....Selection of cold pixels selction done.');
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% disp('starting hot pixel selction process.....');
%% For hot PIXEL
%Back to original combination- start with 10% (Top) LST 10% NDVI (bottom)
conMore = 0; % indicates condition when additional % of NDVI or LST or both are need to be added. start with 0
%pixelbin_limit_forcold = pixellimit_bins;
%conMore1 =0;
%conMore2 =0;
hotpixel_countlimit = pixellimit_counts;
sel_per = 10:5:25;  %Per in Bins
runhot = 1;

NmaxPer = sel_per(1,runhot); %start with 10%
LmaxPer = sel_per(1,runhot); %start with 10%
per_conLs = 1:1:LmaxPer;
per_conNs = 1:1:NmaxPer;
combs = allcomb(per_conLs,per_conNs);
combs_len = length(combs);


count_lsthot_len = 0;
ii_max=1;
inc1 =5; % increment
% tic
while count_lsthot_len < hotpixel_countlimit
    %      for ii =1:combs_len-1
    %ii=ii+1;
    if ii_max > combs_len && runhot <= 4% the max NDVI can vary by a lot., starting with ii_min <1, i.e. less than combs_len
        conMore = 1;
        %msgbox('Increase the max % for LST bins (LmaxPer) to cover more LST values');
        %error('myApp:argChk', 'Increase the max percentage value for LST bins (LmaxPer) to cover more LST values')
        % pixellimit_counts = 5;
        NmaxPer1 = sel_per(1,runhot); % by 5%
        LmaxPer1 = sel_per(1,runhot);% by 5%
        %         disp(['Hot pixels (10) not found within bottom ',int2str(10), '% NDVI and Top ', int2str(NmaxPer), '% LST; Hence, increasing search area to ', int2str(NmaxPer1),'% with 1% increment......']);
        %modify combs
        per_conLs1 = 1:1:LmaxPer1;% [5, 10, 15, 20]; % take top 5% 10% 15% 20% to save some time
        per_conNs1 = 1:1:NmaxPer1;
        %         combs = allcomb(per_conLs1,per_conNs1);
        combs = allcomb(per_conLs1,per_conNs1);
        %         combs(:,[1,2]) = combs(:,[2,1]);
        combs_len = length(combs);
        %combs_len1 = combs_len;
        ii_max = 1; % start again with the new set of max NDVI %ages
        %         disp(LmaxPer1)
    end
    
    if ii_max >= combs_len && conMore >=1 && runhot >=5
        %Increase LST to 15% (bottom) and NDVI to top 20% (top 20%)
        %pixels are found
        conMore =2;
        ii_max=1;
        NmaxPer2 = NmaxPer1+inc1;
        LmaxPer2 = LmaxPer1+inc1;
        %modify combs
        per_conLs2 = sel_per(end-1)+inc1:1:LmaxPer2;%sel_per(end-1)+inc1= 25 and then keeps increasing
        per_conNs2 = sel_per(end-1)+inc1:1:NmaxPer2; %upto 20% NDVI % 25:1:NmaxPers
        %         disp(['No sutiable Hot pixels: increasing search area to', int2str(NmaxPer2),'% with 1% increment......']);
        combs = allcomb(per_conLs2,per_conNs2);
        %combs_len2 = length(combs);
        combs_len = length(combs);
        
        inc1 = inc1 + 5; % keep adding by 5%
        
    end
    
    %     if ii_max == combs_len && conMore==2
    % %        msgbox(['No good Hot pixels (10) found within top ', int2str(LmaxPer2), 'LST of histogram, decrease pixellimits, check input images and cloud cover']);
    % %         break
    %
    %     end
    %
    
    per_conLhot = combs(ii_max,1);
    per_conNhot = combs(ii_max,2);
    
    % Now get the top per_con% max and bottom per_con (i.e. min) LST values
    ind1_couL = length(cent_counts_l1);
    ind1_topL = ceil((per_conLhot * ind1_couL)/100);
    
    ind1_couN = length(cent_counts_n1);
    ind1_topN = ceil(per_conNhot/100 * ind1_couN);
    
    % Top per_ndvi% max ndvi value
    maxlst_list = cent_counts_l1 (end-ind1_topL:end, 1); % min n% LST
    minndvi_list = cent_counts_n1 (1:ind1_topN, 1); % min ndvi
    
    
    % get the mean values.
    %min_ndvimean = mean(minndvi_list);
    min_ndvimean = mean(minndvi_list);
    max_lstmean = mean(maxlst_list);
    [uu,~] = size(minndvi_list);
    [pp, ~] = size(maxlst_list);
    
    
    if conMore == 1  %&& isempty(maxlst_list)==0
        ind_lstmax = find (bw_1 == 1 & lst < maxlst_list (pp)+lstwindow & lst >  maxlst_list(1)-lstwindow.....
            & ndvi < minndvi_list(uu)+ndviwindow & ndvi >  minndvi_list(1)-ndviwindow);
        count_lsthot_len = length(ind_lstmax);
        
    else
        ind_lstmax = find (bw_1 == 1 & lst < max_lstmean+lstwindow & lst >  max_lstmean-lstwindow.....
            & ndvi < min_ndvimean+ndviwindow & ndvi >  min_ndvimean-ndviwindow);
        count_lsthot_len = length(ind_lstmax);
    end
    
    
    % move next
    ii_max = ii_max+1;
    
    
    if count_lsthot_len >=  hotpixel_countlimit
        %         disp(['Hot pixels found within Top ', int2str(per_conLhot), '% LST and bottom ', int2str(per_conNhot),...
        %             '% NDVI with LST ~', num2str(max_lstmean),' K and NDVI ~', num2str(min_ndvimean,3)])
    end
    
    if count_lsthot_len >=  hotpixel_countlimit && per_conLhot> 25
        %         disp('LST from Hot pixels are not within top 25%, consider modifications to pixel limits, check input images......');
    end
    
    if count_lsthot_len >=  hotpixel_countlimit && per_conNhot > 25
        %         disp('NDVI from Hot pixels are not within bottom 25%, consider modifications to pixel limits, check input images......');
    end
    
    if ii_max == length(combs) % whole combination of %s value stried
        runhot = runhot+1; % add 1
    end
    
    %     if runhot > 500 % take
    %         hotpixel_countlimit =hotpixel_countlimit-1;
    %         hotpixel_countlimit = max(hotpixel_countlimit,1); % take atleast 1
    %     end
    %     ii_max
end

% disp('.....Selection of hot pixels selction done.');




% toc;
% percentages of pixel values for NDVI and LST considered
%per_considered  = [per_conLcold, per_conNcold,per_conLhot, per_conNhot,count_lstcold_len,count_lsthot_len

%% Select pixels which satisfies crieteria for max LST and min NDVI;
hotcoldpixels = zeros(m,n);
hotcoldpixels(ind_lstmin) = 1; % 1 = cold pixel
hotcoldpixels(ind_lstmax) = 2; % 2 = hot pixel

% figure(); imagesc(hotcoldpixels); colorbar;
%
% lsthottest= lst; lsthottest(find(hotcoldpixels ~=1))=NaN;
% lstcoldtest = lst;lstcoldtest(find(hotcoldpixels ~=2))=NaN;
%
% meanhotlst = nanmean(nanmean(lsthottest));
% meancoldlst = nanmean(nanmean(lstcoldtest));
%
% figure(); imagesc(lsthottest); colorbar; title (num2str (meanhotlst));
% figure(); imagesc(lstcoldtest); colorbar; title (num2str (meancoldlst));


%% Write Files
% %bounding box = ([left bottom; right top]) from ArcGIS
%  info_sub.BoundingBox= [379515.741468408 2973615.67295261;502845.741468408 3045765.67295261];
%
% filename = (['lsthottest_',int2str(landsattype),'_',int2str(yeardoy),'.tif']);
% geotiffwrite(filename, lsthottest,Rsub,  ...
%        'GeoKeyDirectoryTag', info_sub.GeoTIFFTags.GeoKeyDirectoryTag);
%
% filename = (['lstcoldtest_',int2str(landsattype),'_',int2str(yeardoy),'.tif']);
% geotiffwrite(filename, lstcoldtest,Rsub,  ...
%        'GeoKeyDirectoryTag', info_sub.GeoTIFFTags.GeoKeyDirectoryTag);
%
% filename = (['lst_Selected_AG_',int2str(landsattype),'_',int2str(yeardoy),'.tif']);
% geotiffwrite(filename, lst_new,Rsub,  ...
%        'GeoKeyDirectoryTag', info_sub.GeoTIFFTags.GeoKeyDirectoryTag);


% testing
% Agfil_lst= Ag_filter .* lst;
% Agfil_lst (find(Agfil_lst==0)) = NaN;
% figure(),imagesc(Agfil_lst);colorbar;
%
% filename = (['Ag_filter',int2str(landsattype),'_',int2str(yeardoy),'.tif']);
% geotiffwrite(filename, Ag_filter,Rsub,  ...
%        'GeoKeyDirectoryTag', info_sub.GeoTIFFTags.GeoKeyDirectoryTag);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Use minimum distance from the weather station to get a single location of hot and cold pixel

%find the final hot and cold pixel location in col and row
% Get/ verify LST values for hot and cold pixel
% in_cold = find(hotcoldpixels ==1 & disMat <dis_allowed); % within 30km
% in_hot = find(hotcoldpixels ==2 & disMat <dis_allowed); % within 30km

in_cold = find(hotcoldpixels ==1);
in_hot = find(hotcoldpixels ==2);


% ignore the corner pixel (i.e. of the hot and cold pixels are located in
% the boarder, ignore them).
[in_cold_row,in_cold_col] = ind2sub([m,n],in_cold);
in_cold (in_cold_row==m|in_cold_col==n) = NaN;

in_cold = in_cold(~isnan(in_cold));


[in_hot_row,in_hot_col] = ind2sub([m,n],in_hot);
in_hot (in_hot_row==m|in_hot_col==n) = NaN;

in_hot = in_hot(~isnan(in_hot));



%% SELCTION OF ONE COLD PIXEL
data = lst(in_cold);
data_sorted = sort(data);
[~, rank_lst] = ismember(data,data_sorted);

% inverse ranking of NDVI
data = 1- ndvi(in_cold);
data_sorted = sort(data);
[~, rank_ndvi] = ismember(data,data_sorted);

ranksum = rank_lst+rank_ndvi;

ind_rank = find(ranksum==min(ranksum));

% if there's more than one pixel, select one random
if length(ind_rank) > 1
    ind = ceil(rand * size(ind_rank,1));
    ind_rank =ind_rank(ind);
end

coldind = in_cold(ind_rank);
[coldrow, coldcol] = ind2sub([m,n],coldind);


%% SELCTION OF ONE COLD PIXEL
data = lst(in_hot);
data_sorted = sort(data);
[~, rank_lst] = ismember(data,data_sorted);

% inverse ranking of NDVI
data = 1- ndvi(in_hot);
data_sorted = sort(data);
[~, rank_ndvi] = ismember(data,data_sorted);

ranksum = rank_lst+rank_ndvi;

ind_rank = find(ranksum==max(ranksum)); % take the maximum rank- min NDVI and max LST

% if there's more than one pixel, select one random
if length(ind_rank) > 1
    ind = ceil(rand * size(ind_rank,1));
    ind_rank =ind_rank(ind);
end

hotind = in_hot(ind_rank);
[hotrow, hotcol] = ind2sub([m,n],hotind);


% ignore the boundary pixels(5x5 pixels);



lsthot = lst(hotrow,hotcol);
lstcold = lst(coldrow,coldcol);

%% Now store information of hot and cold pixels
lsthotx= subCx + (hotcol-1) * pixelsize;
lsthoty= subCy - (hotrow-1) * pixelsize;

% in case more than one pixel is selected take one
lstcoldx=subCx + coldcol * pixelsize +1;
lstcoldy=subCy - coldrow * pixelsize +1;

% display the message box
%msgbox('Hot and cold pixels are automatically selected');

if lstcold > lsthot
    %msgbox('Increase the max % for LST bins (LmaxPer) to cover more LST values');
    error('myApp:argChk', 'cold pixel LST is greater than Hot pixel LST- Check your input image for clouds')
    
end

if isempty (lstcoldx) ==1||isempty (lstcoldy) ==1
    %msgbox('Increase the max % for LST bins (LmaxPer) to cover more LST values');
    error('myApp:argChk', 'No Cold pixel within distance allowed; Check distance allowed')
    
end

if isempty (lsthotx) ==1||isempty (lsthoty) ==1
    %msgbox('Increase the max % for LST bins (LmaxPer) to cover more LST values');
    error('myApp:argChk', 'No Hot pixel within distance allowed; Check distance allowed')
    
end

%% Special Condition:when diff between hot and cold pixel temp. are very small
% if lsthot-lstcold < 10
%     disp('Difference between LSTs from hot and cold pixels are less than
%     10 C');
% end


end

