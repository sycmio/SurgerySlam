function locsDoG = getLocalExtrema(DoGPyramid, DoGLevels, ...
                        PrincipalCurvature, th_contrast1, th_contrast2, th_r)
%%Detecting Extrema
% INPUTS
% DoG Pyramid - size (size(im), numel(levels) - 1) matrix of the DoG pyramid
% DoG Levels  - The levels of the pyramid where the blur at each level is
%               outputs
% PrincipalCurvature - size (size(im), numel(levels) - 1) matrix contains the
%                      curvature ratio R
% th_contrast - remove any point that is a local extremum but does not have a
%               DoG response magnitude above this threshold
% th_r        - remove any edge-like points that have too large a principal
%               curvature ratio
%
% OUTPUTS
% locsDoG - N x 3 matrix where the DoG pyramid achieves a local extrema in both
%           scale and space, and also satisfies the two thresholds.

locsDoG = [];

for z = 1:length(DoGLevels)
    
    for i = 2:size(DoGPyramid,1)-1
        for j = 2:size(DoGPyramid,2)-1
            
            % if it is the first level in the DoG pyramid
            if z == 1
                v = DoGPyramid(i-1:i+1, j-1:j+1, z:z+1);
                
            else
                % if it is the last level in the DoG pyramid
                if z == length(DoGLevels)
                    v = DoGPyramid(i-1:i+1, j-1:j+1, z-1:z);
                    
                % if it is just in the middle
                else
                    v = DoGPyramid(i-1:i+1, j-1:j+1, z-1:z+1);
                    
                end
            end
           
            % when satify it is the maximal in the 9 + 9 + 8 region & above
            % contrast threshold & below the principal curvature threshold
            if abs(DoGPyramid(i,j,z)) == max(abs(v(:))) && abs(DoGPyramid(i,j,z)) >= th_contrast1 && abs(DoGPyramid(i,j,z)) <= th_contrast2 && PrincipalCurvature(i,j,z) <= th_r
                locsDoG = [locsDoG; [i,j,z]];
            end
                
        end
    end
    
end