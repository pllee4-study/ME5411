% Main Script

% Find the most recent model file
files = dir('SVMModel*.mat');
training_model = @trainSVMModel_003;
if ~isempty(files)
    % Sort files by date and get the latest one
    [~, idx] = max([files.datenum]);
    latestModelFile = files(idx).name;
    fprintf('Latest model found: %s\n', latestModelFile);
    
    choice = input('Do you want to use the latest model? Y/N [Y]: ', 's');
    if isempty(choice) || lower(choice) == 'y'
        fprintf('Using the latest model: %s\n', latestModelFile);
        load(latestModelFile, 'svmModel', 'dataTest', 'labelsTest', 'dataTestPaths', 'folders');
    else
        % Train many models and get the best one based on crossvalidation accuracy
        [svmModel, dataValidation, labelsValidation, dataTest, labelsTest, dataTestPaths, folders] = training_model();

        % Save the best model
        newModelFile = sprintf('SVMModel_%s.mat', datestr(now, 'yyyy-mm-dd_HH-MM-SS'));
        save(newModelFile, 'svmModel', 'dataTest', 'labelsTest', 'dataTestPaths', 'folders');
        fprintf('Best model saved as: %s\n', newModelFile);
    end
else
    % No models found, train a new one
    % Train many models and get the best one based on crossvalidation accuracy
    [svmModel, dataValidation, labelsValidation, dataTest, labelsTest, dataTestPaths, folders] = training_model();

    % Save the best model
    newModelFile = sprintf('SVMModel_%s.mat', datestr(now, 'yyyy-mm-dd_HH-MM-SS'));
    save(newModelFile, 'svmModel', 'dataTest', 'labelsTest', 'dataTestPaths', 'folders');
    fprintf('Best model saved as: %s\n', newModelFile);

end


% Test the model

predictedLabels = predict(svmModel, dataTest);
disp(length(predictedLabels));
disp(size(dataTest));


accuracy = sum(predictedLabels == labelsTest) / length(labelsTest);


% Display the accuracy
disp(['Accuracy: ', num2str(accuracy * 100), '%']);


% Display images with incorrect predictions
folderNames = folders;
incorrectIndices = find(predictedLabels ~= labelsTest);
figure;
sgtitle('Incorrect Predictions');
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


% Display sample images with predictions and actual labels
figure;
folderNames = folders;
sgtitle('Sample Predictions');
% Generate sampleIndices within the range of labelsTest
numSamples = min(10, length(labelsTest)); % To handle cases where labelsTest has fewer than 10 elements
sampleIndices = randperm(length(labelsTest), numSamples);
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

predictedLabels = predict(svmModel, dataTest);
