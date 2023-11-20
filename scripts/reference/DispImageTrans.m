% Image Transformations for Data Improvement

% Select the first image for demonstration
folderPath = '../assets/modified_dataset/H';

% Define transformations
%transformations = {'original_', 'negative_', 'noPadding_', 'morePadding_', 'vertical_stretch_', 'horizontal_stretch_', 'gaussian_noise_', 'sp_noise_', 'crop_neg_', 'comb_crop_neg_gau_', 'comb_crop_neg_sp_'};
transformations = {'original_', 'negative_', 'noPadding_', 'morePadding_', 'gaussian_noise_', 'sp_noise_', 'crop_neg_', 'comb_crop_neg_gau_', 'comb_crop_neg_sp_'};
% Number of transformations (including the original)
numTransformations = length(transformations);

% Select the first 'original' image for demonstration
originalImages = dir(fullfile(folderPath, 'original_*.png'));
if isempty(originalImages)
    error('No original images found in the specified folder.');
end
baseImgName = erase(originalImages(1).name, 'original_'); % Remove the 'original_' prefix

% Create a figure to display the images
figure;
sgtitle('Image Transformations');

% Loop through each transformation and display the image
for i = 1:numTransformations
    % Construct the filename for each transformed image
    transformedImgName = fullfile(folderPath, [transformations{i}, baseImgName]);
    
    % Check if the file exists
    if ~isfile(transformedImgName)
        warning('File does not exist: %s', transformedImgName);
        continue;
    end

    % Read and display the image
    transformedImg = imread(transformedImgName);
    subplot(2, ceil(numTransformations / 2), i);
    imshow(transformedImg);
    title(transformations{i});
end

% % Create a figure to display the images
% figure;
% sgtitle('Image Transformations');
% 
% % Loop through each transformation and display the image
% for i = 1:numTransformations
%     % Construct the filename for each transformed image
%     transformedImgName = fullfile(folderPath, [transformations{i}, baseName]);
% 
%     % Read and display the image
%     transformedImg = imread(transformedImgName);
%     subplot(2, ceil(numTransformations / 2), i);
%     imshow(transformedImg);
%     title(transformations{i});
% end
