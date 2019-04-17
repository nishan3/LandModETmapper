function [psih] = Psih_SEBAL(zeta,L)
%% SEBAL and METRIC stability correction for momentum transport
%zeta = z/L, z = height (or z-zero displacement height), L =  Monin-Obukhov length 
% change z to get stability correction for heat transfer at different
% heights
% written by- Nishan Bhattarai (University of Michigan)
% Contact: nbbhattar@umich.edu/nbhattar@syr.edu)

[mm,nn]= size(zeta);

%Unstable condition
xh = (1.0-16* zeta) .^ 0.25; 

psih=zeros(mm,nn); % netural condition

ind0less =find(L <0);
ind0more=find(L>0);

psih(ind0less) = 2*log((1+ xh(ind0less).^2)/2);
psih(ind0more) = -5 * zeta(ind0more);

% 
% for i=1:mm
%     for j = 1:nn
%         if zeta(i,j) < 0; %unstable condition
%             psih(i,j) = 2*log((1+ xh(i,j).^2)/2);
%             
%         elseif zeta(i,j) > 0 %stable condition
%             psih(i,j) = -5 * zeta(i,j);
%         end
%     end 
% end

psih= real(psih);

end

