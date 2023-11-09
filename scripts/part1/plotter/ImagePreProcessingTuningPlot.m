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

                case "ErodedImage"
                    ImagePreProcessingTuningPlot.plotDetail(5, 4, 17, figures, name, true);
                otherwise
            end 
        end

        function plotDetail(row, column, index, figures, name, showSegmentedCharacter)
            if (showSegmentedCharacter)
                cc = bwconncomp(figures, 4);
                props = regionprops(cc, 'BoundingBox');
                subplot(row, column, index), imshow(figures), title(name);
                labelMatrix = double(labelmatrix(cc));
                numCc = max(labelMatrix(:));  % Number of connected components
                coloredLabels = label2rgb(labelMatrix, turbo(numCc), 'k', 'shuffle');
                imshow(coloredLabels);
                hold on;

                % Initialize the min width with a value larger than any rectangle width
                minWidth = Inf;

                % Find the smallest rectangle width
                for i = 1:numel(props)
                    width = props(i).BoundingBox(3);
                    if width < minWidth
                        minWidth = width;
                    end
                end

                % Perform additional split if the rectangle width is significantly larger than the min width
                splitThreshold = 1.7;  % Threshold to determine if the width is significantly larger
         
                for i = 1:numel(props)
                    rectangle('Position', props(i).BoundingBox, 'EdgeColor', 'r', 'LineWidth', 2);

                    % Check if the width is significantly larger than the minWidth
                    width = props(i).BoundingBox(3);
                    if width > splitThreshold * minWidth
                        % Split the rectangle into two equal-width rectangles
                        halfWidth = width / 2;
                        x = int32(props(i).BoundingBox(1));
                        y = int32(props(i).BoundingBox(2));
                        height = int32(props(i).BoundingBox(4));

                        % Create two new rectangles
                        rect1 = [x, y, halfWidth, height];
                        rect2 = [x + halfWidth, y, halfWidth, height];
                        
                        coloredLabels(y : y + height, x : x + halfWidth, 1) = 10;
    
                        % Draw the additional rectangles
                        rectangle('Position', rect1, 'EdgeColor', 'g', 'LineWidth', 2);
                        rectangle('Position', rect2, 'EdgeColor', 'b', 'LineWidth', 2);    
                    end
                end
                % show the processed coloredLabels
                imshow(coloredLabels);
            else
                subplot(row, column, index), imshow(figures), title(name);
            end
        end
    end
end