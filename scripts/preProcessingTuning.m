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

preprocessor = ImagePreProcessor(imageLoaded, defaultValues);
ImagePreProcessingTuningPlot.plot("OpenedImage", preprocessor.openedImage);
ImagePreProcessingTuningPlot.plot("OpenedThenAdjustImage", preprocessor.openedThenAdjustImage);
ImagePreProcessingTuningPlot.plot("AdjustedThenOpenImage", preprocessor.adjustedThenOpenImage);
ImagePreProcessingTuningPlot.plot("AdjustedImage", preprocessor.adjustedImage);
ImagePreProcessingTuningPlot.plot("GaussOpenedImage", preprocessor.gaussOpenedImage);
ImagePreProcessingTuningPlot.plot("GaussAdjustedThenOpenImage", preprocessor.gaussAdjustedThenOpenImage);
ImagePreProcessingTuningPlot.plot("GaussOpenedThenAdjustImage", preprocessor.gaussOpenedThenAdjustImage);
ImagePreProcessingTuningPlot.plot("GaussAdjustedImage", preprocessor.gaussAdjustedImage);

ImagePreProcessingTuningPlot.plot("BinarizedOpenedImage", preprocessor.binarizedOpenedImage);
ImagePreProcessingTuningPlot.plot("BinarizedOpenedThenAdjustImage", preprocessor.binarizedOpenedThenAdjustImage);
ImagePreProcessingTuningPlot.plot("BinarizedAdjustedThenOpenImage", preprocessor.binarizedAdjustedThenOpenImage);
ImagePreProcessingTuningPlot.plot("BinarizedGaussOpenedImage", preprocessor.binarizedGaussOpenedImage);
ImagePreProcessingTuningPlot.plot("BinarizedGaussAdjustedImage", preprocessor.binarizedGaussAdjustedImage);
ImagePreProcessingTuningPlot.plot("BinarizedGaussAdjustedThenOpenImage", preprocessor.binarizedGaussAdjustedThenOpenImage);
ImagePreProcessingTuningPlot.plot("BinarizedGaussOpenedThenAdjustImage", preprocessor.binarizedGaussOpenedThenAdjustImage);
ImagePreProcessingTuningPlot.plot("BinarizedAdjustedImage", preprocessor.binarizedAdjustedImage);

ImagePreProcessingTuningPlot.plot("ErodedImage", preprocessor.erodedImage);

function lineLengthUpdatedCallback(value)
    global preprocessor;
    preprocessor.updateLineLength(value);

    % replot any processing related to open
    ImagePreProcessingTuningPlot.plot("OpenedImage", preprocessor.openedImage);
    ImagePreProcessingTuningPlot.plot("OpenedThenAdjustImage", preprocessor.openedThenAdjustImage);
    ImagePreProcessingTuningPlot.plot("AdjustedThenOpenImage", preprocessor.adjustedThenOpenImage);
    ImagePreProcessingTuningPlot.plot("GaussOpenedImage", preprocessor.gaussOpenedImage);
    ImagePreProcessingTuningPlot.plot("GaussAdjustedThenOpenImage", preprocessor.gaussAdjustedThenOpenImage);
    ImagePreProcessingTuningPlot.plot("GaussOpenedThenAdjustImage", preprocessor.gaussOpenedThenAdjustImage);

    ImagePreProcessingTuningPlot.plot("BinarizedOpenedImage", preprocessor.binarizedOpenedImage);
    ImagePreProcessingTuningPlot.plot("BinarizedOpenedThenAdjustImage", preprocessor.binarizedOpenedThenAdjustImage);
    ImagePreProcessingTuningPlot.plot("BinarizedAdjustedThenOpenImage", preprocessor.binarizedAdjustedThenOpenImage);
    ImagePreProcessingTuningPlot.plot("BinarizedGaussOpenedImage", preprocessor.binarizedGaussOpenedImage);
    ImagePreProcessingTuningPlot.plot("BinarizedGaussAdjustedThenOpenImage", preprocessor.binarizedGaussAdjustedThenOpenImage);
    ImagePreProcessingTuningPlot.plot("BinarizedGaussOpenedThenAdjustImage", preprocessor.binarizedGaussOpenedThenAdjustImage);

    ImagePreProcessingTuningPlot.plot("ErodedImage", preprocessor.erodedImage);
end

function sigmaUpdatedCallback(value)
    global preprocessor;
    preprocessor.updateGaussSigma(value);

    % replot any processing related to gaussian filtering
    ImagePreProcessingTuningPlot.plot("GaussOpenedImage", preprocessor.gaussOpenedImage);
    ImagePreProcessingTuningPlot.plot("GaussAdjustedThenOpenImage", preprocessor.gaussAdjustedThenOpenImage);
    ImagePreProcessingTuningPlot.plot("GaussOpenedThenAdjustImage", preprocessor.gaussOpenedThenAdjustImage);
    ImagePreProcessingTuningPlot.plot("GaussAdjustedImage", preprocessor.gaussAdjustedImage);

    ImagePreProcessingTuningPlot.plot("BinarizedGaussOpenedImage", preprocessor.binarizedGaussOpenedImage);
    ImagePreProcessingTuningPlot.plot("BinarizedGaussAdjustedImage", preprocessor.binarizedGaussAdjustedImage);
    ImagePreProcessingTuningPlot.plot("BinarizedGaussAdjustedThenOpenImage", preprocessor.binarizedGaussAdjustedThenOpenImage);
    ImagePreProcessingTuningPlot.plot("BinarizedGaussOpenedThenAdjustImage", preprocessor.binarizedGaussOpenedThenAdjustImage);

    ImagePreProcessingTuningPlot.plot("ErodedImage", preprocessor.erodedImage);
end

function thresholdUpdatedCallback(value)
    global preprocessor;
    preprocessor.updateBinaryThreshold(value);

    ImagePreProcessingTuningPlot.plot("BinarizedOpenedImage", preprocessor.binarizedOpenedImage);
    ImagePreProcessingTuningPlot.plot("BinarizedOpenedThenAdjustImage", preprocessor.binarizedOpenedThenAdjustImage);
    ImagePreProcessingTuningPlot.plot("BinarizedAdjustedThenOpenImage", preprocessor.binarizedAdjustedThenOpenImage);
    ImagePreProcessingTuningPlot.plot("BinarizedGaussOpenedImage", preprocessor.binarizedGaussOpenedImage);
    ImagePreProcessingTuningPlot.plot("BinarizedGaussAdjustedImage", preprocessor.binarizedGaussAdjustedImage);
    ImagePreProcessingTuningPlot.plot("BinarizedGaussAdjustedThenOpenImage", preprocessor.binarizedGaussAdjustedThenOpenImage);
    ImagePreProcessingTuningPlot.plot("BinarizedGaussOpenedThenAdjustImage", preprocessor.binarizedGaussOpenedThenAdjustImage);
    ImagePreProcessingTuningPlot.plot("BinarizedAdjustedImage", preprocessor.binarizedAdjustedImage);

    ImagePreProcessingTuningPlot.plot("ErodedImage", preprocessor.erodedImage);
end