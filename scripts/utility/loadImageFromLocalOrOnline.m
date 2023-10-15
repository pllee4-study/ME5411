onlineURLForImage = 'https://github-production-user-asset-6210df.s3.amazonaws.com/42335542/273423239-ea91ba6e-b53c-4308-9b78-77ab9766b220.jpg';
localFilePathForImage = '../../assets/charact2.bmp';

global imageLoaded;

try
    % Try loading the image from local source
    scriptPath = fileparts(mfilename('fullpath'));
    imageLoaded = imread(fullfile(scriptPath, localFilePathForImage));
    disp('Image loaded from local source.');
catch
    % If an error occurs (e.g., wrong relative path or failed to load), load the image from the hosted online URL
    try
        imageLoaded = imread(onlineURLForImage);
        disp('Image loaded from online source.');
    catch
        % If the online image cannot be loaded, display an error message
        error('Failed to load image from both local and online sources.');
    end
end