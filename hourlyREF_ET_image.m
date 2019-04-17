function [ETsz_tall, ETsz_short ] = hourlyREF_ET_image(J,Tmax,Tmin,z,solar,RH_mean,uz,zw,time,lz,lat,lm,t_interval)
% THis code makes image of reference ET for image time. The inputs are in
% grids but it will work on vectors as well.
%% Source: http://www.fao.org/docrep/x0490e/x0490e07.htm#TopOfPage
% written by Nishan Bhattarai, nbhattar@syr.edu/nbhattar@umich.edu
% Date: Nov 5, 2015

%% INPUT data
% J             = doy_mean; %DOY
% Tmax          = TinstC; % Max temp in degree F or C - F
% Tmin          = TinstC; % Max temp in degree F or C - F
% z             = dem; % elevation in m
% solar         = solar_i; % solar radiation WM-2
% RH_mean       =  rh_inst; % relative humidity %
% uz            = u_inst; % m/s or MPH, wind speed at measurement station m/s or mph
% zw            = 10; % height of anemometer in m
% %time         = standard clock time at the midpoint of the period [hour] (after correcting time for any daylight savings shift). 
% %For example for a period between 1400 and 1500 hours, t = 14.5 hours
% time = 8.5;


% % lz          = 90; % This must be a divisible by 15
% % lz          = longitude of the center of the local time zone [expressed as positive 
                    %degrees west of Greenwich, England]. In the United States, Lz = 75, 90, 
                    %105 and 120° for the Eastern, Central, Rocky Mountain and Pacific time zones, 
                    %respectively, and Lz = 0° for Greenwich, 345° for Paris (France), and 255° for Bangkok (Thailand)


%timezone       = 2;%  1 = eastern; 2 = central; 3 = mountation;  and 4 =  pacific; 
                %THIS could be easily adjusted for nonUS locations. Lz value (see below) 
                %varies with this value. This can be used for large scale application. 
% lat           =imglat; % in degress , +ve for northern hemisphere
% % lm = 88;% longitude of the solar radiation measurement site [expressed as positive degrees west of Greenwich, England]
% t_interval    = 1; %length of the calculation period [hour]: i.e., 1 for hourly periods or 0.5 for 30-minute periods.

%% convert F into C- Comment these four lines if temperature is in C
% TmaxC = (Tmax - 32)/1.8;
% TminC = (Tmin - 32)/1.8;
% Tmax = TmaxC;
% Tmin = TminC;

%CONVERSIONS (May not require this check UNITS)
Rs = solar * 0.0862068/24; % WM-2 into MJ m-2 day-1 (24 is to convert it into MJ m-2 hr-1) 
% lat_rad = lat*pi/180; % degrees to radians
%%%%uz = uz * 0.44704; % wind speed at measurement station in m/s 
% Tmax = 5/9 * (Tmax-32); % F to C
% Tmin = 5/9 * (Tmin-32); %  F to C

%ASCE recommended values
lamda = 2.45; % Latent Heat of Vaporization (?)- MJ kg-1

% z = 1800; %testing FAO

% atmospheric pressure, P = mean atmospheric pressure @ station ele z [kPa]
P = 101.3 * ((293 - 0.0065.* z)/293) .^5.26;

% Psychrometric Constant (kPa °C-1)
ji = 0.000665* P;


%Saturation Vapor Pressure (es)
%saturation vapor pressure function (eo)

% testing FAO
% Tmax = 25;
% Tmin = 18;
% RHmax = 82;
% RHmin = 54;

T_avg = (Tmax + Tmin)/2;
eo_max = 0.6108 * exp(17.27 * Tmax./(Tmax + 237.3));
eo_min = 0.6108 * exp(17.27 * Tmin./(Tmin + 237.3));
% mean saturation vapor pressure
es = (eo_max + eo_min)/2;

% ea from relative humidity data
% eoT = 0.6108 * exp(17.27 * T_avg/(T_avg + 237.3));
% 
% RH_mean = (RHmax+RHmin)/2;
%ACtual Vapor Pressure
ea_RH = RH_mean/100 .* (eo_max + eo_min)/2;


%Actual vapour pressure (ea_dew) derived from dewpoint temperature
% T_dew = 17; example
% ea_dew = 0.6108 * exp(17.27 * T_dew/(T_dew + 237.3));

% Slope of the Saturation Vapor Pressure-Temperature Curve (delta)
delta = 2503 * exp((17.27 * T_avg)./(T_avg+237.3))./((T_avg+237.3).^2);

% vapor pressure deficit (es-ea)
% e_deficit = es - ea_RH;


%% Extra Terrestial Radiation

%albedo
% albedo = 0.23;


% fcd = cloudiness function [dimensionless] (limited to 0.05 ? fcd ? 1.0)

% sbconst = 2.042 * 10 .^(-10); % Stefan-Boltzmann constant [2.042 x 10-10 MJ K-4 m-2 h-1]
% TK = T_avg + 273.16; % abslolute temp in K

%% Net radiation, MJ m-2 d-1

% The latitude, ?, expressed in radians is positive for the Northern Hemisphere and negative for the Southern Hemisphere 
% CONVERSION: convert this latitue from degree to radians
lat_rad = lat*pi/180; % degrees to radians

% inverse relative distance factor (squared) for the earth-sun [unitless]
dr = 1+0.033*cos(J*2*pi/365);

% incoming solar rdiation in MJ m-2 hr-1
Rns = (1-0.23).* Rs;

%rso = clear sky solar radiation
% calculate extra terrestial radiation

% example for september 3, 20degrees S
%%Seasonal Correction for solar 
% J = 246;
% lat_rad = pi*(-20/180);
b = 2*pi*(J-81)/364;
sc = 0.1645* sin(2*b)-0.1255*cos(b)-0.025*sin(b);

Gsc = 4.92; %  solar constant = 4.92 MJ m-2 h-1,

% Solar declination in radians
% doy = 197;
dec = 0.4093 * sin ((2*pi/365)*J - 1.39);
% the values (degrees) are also available in 
%http://www.wsanford.com/~wsanford/exo/sundials/DEC_Sun.html

%% The equation will give you DOY or J. But if J is input it's not required.
% M = 7;
% Y = 2008;
% % dm = 15;
% J1 = dm - 32 + fix(275*M/9)+2*fix(3/(M+1))+fix(M/100-rem(Y,4)/4 + 0.975);
%%
% solar angle hour for diurnal exposition
% latitue in radians..can use lat grid or image center lattitue
% lat grid was created by converting raster to vector and assigned latitue
% and converted back to raster...or using Mesh grids
% lat = 30; % in degress , +ve for northern hemisphere
% lat_rad = lat* pi/180; % radians % lat grids can be used too
ws = acos(-tan(lat_rad).*tan(dec));

% timezone = 2; % central;
% if timezone == 1
%     lz = 75;
% elseif timezone == 2
%     lz = 90;
% elseif timezone == 3
%     lz = 105;
% elseif timezone == 4
%     lz = 120;
% end

% lm = 77;% longitude of the solar radiation measurement site [expressed as positive degrees west of Greenwich, England]

% standard clock time at the midpoint of the period [hour] (after correcting time for any daylight savings shift). 
%For example for a period between 1400 and 1500 hours, t = 14.5 hours


w = pi/12 * ((time + 0.06667*(lz-lm)+sc)-12);

% w = pi/12 * ((time + 0.667*(90-77)+sc)-12);


% t_interval = 1; %length of the calculation period [hour]: i.e., 1 for hourly periods or 0.5 for 30-minute periods.

w1 = w - pi*t_interval/24;
w2 = w + pi*t_interval/24;

% to ensure numerical staility of Extraterrestrial radiation equation,
% following conditions are applied. Refer ASCE 2005 handbook
% if w2 < -ws
%     w2 = - ws;
% elseif w2 > ws
%     w2 = ws;  
% elseif w1 < -ws;
%     w1 = -ws;
% end
% 
% if w1 > ws
%     w2 = ws;
% elseif w1 > w2
%     w1 = w2;
% end

if length(w) ~=1
    
    
    w2(w2 < -ws) = -1 * ws(w2 < -ws);
    w2(w2 > ws) = ws(w2 > ws);
    
    w1(w1 < -ws) = -1 * ws(w1 < -ws);
    w1(w1 > ws) = ws(w1 > ws);
    w1(w1 > w2) = w2(w1 > w2);
    
    
else
    if w2 < -ws
        w2 = - ws;
    elseif w2 > ws
        w2 = ws;
    end
    if w1 < -ws
        w1 = -ws;
    elseif w1 > ws
        w1 = ws;
    elseif w1 > w2
        w1 = w2;
    end
 
end


% lat = 28; % latitude of the station

% The angle of the sun above the horizon, ?, at the midpoint of the hourly or shorter time period
% Y = sin(lat_rad)*sin(dec)+cos(lat_rad)*cos(dec)*cos(w);
% B = atan(Y/((1-Y^2)^0.5));


% Extraterrestrial radiation, Ra for hourly period.
Ra = (12/pi *  Gsc* dr) .*((w2-w1).*sin(lat_rad).*sin(dec)+cos(lat_rad).*cos(dec).*(sin(w2)-sin(w1)));


% CLear sky solar radiation Rso
Rso = (0.75+2*10^(-5)*z).*Ra;

ratioRs = (Rs)./Rso;
ratioRs(ratioRs <0.3) = 0.3;
ratioRs(ratioRs >1) = 1;

   
%fcd
fcd = 1.35 * ratioRs - 0.35; % 

%Rnl is the difference between long-wave radiation radiated upward from the
%standardized surface (Rlu) and long-wave radiation radiated downward 
%from the atmosphere (Rld) Unit MJ m-2 h-1

Rnl = 2.042 * 10^(-10)*fcd.*(0.34-0.14 .* sqrt(ea_RH)).*(T_avg +273.16) .^4;


% Net Radiation
Rn = (Rns - Rnl); % MJ m-2 h-1

% Soil heat flux
%% Daytime is time when net radiation is more than 0- Valid assumption (ASCE 2005 refET handbook)
Ghrshort = 0.1* Rn;
Ghrtall = 0.04* Rn;


Ghrshort (Rn < 0.001) =     0.5* Rn(Rn < 0.001);
Ghrtall (Rn < 0.001) =     0.2* Rn(Rn < 0.001);

% 
% 
% if Rn > 0.001
%     Ghrshort = 0.1* Rn;
%     Ghrtall = 0.04* Rn;
% end
% if Rn < 0.001
%     Ghrshort = 0.5* Rn;
%     Ghrtall = 0.2* Rn;
% end

% Cn = numerator constant that changes with reference type and 
%calculation time step (K mm s3 Mg-1 d-1 or K mm s3 Mg-1 h-1) and
%Cd = denominator constant that changes with reference type and 
%calculation time step (s m-1).


%% Daytime is time when net radiation is more than 0- Valid assumption (ASCE 2005 refET handbook)
% instead of 0 a very small value if used just to avoid some very small
% values that may appear due to roundings
Cn_t = zeros(size(Rn));
Cd_t = zeros(size(Rn));
Cn_s= zeros(size(Rn));
Cd_s= zeros(size(Rn));

Cn_t(Rn > 0.0001) = 66;
Cd_t(Rn > 0.0001) = 0.25;
Cn_s(Rn > 0.0001) = 37;
Cd_s(Rn > 0.0001) = 0.24;

Cn_t(Rn < 0.0001) = 66;
Cd_t(Rn < 0.0001) = 1.7;
Cn_s(Rn < 0.0001) = 37;
Cd_s(Rn < 0.0001) = 0.96;

% if Rn > 0.0001
%     % for hourly tall grass, daytime
%     Cn_t = 66;
%     Cd_t = 0.25;
%     
%     % for hourly short grass, daytime
%     Cn_s = 37;
%     Cd_s = 0.24;
% end
% if Rn < 0.0001
%     % for hourly tall grass, daytime
%     Cn_t = 66;
%     Cd_t = 1.7;
%     
%     % for hourly short grass, daytime
%     Cn_s = 37;
%     Cd_s = 0.96;
% end

% Wind Profile Relationship

% u2 = wind speed at 2m 

%uz = wind speed measured at zm height

% wind speed at 2m height
if zw==10
u2 = uz * 4.87/ (log(67.8* zw - 5.42)); % wind speed profile equation 
else
    u2 = uz;
end

% The Standardized Reference Evapotranspiration Equation
% Rn= 2.07;
% Ghrshort_day = 0.1* Rn;
% Ghrshort_night = 0.5* Rn;
% 
% Ghrtall_day = 0.04* Rn;
% Ghrstall_night = 0.2* Rn;

ETsz_tall = (0.408 * delta .* (Rn-Ghrtall) + ji .* (Cn_t./(T_avg+273)).*u2.*(es-ea_RH))./(delta + ji .*(1+Cd_t .*u2));
ETsz_short = (0.408 * delta .* (Rn-Ghrshort) + ji .* (Cn_s./(T_avg+273)).*u2 .*(es-ea_RH))./(delta + ji .*(1+Cd_s .*u2));

% figure, imagesc(ETsz_tall);colorbar;
% figure, imagesc(ETsz_short);colorbar;
% end

