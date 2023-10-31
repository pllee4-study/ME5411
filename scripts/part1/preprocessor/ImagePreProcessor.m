classdef ImagePreProcessor
    properties
        image

        radius

        sigma

        threshold
    end

    methods
        function obj = ImagePreProcessor(image, defaultValues)
            obj.image = image;
            obj.radius = defaultValues.radius;
            obj.sigma = defaultValues.sigma;
            obj.threshold = defaultValues.threshold;

            global adjustedImage;
            adjustedImage = imadjust(rgb2gray(obj.image));

            obj.performMorphologicalProcess();
            obj.performSigmaUpdate();
        end

        function updateDiskRadius(obj, radius)
            obj.radius = radius;
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
            se = strel('disk', floor(obj.radius), 0);  % Create a disk-shaped structuring element with radius 6 pixels
            global openedImage;
            openedImage = imopen(obj.image, se);  % Perform opening operation
            obj.performOpenImageUpdate();
        end

        function performOpenImageUpdate(obj)
            obj.openThenAdjustImage();
            obj.adjustedThenOpenImage();

            % The sequence here is crucial
            obj.performSigmaUpdate();
            obj.erodeImage();
        end

        function performSigmaUpdate(obj)
            obj.gaussOpenedImage();
            obj.gaussAdjustedImage();
            obj.gaussOpenedThenAdjustedImage();
            obj.gaussAdjustedThenOpenImage();

            obj.performThresholdUpdate();
        end

        function performThresholdUpdate(obj)
            obj.binarizeImage();
            obj.erodeImage();
        end

        function openThenAdjustImage(obj)
            global openedImage;
            global openedThenAdjustImage;
            openedImageGrayScale = rgb2gray(openedImage);
            openedThenAdjustImage = imadjust(openedImageGrayScale);
        end

        function adjustedThenOpenImage(obj)
            global adjustedThenOpenImage;
            global adjustedImage;
            se = strel('disk', floor(obj.radius), 0);
            % se = strel('line', obj.radius, 90);
            adjustedThenOpenImage = imopen(adjustedImage, se);
        end

        function erodeImage(obj)
            global binarizedGaussAdjustedThenOpenImage;
            global binarizedGaussOpenedImage;
            global erodedImage;
            % se = strel('disk', floor(obj.radius), 0);
            se = strel('line', obj.radius, 90);
            erodedImage = imerode(binarizedGaussOpenedImage, se);    % Perform erosion
            erodedImage = bwareaopen(erodedImage, 100);
        end

        function gaussOpenedImage(obj)
            global openedImage;
            global gaussOpenedImage;
            openedImageGrayScale = rgb2gray(openedImage);
            gaussOpenedImage = imgaussfilt(openedImageGrayScale, obj.sigma);
        end

        function gaussAdjustedImage(obj)
            global adjustedImage;
            global gaussAdjustedImage;
            gaussAdjustedImage = imgaussfilt(adjustedImage, obj.sigma);
        end

        function gaussOpenedThenAdjustedImage(obj)
            global openedThenAdjustImage;
            global gaussOpenedThenAdjustImage;
            gaussOpenedThenAdjustImage = imgaussfilt(openedThenAdjustImage, obj.sigma);
        end

        function gaussAdjustedThenOpenImage(obj)
            global adjustedThenOpenImage;
            global gaussAdjustedThenOpenImage;
            gaussAdjustedThenOpenImage = imgaussfilt(adjustedThenOpenImage, obj.sigma);
        end

        function binarizeImage(obj)
            % input
            global openedImage;

            global openedThenAdjustImage;
            global adjustedThenOpenImage;

            global gaussOpenedImage;
            global gaussAdjustedImage;
            global gaussAdjustedThenOpenImage;
            global gaussOpenedThenAdjustImage;

            global adjustedImage;

            % binarized output
            global binarizedOpenedImage;

            global binarizedOpenedThenAdjustImage;
            global binarizedAdjustedThenOpenImage;

            global binarizedGaussOpenedImage;
            global binarizedGaussAdjustedImage;
            global binarizedGaussAdjustedThenOpenImage;
            global binarizedGaussOpenedThenAdjustImage;

            global binarizedAdjustedImage;

            binarizedOpenedImage = imbinarize(rgb2gray(openedImage), obj.threshold);
            binarizedOpenedThenAdjustImage = imbinarize(openedThenAdjustImage, obj.threshold);
            binarizedAdjustedThenOpenImage = imbinarize(adjustedThenOpenImage, obj.threshold);
    
            binarizedGaussOpenedImage = imbinarize(gaussOpenedImage, obj.threshold);
            binarizedGaussAdjustedImage = imbinarize(gaussAdjustedImage, obj.threshold);
            binarizedGaussAdjustedThenOpenImage = imbinarize(gaussAdjustedThenOpenImage, obj.threshold);

            binarizedGaussOpenedThenAdjustImage = imbinarize(gaussOpenedThenAdjustImage, obj.threshold);

            binarizedAdjustedImage = imbinarize(adjustedImage, obj.threshold);
        end
    end
end