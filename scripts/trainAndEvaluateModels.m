function [bestModel, bestAccuracy, dataTest, labelsTest, dataTestPaths, folders] = trainAndEvaluateModels(modelFunc, numModels)
    % Train multiple models and evaluate them to select the best one

    % Train models
    models = cell(1, numModels);
    for i = 1:numModels
        [svmModel, dataValidation, labelsValidation, dataTest, labelsTest, dataTestPaths, folders] = modelFunc();
        models{i} = {svmModel, dataValidation, labelsValidation, dataTest, labelsTest, dataTestPaths, folders};
    end

    % Evaluate models based on Cross Validation Set
    accuracies = zeros(1, numModels);
    for i = 1:numModels
        [svmModel, dataValidation, labelsValidation, ~, ~, ~, ~] = models{i}{:};
        predictedLabels = predict(svmModel, dataValidation);
        accuracies(i) = sum(predictedLabels == labelsValidation) / length(labelsValidation);
    end

    % Select the best model
    [bestAccuracy, bestModelIndex] = max(accuracies);
    [bestModel, ~, ~, dataTest, labelsTest, dataTestPaths, folders] = models{bestModelIndex}{:};

    % Display the best model info
    disp(['Best Model Index: ', num2str(bestModelIndex)]);
    disp(['Best Model Accuracy: ', num2str(bestAccuracy)]);
end
