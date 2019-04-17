function [longrids,latgrids] = MakeLatLongridsFromGeotiffInfo(info_sub,m,n)
% Make Lat and Lon grids
% Get the Corner coordinates
% Info_sub= geotiffinfo
% Nishan Bhattarai- nishan.bhattarai@tufts.edu
%m= number of rows
%n = number of cols

LatUL =info_sub.CornerCoords.Lat(1,1);
LonUL=info_sub.CornerCoords.Lon(1,1);

% LatUR =info_sub.CornerCoords.Lat(1,2);
LonUR=info_sub.CornerCoords.Lon(1,2);
LatLR = info_sub.CornerCoords.Lat(1,4);

Lonrange = LonUL-LonUR;%Lon changes along columns- X axis (i.e. same for each column-Y)
Latrange = LatUL-LatLR;%Lat changes along rows- Y axis (i.e. same for each column-X
% Pixel size based on degrees
Lonc = Lonrange/n;
Latc = Latrange/m;
LonR = zeros(1,n);
LatR = zeros(m,1);

% Note that this is for Northern Hemisphere
for i =1:n
    LonR(1,i)=LonUL-i*Lonc;
    
end
for i =1:m
    LatR(i,1) = LatUL - i*Latc;
end

longrids = repmat(LonR,m, 1);
latgrids = repmat(LatR,[1,n]);

end

