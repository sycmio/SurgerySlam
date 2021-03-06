function [locsDoG, GaussianPyramid] = DoGdetector(img, sigma0, k, ...
                                                levels, th_contrast1, th_contrast2, th_r)
%%DoGdetector
%  Putting it all together
%
%   Inputs          Description
%--------------------------------------------------------------------------
%   im              Grayscale image with range [0,1].
%
%   sigma0          Scale of the 0th image pyramid.
%
%   k               Pyramid Factor.  Suggest sqrt(2).
%
%   levels          Levels of pyramid to construct. Suggest -1:4.
%
%   th_contrast     DoG contrast threshold.  Suggest 0.03.
%
%   th_r            Principal Ratio threshold.  Suggest 12.
%
%   Outputs         Description
%--------------------------------------------------------------------------
%
%   locsDoG         N x 3 matrix where the DoG pyramid achieves a local extrema
%                   in both scale and space, and satisfies the two thresholds.
%
%   GaussianPyramid A matrix of grayscale images of size (size(im),numel(levels))

[GaussianPyramid] = createGaussianPyramid(img, sigma0, k, levels);

[DoGPyramid, DoGLevels] = createDoGPyramid(GaussianPyramid, levels);  % perfrom DoG using the GaussiaanPyramid from previous step

PrincipalCurvature = computePrincipalCurvature(DoGPyramid);

locsDoG = getLocalExtrema(DoGPyramid, DoGLevels, PrincipalCurvature, th_contrast1, th_contrast2, th_r);


end

