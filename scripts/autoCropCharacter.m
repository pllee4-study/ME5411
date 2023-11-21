function croppedImg = autoCropCharacter(originalImg)
    % Convert to grayscale if the image is colored
    if size(originalImg, 3) == 3
        grayImg = rgb2gray(originalImg);
    else
        grayImg = originalImg;
    end

    % Use edge detection to find character boundaries
    edges = edge(grayImg, 'Canny');

    % Find the bounding box around the largest edge region
    stats = regionprops(edges, 'BoundingBox', 'Area');

    % Filter out very small areas which might be noise
    areas = [stats.Area];
    thresholdArea = 0.1 * max(areas);  % Adjust threshold as needed
    largeEnough = areas > thresholdArea;
    stats = stats(largeEnough);

    % If no large regions found, return the original image
    if isempty(stats)
        croppedImg = originalImg;
        return;
    end

    % Choose the largest remaining region
    [~, largestIdx] = max(areas(largeEnough));
    bbox = round(stats(largestIdx).BoundingBox);

    % Crop the image
    x = bbox(1);
    y = bbox(2);
    w = bbox(3);
    h = bbox(4);
    croppedImg = imcrop(originalImg, [x, y, w, h]);
end







% function croppedImg = autoCropCharacter(originalImg)
%     % Convert to grayscale if the image is colored
%     if size(originalImg, 3) == 3
%         grayImg = rgb2gray(originalImg);
%     else
%         grayImg = originalImg;
%     end
% 
%     % Binarize the image (assuming the character is darker than the background)
%     % Adjust the threshold value as needed
%     binaryImg = imbinarize(grayImg, 'global');
% 
%     % Invert if the background is black and the character is white
%     if mean(grayImg(:)) < 128
%         binaryImg = ~binaryImg;
%     end
% 
%     % Find the bounding box around the largest binary region
%     stats = regionprops(binaryImg, 'BoundingBox');
%     if isempty(stats)
%         croppedImg = originalImg; % Return original if no character is found
%         return;
%     end
% 
%     % Get the coordinates of the bounding box
%     bbox = round(stats(1).BoundingBox);
%     x = bbox(1);
%     y = bbox(2);
%     w = bbox(3);
%     h = bbox(4);
% 
%     % Crop the image
%     croppedImg = imcrop(originalImg, [x, y, w, h]);
% end
