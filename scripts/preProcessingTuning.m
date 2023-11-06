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

defaultValues.length = 11;
defaultValues.threshold = 0.417143;
defaultValues.sigma = 2;

% ImagePreProcessingTuningTools
tuningTools = ImagePreProcessingTuningTools(figSize, defaultValues);
tuningTools.setLineLengthUpdatedCallback(@lineLengthUpdatedCallback);
tuningTools.setGaussSigmaUpdatedCallback(@sigmaUpdatedCallback);
tuningTools.setBinaryThresholdUpdatedCallback(@thresholdUpdatedCallback);

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

global binarizedOpenedImage;

global binarizedOpenedThenAdjustImage;
global binarizedAdjustedThenOpenImage;

global binarizedGaussOpenedImage;
global binarizedGaussAdjustedImage;
global binarizedGaussAdjustedThenOpenImage;
global binarizedGaussOpenedThenAdjustImage;

global binarizedAdjustedImage;

global erodedImage;

ImagePreProcessingTuningPlot.plot("OpenedImage", openedImage);
ImagePreProcessingTuningPlot.plot("OpenedThenAdjustImage", openedThenAdjustImage);
ImagePreProcessingTuningPlot.plot("AdjustedThenOpenImage", adjustedThenOpenImage);
ImagePreProcessingTuningPlot.plot("AdjustedImage", adjustedImage);
ImagePreProcessingTuningPlot.plot("GaussOpenedImage", gaussOpenedImage);
ImagePreProcessingTuningPlot.plot("GaussAdjustedThenOpenImage", gaussAdjustedThenOpenImage);
ImagePreProcessingTuningPlot.plot("GaussOpenedThenAdjustImage", gaussOpenedThenAdjustImage);
ImagePreProcessingTuningPlot.plot("GaussAdjustedImage", gaussAdjustedImage);

ImagePreProcessingTuningPlot.plot("BinarizedOpenedImage", binarizedOpenedImage);
ImagePreProcessingTuningPlot.plot("BinarizedOpenedThenAdjustImage", binarizedOpenedThenAdjustImage);
ImagePreProcessingTuningPlot.plot("BinarizedAdjustedThenOpenImage", binarizedAdjustedThenOpenImage);
ImagePreProcessingTuningPlot.plot("BinarizedGaussOpenedImage", binarizedGaussOpenedImage);
ImagePreProcessingTuningPlot.plot("BinarizedGaussAdjustedImage", binarizedGaussAdjustedImage);
ImagePreProcessingTuningPlot.plot("BinarizedGaussAdjustedThenOpenImage", binarizedGaussAdjustedThenOpenImage);
ImagePreProcessingTuningPlot.plot("BinarizedGaussOpenedThenAdjustImage", binarizedGaussOpenedThenAdjustImage);
ImagePreProcessingTuningPlot.plot("BinarizedAdjustedImage", binarizedAdjustedImage);

ImagePreProcessingTuningPlot.plot("ErodedImage", erodedImage);

function lineLengthUpdatedCallback(value)
    global preprocessor;
    preprocessor.updateLineLength(value);

    global openedImage;
    global openedThenAdjustImage;
    global adjustedThenOpenImage;
    global gaussOpenedImage;
    global gaussAdjustedThenOpenImage;
    global gaussOpenedThenAdjustImage;

    global binarizedOpenedImage;
    global binarizedOpenedThenAdjustImage;
    global binarizedAdjustedThenOpenImage;
    global binarizedGaussOpenedImage;
    global binarizedGaussAdjustedThenOpenImage;
    global binarizedGaussOpenedThenAdjustImage;

    global erodedImage;

    % replot any processing related to open
    ImagePreProcessingTuningPlot.plot("OpenedImage", openedImage);
    ImagePreProcessingTuningPlot.plot("OpenedThenAdjustImage", openedThenAdjustImage);
    ImagePreProcessingTuningPlot.plot("AdjustedThenOpenImage", adjustedThenOpenImage);
    ImagePreProcessingTuningPlot.plot("GaussOpenedImage", gaussOpenedImage);
    ImagePreProcessingTuningPlot.plot("GaussAdjustedThenOpenImage", gaussAdjustedThenOpenImage);
    ImagePreProcessingTuningPlot.plot("GaussOpenedThenAdjustImage", gaussOpenedThenAdjustImage);

    ImagePreProcessingTuningPlot.plot("BinarizedOpenedImage", binarizedOpenedImage);
    ImagePreProcessingTuningPlot.plot("BinarizedOpenedThenAdjustImage", binarizedOpenedThenAdjustImage);
    ImagePreProcessingTuningPlot.plot("BinarizedAdjustedThenOpenImage", binarizedAdjustedThenOpenImage);
    ImagePreProcessingTuningPlot.plot("BinarizedGaussOpenedImage", binarizedGaussOpenedImage);
    ImagePreProcessingTuningPlot.plot("BinarizedGaussAdjustedThenOpenImage", binarizedGaussAdjustedThenOpenImage);
    ImagePreProcessingTuningPlot.plot("BinarizedGaussOpenedThenAdjustImage", binarizedGaussOpenedThenAdjustImage);

    ImagePreProcessingTuningPlot.plot("ErodedImage", erodedImage);
end

function sigmaUpdatedCallback(value)
    global preprocessor;
    preprocessor.updateGaussSigma(value);

    global gaussOpenedImage;
    global gaussAdjustedThenOpenImage;
    global gaussOpenedThenAdjustImage;
    global gaussAdjustedImage;

    global binarizedGaussOpenedImage;
    global binarizedGaussAdjustedImage;
    global binarizedGaussAdjustedThenOpenImage;
    global binarizedGaussOpenedThenAdjustImage;

    global erodedImage;

    % replot any processing related to gaussian filtering
    ImagePreProcessingTuningPlot.plot("GaussOpenedImage", gaussOpenedImage);
    ImagePreProcessingTuningPlot.plot("GaussAdjustedThenOpenImage", gaussAdjustedThenOpenImage);
    ImagePreProcessingTuningPlot.plot("GaussOpenedThenAdjustImage", gaussOpenedThenAdjustImage);
    ImagePreProcessingTuningPlot.plot("GaussAdjustedImage", gaussAdjustedImage);

    ImagePreProcessingTuningPlot.plot("BinarizedGaussOpenedImage", binarizedGaussOpenedImage);
    ImagePreProcessingTuningPlot.plot("BinarizedGaussAdjustedImage", binarizedGaussAdjustedImage);
    ImagePreProcessingTuningPlot.plot("BinarizedGaussAdjustedThenOpenImage", binarizedGaussAdjustedThenOpenImage);
    ImagePreProcessingTuningPlot.plot("BinarizedGaussOpenedThenAdjustImage", binarizedGaussOpenedThenAdjustImage);

    ImagePreProcessingTuningPlot.plot("ErodedImage", erodedImage);
end

function thresholdUpdatedCallback(value)
    global preprocessor;
    preprocessor.updateBinaryThreshold(value);

    global binarizedOpenedImage;

    global binarizedOpenedThenAdjustImage;
    global binarizedAdjustedThenOpenImage;

    global binarizedGaussOpenedImage;
    global binarizedGaussAdjustedImage;
    global binarizedGaussAdjustedThenOpenImage;
    global binarizedGaussOpenedThenAdjustImage;

    global binarizedAdjustedImage;
    global erodedImage;

    ImagePreProcessingTuningPlot.plot("BinarizedOpenedImage", binarizedOpenedImage);
    ImagePreProcessingTuningPlot.plot("BinarizedOpenedThenAdjustImage", binarizedOpenedThenAdjustImage);
    ImagePreProcessingTuningPlot.plot("BinarizedAdjustedThenOpenImage", binarizedAdjustedThenOpenImage);
    ImagePreProcessingTuningPlot.plot("BinarizedGaussOpenedImage", binarizedGaussOpenedImage);
    ImagePreProcessingTuningPlot.plot("BinarizedGaussAdjustedImage", binarizedGaussAdjustedImage);
    ImagePreProcessingTuningPlot.plot("BinarizedGaussAdjustedThenOpenImage", binarizedGaussAdjustedThenOpenImage);
    ImagePreProcessingTuningPlot.plot("BinarizedGaussOpenedThenAdjustImage", binarizedGaussOpenedThenAdjustImage);
    ImagePreProcessingTuningPlot.plot("BinarizedAdjustedImage", binarizedAdjustedImage);

    ImagePreProcessingTuningPlot.plot("ErodedImage", erodedImage);
end