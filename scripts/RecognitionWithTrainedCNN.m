scriptPath = fileparts(mfilename('fullpath'));
modelPath = fullfile(fileparts(mfilename('fullpath')), '../model');

%% 设置神经网络目录并加载模型
nnFullPath = fullfile(modelPath, 'CNN/CNN.mat');
load(nnFullPath, 'net');
%% 

imagefiles = dir(fullfile(scriptPath, '../assets/charactersFromPart1/', '*.png'))

% 读取原始图像
for i = 1:length(imagefiles)
    imgPath = fullfile(imagefiles(i).folder, imagefiles(i).name);
    currentImage = imread(imgPath);
    grayImage = im2gray(currentImage);
    [label, scores] = classify(net, grayImage);
    fprintf('Element %d: Predicted label: %s, Score: %f\n', i, char(label), max(scores));
end
