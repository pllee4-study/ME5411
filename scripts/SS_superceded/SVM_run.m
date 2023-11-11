% Main Script

% Find the most recent model file
files = dir('SVMModel*.mat');
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
        [svmModel, dataTest, labelsTest, dataTestPaths, folders] = trainSVMModel();
        % Save the new model with a unique filename
        newModelFile = sprintf('SVMModel_%s.mat', datestr(now, 'yyyy-mm-dd_HH-MM-SS'));
        save(newModelFile, 'svmModel');
        fprintf('New model saved as: %s\n', newModelFile);
    end
else
    % No models found, train a new one
    [svmModel, dataTest, labelsTest, dataTestPaths, folders] = trainSVMModel();
    % Save the new model
    newModelFile = sprintf('SVMModel_%s.mat', datestr(now, 'yyyy-mm-dd_HH-MM-SS'));
    save(newModelFile, 'svmModel');
    fprintf('New model saved as: %s\n', newModelFile);
end

% Tune the model with cross-validation data (adjust parameters if needed)

% Test the model
predictedLabels = predict(svmModel, dataTest);
accuracy = sum(predictedLabels == labelsTest) / length(labelsTest);


% Print actual vs. predicted labels
fprintf('Actual vs. Predicted Labels:\n');
for i = 1:length(labelsTest)
    fprintf('Actual: %d, Predicted: %d\n', labelsTest(i), predictedLabels(i));
end

% Display the accuracy
disp(['Accuracy: ', num2str(accuracy * 100), '%']);


% Define the mapping from numeric labels to folder names
folderNames = folders;

% Display sample images with predictions and actual labels
numSamples = 10; % Number of samples to display
figure;
sampleIndices = randperm(length(dataTestPaths), min(numSamples, length(dataTestPaths))); % Ensure no out-of-bounds

for i = 1:length(sampleIndices)
    idx = sampleIndices(i);
    labelsTest
    idx

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














% % Display sample images with predictions and actual labels
% numSamples = 10; % Number of samples to display
% figure;
% sampleIndices = randperm(length(dataTestPaths), min(numSamples, length(dataTestPaths))); % Ensure no out-of-bounds
% 
% for i = 1:numSamples
%     idx = sampleIndices(i);
%     imagePath = dataTestPaths{idx};
%     actualLabelName = folderNames{labelsTest(idx)};
%     predictedLabelName = folderNames{predictedLabels(idx)};
% 
%     subplot(2, numSamples/2, i);
%     imshow(imread(imagePath));
%     title(sprintf('Actual: %s, Pred: %s', actualLabelName, predictedLabelName));
% end
% 
% % Display images with incorrect predictions
% incorrectIndices = find(predictedLabels ~= labelsTest);
% figure;
% for i = 1:length(incorrectIndices)
%     idx = incorrectIndices(i);
%     imagePath = dataTestPaths{idx};
%     actualLabelName = folderNames{labelsTest(idx)};
%     predictedLabelName = folderNames{predictedLabels(idx)};
% 
%     subplot(2, ceil(length(incorrectIndices) / 2), i);
%     imshow(imread(imagePath));
%     title(sprintf('Guess: %s, Actual: %s', predictedLabelName, actualLabelName));
% end
% 
% 
% 
% 
% 
% 
% 
% 
% 
% % % Display sample images with predictions and actual labels
% % numSamples = 10; % Number of samples to display
% % figure;
% % for i = 1:numSamples
% %     if i <= length(dataTestPaths)
% %         imagePath = dataTestPaths{i}; 
% %         subplot(2, numSamples/2, i);
% %         imshow(imread(imagePath)); % Directly use imagePath
% %         title(sprintf('Actual: %d, Pred: %d', labelsTest(i), predictedLabels(i)));
% %     end
% % end
% % 
% % % Display images with incorrect predictions
% % incorrectIndices = find(predictedLabels ~= labelsTest);
% % figure;
% % for i = 1:length(incorrectIndices)
% %     if i <= length(incorrectIndices)
% %         imagePath = dataTestPaths{incorrectIndices(i)}; % Use curly braces
% %         subplot(2, ceil(length(incorrectIndices) / 2), i);
% %         imshow(imread(imagePath)); % Directly use imagePath
% %         title(sprintf('Guess: %d, Actual: %d', predictedLabels(incorrectIndices(i)), labelsTest(incorrectIndices(i))));
% %     end
% % end