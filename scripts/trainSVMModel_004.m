function [svmModel, dataValidation, labelsValidation, dataTest, labelsTest, dataTestPaths, folders] = trainSVMModel_004()


    % Initialize arrays
    folders = {'H', 'D', 'A', '8', '7', '4', '0'};

    % Calculate total number of images
    totalImages = sum(arrayfun(@(f) numel(dir(fullfile('../assets/modified_dataset/', char(f), '/*.png'))), folders));

    data = cell(1, totalImages);
    labels = cell(1, totalImages);
    allPaths = cell(1, totalImages); % Temporary array to store all image paths    

    currentIndex = 1;

    % Load and process data
    for i = 1:length(folders)
        folderPath = strcat('../assets/modified_dataset/', folders{i}, '/*.png');
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
   
            % Append to data and labels
            data{currentIndex} = features;
            labels{currentIndex} = i;
            allPaths{currentIndex} = imgPath; % Store all paths for visualization  

            % Increment index for the next iteration
            currentIndex = currentIndex + 1;     
        end
    end

    % Split the data
    cv = cvpartition(numel(data), 'HoldOut', 0.25);
    idx = cv.test;
    dataTrain = data(~idx);
    labelsTrain = labels(~idx);
    dataTest = data(idx);
    labelsTest = labels(idx);
    

    dataValidation = {};
    labelsValidation = {};
    % % Further split test data into 0% validation and 10test sets
    % cvTest = cvpartition(numel(dataTest), 'HoldOut', 0);
    % idxTest = cvTest.test;
    % dataValidation = dataTest(~idxTest);
    % labelsValidation = labelsTest(~idxTest);
    % dataTest = dataTest(idxTest);
    % labelsTest = labelsTest(idxTest);
    
    % Now populate dataTestPaths with only the test image paths
    dataTestPaths = allPaths(idx); %
    %dataTestPaths = dataTestPaths(idxTest);

    % Convert from cell array to numeric array
    % dataValidation = cell2mat(dataValidation');
    % labelsValidation = cell2mat(labelsValidation)';

    dataTest = cell2mat(dataTest');
    labelsTest = cell2mat(labelsTest)';

    dataTrain = cell2mat(dataTrain');
    labelsTrain = cell2mat(labelsTrain)';

    % Train the SVM for multi-class classification
    svmModel = fitcecoc(dataTrain, labelsTrain);
    fprintf('Model training complete.\n');
end
