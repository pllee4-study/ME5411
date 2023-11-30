% code logic written by Kian Seong
classdef RotatingMask
    methods (Static, Access = public)
        function averagedImage = Averaging(img, kernelSize)
            function dispersion = calcDispersion(subMatrix)
                pixelSum = sum(subMatrix, 'all');
                pixelSquareSum = sum((subMatrix .* subMatrix), 'all');
                dispersion = (pixelSquareSum - (pixelSum ^ 2) / N) / N;
            end

            averagedImage = zeros(size(img), 'uint8');
            paddedImage = RotatingMask.PadImage(img, kernelSize);

            % Apply padding again to extend the image border for calculating
            % neighbourhood dispersions for the pixels at the border
            paddedImage = RotatingMask.PadImage(paddedImage, kernelSize);

            dispersionDim = size(paddedImage) - kernelSize + 1;
            dispersion = zeros(dispersionDim);
            N = kernelSize ^ 2;
            offset = kernelSize - 1;

            % calculate dispersion of each sub_image within the kernel
            for row = 1:dispersionDim(1)
                for col = 1:dispersionDim(2)
                    rowEnd = row + offset;
                    colEnd = col + offset;
                    subMatrix = paddedImage(row : rowEnd, col : colEnd);
                    dispersion(row, col) = calcDispersion(double(subMatrix));
                end
            end
            
            % Compare neighbourhood dispersions of every pixel
            % and get the region with minimun dispersion
            % then average the pixel values within the region 
            % to obtain the new central pixel value
            for row = 1 : size(averagedImage, 1)
                for col = 1 : size(averagedImage, 2)
                    rowEnd = row + offset;
                    colEnd = col + offset;
                    nhoodDisp = dispersion(row : rowEnd, col : colEnd);
                    [~, argmin] = min(nhoodDisp(:));

                    % Convert the linear index (argmin) to row and col of 
                    % the corresponding element in nhoodDisp matrix 
                    minDispCol = floor((argmin - 1) / kernelSize) + 1;
                    minDispRow = argmin - (minDispCol - 1) * kernelSize;

                    % Get the region of interest (ie. region with min dispersion)
                    roiRowStart = row + minDispRow - 1;
                    roiColStart = col + minDispCol - 1;
                    roiRowEnd = roiRowStart + offset;
                    roiColEnd = roiColStart + offset;
                    roi = paddedImage(roiRowStart : roiRowEnd, roiColStart : roiColEnd);

                    averagedImage(row, col) = sum(roi, 'all') / N;
                end
            end
        end
    end

    methods (Static, Access = private)
        function paddedImage = PadImage(img, kernelSize)
            padSize = kernelSize - 1;
            prePadSize = floor(padSize / 2);
            postPadSize = padSize - prePadSize;
            paddedImage = padarray(img, [prePadSize, prePadSize], 0, 'pre');
            paddedImage = padarray(paddedImage, [postPadSize, postPadSize], 0, 'post');
        end
    end
end