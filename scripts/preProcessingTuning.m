% Run script to load image
scriptPath = fileparts(mfilename('fullpath'));
rootPath = fileparts(scriptPath);
run(fullfile(rootPath, 'scripts/utility/loadImageFromLocalOrOnline.m'));

addpath(fullfile(rootPath, 'scripts/part1'));
addpath(fullfile(rootPath, 'scripts/part1/plotter'));
addpath(fullfile(rootPath, 'scripts/part1/preprocessor'));
addpath(fullfile(rootPath, 'scripts/part1/tuningTools'));

% Show the impact of using different appraoches for preprocessing
figure('Name', 'ME5411 Group 11 PreProcessing');
figPos = get(gcf, 'Position');
figSize.width = figPos(3);
figSize.height = figPos(4);

defaultValues.radius = 6;
defaultValues.threshold = 100;
defaultValues.sigma = 4;

% ImagePreProcessingTuningTools
tuningTools = ImagePreProcessingTuningTools(figSize, defaultValues);
tuningTools.setDiskRadiusUpdatedCallback(@diskRadiusUpdatedCallback);

global preprocessor;
preprocessor = ImagePreProcessor(imageLoaded, defaultValues);

global openedImage;
ImagePreProcessingTuningPlot.plot(openedImage);

function diskRadiusUpdatedCallback(value)
    global preprocessor;
    preprocessor.updateDiskRadius(value);
    global openedImage;
    ImagePreProcessingTuningPlot.plot(openedImage);
end