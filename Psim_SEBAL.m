function [psim] = Psim_SEBAL(zeta,L)
%% SEBAL and METRIC stability correction for momentum transport
%zeta = z/L, z = height (or z-zero displacement height), L =  Monin-Obukhov length 
% change z to get stability correction for momentum transfer at different
% heights

% written by- Nishan Bhattarai (University of Michigan)
% Contact: nbbhattar@umich.edu/nbhattar@syr.edu)
[mm,nn]= size(zeta);

%Unstable condition
xm = (1-16* zeta) .^ 0.25; 

psim=zeros(mm,nn); % neutral condition.

ind0less =find(L <0);
ind0more=find(L>0);


psim(ind0less) = real(2*log((1+ xm(ind0less))/2)+log((1+ xm(ind0less).^2)/2) -2 * atan(xm(ind0less)) + 0.5 *pi);
psim(ind0more) = -5 * zeta(ind0more);

% for i=1:mm
%     for j = 1:nn
%         if zeta(i,j) < 0; %unstable condition
%             psim(i,j) = real(2*log((1+ xm(i,j))/2)+log((1+ xm(i,j).^2)/2) -2 * atan(xm(i,j)) + 0.5 *pi);
%             
%         elseif zeta(i,j) > 0 %stable condition
%             psim(i,j) = -5 * zeta(i,j);
%         end
%     end 
% end

psim = real(psim);

end

