function [lstcold, lsthot, countiter, ustar,rah,rahhot, rahcold,dttemp,dtcold, dthot,efcold,efhot, L,...
    sensheat,lamdaet,inset, ef, dailyet, sens24, lam24,Lamda24] = SEBAL(Rn, G,zref,zb,Q24,...
    lst,TinstK,TmeandailyK,coldrow,coldcol,hotrow,hotcol,z0m,dem,z_st_veg, u_inst,lapse)
% written by- Nishan Bhattarai (University of Michigan)
% Contact: nbbhattar@umich.edu/nbhattar@syr.edu)
% clear all; close all; clc;
%% NOTE: In this model, Rn and G are provided as input.
%% INPUT DATA
% Rn =                  net radiation (Wm-2)
% G =                   soil heat flux (W m-2)
% zref =                reference height of wind measurment
% zb =                   blending height (m)
% Q24 =                 24 hr net radiation (W m-2)
% TinstK =              air temp (K) at image time
% TmeandailyK=          mean daily air temp (K)
% lst =                 lst in K
% coldrow =             row of cold pixel
% hotrow =              row of hot pixel
% hotcol =              column number of hot pixel
% kr =                  ERrF in hot pixel using FAO method
% z0m =                 surface roughness (m)
% dem =                 elevation (m)
% z_st_veg =            height of grass in the weather station(m)
% u_inst =              wind speed at ref height
% lapse =               lapse rate (0.0065 C per m);

% ETrinst =             Instantaneous ETr from ASCE-PM method(mm/hr)
% ETrdaily =            Daily ETr from ASCE-PM method (mm/day)



%% OUTPUT
%lstcold =              LST (K) at the cold pixel
% lsthot =              LST (K) at the hot pixel
% countiter =           total number of iteations used in rah stabilization
% ustar =               frictional velocity (m/s)
% rah =                 aerodynamic resistance
% rahhot =              rah at hot pixel
% rahcold =             rah at cold pixel
% L =                   monin-Okuluv length (m)
% dttemp =              near surface temp difference (Ts-Ta)
% dtcold =              dttemp at cold pixel
% dthot =               dttemp at hot pixel
% efcold =              EF at the cold pixel
% efhot=                EF at the hot pixel
% sensheat =            sensible heat flux (H) - W m-2
% lamdaet =             latent heat flux (LE) - W m-2
% inset =               instantaneous ET (mm/hr)
% ef =                  Evaporative fraction (LE/Rn-G)
% dailyet =             Daily ET (mm/day)
% sens24 =              24 hr net sensible heat flux (W m-2)
% lam24 =               24 hr net latent heat flux (W m-2)


z2= zref;
z1= 0.1;
lst_dem = lst + lapse*dem;

% wind speed at blending height
k = 0.41;
zomst = 0.12*z_st_veg; %momentum roughness length (m), h = height of the vegetation in the weather station
ux = k*u_inst/(log(zref/zomst));
u200 = ux * log(zb/zomst)/k; % wind speed at 200m during imagetime
Rhot = nanmean(nanmean(Rn(hotrow-1:hotrow+1,hotcol-1:hotcol+1)));

% Gcold = nanmean(nanmean(G(coldrow-1:coldrow+1,coldcol-1:coldcol+1)));
Ghot = nanmean(nanmean(G(hotrow-1:hotrow+1,hotcol-1:hotcol+1)));
h = z0m/0.13;% zero plane displacement height
d0= 2/3 * h;

% FIRST APPROXIMATION of friction velocity (ustar)
% ustar = real(0.41*u200./log((zb-d0)./z0m));_______

ustar = real(k*u200./log((zb)./z0m));

z0h= 0.1; % roughness length for heat transport...Using Spatial constant value

% FIRST APPROXIMATION OF AERODYNAMIC RESISTANCE TO HEAT TRANSPORT (Rah1)
rah = real(log(z2/z1)./(ustar*k));


% From neutral condition
rahcold =nanmean(nanmean(rah(coldrow-1:coldrow+1,coldcol-1:coldcol+1)));
rahhot =nanmean(nanmean(rah(hotrow-1:hotrow+1,hotcol-1:hotcol+1)));

% demcold = nanmean(nanmean(dem(coldrow-1:coldrow+1,coldcol-1:coldcol+1)));
demhot = nanmean(nanmean(dem(hotrow-1:hotrow+1,hotcol-1:hotcol+1)));

% LST values for cold and hot pixel
lstcold = min(min(lst_dem(coldrow-1:coldrow+1,coldcol-1:coldcol+1))); % get the minimum value
lsthot = nanmean(nanmean(lst_dem(hotrow-1:hotrow+1,hotcol-1:hotcol+1)));

% initial sensible heat for hot and cold pixels
% hcold = 0; % assume 0 for wettest pixels
h1hot = Rhot-Ghot;
%
% clear dem;
% pcold = (1 -demcold* 0.0000225577)^ 5.2599 * 101325 /(287.05 *  lstcold); % air density at cold pixel
phot = (1 -demhot* 0.0000225577)^ 5.2599 * 101325 /(287.05 *  lsthot); % air density at hot pixel


%%Iteration starts
%  [m,n] = size (lst);
countiter = 1; % to record the number of iterations. published papers indicate 2-8 interations is common
diff = 100; % arbitary. just to run the loop


while diff > 5 %% run it till difference in sensible heat(hot pixel) is < 5%, in METRIC Rah_hot was stabilized)
    % typically 3-8 iterations will stabilize rah at the hot pixel
    
    dtcold =0;% dtcold  = 0
    % start with h1hot = rnhot- Ghot
    dthot=rahhot* h1hot/(phot*1004); % sensible heat equation,..1004 is the water density
    dtplot= [lsthot dthot; lstcold dtcold];
    p = polyfit(dtplot(:,1), dtplot(:,2),1);
    ao = p(1); bo = p(2);
    %plot(dtplot(:,1), dtplot(:,2),'.k','MarkerFaceColor','g','MarkerSize',5);
    %            %axis([290 320 -0.2 1.4]);lsline; % show linear fit
    
    dttemp = ao*lst_dem + bo;
    dttemp(dttemp <0)=0.0000001; % just to avoid 0 and -inf later
    tair = lst_dem-dttemp; % air temp
    den = (287.05 * tair);
    num = (101325 * (1 - 0.0000225577 .*dem).^ 5.2599); % elve in m/ can use a DEM too
    pair = num./den; clear num; clear den;
    
    %sensible heatflux (H) % this is just an rough estimate which will
    %be corrected through iterations
    % This H is allows to estimates stability correction using Monin Obukhov’s similarity hypothesis
    sensheat = 1004* (pair.*dttemp)./rah;
    %     hot_sens = sensheat(hotrow,hotcol);
    
    num = -(1004*pair.*(ustar.^3)).*lst;
    den = (0.41*9.81*sensheat);
    L = num./den; clear num; clear den;
    
    
    % THE STABILITY CORRECTIONs FOR THE  MOMENTUM AND ATMOSPHERIC HEAT TRANSPORT
    psim_zb = Psim_SEBAL((zb)./L,L);
    psih_z = Psih_SEBAL((2)./L, L);
    psih_z0h = Psih_SEBAL(z0h./L,L);
    
    newu = real(u200*k./(log((zb)./z0m)-psim_zb)); %Bastiaanssen et al. (1998, 2005)
    rah_new = (log(2./z0h)- psih_z +psih_z0h)./(0.41* newu);
    
    % the following codes can be used to test model under different zref
%     if zref <=2
%         psim_zb = Psim_SEBAL((zb)./L,L);
%         psih_z = Psih_SEBAL((zref)./L, L);
%         psih_z0h = Psih_SEBAL(z0h./L,L);
%         
%         newu = real(u200*k./(log((zb)./z0m)-psim_zb)); %Bastiaanssen et al. (1998, 2005)
%         rah_new = (log(zref./z0h)- psih_z +psih_z0h)./(k* newu);
%         
%         
%     elseif zref >2
%         psim_zb = Psim_SEBAL((zb-d0)./L,L);
%         psih_z = Psih_SEBAL((zref-d0)./L, L);
%         psih_z0h = Psih_SEBAL(z0h./L,L);
%         
%         newu = real(u200*k./(log((zb-d0)./z0m)-psim_zb)); %Bastiaanssen et al. (1998, 2005)
%         rah_new = (log((zref-d0)./z0h)- psih_z +psih_z0h)./(k* newu);
%         
%     end
%     
    
    
    rah_newhot = nanmean(nanmean(rah_new(hotrow-1:hotrow+1,hotcol-1:hotcol+1)));
    diff = abs(100* (rah_newhot-rahhot)/rahhot); % stabilized in hot pixels..
    
    %     h1hot = hot_newsens;
    % set new rah and ustar
    rah= rah_new; ustar = newu;
    %     sensheat = newsensheat;
    
    %     h1hot = newsensheat(hotrow,hotcol);
    rahhot = rah_newhot;
    countiter = countiter+1;
    
    if countiter == 50 % stop after 15 iterations- in some cases
        diff = 4; % < 5 to close the loop
    end
    
end

% figure,imagesc(sensheat);colorbar;
sensheat(sensheat < 0) = 0;
lamdaet = Rn-G-sensheat;
Lamda = (2.501-(0.002361 * (TinstK-273.16))) * 1000000; %latent heat of vaporization
inset = 3600* lamdaet./ Lamda; % instant et in mm/hr

% EVAPORATIVE FRACTION
ef = (Rn-G-sensheat) ./(Rn-G);


ef(ef <0) = NaN;
ef(ef > 1) =1;


%% daily ET
Lamda24 = (2.501-(0.002361 * (TmeandailyK-273.16))) * 1000000; %latent heat of vaporization
dailyet = ef .* (86400*1000*Q24)./(Lamda24*1000); % for daily basis, sensible heat is considered 0

% 24 hr sensible hear flux
sens24 = Q24 .* (1- ef);

efcold = ef(coldrow,coldcol);
efhot =ef(hotrow,hotcol);

% 24 hr latent heat flux
lam24 = Q24 .*ef;

%ET
%  figure();
%  subplot(2,1,1)
%  imagesc(ef);caxis([0 1.4]);colorbar;
%  subplot (2,1,2)
%  imagesc(dailyet); caxis([0 10]);colorbar;



end






