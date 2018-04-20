function [Ps_mat_t, Period] = LocalizePointPCA(Ps, t, minPeakDis, minPeakHei)
% 1) Given n points trajectory (Ps), get PCA axis and estimate period
% 2) Given desired time t and period, get the points locations 
% return 
% Ps_mat_t: current location of points
% Period: points period


num_p = size(Ps{1}, 1);
Ps_mat = cell2mat(Ps);
Period = cell(num_p, 1);

Ps_mat_t = cell(1, num_p);
for i = 1:num_p
    
    %% for each point's motion in x,y,z direction
    x_list = Ps_mat(i, 1:3:end);
    y_list = Ps_mat(i, 2:3:end);
    z_list = Ps_mat(i, 3:3:end);
    M = [x_list', y_list', z_list'];
    
    % run PCA here for x,y,z
    [coeff, score, latent] = pca(M);
    
    %% use the principal axis with maximal eigen-value to extract period (auto-cross correlation)
    s = score(:,1);
    [autocor, lags] = xcorr(s, 10,'coeff');  % set maxlag = the biggest period can observed
    
    % find short/long period
    [pk, lc] = findpeaks(autocor, 'MinPeakDistance', minPeakDis, ...
        'MinPeakheight', minPeakHei);
    long = mean(diff(lc));
    
    Period_cur = [x_list(1:long)', y_list(1:long)', z_list(1:long)'];
    Period{i} = Period_cur; % store the period
    
    %% reconstruct point position given t and principal axis
    Ps_mat_t{i} = Period_cur(rem(t, long), :);
    
end

end

