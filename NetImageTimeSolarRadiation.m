function [Rn] = NetImageTimeSolarRadiation(solar_i,TinstK,rh_inst, albedo, emiss, lst)
%% Net radiation during image time
% written by Nishan Bhattarai, nbhattar@syr.edu/nbhattar@umich.edu
% Date: Nov 5, 2015

%% Input, 
%solar_i        = incoming solar radiation (W/m-2)
%TinstK        = air temperature in K
%rh_inst        = relative humidity (%)
%albedo        = albedo (unitless)
%emiss          = emissivity (unitless)
%lst             = land surface temprature (K)


% solar_i incoming shortwave radiation (W/m2) at the station- Note: This can be
% calculated using FAO equations using day and latitue but station data is
% preferred.
%dr is the inverse squared relative earth-sun distance in astronomical units, from the equation by Duffie and Beckham (1980)
% dr = 1+0.033*cos(doy*2*pi/365);
% 
% %costheta is the cosine of the solar incidence computed from sun elevation angle (b) where theta = (90 – b)
% costheta = cos((90-b)*pi/180); 
% 
% %tsw includes transmissivity of both direct solar beam radiation and diffuse (scattered) radiation to the surface
% % Based on FAO-56 method, elevation (m) of weather station can also be used recommended,
% % which also represnts elevation of area of interest
% 
% tswimage = 0.75+ 2*10^(-5).*dem; %%elevation is  in meters Allen et al. 2007
% r_s = 1367*tswimage .*(dr .*costheta); % incoming shortwave radiation
r_s = solar_i;

% Output = Net solar radiation in W/m2
t_instC = TinstK - 273.16;
es= 0.6108 * exp (17.27 * t_instC ./(t_instC+237.3));

ea = (rh_inst/100) .* es;
%atmospheric emissivity from Brutsaert 1975
Ea = 0.892 * (ea./t_instC) .^(1/7);
Ea = real(Ea);

% Ea = 0.85 * ((-1*log(tswimage)) .^0.09); % Allen i METRIC model

% Ea = 1.08 * (-log(tswimage)) .^(.265);
%0.7756963; % from Bastiaanssen 1995
r_lin = Ea .* (5.67 * 10^(-8)* TinstK .^4); 

% Results shows that there is no significant difference in Rns values using
% Lstcold and inst airtemperature, So We are using air temperature here. This
% makes Rn computaion for SEBAL and METRIC same.

% derive net radiation and soilheat flux images
r_out = 5.67 * 10^(-8)* (emiss .* (lst.^4));

Rn = round((1-albedo).*r_s + r_lin - r_out- (1-emiss).*r_lin); 
Rn = real(Rn);
end

