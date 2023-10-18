classdef ImagePreProcessingTuningPlot
    methods (Static)
        function plotFigures = plot(name, figures)
            switch name
                case "OpenedImage"
                    subplot(4, 4, 1), imshow(figures), title(name);
                case "OpenedThenAdjustImage"
                    subplot(4, 4, 2), imshow(figures), title(name);
                case "AdjustedThenOpenImage"
                    subplot(4, 4, 3), imshow(figures), title(name);
                case "AdjustedImage"
                    subplot(4, 4, 4), imshow(figures), title(name);
                case "GaussOpenedImage"
                    subplot(4, 4, 5), imshow(figures), title(name);
                case "GaussOpenedThenAdjustImage"
                    subplot(4, 4, 6), imshow(figures), title(name);
                case "GaussAdjustedThenOpenImage"
                    subplot(4, 4, 7), imshow(figures), title(name);
                otherwise
            end 
        end
    end
end