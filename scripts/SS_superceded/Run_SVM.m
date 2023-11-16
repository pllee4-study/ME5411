% Main Script

% Find the most recent model file
files = dir('SVMModel*.mat');
model = @trainSVMModel_002
if ~isempty(files)
    % Sort files by date and get the latest one
    [~, idx] = max([files.datenum]);
    latestModelFile = files(idx).name;
    fprintf('Latest model found: %s\n', latestModelFile);
    
    choice = input('Do you want to use the latest model? Y/N [Y]: ', 's');
    if isempty(choice) || lower(choice) == 'y'
        fprintf('Using the latest model: %s\n', latestModelFile);
        load(latestModelFile, 'svmModel');
    else
        % Train a new model
        [svmModel, dataValidation, labelsValidation, dataTest, labelsTest, dataTestPaths, folders] = model();
        % Save the new model with a unique filename
        newModelFile = sprintf('SVMModel_%s.mat', datestr(now, 'yyyy-mm-dd_HH-MM-SS'));
        save(newModelFile, 'svmModel');
        fprintf('New model saved as: %s\n', newModelFile);
    end
else
    % No models found, train a new one
    [svmModel, dataValidation, labelsValidation, dataTest, labelsTest, dataTestPaths, folders] = model();
    % Save the new model
    newModelFile = sprintf('SVMModel_%s.mat', datestr(now, 'yyyy-mm-dd_HH-MM-SS'));
    save(newModelFile, 'svmModel');
    fprintf('New model saved as: %s\n', newModelFile);
end

%% Tune the model with cross-validation data
    % Train 10 models compare with cross-validation data and pick the best model. 
    % Best model will be tested on test data. 

% Train 10 models
numModels = 2;
models = cell(1, numModels);
for i = 1:numModels
    [svmModel, dataValidation, labelsValidation, dataTest, labelsTest, dataTestPaths, folders] = model();
    models{i} = {svmModel, dataValidation, labelsValidation, dataTest, labelsTest, dataTestPaths, folders}; 
end

% Evaluate Models based on Cross Validation Set
accuracies = zeros(1, numModels);

for i = 1:numModels
    [svmModel, dataValidation, labelsValidation, ~, ~, ~, ~] = models{i}{:};
    predictedLabels = predict(svmModel, dataValidation);
    accuracies(i) = sum(predictedLabels == labelsValidation) / length(labelsValidation);
end



% Select Best Model then test it against test data
[bestAccuracy, bestModelIndex] = max(accuracies);
[bestModel, ~, ~, dataTest, labelsTest, dataTestPaths, folders] = models{bestModelIndex}{:};

disp(['Best Model Index: ', num2str(bestModelIndex)]);
disp(['Best Model Accuracy: ', num2str(bestAccuracy)]);





% Test the model
if ~svmModel
    svmModel=bestModel;
end
predictedLabels = predict(svmModel, dataTest);
disp(length(predictedLabels));
disp(size(dataTest));


accuracy = sum(predictedLabels == labelsTest) / length(labelsTest);


% Display the accuracy
disp(['Accuracy: ', num2str(accuracy * 100), '%']);


% Define the mapping from numeric labels to folder names
folderNames = folders;

% Display sample images with predictions and actual labels
figure;

% Generate sampleIndices within the range of labelsTest
numSamples = min(10, length(labelsTest)); % To handle cases where labelsTest has fewer than 10 elements
sampleIndices = randperm(length(labelsTest), numSamples);
%sampleIndices = randperm(length(dataTestPaths), min(numSamples, length(dataTestPaths))); % Ensure no out-of-bounds
disp(size(dataTestPaths));
for i = 1:numSamples
    idx = sampleIndices(i);
    %fprintf('sampleIndex: %d\n', idx);
    %fprintf('labelsTest(idx): %d\n', labelsTest(idx));
    if labelsTest(idx) >= 1 && labelsTest(idx) <= length(folderNames)
        imagePath = dataTestPaths{idx};
        actualLabelName = folderNames{labelsTest(idx)};
        predictedLabelName = folderNames{predictedLabels(idx)};

        subplot(2, numSamples/2, i);
        imshow(imread(imagePath));
        title(sprintf('Actual: %s, Pred: %s', actualLabelName, predictedLabelName));
    end
end

% Display images with incorrect predictions
incorrectIndices = find(predictedLabels ~= labelsTest);
figure;
for i = 1:length(incorrectIndices)
    idx = incorrectIndices(i);
    if labelsTest(idx) >= 1 && labelsTest(idx) <= length(folderNames)
        imagePath = dataTestPaths{idx};
        actualLabelName = folderNames{labelsTest(idx)};
        predictedLabelName = folderNames{predictedLabels(idx)};

        subplot(2, ceil(length(incorrectIndices) / 2), i);
        imshow(imread(imagePath));
        title(sprintf('Guess: %s, Actual: %s', predictedLabelName, actualLabelName));
    end
end
