function [FigHandle] = graph_img(data,lat_trmm,lon_trmm, GraphTitle,  caxismin, caxismax,colorbarcode,colortitle)
% GraphTitle ='MOD Day Available Days';
FigHandle=surface(lon_trmm,lat_trmm,data,'EdgeColor','none');
shading flat;
xlim([min(min(lon_trmm)) max(max(lon_trmm))]);
ylim([min(min(lat_trmm)) max(max(lat_trmm))]);
xlabel('Longitude');
ylabel('Latitude');
caxis([caxismin caxismax]);
title(GraphTitle);

if colorbarcode==1
% c = colorbar('southoutside');
c = colorbar;
c.Label.String = colortitle;
end
end

