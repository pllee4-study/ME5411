classdef ImagePreProcessingTuningTools  < handle
    properties
        % Figure size
        figWidth
        figHeight

        % Default values for parameters
        defaultValues

        % Callbacks
        diskRadiusUpdatedCallback
        gaussSigmaUpdatedCallback

        % For disk radius
        diskSliderText
        diskSlider

        % For Gaussian sigma
        sigmaSliderText
        sigmaSlider

        % For binary threshold
    end

    methods
        function obj = ImagePreProcessingTuningTools(figSize, defaultValues)
            obj.figWidth = figSize.width;
            obj.figHeight = figSize.height;
            obj.defaultValues = defaultValues;

            obj.setupDiskRadiusSlider();
            obj.setupSigmaSlider();
        end

        function setDiskRadiusUpdatedCallback(obj, callback)
            obj.diskRadiusUpdatedCallback = callback;
        end

        function setGaussSigmaUpdatedCallback(obj, callback)
            obj.gaussSigmaUpdatedCallback = callback;
        end
    end
    
    methods(Access = private)
        function setupDiskRadiusSlider(obj)
            diskSliderTextLeft = 0.1 * obj.figWidth;  % 10% from the left edge of the figure
            diskSliderTextBottom = 0.15 * obj.figHeight;  % 15% from the bottom edge of the figure
            diskSliderTextWidth = 0.25 * obj.figWidth;  % 25% of the width of the figure
            diskSliderTextHeight = 0.05 * obj.figHeight;  % 5% of the height of the figure
            
            obj.diskSliderText = uicontrol('style', 'text', 'position', [diskSliderTextLeft, diskSliderTextBottom, diskSliderTextWidth, diskSliderTextHeight], 'String', sprintf('Disk radius: %d', obj.defaultValues.radius));

            diskSliderLeft = diskSliderTextLeft + diskSliderTextWidth;
            diskSliderBottom = diskSliderTextBottom;
            diskSliderWidth = 0.4 * obj.figWidth;
            diskSliderHeight = diskSliderTextHeight;

            obj.diskSlider = uicontrol('style', 'slider', 'position', [diskSliderLeft, diskSliderBottom, diskSliderWidth, diskSliderHeight]);
            set(obj.diskSlider, 'Min', 1, 'Max', 10, 'Value', obj.defaultValues.radius, 'SliderStep', [1.0 2.0], 'Tag', 'DiskSlider');

            addlistener(obj.diskSlider, 'ContinuousValueChange', @(~, ~) obj.updateDiskRadius());
        end

        function updateDiskRadius(obj)
            set(obj.diskSliderText, 'String', sprintf('Disk radius: %d', int32(obj.diskSlider.Value)));
            if isempty(obj.diskRadiusUpdatedCallback)
                disp('method setDiskRadiusUpdatedCallback from ImagePreProcessingTuningTools is not set!');
            else
                obj.diskRadiusUpdatedCallback(obj.diskSlider.Value);
            end
        end

        function setupSigmaSlider(obj)
            sigmaSliderTextLeft = 0.1 * obj.figWidth;  % 10% from the left edge of the figure
            sigmaSliderTextBottom = 0.1 * obj.figHeight;  % 1% from the bottom edge of the figure
            sigmaSliderTextWidth = 0.25 * obj.figWidth;  % 25% of the width of the figure
            sigmaSliderTextHeight = 0.05 * obj.figHeight;  % 5% of the height of the figure
            
            obj.sigmaSliderText = uicontrol('style', 'text', 'position', [sigmaSliderTextLeft, sigmaSliderTextBottom, sigmaSliderTextWidth, sigmaSliderTextHeight], 'String', sprintf('Gaussian sigma: %d', obj.defaultValues.sigma));

            sigmaSliderLeft = sigmaSliderTextLeft + sigmaSliderTextWidth;
            sigmaSliderBottom = sigmaSliderTextBottom;
            sigmaSliderWidth = 0.4 * obj.figWidth;
            sigmaSliderHeight = sigmaSliderTextHeight;

            obj.sigmaSlider = uicontrol('style', 'slider', 'position', [sigmaSliderLeft, sigmaSliderBottom, sigmaSliderWidth, sigmaSliderHeight]);
            set(obj.sigmaSlider, 'Min', 1, 'Max', 10, 'Value', obj.defaultValues.radius, 'SliderStep', [1.0 2.0], 'Tag', 'DiskSlider');

            addlistener(obj.sigmaSlider, 'ContinuousValueChange', @(~, ~) obj.updateSigma());
        end

        function updateSigma(obj)
            set(obj.sigmaSliderText, 'String', sprintf('Gaussian sigma: %d', int32(obj.sigmaSlider.Value)));
            if isempty(obj.gaussSigmaUpdatedCallback)
                disp('method setGaussSigmaUpdatedCallback from ImagePreProcessingTuningTools is not set!');
            else
                obj.gaussSigmaUpdatedCallback(obj.sigmaSlider.Value);
            end
        end

    end
end