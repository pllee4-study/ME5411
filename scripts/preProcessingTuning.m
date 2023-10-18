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

defaultValues.radius = 8;
defaultValues.threshold = 100;
defaultValues.sigma = 4;

% ImagePreProcessingTuningTools
tuningTools = ImagePreProcessingTuningTools(figSize, defaultValues);
tuningTools.setDiskRadiusUpdatedCallback(@diskRadiusUpdatedCallback);
tuningTools.setGaussSigmaUpdatedCallback(@sigmaUpdatedCallback);

global preprocessor;
preprocessor = ImagePreProcessor(imageLoaded, defaultValues);

global openedImage;

global openedThenAdjustImage;
global adjustedThenOpenImage;

global gaussOpenedImage;
global gaussAdjustedImage;
global gaussAdjustedThenOpenImage;
global gaussOpenedThenAdjustImage;

global adjustedImage;

ImagePreProcessingTuningPlot.plot("OpenedImage", openedImage);
ImagePreProcessingTuningPlot.plot("OpenedThenAdjustImage", openedThenAdjustImage);
ImagePreProcessingTuningPlot.plot("AdjustedThenOpenImage", adjustedThenOpenImage);
ImagePreProcessingTuningPlot.plot("AdjustedImage", adjustedImage);
ImagePreProcessingTuningPlot.plot("GaussOpenedImage", gaussOpenedImage);
ImagePreProcessingTuningPlot.plot("GaussAdjustedThenOpenImage", gaussAdjustedThenOpenImage);
ImagePreProcessingTuningPlot.plot("GaussOpenedThenAdjustImage", gaussOpenedThenAdjustImage);

function diskRadiusUpdatedCallback(value)
    global preprocessor;
    preprocessor.updateDiskRadius(value);

    global openedImage;
    global openedThenAdjustImage;
    global adjustedThenOpenImage;
    global gaussOpenedImage;
    global gaussAdjustedThenOpenImage;
    global gaussOpenedThenAdjustImage;

    % replot any processing related to open
    ImagePreProcessingTuningPlot.plot("OpenedImage", openedImage);
    ImagePreProcessingTuningPlot.plot("OpenedThenAdjustImage", openedThenAdjustImage);
    ImagePreProcessingTuningPlot.plot("AdjustedThenOpenImage", adjustedThenOpenImage);
    ImagePreProcessingTuningPlot.plot("GaussOpenedImage", gaussOpenedImage);
    ImagePreProcessingTuningPlot.plot("GaussAdjustedThenOpenImage", gaussAdjustedThenOpenImage);
    ImagePreProcessingTuningPlot.plot("GaussOpenedThenAdjustImage", gaussOpenedThenAdjustImage);
end

function sigmaUpdatedCallback(value)
    global preprocessor;
    preprocessor.updateGaussSigma(value);

    global gaussOpenedImage;
    global gaussAdjustedThenOpenImage;
    global gaussOpenedThenAdjustImage;

    % replot any processing related to gaussian filtering
    ImagePreProcessingTuningPlot.plot("GaussOpenedImage", gaussOpenedImage);
    ImagePreProcessingTuningPlot.plot("GaussAdjustedThenOpenImage", gaussAdjustedThenOpenImage);
    ImagePreProcessingTuningPlot.plot("GaussOpenedThenAdjustImage", gaussOpenedThenAdjustImage);
end