classdef ImagePreProcessor
    properties
        image

        radius

    end

    methods
        function obj = ImagePreProcessor(image, defaultValues)
            obj.image = image;
            obj.radius = defaultValues.radius;

            obj.performMorphologicalProcess();
        end

        function updateDiskRadius(obj, radius)
            obj.radius = radius;
            obj.performMorphologicalProcess();
        end

    end

    methods(Access = private)
        function performMorphologicalProcess(obj)
            se = strel('disk', floor(obj.radius), 0);  % Create a disk-shaped structuring element with radius 6 pixels
            global openedImage;
            openedImage = imopen(obj.image, se);  % Perform opening operation
        end

        function performAllProcessing(obj)
            obj.performMorphologicalProcess();
        end
    end
end