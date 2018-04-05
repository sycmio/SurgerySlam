function [DoGPyramid, DoGLevels] = createDoGPyramid(GaussianPyramid, levels)
%%Produces DoG Pyramid
% inputs
% Gaussian Pyramid - A matrix of grayscale images of size
%                    (size(im), numel(levels))
% levels      - the levels of the pyramid where the blur at each level is
%               outputs
% DoG Pyramid - size (size(im), numel(levels) - 1) matrix of the DoG pyramid
%               created by differencing the Gaussian Pyramid input

l = length(levels) - 1; % number of levels in Difference of Gaussian
DoGPyramid = zeros(size(GaussianPyramid, 1), size(GaussianPyramid, 2), l); %initialize the DoG pyramid

for i = 1:l
   DoGPyramid(:,:,i) = GaussianPyramid(:,:,i) - GaussianPyramid(:,:,i+1); % get DoG by subtraction of diff levels of Gaussian Pyramid
end

DoGLevels = 1:l;
