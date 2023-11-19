clc

%% 设置神经网络目录并加载模型
directory_NNs = 'saved_NNs';
name_nn = 'CNN_1';
nn_fullpath = fullfile(directory_NNs, name_nn);
load(nn_fullpath, 'net');
%% 

task_data = 'characters_white'
imagefiles = dir(fullfile(task_data, '*.png'))
nfiles = length(imagefiles);
% 读取原始图像
for i = 1:nfiles
    current_filename = fullfile(task_data, imagefiles(i).name);
    current_image = imread(current_filename);
% current_image = imread('0alsotoo.png');

%  grayImage = im2gray(current_image);
%  imshow(grayImage);
 
% imshow(inverted_image);
grayImage = im2gray(current_image);
% imshow(grayImage);
% inverted_image = imcomplement(current_image);
[label, scores] = classify(net, grayImage);
fprintf('Element %d: Predicted label: %s, Score: %f\n', i, char(label), max(scores));
end
