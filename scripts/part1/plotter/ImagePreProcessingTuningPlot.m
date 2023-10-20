classdef ImagePreProcessingTuningPlot
    methods (Static)
        function plotFigures = plot(name, figures)
            switch name
                case "OpenedImage"
                    subplot(5, 4, 1), imshow(figures), title(name);
                case "OpenedThenAdjustImage"
                    subplot(5, 4, 2), imshow(figures), title(name);
                case "AdjustedThenOpenImage"
                    subplot(5, 4, 3), imshow(figures), title(name);
                case "AdjustedImage"
                    subplot(5, 4, 4), imshow(figures), title(name);
                case "GaussOpenedImage"
                    subplot(5, 4, 5), imshow(figures), title(name);
                case "GaussOpenedThenAdjustImage"
                    subplot(5, 4, 6), imshow(figures), title(name);
                case "GaussAdjustedThenOpenImage"
                    subplot(5, 4, 7), imshow(figures), title(name);
                case "GaussAdjustedImage"
                    subplot(5, 4, 8), imshow(figures), title(name);

                case "BinarizedOpenedImage"
                    ImagePreProcessingTuningPlot.plotDetail(5, 4, 9, figures, name, false);
                case "BinarizedOpenedThenAdjustImage"
                    ImagePreProcessingTuningPlot.plotDetail(5, 4, 10, figures, name, false);
                case "BinarizedAdjustedThenOpenImage"
                    ImagePreProcessingTuningPlot.plotDetail(5, 4, 11, figures, name, false);
                case "BinarizedAdjustedImage"
                    ImagePreProcessingTuningPlot.plotDetail(5, 4, 12, figures, name, false);
                case "BinarizedGaussOpenedImage"
                    ImagePreProcessingTuningPlot.plotDetail(5, 4, 13, figures, name, true);
                case "BinarizedGaussOpenedThenAdjustImage"
                    ImagePreProcessingTuningPlot.plotDetail(5, 4, 14, figures, name, true);
                case "BinarizedGaussAdjustedThenOpenImage"
                    ImagePreProcessingTuningPlot.plotDetail(5, 4, 15, figures, name, true);
                case "BinarizedGaussAdjustedImage"
                    ImagePreProcessingTuningPlot.plotDetail(5, 4, 16, figures, name, true);
                otherwise
            end 
        end

        function plotDetail(row, column, index, figures, name, showSegmentedCharacter)
            if (showSegmentedCharacter)
                cc = bwconncomp(figures, 4);
                props = regionprops(cc, 'BoundingBox');
                subplot(row, column, index), imshow(figures), title(name);
                hold on;
                for i = 1:numel(props)
                    rectangle('Position', props(i).BoundingBox, 'EdgeColor', 'r', 'LineWidth', 2);
                end
            else
                subplot(row, column, index), imshow(figures), title(name);
            end
        end
    end
end