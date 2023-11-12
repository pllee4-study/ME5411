% Run script to load image
scriptPath = fileparts(mfilename('fullpath'));
rootPath = fileparts(scriptPath);
run(fullfile(rootPath, 'scripts/utility/loadImageFromLocalOrOnline.m'));
addpath(fullfile(rootPath, 'scripts/part1'));

% Read the image
img = imageLoaded;

% Create a structuring element
se = strel('disk', 5);  % Create a disk-shaped structuring element with radius 5 pixels

% Perform image filtering using the structuring element
openedImage = imopen(img, se);  % Perform opening operation

% Convert the image to grayscale
imgGrayScale = rgb2gray(img);
openedImgGrayScale = rgb2gray(openedImage);

% Define the 3x3 and 5x5 averaging mask
threeByThreeAverageMask = ones(3) / 9;
fiveByFiveAverageMask = ones(5) / 25;

% Apply the averaging mask using the conv2 function
threeByThreeImgAverage = conv2(double(imgGrayScale), threeByThreeAverageMask, 'same');
fiveByFiveImgAverage = conv2(double(imgGrayScale), fiveByFiveAverageMask, 'same');

enhancedThreeByThreeImgAverage = conv2(double(openedImgGrayScale), threeByThreeAverageMask, 'same');
enhancedFiveByFiveImgAverage = conv2(double(openedImgGrayScale), fiveByFiveAverageMask, 'same');

% Define the 3x3 and 5x5 rotating mask
threeByThreeRotMask = [3 5 3; 5 8 5; 3 5 3] / 200;
fiveByFiveRotMask = [5 6 9 6 5; 6 7 11 7 6; 9 11 16 11 9; 6 7 11 7 6; 5 6 9 6 5] / 1648;

enhancedThreeByThreeRotMask = [3 5 3; 5 8 5; 3 5 3] / 50;
enhancedFiveByFiveRotMask = [5 6 9 6 5; 6 7 11 7 6; 9 11 16 11 9; 6 7 11 7 6; 5 6 9 6 5] / 412;

% Apply the rotating mask using the conv2 function
threeByThreeImgRotate = conv2(double(imgGrayScale), threeByThreeRotMask, 'same');
fiveByFiveImgRotate = conv2(double(imgGrayScale), fiveByFiveRotMask, 'same');

enhancedThreeByThreeImgRotate = conv2(double(openedImgGrayScale), enhancedThreeByThreeRotMask, 'same');
enhancedFiveByFiveImgRotate = conv2(double(openedImgGrayScale), enhancedFiveByFiveRotMask, 'same');

% Perform image filtering using the structuring element
dilatedImage = imdilate(img, se);  % Perform dilation
erodedImage = imerode(img, se);    % Perform erosion
closedImage = imclose(img, se);  % Perform closing operation
outlineImage = dilatedImage - erodedImage;

% Display the original image and the processed images
figure('Name', 'Raw');
subplot(4, 3, 1), imshow(img), title('Original Image');
subplot(4, 3, 2), imshow(openedImage), title('Opened Image');
subplot(4, 3, 3), imshow(closedImage), title('Closed Image');
subplot(4, 3, 4), imshow(uint8(threeByThreeImgAverage)), title('Averaging Mask(3x3)');
subplot(4, 3, 5), imshow(uint8(threeByThreeImgRotate)), title('Rotating Mask(3x3)');
subplot(4, 3, 6), imshow(dilatedImage), title('Dilated Image');
subplot(4, 3, 7), imshow(uint8(fiveByFiveImgAverage)), title('Averaging Mask(5x5)');
subplot(4, 3, 8), imshow(uint8(fiveByFiveImgRotate)), title('Rotating Mask(5x5)');
subplot(4, 3, 9), imshow(erodedImage), title('Eroded Image');
subplot(4, 3, 12), imshow(outlineImage), title('Outline Image');

[rows, cols, ~] = size(uint8(img));
startingRow = (rows / 2) + 1;
subImage = img(int32(startingRow) : int32(rows), :, :);

grayScaleSubImage = rgb2gray(subImage);

% Convert the grayscale image to binary
binarySubImage = imbinarize(grayScaleSubImage, 0.4617);

[enhancedRows, enhancedCols, ~] = size(uint8(openedImage));
enhancedSubImage = openedImage(int32((enhancedRows / 2) + 1) : int32(enhancedRows), :, :);

enhancedGrayScaleSubImage = rgb2gray(enhancedSubImage);
enhancedBinarySubImage = imbinarize(enhancedGrayScaleSubImage, 0.4169);

subplot(4, 3, 10), imshow(subImage), title('SubImage');
subplot(4, 3, 11), imshow(binarySubImage), title('Binary SubImage');

figPos = get(gcf, 'Position');
figWidth = figPos(3);
figHeight = figPos(4);

sliderLeft = 0.1 * figWidth;  % 10% from the left edge of the figure
sliderBottom = 0.1 * figHeight;  % 10% from the bottom edge of the figure
sliderWidth = 0.8 * figWidth;  % 80% of the figure width
sliderHeight = 0.05 * figHeight;  % 5% of the figure height

slider = uicontrol('style', 'slider', 'position', [sliderLeft, sliderBottom, sliderWidth, sliderHeight], 'callback', @(src, event) updateThreshold(src, grayScaleSubImage));
set(slider, 'Min', 0, 'Max', 1, 'Value', 0.4617, 'SliderStep', [0.01 0.1], 'UserData', binarySubImage, 'Tag', 'ThresholdSlider');

addlistener(slider, 'ContinuousValueChange', @(src, event) updateThreshold(src, grayScaleSubImage));

% Special handling for better outline performance
gaussOpenedImage = imgaussfilt(rgb2gray(openedImage), 2);
binarizedGaussOpenedImage = imbinarize(gaussOpenedImage, 0.428571);
enhancedDilatedImage = imdilate(binarizedGaussOpenedImage, se);
enhancedErodeImage = imerode(binarizedGaussOpenedImage, se);
enhancedOutlineImage = enhancedDilatedImage - enhancedErodeImage;

figure('Name', 'Final');
subplot(4, 3, 1), imshow(img), title('Original Image');

% from preProcessingTuning.m
getFinalResultFromPreProcessingTuning(img, 4, 3, 2, 'Labelled Image');

subplot(4, 3, 3), imshow(imcomplement(enhancedOutlineImage)), title('Enhanced Complement Outline Image');
subplot(4, 3, 4), imshow(uint8(enhancedThreeByThreeImgAverage)), title('Enhanced Averaging Mask(3x3)');
subplot(4, 3, 5), imshow(uint8(enhancedThreeByThreeImgRotate)), title('Enhanced Rotating Mask(3x3)');
subplot(4, 3, 6), imshow(enhancedDilatedImage), title('Enhanced Dilated Image');
subplot(4, 3, 7), imshow(uint8(enhancedFiveByFiveImgAverage)), title('Enchanced Averaging Mask(5x5)');
subplot(4, 3, 8), imshow(uint8(enhancedFiveByFiveImgRotate)), title('Enchanced Rotating Mask(5x5)');
subplot(4, 3, 9), imshow(enhancedErodeImage), title('Enhanced Eroded Image');
subplot(4, 3, 12), imshow(enhancedOutlineImage), title('Enhanced Outline Image');

subplot(4, 3, 10), imshow(enhancedSubImage), title('Enhanced SubImage');
subplot(4, 3, 11), imshow(enhancedBinarySubImage), title('Enhanced Binary SubImage');

enhancedSlider = uicontrol('style', 'slider', 'position', [sliderLeft, sliderBottom, sliderWidth, sliderHeight], 'callback', @(src, event) updateThreshold(src, enhancedGrayScaleSubImage));
set(enhancedSlider, 'Min', 0, 'Max', 1, 'Value', 0.4169, 'SliderStep', [0.01 0.1], 'UserData', enhancedSubImage, 'Tag', 'ThresholdSlider');

addlistener(enhancedSlider, 'ContinuousValueChange', @(src, event) updateThreshold(src, enhancedGrayScaleSubImage));

function updateThreshold(sliderValue, grayScaleSubImage)
    threshold = get(sliderValue, 'Value');
    disp(threshold);
    try
        binarySubImage = imbinarize(grayScaleSubImage, threshold);
    catch ME
        error('Failed to convert the image to binary: %s', ME.message);
    end
    subplot(4, 3, 11), imshow(binarySubImage), title('Binary SubImage');
end

function getFinalResultFromPreProcessingTuning(image, row, column, index, name)
    se = strel('line', 11, 90); % Create a line-shaped structuring element with angle of 90
    openedImage = imopen(image, se);  % Perform opening operation
    openedImageGrayScale = rgb2gray(openedImage);
    gaussOpenedImage = imgaussfilt(openedImageGrayScale, 2);
    binarizedGaussOpenedImage = imbinarize(gaussOpenedImage, 0.417143);
    erodedImage = imerode(binarizedGaussOpenedImage, se);
    erodedImage = bwareaopen(erodedImage, 100);
    cc = bwconncomp(erodedImage, 4);
    props = regionprops(cc, 'BoundingBox');
    labelMatrix = double(labelmatrix(cc));
    numCc = max(labelMatrix(:));  % Number of connected components
    coloredLabels = label2rgb(labelMatrix, turbo(numCc), 'k', 'shuffle');
    minWidth = Inf;

    % Find the smallest rectangle width
    for i = 1:numel(props)
        width = props(i).BoundingBox(3);
        if width < minWidth
            minWidth = width;
        end
    end
    splitThreshold = 1.7;  % Threshold to determine if the width is significantly larger
    for i = 1:numel(props)
        % Check if the width is significantly larger than the minWidth
        width = props(i).BoundingBox(3);
        if width > splitThreshold * minWidth
            % Split the rectangle into two equal-width rectangles
            halfWidth = width / 2;
            x = int32(props(i).BoundingBox(1));
            y = int32(props(i).BoundingBox(2));
            height = int32(props(i).BoundingBox(4));  
            coloredLabels(y : y + height, x : x + halfWidth, 1) = 10; 
        end
    end
    subplot(row, column, index), imshow(coloredLabels), title(name);
end