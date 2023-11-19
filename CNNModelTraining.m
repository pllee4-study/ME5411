clc
clear

% 通过手动指定路径
trainDataPath = 'D:\b) Study\水硕\ME5411 robot vision and ai\assignment1\p_dataset_26 (1)\p_dataset_26\TRAIN';
testDataPath = 'D:\b) Study\水硕\ME5411 robot vision and ai\assignment1\p_dataset_26 (1)\p_dataset_26\TEST';
% taskDataPath = '完整的分类任务数据文件夹路径';
imsTrain = imageDatastore(trainDataPath, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
imdsTest= imageDatastore(testDataPath, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
%储存标签
trainLabels = imsTrain.Labels;
testLabels = imdsTest.Labels;

%Directory for saving the output neural network
name_nn = "CNN_1";
nn_directory = 'saved_NNs';
nn_fullpath = strcat(nn_directory, '/',name_nn);

%Check if the directory for saving the output neural network exists.
if ~exist(nn_directory, 'dir')
   mkdir(nn_directory)
end


img=readimage(imsTrain,1);
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
save('labels.mat', 'trainLabels', 'testLabels');

   YPred=classify(net,imdsTest);
   YTest=imdsTest.Labels;
   accuracy = sum(YPred == YTest)/numel(YTest)
   confmat=confusionmat(YTest,YPred);
%    MhelperDisplayConfusionMatrix(confmat);
   plotconfusion(YTest,YPred);


%% Save the neural net in disk for later use.
save(nn_fullpath,'net')
   %task predict
%    taskpath=fullfile('D/')
%    imsTask=imageDatastore(taskpath,'IncludeSubfolders',true,'LabelSource','foldernames');
% 
%    YTaskpredict=classify(net,imsTask);
%    YTrue=imsTask.Labels;
% 
%    figure;





lgraph = layerGraph(layers);