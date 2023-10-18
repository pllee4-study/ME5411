classdef ImagePreProcessor
    properties
        image

        radius

        sigma
    end

    methods
        function obj = ImagePreProcessor(image, defaultValues)
            obj.image = image;
            obj.radius = defaultValues.radius;
            obj.sigma = defaultValues.sigma;

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
            obj.gaussOpenedThenAdjustedImage();
            obj.gaussAdjustedThenOpenImage();
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
    end
end