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
    results(i).filename = imgPath;
    results(i).original_label = extractBetween(imagefiles(i).name, 'label_', '_');
    results(i).predicted_label = char(label);
    results(i).scores = scores;
fprintf('Element %d: Predicted label: %s, Score: %f\n', i, char(label), max(scores));
end
%% 
% 对结果按照文件名排序
[~, order] = sort({imagefiles.name});
results = results(order);
% 可视化
figure('Name', 'Image Classification Results');

nfiles = length(imagefiles);
for i = 1:nfiles
    subplot(2, ceil(nfiles/2), i);
    imshow(imread(results(i).filename));
    title(sprintf(' \nCNNPredicted: %s', results(i).original_label{:}, results(i).predicted_label));
end