
i= 30
baseFolderPath = '../assets/original_dataset/H';
folderPath = fullfile(baseFolderPath, '*.png');
images = dir(folderPath);
imgPath = fullfile(images(i).folder, images(i).name);
originalImg = imread(imgPath);


croppedImg = autoCropCharacter(originalImg);        
resizedCroppedImg = imresize(croppedImg, [size(originalImg, 1), size(originalImg, 2)]);

outputFolder = '../assets/modified_dataset/';
imwrite(resizedCroppedImg, fullfile(outputFolder, ['noPadding_', images(i).name]));