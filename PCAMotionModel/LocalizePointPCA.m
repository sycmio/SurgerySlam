function [Ps_mat_t, Period] = LocalizePointPCA(Ps, t_start, t_end, minPeakDis, minPeakHei)
% 1) Given n points trajectory (Ps), get PCA axis and estimate period
% 2) Given desired time t and period, get the points locations 
% return 
% Ps_mat_t: location of points [t_start -> t_end]
% Period: points period

num_p = size(Ps{1}, 1);
Ps_mat = cell2mat(Ps);
Period = cell(num_p, 1);

Ps_mat_t = zeros(num_p, 3*(t_end - t_start + 1));
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
    [autocor, lags] = xcorr(s, 100,'coeff');  % set maxlag = the biggest period can observed
    
    % find short/long period
    [pk, lc] = findpeaks(autocor, 'MinPeakDistance', minPeakDis, ...
        'MinPeakheight', minPeakHei);
    long = round(mean(diff(lc)));
    
    % compute Period_cur
    tmp_start = 1;
    Period_cur = zeros(long,3);
    period_num = 1;
    for j=1:period_num
        tmp_end = tmp_start+lc(j+1)-lc(j)-1;
        interval = (tmp_end-tmp_start)/(long-1);
        x_interpolate = interp1(tmp_start:tmp_end,x_list(tmp_start:tmp_end),tmp_start:interval:tmp_end,'spline');
        y_interpolate = interp1(tmp_start:tmp_end,y_list(tmp_start:tmp_end),tmp_start:interval:tmp_end,'spline');
        z_interpolate = interp1(tmp_start:tmp_end,z_list(tmp_start:tmp_end),tmp_start:interval:tmp_end,'spline');
        Period_cur = Period_cur + [x_interpolate',y_interpolate',z_interpolate'];
        tmp_start = tmp_start+lc(j+1)-lc(j);
    end
    
    Period_cur = Period_cur/period_num;
    
%     Period_cur = [x_list(1:long)', y_list(1:long)', z_list(1:long)'];
    Period{i} = Period_cur; % store the period
   
    %% reconstruct point position given t and principal axis
    t_ind = 1;
    for t = t_start:t_end
        Ps_mat_t(i, 3*(t_ind-1) + 1:3*(t_ind-1) + 3) = Period_cur(rem(t-1, long)+1, :);
        t_ind = t_ind + 1; 
    end

end

Ps_mat_t = mat2cell(Ps_mat_t, num_p, 3 * ones(1, t_end-t_start+1));
    
end

