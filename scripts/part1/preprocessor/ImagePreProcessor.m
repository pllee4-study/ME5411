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
            adjustedThenOpenImage = imopen(adjustedImage, se);
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

            binarizedOpenedImage = im2bw(rgb2gray(openedImage), obj.threshold);
            binarizedOpenedThenAdjustImage = im2bw(openedThenAdjustImage, obj.threshold);
            binarizedAdjustedThenOpenImage = im2bw(adjustedThenOpenImage, obj.threshold);
    
            binarizedGaussOpenedImage = im2bw(gaussOpenedImage, obj.threshold);
            binarizedGaussAdjustedImage = im2bw(gaussAdjustedImage, obj.threshold);
            binarizedGaussAdjustedThenOpenImage = im2bw(gaussAdjustedThenOpenImage, obj.threshold);

            binarizedGaussOpenedThenAdjustImage = im2bw(gaussOpenedThenAdjustImage, obj.threshold);

            binarizedAdjustedImage = im2bw(adjustedImage, obj.threshold);
        end
    end
end