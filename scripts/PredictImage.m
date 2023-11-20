
folderPath = '../assets/charactersFromPart1/*.png'; % Specify the path to the images
images = dir(folderPath); % Get a list of all .png files in the folder
totalImages = numel(images); % Count the number of files


data = cell(1, totalImages);
labels = cell(1, totalImages);
allPaths = cell(1, totalImages); % Temporary array to store all image paths    

currentIndex = 1;



% Load and process data
for i = 1:1
    folderPath = strcat('../assets/charactersFromPart1/*.png');
    images = dir(folderPath);
    disp('Processing folder %s charactersFromPart1');
    for j = 1:length(images)
        imgPath = fullfile(images(j).folder, images(j).name);
        img = imread(imgPath);

        % Convert to grayscale if the image is colored
        if size(img, 3) == 3
            img = rgb2gray(img);
        end

        % Extract HOG features
        features = extractHOGFeatures(img);

        % Append to data and labels
        data{currentIndex} = features;
        allPaths{currentIndex} = imgPath; % Store all paths for visualization  

        % Increment index for the next iteration
        currentIndex = currentIndex + 1;    
  
    end
end


data = cell2mat(data');

modelPath = fullfile(fileparts(mfilename('fullpath')), '../model');
files = dir(fullfile(modelPath, '/SVMModel*.mat'));

[~, idx] = max([files.datenum]);

latestModelFile = files(idx).name;
fprintf('Latest model found: %s\n', latestModelFile);
fprintf('Using the latest model: %s\n', latestModelFile);
load(fullfile(modelPath, latestModelFile), 'svmModel', 'dataTest', 'labelsTest', 'dataTestPaths', 'folders');

folders = {'H', 'D', 'A', '8', '7', '4', '0'};

% 
% predictedLabels = predict(svmModel, data);
% actualLabels = folders(predictedLabels);
% 
% disp('Actual Labels:');
% disp(actualLabels);
% %accuracy = sum(predictedLabels == labelsTest) / length(labelsTest);
% 
% 
% % Display the accuracy
% %disp(['Accuracy: ', num2str(accuracy * 100), '%']);

%% labels and accuray
% print out images

% Parse actual labels from filenames
actualLabels = cell(1, length(images));
for j = 1:length(images)
    [~, name, ~] = fileparts(images(j).name);
    labelParts = split(name, '_');
    actualLabels{j} = labelParts{end};
end

% Predict labels using the SVM model
predictedLabels = predict(svmModel, data);

% Convert predicted indices to label names
predictedLabelNames = folders(predictedLabels);

% Calculate accuracy
correctPredictions = sum(strcmp(actualLabels, predictedLabelNames));
accuracy = correctPredictions / length(actualLabels);

% Display the accuracy
disp(['Accuracy: ', num2str(accuracy * 100), '%']);


% % Display images with predictions and actual labels
% figure;
% sgtitle('Predictions');
% numSamples = min(10, length(actualLabels)); % To handle cases where there are fewer than 10 images
% sampleIndices = randperm(length(actualLabels), numSamples);
% for i = 1:numSamples
%     idx = sampleIndices(i);
%     imagePath = allPaths{idx};
%     actualLabelName = actualLabels{idx};
%     predictedLabelName = predictedLabelNames{idx};
% 
%     subplot(2, numSamples/2, i);
%     imshow(imread(imagePath));
%     title(sprintf('Actual: %s, Pred: %s', actualLabelName, predictedLabelName));
% end

% Extract the numerical part from the filenames and convert to numbers
imageNumbers = zeros(1, length(images));
for j = 1:length(images)
    [~, name, ~] = fileparts(images(j).name);
    labelParts = split(name, '_');
    numPart = labelParts{1};
    imageNumbers(j) = str2double(regexprep(numPart, '[^\d]', ''));
end

% Sort the images and labels based on imageNumbers
[sortedNumbers, sortOrder] = sort(imageNumbers);
sortedPaths = allPaths(sortOrder);
sortedActualLabels = actualLabels(sortOrder);
sortedPredictedLabels = predictedLabelNames(sortOrder);

% Display the images in sorted order
figure;
sgtitle('Predictions');
numSamples = length(sortedNumbers); % Display all images
for i = 1:numSamples
    idx = sortOrder(i);
    imagePath = sortedPaths{i};
    actualLabelName = sortedActualLabels{i};
    predictedLabelName = sortedPredictedLabels{i};

    subplot(2, ceil(numSamples/2), i);
    imshow(imread(imagePath));
    title(sprintf('Actual: %s, Pred: %s', actualLabelName, predictedLabelName));
end




