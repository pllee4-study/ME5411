function grayImage = rgb2gray(image)
    % Convert the RGB image to grayscale
    % Reference(ITU-R BT.601-7, page 2): https://www.itu.int/dms_pubrec/itu-r/rec/bt/R-REC-BT.601-7-201103-I!!PDF-E.pdf
    grayImage = 0.2989 * image(:, :, 1) + 0.5870 * image(:, :, 2) + 0.1140 * image(:, :, 3);
end