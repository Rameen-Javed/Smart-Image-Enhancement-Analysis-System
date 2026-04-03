enhanced = process_image(img);

figure, imshow(enhanced), title('Final Enhanced Image');

imwrite(enhanced, 'output.jpg');
