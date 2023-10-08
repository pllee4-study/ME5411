onlineURLForImage = 'https://github-production-user-asset-6210df.s3.amazonaws.com/42335542/273423239-ea91ba6e-b53c-4308-9b78-77ab9766b220.jpg';
localFilePathForImage = '../assets/charact2.jpg';

try
    % Try loading the image from the hosted online URL
    imageLoaded = imread(onlineURLForImage);
    disp('Image loaded from online source.');
catch
    % If an error occurs (e.g., no internet connection or failed to load), load the local image
    try
        imageLoaded = imread(localFilePathForImage);
        disp('Image loaded from local source.');
    catch
        % If the local image cannot be loaded, display an error message
        error('Failed to load image from both online and local sources.');
    end
end