function [svmModel, dataTest, labelsTest, dataTestPaths, folders] = trainSVMModel()
    % Initialize arrays
    data = []; 
    labels = [];
    allPaths = {}; % Temporary array to store all image paths
    dataTestPaths = {}; % Store paths of test images for later visualization
    folders = {'H', 'D', 'A', '8', '7', '4', '0'};

    % Load and process data
    for i = 1:length(folders)
        folderPath = strcat('../assets/p_dataset_26_v2/', folders{i}, '/*.png');
        images = dir(folderPath);
        fprintf('Processing folder %s\n', folders{i});
        for j = 1:length(images)
            imgPath = fullfile(images(j).folder, images(j).name);
            img = imread(imgPath);

            % Convert to grayscale if the image is colored
            if size(img, 3) == 3
                img = rgb2gray(img);
            end

            % Extract HOG features
            features = extractHOGFeatures(img);
            % if i == 1
            %     disp(features);
            % end
            % Append to data and labels
            data = [data; [features]];
            labels = [labels; i];
            allPaths{end+1} = imgPath; % Store all paths for visualization            
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
    
    % Now populate dataTestPaths with only the test image paths
    dataTestPaths = allPaths(idx); %

    % Train the SVM for multi-class classification
    svmModel = fitcecoc(dataTrain, labelsTrain);
    fprintf('Model training complete.\n');
end
