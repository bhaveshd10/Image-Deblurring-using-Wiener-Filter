clear all;clc;close all

% Read image and convert into double
img=imread('Signs_degraded.jpg');
temp_img=double(img);

% Choose a random flat region in the image to identify noise standard
% deviation and Variance
flat=temp_img(70:93,1:80);
figure,imshow(img)
title('Original image')
figure,imshow(uint8(flat))
title('Patch to calculate noise')
Sd=std2(flat);
Var=Sd^2;

% Fourier transform of image to get magnitude
fft=fft2(img);
mag=log(abs(fft));
mag_shift=fftshift(mag);
figure,imshow(mag_shift,[])
title('Shifted Magnitude image') 

% Identify the motion and its direction from shifted magnitude plot
H = fspecial('motion',35,90);

% Temporary matrix with same size of image
temp=zeros(600,600);

% Place detected motion at center of temporary matrix
[l n]=size(H);
center_temp=round(length(temp)/2);
temp(center_temp-round(l)/2:center_temp+(round(l)/2)-1,center_temp-round(n)/2:center_temp+(round(n)/2)-1)=H;

%  Shifted Magnitude of the temporary matrix
fft_temp=fft2(temp);
mag_temp=(abs(fft_temp));
magshift_temp=fftshift(mag_temp); 
figure,imshow(magshift_temp,[])
title('Shifted magnitude Wiener')

% Multiply image magnitude with magnitude of temporary matrix
I=mag_shift.*magshift_temp;
figure,imshow(I,[])
title('image+wiener')

% Obtain the output image 
NSR = 10/var(temp_img(:));
Z = deconvwnr(temp_img,H,NSR);
figure,imshow(Z,[])
title('Output image')
