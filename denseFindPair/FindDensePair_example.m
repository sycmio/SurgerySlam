% Clean
clc; clear all; close all;

% Read two images
I1=rgb2gray(im2double(imread('images/00001_left.png')));  
I2=rgb2gray(im2double(imread('images/00001_right.png'))); 

[p1, p2] = FindDensePair(I1, I2);

% validate
ind = randi([0 size(p2, 1)],1,50);

figure,imshow(I1, []); hold on
plot(p1(ind, 1), p1(ind, 2), '.g', 'MarkerSize', 6); hold off

figure,imshow(I2, []); hold on
plot(p2(ind, 1), p2(ind, 2), '.g', 'MarkerSize', 6); hold off

