% Run script to load image
scriptPath = fileparts(mfilename('fullpath'));
rootPath = fileparts(scriptPath);
run(fullfile(rootPath, 'scripts/utility/loadImageFromLocalOrOnline.m'));
addpath(fullfile(rootPath, 'scripts/part1'));

% Read the image
img = imageLoaded;

% Create a structuring element
se = strel('disk', 6);  % Create a disk-shaped structuring element with radius 6 pixels

% Perform image filtering using the structuring element
openedImage = imopen(img, se);  % Perform opening operation

% Convert the image to grayscale
imgGrayScale = rgb2gray(img);

% Define the 3x3 and 5x5 averaging mask
threeByThreeAverageMask = ones(3) / 9;
fiveByFiveAverageMask = ones(5) / 25;

% Apply the averaging mask using the conv2 function
threeByThreeImgAverage = conv2(double(imgGrayScale), threeByThreeAverageMask, 'same');
fiveByFiveImgAverage = conv2(double(imgGrayScale), fiveByFiveAverageMask, 'same');

% Define the 3x3 and 5x5 rotating mask
% threeByThreeRotMask = [3 5 3; 5 8 5; 3 5 3] / 200;
% fiveByFiveRotMask = [5 6 9 6 5; 6 7 11 7 6; 9 11 16 11 9; 6 7 11 7 6; 5 6 9 6 5] / 1648;
threeByThreeRotMask = [3 5 3; 5 8 5; 3 5 3] / 50;
fiveByFiveRotMask = [5 6 9 6 5; 6 7 11 7 6; 9 11 16 11 9; 6 7 11 7 6; 5 6 9 6 5] / 412;

% Apply the rotating mask using the conv2 function
threeByThreeImgRotate = conv2(double(imgGrayScale), threeByThreeRotMask, 'same');
fiveByFiveImgRotate = conv2(double(imgGrayScale), fiveByFiveRotMask, 'same');

% Perform image filtering using the structuring element
dilatedImage = imdilate(uint8(threeByThreeImgAverage), se);  % Perform dilation
erodedImage = imerode(uint8(threeByThreeImgAverage), se);    % Perform erosion
closedImage = imclose(uint8(threeByThreeImgAverage), se);  % Perform closing operation
outlineImage = dilatedImage - erodedImage;

% Display the original image and the processed images
figure('Name', 'ME5411 Group 11');
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

[rows, cols, ~] = size(uint8(threeByThreeImgAverage));
startingRow = (rows / 2) + 1;
subImage = img(int32(startingRow) : int32(rows), :, :);

grayScaleSubImage = rgb2gray(subImage);

% Convert the grayscale image to binary
binarySubImage = imbinarize(grayScaleSubImage, 0.3852);

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
set(slider, 'Min', 0, 'Max', 1, 'Value', 0.5, 'SliderStep', [0.01 0.1], 'UserData', binarySubImage, 'Tag', 'ThresholdSlider');

addlistener(slider, 'ContinuousValueChange', @(src, event) updateThreshold(src, grayScaleSubImage));

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