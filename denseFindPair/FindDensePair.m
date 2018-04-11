function [ p1, p2 ] = FindDensePair(I1, I2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

addpath('functions_nonrigid')
addpath('functions_affine')

% Compile the mex files
% compile_c_files

tic
% affine registration
[optimizer, metric] = imregconfig('multimodal');
optimizer.InitialRadius = 0.009;
optimizer.Epsilon = 1.5e-4;
optimizer.GrowthFactor = 1.01;
optimizer.MaximumIterations = 1000;

tformSimilarity = imregtform(I1, I2,'similarity',optimizer,metric);
Rfixed = imref2d(size(I2));
I1 = imwarp(I1,tformSimilarity,'OutputView', Rfixed);

% Set static and moving image
S=I2; M=I1;

% Alpha (noise) constant
alpha=2.5;

% Velocity field smoothing kernel
Hsmooth=fspecial('gaussian',[60 60],10);

% The transformation fields
Tx=zeros(size(M)); Ty=zeros(size(M));

[Sy,Sx] = gradient(S);
for itt=1:10
	    % Difference image between moving and static image
        Idiff=M-S;

        % Default demon force, (Thirion 1998)
        %Ux = -(Idiff.*Sx)./((Sx.^2+Sy.^2)+Idiff.^2);
        %Uy = -(Idiff.*Sy)./((Sx.^2+Sy.^2)+Idiff.^2);

        % Extended demon force. With forces from the gradients from both
        % moving as static image. (Cachier 1999, He Wang 2005)
        [My,Mx] = gradient(M);
        Ux = -Idiff.*  ((Sx./((Sx.^2+Sy.^2)+alpha^2*Idiff.^2))+(Mx./((Mx.^2+My.^2)+alpha^2*Idiff.^2)));
        Uy = -Idiff.*  ((Sy./((Sx.^2+Sy.^2)+alpha^2*Idiff.^2))+(My./((Mx.^2+My.^2)+alpha^2*Idiff.^2)));
 
        % When divided by zero
        Ux(isnan(Ux))=0; Uy(isnan(Uy))=0;

        % Smooth the transformation field
        Uxs=3*imfilter(Ux,Hsmooth);
        Uys=3*imfilter(Uy,Hsmooth);

        % Add the new transformation field to the total transformation field.
        Tx=Tx+Uxs;
        Ty=Ty+Uys;
        M=movepixels(I1,Tx,Ty); 
end
toc

% figure,
% subplot(1,3,1), imshow(I1,[]); title('image 1');
% subplot(1,3,2), imshow(I2,[]); title('image 2');
% subplot(1,3,3), imshow(M,[]); title('Registered image 1');
% figure, imshowpair(M, I2,'Scaling','joint');

% find the small difference point and extract candidate feature points
DIFF = abs(M - I2);
thres_diff = 0.01;
[y2,x2] = find(DIFF < thres_diff);

% correct the non-rigid registration shift
y_move = Ty(find(DIFF < thres_diff));
x_move = Tx(find(DIFF < thres_diff));
y1_noffd = y2 - y_move;
x1_noffd = x2 - x_move;

% correct the affine registration shift
tformSimilarity_inv = invert(tformSimilarity);
out = tformSimilarity_inv.T' * [y1_noffd' ; x1_noffd'; ones(size(x1_noffd))'];
x1_noffd_noaff = round(out(2, :))';
y1_noffd_noaff = round(out(1, :))';

% only keep points within the image range
ind_valid = find(x1_noffd_noaff > 0 & x1_noffd_noaff < size(I1, 2) & ...
    y1_noffd_noaff > 0 & y1_noffd_noaff < size(I1, 1));

x1_noffd_noaff_valid = x1_noffd_noaff(ind_valid);
y1_noffd_noaff_valid = y1_noffd_noaff(ind_valid);
x2_valid = x2(ind_valid);
y2_valid = y2(ind_valid);

% please note to comply with the demo, change to [x, y]
% p1 = [x1_noffd_noaff_valid, y1_noffd_noaff_valid];
% p2 = [x2_valid, y2_valid];
p1 = [y1_noffd_noaff_valid, x1_noffd_noaff_valid];
p2 = [y2_valid, x2_valid];

end

