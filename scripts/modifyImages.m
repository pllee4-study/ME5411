% Pre process data

% Initialize the folders array
folders = {'H', 'D', 'A', '8', '7', '4', '0'};
baseFolderPath = '../assets/p_dataset_26/';

% Define the output folder
outputFolder = '../assets/modified_dataset/';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Loop through each folder
for i = 1:length(folders)
    folderPath = fullfile(baseFolderPath, folders{i}, '*.png');
    images = dir(folderPath);
    fprintf('Processing folder %s\n', folders{i});

    % Determine the label folder (assuming images(i).folder contains the label name)
    [~, labelFolderName, ~] = fileparts(images(i).folder);
    
    % Create the label-specific output folder if it doesn't exist
    labelOutputFolder = fullfile(outputFolder, labelFolderName);
    if ~exist(labelOutputFolder, 'dir')
        mkdir(labelOutputFolder);
    end

    % Loop through each image
    for j = 1:length(images)
        imgPath = fullfile(images(j).folder, images(j).name);
        originalImg = imread(imgPath);
        [rows, cols, ~] = size(originalImg);
        imwrite(originalImg, fullfile(labelOutputFolder, ['original_', images(j).name]));

        % 1. Negative Transformation
        negativeImg = imcomplement(originalImg);
        %imwrite(negativeImg, fullfile(labelOutputFolder, ['negative_', images(j).name]));
    
        % 2. Remove/Add Padding and Resize        
        % Automatically crop the image & Resize back to original 
        croppedImg = autoCropCharacter(originalImg);        
        resizedCroppedImg = imresize(croppedImg, [size(originalImg, 1), size(originalImg, 2)]);
        imwrite(resizedCroppedImg, fullfile(labelOutputFolder, ['noPadding_', images(j).name]));

        % Increase padding
        paddingSize = [10 10]; % Chosen padding size. Can be adjusted
        if size(originalImg, 3) == 1  % Grayscale image
            paddedImg = padarray(originalImg, paddingSize, 255, 'both'); % Add white padding
        else  % Color image
            paddedImg = padarray(originalImg, paddingSize, [255 255 255], 'both'); % Add white padding for color images
        end
        % Resize the padded image back to original size
        resizedBackImg = imresize(paddedImg, [rows, cols]);
        % Save the final image
        % imwrite(resizedBackImg, fullfile(labelOutputFolder, ['morePadding_', images(j).name]));

    
        % % 3. Stretching
        % 
        % % Vertical Stretch
        % verticalStretchImg = imresize(originalImg, [rows * 1.5, cols]); % 50% vertical stretch        
        % % Calculate the amount of padding needed to add horizontally
        % padWidth = cols - size(verticalStretchImg, 2);
        % padLeft = floor(padWidth / 2);
        % padRight = ceil(padWidth / 2);        
        % % Add horizontal padding
        % verticalStretchImgPadded = padarray(verticalStretchImg, [0, padLeft], 255, 'pre');
        % verticalStretchImgPadded = padarray(verticalStretchImgPadded, [0, padRight], 255, 'post');        
        % % Save the vertically stretched and padded image
        % imwrite(verticalStretchImgPadded, fullfile(labelOutputFolder, ['vertical_stretch_', images(j).name]));
        % 
        % % % Horizontal Stretch
        % 
        % % Horizontal Stretch
        % horizontalStretchImg = imresize(originalImg, [rows, cols * 1.5]); % 50% horizontal stretch        
        % % Calculate the amount of padding needed to add vertically
        % padHeight = rows - size(horizontalStretchImg, 1);
        % padTop = floor(padHeight / 2);
        % padBottom = ceil(padHeight / 2);        
        % % Add vertical padding
        % horizontalStretchImgPadded = padarray(horizontalStretchImg, [padTop, 0], 255, 'pre');
        % horizontalStretchImgPadded = padarray(horizontalStretchImgPadded, [padBottom, 0], 255, 'post');        
        % % Save the horizontally stretched and padded image
        % imwrite(horizontalStretchImgPadded, fullfile(labelOutputFolder, ['horizontal_stretch_', images(j).name]));

    
        % 4. Adding Noise
        % Gaussian Noise
        gaussianNoiseImg = imnoise(originalImg, 'gaussian', 0, 0.2);
        % imwrite(gaussianNoiseImg, fullfile(labelOutputFolder, ['gaussian_noise_', images(j).name]));
    
        % Salt and Pepper Noise
        spNoiseImg = imnoise(originalImg, 'salt & pepper', 0.4);
        % imwrite(spNoiseImg, fullfile(labelOutputFolder, ['sp_noise_', images(j).name]));
    
        % Combinations by applying multiple transformations sequentially.
        % Negative transformation followed by adding Gaussian noise
        % and removing pading
        neg_crop = imcomplement(resizedCroppedImg);
        imwrite(neg_crop, fullfile(labelOutputFolder, ['crop_neg_', images(j).name]));

        combinedImg = imnoise(neg_crop, 'gaussian',0, 0.2);
        % imwrite(combinedImg, fullfile(labelOutputFolder, ['comb_crop_neg_gau_', images(j).name]));

        combinedImg2 = imnoise(neg_crop, 'salt & pepper',0.4);
        % imwrite(combinedImg, fullfile(labelOutputFolder, ['comb_crop_neg_sp_', images(j).name]));
    end
end
