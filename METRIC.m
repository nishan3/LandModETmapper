function [lstcold, lsthot, countiter, ustar,rah,rahhot, rahcold,dttemp,dtcold, dthot,etrfcold,etrfhot, L,...
    sensheat,lamdaet,inset, etrf,dailyet, sens24, lam24] = METRIC(Rn, G,...
    lst,coldrow,coldcol,hotrow,hotcol,kr, z0m, zref,dem,z_st_veg,u_inst,zb,TinstK,etr_inst,etr_d, Q24,Kadj,lapse)
% written by- Nishan Bhattarai (University of Michigan)
% Contact: nbbhattar@umich.edu/nbhattar@syr.edu)
% clear all; close all; clc;
%% NOTE: In this model, Rn and G are provided as input.
%% INPUT DATA
% Rn =                  net radiation (Wm-2)
% G =                   soil heat flux (W m-2)
% lst =                 lst in K
% coldrow =             row of cold pixel
% hotrow =              row of hot pixel
% hotcol =              column number of hot pixel
% kr =                  ERrF in hot pixel using FAO method
% z0m =                 surface roughness (m)
% zref =                reference height of wind measurment
% dem =                 elevation (m)
% u_inst =              wind speed at ref height
% z_st_veg =            height of grass in the weather station(m)
% zb =                   blending height (m)
% TinstK =              air temp (K) at image time
% TmeandailyK=          mean daily air temp (K)
% ETrinst =             Instantaneous ETr from ASCE-PM method(mm/hr)
% ETrdaily =            Daily ETr from ASCE-PM method (mm/day)
% Q24 =                 24 hr net radiation (W m-2)
% Kadj =                adjustment factor used for cold pixel ET (1.05)
% lapse =               lapse rate (0.0065 C per m);


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
% efcold =              reference ET fraction at the cold pixel
% efhot=                reference ET fraction at the hot pixel
% sensheat =            sensible heat flux (H) - W m-2
% lamdaet =             latent heat flux (LE) - W m-2
% inset =               instantaneous ET (mm/hr)
% etrf =                reference ET fraction
% dailyet =             Daily ET (mm/day)
% sens24 =              24 hr net sensible heat flux (W m-2)
% lam24 =               24 hr net latent heat flux (W m-2)

z2= 2;
z1 = 0.1;

lst_dem = lst + lapse*dem;

% wind speed at blending height
k = 0.41;
zomst = 0.12*z_st_veg; %momentum roughness length (m), h = height of the vegetation in the weather station
ux = k*u_inst/(log(zref/zomst));
u200 = ux * log(zb/zomst)/k; % wind speed at 200m during imagetime


% LST at the hot and cold pixel -using 3x3 mean
lstcold = nanmin(nanmin(lst_dem(coldrow-1:coldrow+1,coldcol-1:coldcol+1))); %%% get the minimum value
lsthot = nanmean(nanmean(lst_dem(hotrow-1:hotrow+1,hotcol-1:hotcol+1)));


%%Fluxes at hot and cold pixels
%%%% using 3x3 mean
Rcold = nanmean(nanmean(Rn(coldrow-1:coldrow+1,coldcol-1:coldcol+1)));
Rhotpixels = Rn(hotrow-1:hotrow+1,hotcol-1:hotcol+1);
% Rhot = nanmean(nanmean(Rhotpixels(Rhotpixels >0)));
Rhot = nanmean(nanmean(Rhotpixels));

Gcold = nanmean(nanmean(G(coldrow-1:coldrow+1,coldcol-1:coldcol+1)));
Ghotpixels = G(hotrow-1:hotrow+1,hotcol-1:hotcol+1);
% Ghot = nanmean(nanmean(Ghotpixels(Ghotpixels >0)));
Ghot = nanmean(nanmean(Ghotpixels));


% Ref et for the cold pixel- if ref ET is provided as an image get
% the value for the cold pixel
if length(etr_inst) >1
    ret_cold = mean(mean(etr_inst(coldrow-1:coldrow+1,coldcol-1:coldcol+1)));
    ret_hot = mean(mean(etr_inst(hotrow-1:hotrow+1,hotcol-1:hotcol+1)));
    %     lecold = 1.05*ret_cold*681.6;
    lecold = Kadj*ret_cold*681.6;
    lehot = kr*ret_hot*681.6;
else
    %     lecold = 1.05*etr_inst*681.6;% 681.6 is a factor to change it to W/m2 1.2 if ET0 is used from grass
    % adj K
    lecold = Kadj*etr_inst*681.6;
    
    lehot = kr*etr_inst*681.6;
end


h1cold = Rcold-lecold-Gcold;
% if h1cold < 0
%     h1cold = 0;
% end
h1hot = Rhot-lehot-Ghot;

% friction velocity and rah
ustar = k*u200./log((zb)./z0m);
rah = real(log(z2/z1)./(ustar*k));

rahcold =mean(mean(rah(coldrow-1:coldrow+1,coldcol-1:coldcol+1)));
rahhot =mean(mean(rah(hotrow-1:hotrow+1,hotcol-1:hotcol+1)));

demcold = mean(mean(dem(coldrow-1:coldrow+1,coldcol-1:coldcol+1)));
demhot = mean(mean(dem(hotrow-1:hotrow+1,hotcol-1:hotcol+1)));


% clear dem;
pcold = (1 -demcold* 0.0000225577)^ 5.2599 * 101325 /(287.05 *  lstcold); % air density at cold pixel
phot = (1 -demhot* 0.0000225577)^ 5.2599 * 101325 /(287.05 *  lsthot); % air density at hot pixel


% estimated canopy height
hc = real(z0m/0.13);
d0 = 2/3 * hc;

%%Iteration starts
zb=200; % blending height
%[m,n] = size (lst);
countiter = 1; % to record the number of iterations. published papers indicate 2-8 interations is common
diff = 100; % arbitary. just to run the loop
%  dtcold =0;
%  dthot =0;


while diff > 5 %% run it till difference in rah(hot pixel) is < 5%...can do same with DT(hot)
    %      typically 3-8 iterations will stabilize rah at the hot pixel
    dtcold =rahcold * h1cold/(pcold*1004); % sensible heat equation,..1004 is the water density
    dthot=rahhot* h1hot/(phot*1004);
    
    dtplot= [lsthot dthot; lstcold dtcold];
    p = polyfit(dtplot(:,1), dtplot(:,2),1);
    a1 = p(1); b1 = p(2);
    dttemp = double(a1*lst_dem +b1);
    tair = lst_dem-dttemp;
    den = (287.05 * tair);
    num = (101325 * (1 - 0.0000225577 .*dem).^ 5.2599); % elve in m/ can use a DEM too
    pair = num./den; clear num; clear den;
    
    %sensible heatflux
    sensheat = 1004* (pair.*dttemp)./rah;
    %              clear tair; clear dttemp;
    
    num = -(1004*pair.*(ustar.^3)).*lst;
    den = (0.41*9.81*sensheat);
    L = num./den; clear num; clear den;
    
    
    psim_zb = Psim_SEBAL((zb)./L,L);
    psih_z2 = Psih_SEBAL((z2)./L, L);
    psih_z1 = Psih_SEBAL(z1./L,L);
    newu = real(u200*k./(log((zb)./z0m)-psim_zb)); %Bastiaanssen et al. (1998, 2005)
    rah_new = real((log((z2)./z1)- psih_z2+psih_z1 )./(k* newu));
    
    
    
    % the following codes can be used to test model under different zref
    %
    %                 if zref <=2
    %                     psim_zb = Psim_SEBAL((zb)./L,L);
    %                     psih_z2 = Psih_SEBAL((z2)./L, L);
    %                     psih_z1 = Psih_SEBAL(z1./L,L);
    %                     newu = real(u200*k./(log((zb)./z0m)-psim_zb)); %Bastiaanssen et al. (1998, 2005)
    %                     rah_new = real((log((z2)./z1)- psih_z2+psih_z1 )./(k* newu));
    %
    %
    %                 elseif zref >2
    %
    %                     psim_zb = Psim_SEBAL((zb-d0)./L,L);
    %                     psih_zref = Psih_SEBAL((zref-d0)./L, L);
    %                     psih_z1 = Psih_SEBAL(z1./L,L);
    %                     newu = real(u200*k./(log((zb-d0)./z0m)-psim_zb)); %Bastiaanssen et al. (1998, 2005)
    %                     rah_new = real((log((zref-d0)./z1)- psih_zref+psih_z1 )./(k* newu));
    %
    %                 end
    
    %                 rahcold_new =nanmean(nanmean(rah_new(coldrow-1:coldrow+1,coldcol-1:coldcol+1)));
    rahhot_new =nanmean(nanmean(rah_new(hotrow-1:hotrow+1,hotcol-1:hotcol+1)));
    diff = abs(100* (rahhot-rahhot_new)/rahhot_new); %% differnce in Rah for hot pixel
    
    %              rahcold = rahcold_new;
    rahhot =rahhot_new;
    % set new rah and ustar
    rah= rah_new; ustar = newu;
    countiter = countiter+1;
    
    if countiter == 50 % stop after 10 iterations- in some cases
        diff = 4; % < 5 to close the loop
    end
    
end


sensheat (sensheat <0) = 0;
% figure,imagesc(sensheat);colorbar;
lamdaet = Rn-G-sensheat;
% instantaneous ET (ET at the image time) mm/day
inset = 3600* lamdaet./ ((2.501-(0.002361 * (TinstK-273.15)))  * 1000000); % instant et in mm/hr
etrf = inset./etr_inst; % reference evaporative fraction

etrf(etrf <0)= 0;
etrf(etrf > 1.2) =1.2;

etrf = real(etrf);

dailyet = etrf .*etr_d; % daily ET
% figure,imagesc(dailyet);colorbar;
% figure,imagesc(etrf);colorbar;

lamda = (2.501-(0.002361 * (TinstK-273.15)))  * 1000000;

% 24 hr latent heat flux
lam24 = (dailyet/ 86400) .* lamda;

% 24 hr sensible hear flux
sens24 = Q24-lam24;

etrfcold = etrf(coldrow,coldcol);
etrfhot =etrf(hotrow,hotcol);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%  figure();
%  subplot(2,1,1)
%  imagesc(etrf);colorbar;
%  subplot (2,1,2)
%  imagesc(dailyet); caxis([ 0 10]); colorbar;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end






