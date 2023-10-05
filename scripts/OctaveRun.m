% Read the image
img = imread('./Image.png');

% Convert the image to grayscale
img_gray = rgb2gray(img);

% Debug printing
% disp(img_gray);

% Define the 3x3 and 5x5 averaging mask
three_by_three_average_mask = ones(3) / 9;
five_by_five_average_mask = ones(5) / 25;

% Apply the averaging mask using the conv2 function
three_by_three_img_average = conv2(double(img_gray), three_by_three_average_mask, 'same');
five_by_five_img_average = conv2(double(img_gray), five_by_five_average_mask, 'same');

% Define the 3x3 and 5x5 rotating mask
three_by_three_rot_mask = [0 1 0; 1 -4 1; 0 1 0];
five_by_five_rot_mask = [-1 -1 -1 -1 -1; -1 1 2 1 -1; -1 2 4 2 -1; -1 1 2 1 -1; -1 -1 -1 -1 -1];

% Apply the rotating mask using the conv2 function
three_by_three_img_rotate = conv2(double(img_gray), three_by_three_rot_mask, 'same');
five_by_five_img_rotate = conv2(double(img_gray), five_by_five_rot_mask, 'same');

% Display the original image and the processed images
figure('Name', 'ME5411');
subplot(4, 2, [1,2]), imshow(img_gray), title('Original Image');
subplot(4, 2, 3), imshow(uint8(three_by_three_img_average)), title('Averaging Mask(3x3)');
subplot(4, 2, 4), imshow(uint8(three_by_three_img_rotate)), title('Rotating Mask(3x3)');
subplot(4, 2, 5), imshow(uint8(five_by_five_img_average)), title('Averaging Mask(5x5)');
subplot(4, 2, 6), imshow(uint8(five_by_five_img_rotate)), title('Rotating Mask(5x5)');