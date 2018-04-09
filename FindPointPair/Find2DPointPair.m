function [ p1, p2 ] = Find2DPointPair(img1, img2)
% Find the point pairs in the stereo left and right images]
% 1. Inititalize key point in the left image (gradient image)
% 2. Search the close area in right image using SSIM

[img1_grad, ~] = imgradient(im2double(rgb2gray(img1)));

% initialize find salient points on left stereo image
sigma0 = 1; k = sqrt(2); levels = [-1, 0, 1, 2, 3, 4];
th_contrast1 = 0.001; th_contrast2 = 0.085; th_r1 = 1;

[locsDoG1, ~] = DoGdetector(img1_grad, sigma0, k, levels, th_contrast1, th_contrast2, th_r1);
ind1 = find(locsDoG1(:,1) > 40 & locsDoG1(:,1) < size(img1_grad, 1)-40 &...
    locsDoG1(:,2) > 40 & locsDoG1(:,2) < size(img1_grad, 2)-40);
locsDoG1 = locsDoG1(ind1(1:2:end), :);

% extract the image patch for finding the corresponding on the right
locsDoG1_new = [];
locsDoG2_new = [];
parfor i = 1:size(locsDoG1,1)
    
    y_img1 = locsDoG1(i,1); x_img1 = locsDoG1(i,2);
    patch_img1 = img1(y_img1-9:y_img1+9, x_img1-9:x_img1+9, :);
    
    % search the sw range for finding the best match by using RGB SSIM
    sw = 20;
    sim = zeros(2*sw+1, 2*sw+1);
    
    for y_sr = -sw:2:sw
        for x_sr = -sw:2:sw
            y_img2 = y_img1 + y_sr; x_img2 = x_img1 + x_sr;       
            if y_img2 > sw && y_img2 < size(img2,1)-sw && x_img2 > sw && x_img2 < size(img2,1)-sw
                patch_img2 = img2(y_img2-9:y_img2+9, x_img2-9:x_img2+9, :);
                sim(y_sr + (sw+1), x_sr + (sw+1)) = ssim(patch_img1, patch_img2);
            end    
        end
    end
    
    % find the match point, skip if minimal dis-similarity too big
    if max(sim(:)) > 0.975
        [r, c] = find(sim == max(sim(:)));
        locsDoG1_new = [locsDoG1_new; [locsDoG1(i,1), locsDoG1(i,2)]];
        locsDoG2_new = [locsDoG2_new; [locsDoG1(i,1)+mean(r)-sw, locsDoG1(i,2)+mean(c)-sw]];
    end
    
end

p1 = locsDoG1_new(:,end:-1:1);
p2 = locsDoG2_new(:,end:-1:1);

end

