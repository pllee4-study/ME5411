classdef ImagePreProcessor < handle
    properties
        image

        length

        sigma

        threshold

        % input
        openedImage;

        openedThenAdjustImage;
        adjustedThenOpenImage;

        gaussOpenedImage;
        gaussAdjustedImage;
        gaussAdjustedThenOpenImage;
        gaussOpenedThenAdjustImage;

        adjustedImage;

        % binarized output
        binarizedOpenedImage;

        binarizedOpenedThenAdjustImage;
        binarizedAdjustedThenOpenImage;

        binarizedGaussOpenedImage;
        binarizedGaussAdjustedImage;
        binarizedGaussAdjustedThenOpenImage;
        binarizedGaussOpenedThenAdjustImage;

        binarizedAdjustedImage;

        erodedImage;
    end

    methods (Access = public)
        function obj = ImagePreProcessor(image, defaultValues)
            obj.image = image;
            obj.length = defaultValues.length;
            obj.sigma = defaultValues.sigma;
            obj.threshold = defaultValues.threshold;

            obj.adjustedImage = imadjust(rgb2gray(obj.image));
            obj.performMorphologicalProcess();
        end

        function updateLineLength(obj, length)
            obj.length = length;
            obj.performMorphologicalProcess();
        end

        function updateGaussSigma(obj, sigma)
            obj.sigma = sigma;
            obj.performSigmaUpdate();
        end

        function updateBinaryThreshold(obj, threshold)
            obj.threshold = threshold;
            obj.performThresholdUpdate();
        end

    end

    methods(Access = private)
        function performMorphologicalProcess(obj)
            se = strel('line', obj.length, 90); % Create a line-shaped structuring element with angle of 90
            obj.openedImage = imopen(obj.image, se);  % Perform opening operation
            obj.performOpenImageUpdate();
        end

        function performOpenImageUpdate(obj)
            obj.doOpenThenAdjustImage();
            obj.doAdjustedThenOpenImage();

            % The sequence here is crucial
            obj.performSigmaUpdate();
            obj.doErodeImage();
        end

        function performSigmaUpdate(obj)
            obj.doGaussOpenedImage();
            obj.doGaussAdjustedImage();
            obj.doGaussOpenedThenAdjustedImage();
            obj.doGaussAdjustedThenOpenImage();

            obj.performThresholdUpdate();
        end

        function performThresholdUpdate(obj)
            obj.doBinarizeImage();
            obj.doErodeImage();
        end

        function doOpenThenAdjustImage(obj)
            openedImageGrayScale = rgb2gray(obj.openedImage);
            obj.openedThenAdjustImage = imadjust(openedImageGrayScale);
        end

        function doAdjustedThenOpenImage(obj)
            se = strel('line', obj.length, 90);
            obj.adjustedThenOpenImage = imopen(obj.adjustedImage, se);
        end

        function doErodeImage(obj)
            se = strel('line', obj.length, 90);
            obj.erodedImage = imerode(obj.binarizedGaussOpenedImage, se);    % Perform erosion
            obj.erodedImage = bwareaopen(obj.erodedImage, 100);
        end

        function doGaussOpenedImage(obj)
            openedImageGrayScale = rgb2gray(obj.openedImage);
            obj.gaussOpenedImage = imgaussfilt(openedImageGrayScale, obj.sigma);
        end

        function doGaussAdjustedImage(obj)
            obj.gaussAdjustedImage = imgaussfilt(obj.adjustedImage, obj.sigma);
        end

        function doGaussOpenedThenAdjustedImage(obj)
            obj.gaussOpenedThenAdjustImage = imgaussfilt(obj.openedThenAdjustImage, obj.sigma);
        end

        function doGaussAdjustedThenOpenImage(obj)
            obj.gaussAdjustedThenOpenImage = imgaussfilt(obj.adjustedThenOpenImage, obj.sigma);
        end

        function doBinarizeImage(obj)
            obj.binarizedOpenedImage = imbinarize(rgb2gray(obj.openedImage), obj.threshold);
            obj.binarizedOpenedThenAdjustImage = imbinarize(obj.openedThenAdjustImage, obj.threshold);
            obj.binarizedAdjustedThenOpenImage = imbinarize(obj.adjustedThenOpenImage, obj.threshold);
    
            obj.binarizedGaussOpenedImage = imbinarize(obj.gaussOpenedImage, obj.threshold);
            obj.binarizedGaussAdjustedImage = imbinarize(obj.gaussAdjustedImage, obj.threshold);
            obj.binarizedGaussAdjustedThenOpenImage = imbinarize(obj.gaussAdjustedThenOpenImage, obj.threshold);

            obj.binarizedGaussOpenedThenAdjustImage = imbinarize(obj.gaussOpenedThenAdjustImage, obj.threshold);

            obj.binarizedAdjustedImage = imbinarize(obj.adjustedImage, obj.threshold);
        end
    end
end