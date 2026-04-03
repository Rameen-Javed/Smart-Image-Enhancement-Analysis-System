img = imread('/MATLAB Drive/grains.jfif');   % put your image in same folder
figure, imshow(img), title('Original Image');


%% Convert to Grayscale
if size(img,3) == 3
    gray = rgb2gray(img);
else
    gray = img;
end

figure, imshow(gray), title('Grayscale Image');

%% Display Info
disp('Image Info:');
disp(size(gray));
disp(class(gray));
disp(gray(1:5,1:5));   % partial matrix

%% 2. Sampling (Resize)
scales = [0.5, 0.25, 1.5, 2];
for i = 1:length(scales)
    resized = imresize(gray, scales(i));
    figure, imshow(resized), title(['Scale = ', num2str(scales(i))]);
end

%% Quantization (Bit Depth Reduction)
levels = [256, 16, 4];  % 8-bit, 4-bit, 2-bit
for i = 1:length(levels)
    q_img = floor(double(gray)/(256/levels(i))) * (256/levels(i));
    q_img = uint8(q_img);
    figure, imshow(q_img), title(['Levels = ', num2str(levels(i))]);
end

%% 3. Geometric Transformations

% Rotation
angles = [30, 45, 90, 180];
for i = 1:length(angles)
    rot = imrotate(gray, angles(i), 'bilinear', 'crop');
    figure, imshow(rot), title(['Rotation ', num2str(angles(i))]);
end

% Translation
tform = affine2d([1 0 0; 0 1 0; 50 30 1]);
translated = imwarp(gray, tform);
figure, imshow(translated), title('Translated');

% Shearing
shear = affine2d([1 0.5 0; 0 1 0; 0 0 1]);
sheared = imwarp(gray, shear);
figure, imshow(sheared), title('Sheared');

%% 4. Intensity Transformations

% Negative
neg = 255 - gray;
figure, imshow(neg), title('Negative');

% Log Transform
log_img = uint8(255 * log(1 + double(gray)) / log(256));
figure, imshow(log_img), title('Log Transform');

% Gamma Correction
gamma1 = imadjust(gray, [], [], 0.5);
gamma2 = imadjust(gray, [], [], 1.5);

figure, imshow(gamma1), title('Gamma 0.5');
figure, imshow(gamma2), title('Gamma 1.5');

%% 5. Histogram Processing

figure;
imhist(gray);
title('Original Histogram');

eq_img = histeq(gray);

figure, imshow(eq_img), title('Histogram Equalized');
figure;
imhist(eq_img);
title('Equalized Histogram');

%% 6. Final Enhanced Image (Best Combination)

enhanced = process_image(img);

figure, imshow(enhanced), title('Final Enhanced Image');

imwrite(enhanced, 'output.jpg');
