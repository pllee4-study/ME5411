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
                    subplot(5, 4, 9), imshow(figures), title(name);
                case "BinarizedOpenedThenAdjustImage"
                    subplot(5, 4, 10), imshow(figures), title(name);
                case "BinarizedAdjustedThenOpenImage"
                    subplot(5, 4, 11), imshow(figures), title(name);
                case "BinarizedAdjustedImage"
                    subplot(5, 4, 12), imshow(figures), title(name);
                case "BinarizedGaussOpenedImage"
                    subplot(5, 4, 13), imshow(figures), title(name);
                case "BinarizedGaussOpenedThenAdjustImage"
                    subplot(5, 4, 14), imshow(figures), title(name);
                case "BinarizedGaussAdjustedThenOpenImage"
                    subplot(5, 4, 15), imshow(figures), title(name);
                case "BinarizedGaussAdjustedImage"
                    subplot(5, 4, 16), imshow(figures), title(name);
                otherwise
            end 
        end
    end
end