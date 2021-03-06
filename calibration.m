K = [530.90002, 0,         136.63037; 
      0,         581.00362, 161.32884; 
      0,         0,         1]; 
radialDistortion = [-0.3361 0.0921]; 
tangentialDistortion = [-0.00212 0.00152];

cameraParams = cameraParameters('IntrinsicMatrix',K,'RadialDistortion',radialDistortion,'TangentialDistortion',tangentialDistortion);

video_path = 'Data/heart/left';
start_frame = 1;
end_frame = 1573;

[img_files, video_path_new] = load_video_info(video_path, start_frame, end_frame);

for i=1:(end_frame-start_frame+1)
    I = imread([video_path_new img_files{i}]);
    J = undistortImage(I,cameraParams);
    filename = [video_path num2str(i, 'calibrate/img%05i.jpg')];
    imwrite(J,filename);
end