function PrincipalCurvature = computePrincipalCurvature(DoGPyramid)
%%Edge Suppression
% Takes in DoGPyramid generated in createDoGPyramid and returns
% PrincipalCurvature,a matrix of the same size where each point contains the
% curvature ratio R for the corre-sponding point in the DoG pyramid
%
% INPUTS
% DoG Pyramid - size (size(im), numel(levels) - 1) matrix of the DoG pyramid
%
% OUTPUTS
% PrincipalCurvature - size (size(im), numel(levels) - 1) matrix where each 
%                      point contains the curvature ratio R for the 
%                      corresponding point in the DoG pyramid

PrincipalCurvature = zeros(size(DoGPyramid));
for i = 1:size(DoGPyramid,3)
    
    img_DoG_cur = DoGPyramid(:,:,i); % get current DoG in the DoG pyramid
    
    % Calculate Dxx, Dxy, Dyx, Dyy
    [Dx, Dy] = gradient(img_DoG_cur);
    [Dxx, Dxy] = gradient(Dx);
    [Dyx, Dyy] = gradient(Dy);
    
    for r = 1:size(img_DoG_cur,1)
        for l = 1:size(img_DoG_cur,2)
            
            H = [Dxx(r,l), Dxy(r,l);    % calculate the Hessian matrix
                Dyx(r,l), Dyy(r,l)];
            
            R = trace(H)^2 / det(H);    % calculate the R (principal curature)
            
            PrincipalCurvature(r,l,i) = R;     % give to corresponding location in the pyramid
            
        end
    end
    
    
end



