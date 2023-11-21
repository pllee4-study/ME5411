scriptPath = fileparts(mfilename('fullpath'));
% datasetPath = fullfile(scriptPath, '../assets/CNNDataset');
% Better performance for task 8
datasetPath = fullfile(scriptPath, '../assets/CNNDataset/task8');

% 通过手动指定路径
trainDataPath = fullfile(datasetPath, 'TRAIN');
testDataPath = fullfile(datasetPath, 'TEST');

imsTrain = imageDatastore(trainDataPath, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
imdsTest= imageDatastore(testDataPath, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
%储存标签
trainLabels = imsTrain.Labels;
testLabels = imdsTest.Labels;

% Directory for saving the output neural network
modelPath = fullfile(scriptPath, '../model');
nnDir = fullfile(modelPath, 'CNN');
labelPath = fullfile(nnDir, 'labels.mat');
nnFullPath = fullfile(nnDir, 'CNN');

%Check if the directory for saving the output neural network exists.
if ~exist(nnDir, 'dir')
   mkdir(nnDir)
end

img = readimage(imsTrain,1);
size(img);

layers = [
    imageInputLayer([128 128 1])

    convolution2dLayer(3,8,'Padding','same')
    batchNormalizationLayer
    reluLayer

    maxPooling2dLayer(2,'Stride',2)

    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer

    maxPooling2dLayer(2,'Stride',2)

    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer

    maxPooling2dLayer(2,'Stride',2)

    convolution2dLayer(3,64,'Padding','same')
    batchNormalizationLayer
    reluLayer

    convolution2dLayer(3,128,'Padding','same')
    batchNormalizationLayer
    reluLayer

    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,256,'Padding','same')
    batchNormalizationLayer
    reluLayer

    maxPooling2dLayer(2,'Stride',2)

    dropoutLayer

    fullyConnectedLayer(7)
    softmaxLayer
    classificationLayer
    ];

options = trainingOptions("adam",...
   "InitialLearnRate",0.001,...
   "MaxEpochs",20,...
   "Shuffle","every-epoch",...
   "ValidationData",imdsTest, ...
   "validationfrequency",20,...
   "MiniBatchSize",64,...
   "Verbose",false,...
   "ExecutionEnvironment","auto",...
   "Plots","training-progress");

net=trainNetwork(imsTrain,layers,options);

% 保存标签
save(labelPath, 'trainLabels', 'testLabels');

YPred=classify(net,imdsTest);
YTest=imdsTest.Labels;
accuracy = sum(YPred == YTest)/numel(YTest)
confmat=confusionmat(YTest,YPred);
plotconfusion(YTest,YPred);


%% Save the neural net in disk for later use.
save(nnFullPath, 'net')
lgraph = layerGraph(layers);
