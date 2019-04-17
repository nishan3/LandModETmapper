function [kr] = Skin_evapAllen(pptyear,etoyear,soil_t_hot,doy)
 %% computes kr for hot pixel based on FAO based skin evaporation (allen et
 % al. 1998, Allen et al., 2011)
 
 
% INPUTS
% pptyear = column vector of ppt in inches
% etoyear = column vector of eto in mm/day
% soil_t_hot, soil text code
% doy of the given year

% pptyear =Ref_ET_daily.RAIN(Ref_ET_daily.YEAR==year);
% pptyear(pptyear <0)= 0; %0
% etoyear= Ref_ET_daily.ET0(Ref_ET_daily.YEAR==year);
% etoyear(etoyear<0)=nanmean(etoyear >0); % replace by mean value
% 
% % soil_t_hot = soil_text(hotrow,hotcol);
% soil_t_hot = 2;

yr1 = length(pptyear);
y_fao = zeros(yr1,6);
y_fao(:,1) = pptyear;
y_fao(:,2) = etoyear;



soil_t_hot = max(0,soil_t_hot); % no water will be selected. 0 -water

% Typical soil water characteristics for different soil types (after Allen et al., 1998)
rew = 8; tew = 25; % 

if soil_t_hot == 1
    rew = 2; tew = 12;
elseif soil_t_hot == 2
    rew = 4; tew = 14;
    
elseif soil_t_hot == 3
    rew = 6; tew = 20;
    
elseif soil_t_hot == 4
    rew = 8; tew = 22;
    
elseif soil_t_hot == 5
    rew = 8; tew = 25;
    
    elseif soil_t_hot == 6
    rew = 8; tew = 26;
elseif soil_t_hot == 7
    rew = 8; tew = 27;

elseif soil_t_hot == 8
    rew = 8; tew = 28;

elseif soil_t_hot == 9
    rew = 8; tew = 29;

end



tew_rew = tew-rew;
% cumulative depth of evaporation for day i, De,i (mm)
% dei = tew_rew; % start from Jan 1st..assume it's tew-rew
y_fao(1,4) = 1; % kr,..start with 1
y_fao(1,5) = y_fao(1,4)*y_fao(1,2); % et % use 1.2 when ETo is used

y_fao(1,3) = tew_rew;
y_fao(1,6) = y_fao(1,3) - y_fao(1,4)+ y_fao(1,5);
y_fao(1,6) = min(tew,y_fao(1,6)); % limit max value to tew
y_fao(1,6) = max(0,y_fao(1,6)); % limit min value to 0

%
% % now dei for i=2 day
% y_fao(2,3) = max(y_fao(1,6) - y_fao(2,1)*25.4,0);
% y_fao(2,3) = min(tew,y_fao(2,3));
% %y_fao(2,3) = max(0,y_fao(2,3));
%
% % kr for i day;
% y_fao(2,4) = (tew - y_fao(2,3))/tew_rew;
% y_fao(2,4) = min(1,y_fao(2,4));
% y_fao(2,4) = max(0,y_fao(2,4));
% y_fao(2,5) = y_fao(2,4)*y_fao(2,2);
% y_fao(2,6) = y_fao(2,3) - y_fao(2,4)+ y_fao(2,5);
% y_fao(2,6) = min(tew,y_fao(2,6)); % limit max value to tew
% y_fao(2,6) = max(0,y_fao(2,6)); % limit min value to 0


for i = 1:yr1-1
    %cumulative depth of evaporation for day i start
    y_fao(i+1,3) = max(y_fao(i,6) - y_fao(i+1,1)*25.4,0); %
    y_fao(i+1,3) = min(tew,y_fao(i+1,3));
    % kr
    y_fao(i+1,4) = (tew - y_fao(i+1,3))/tew_rew; %kr
    y_fao(i+1,4) = min(1,y_fao(i+1,4));
    y_fao(i+1,4) = max(0,y_fao(i+1,4));
    y_fao(i+1,5) = y_fao(i+1,4)*y_fao(i+1,2); % ET
    %cumulative depth of evaporation for day i end
    y_fao(i+1,6) = y_fao(i+1,3) - y_fao(i+1,4)+ y_fao(i+1,5);
    y_fao(i+1,6) = min(tew,y_fao(i+1,6)); % limit max value to tew
    y_fao(i+1,6) = max(0,y_fao(i+1,6)); % limit min value to 0
end


% Now get kr for the hot pixel for image doy;
kr = y_fao(doy,4);
%kr = min(0.5,kr); % limit value of kr to 0.5. Higher value may result into inconsistant results

if doy > 5
    ppt_doy = y_fao(doy,1)* 25.4;
    ppt_doy1 = y_fao(doy-1,1)* 25.4;
    ppt_doy2 = y_fao(doy-2,1)* 25.4;
    ppt_doy3 = y_fao(doy-3,1)* 25.4;
    ppt_doy4 = y_fao(doy-4,1)* 25.4;
    
    ppt_4days = (y_fao(doy-4,1)+y_fao(doy-3,1)+y_fao(doy-2,1)+y_fao(doy-1,1)) * 25.4; % in mm
    
    % if there was no ppt in ast 4-5 days.
    if ppt_4days ==0
        kr =0;
    end
end

end

