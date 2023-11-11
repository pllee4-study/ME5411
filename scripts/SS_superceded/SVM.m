%SVM
% path for data:  ../assets/p_dataset_26_v2


% Load and process the data
data = []; % Initialize an array to hold feature data
labels = []; % Initialize labels
folders = {'H', 'D', 'A', '8', '7', '4', '0'};

for i = 1:length(folders)
    folderPath = strcat('../assets/p_dataset_26_v2/', folders{i}, '/*.png');
    images = dir(folderPath);
    fprintf('Processing folder %s\n', folders{i});
    for j = 1:length(images)
        img = imread(fullfile(images(j).folder, images(j).name));
        % Convert the image to grayscale
        if size(img, 3) == 3
            img = rgb2gray(img);
        end
        % Extract HOG features
        features = extractHOGFeatures(img);
        
        % Append to data and labels
        data = [data; features];
        labels = [labels; i]; % Each folder represents a different class
    end
end

% Split the data
cv = cvpartition(size(data, 1), 'HoldOut', 0.40);
idx = cv.test;
dataTrain = data(~idx, :);
labelsTrain = labels(~idx, :);
dataTest = data(idx, :);
labelsTest = labels(idx, :);

% Further split test data into validation and test sets
cvTest = cvpartition(size(dataTest, 1), 'HoldOut', 0.5);
idxTest = cvTest.test;
dataValidation = dataTest(~idxTest, :);
labelsValidation = labelsTest(~idxTest, :);
dataTest = dataTest(idxTest, :);
labelsTest = labelsTest(idxTest, :);

% Train the SVM for multi-class classification
svmModel = fitcecoc(dataTrain, labelsTrain);
fprintf('Model training complete.\n');

% Tune the model with cross-validation data (adjust parameters if needed)

% Save the trained model
save('trainedSVMModel.mat', 'svmModel');
fprintf('Model saved to trainedSVMModel.mat\n');

% Load the model (use when needed)
% load('trainedSVMModel.mat');

% Test the model
predictedLabels = predict(svmModel, dataTest);
accuracy = sum(predictedLabels == labelsTest) / length(labelsTest);

% Display the accuracy
disp(['Accuracy: ', num2str(accuracy * 100), '%']);

% Print actual vs. predicted labels
fprintf('Actual vs. Predicted Labels:\n');
for i = 1:length(labelsTest)
    fprintf('Actual: %d, Predicted: %d\n', labelsTest(i), predictedLabels(i));
end
