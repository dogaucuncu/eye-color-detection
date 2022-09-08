%Doğa ÜÇÜNCÜ - 201411063

clear all
close all


%I = imread('hazel.jpg');
%I2 = imread('hazel.jpg');


I = imread('blue.jpg');
I2 = imread('blue.jpg');

%I = imread('green.jpg');
%I2 = imread('green.jpg');

%I = imread('brown.jpg');
%I2 = imread('brown.jpg');

I= rgb2gray(I);


[histo, tresh] = hist(double(I(:)), 10);
T = tresh(1);

b = I < T;

imshow(b);
%labela aldık ve 8-connecteda çevirdik. Bu sayede orta matristen her yanı
%görüyor.
label = bwlabel(b, 8);

%regionprops ile ölçüm yapacağımız durumları giriyoruz. Alan, dış çevre,
%merkez ve algılama
define_orb = regionprops(label, 'Area', ...
  'Eccentricity', 'Centroid', 'BoundingBox');
maxarea = 0;
for i = 1 : length(define_orb)
    if (define_orb(i).Area > maxarea) && ...
          (define_orb(i).Eccentricity <= 0.9)
        maxarea = define_orb(i).Area;
        m = i;
    end
end
% getting the centroid and radius of the orb
orb.Cx = round(define_orb(m).Centroid(1));
orb.Cy = round(define_orb(m).Centroid(2));
orb.R = round(max(define_orb(m).BoundingBox(3) / 2, define_orb(m).BoundingBox(4) / 2));

orb.Rbig = orb.R * 3.14;
%linspace ile vektör oluşturuyoruz. Pol2chart ile silindirik bir veriyi
%kartezyene çeviriyoruz.
nPoints = 10;
theta = linspace(0, 5 * pi, nPoints);
rho = ones(1, nPoints) * orb.R;
[X, Y] = pol2cart(theta, rho);
X = X + orb.Cx;
Y = Y + orb.Cy;
%figure;
%imshow(I);



% Iris Extraction
imgsize = size(I2);
ci = [orb.Cy, orb.Cx, orb.R]; 
[xx, yy] = ndgrid((1:imgsize(1)) - ci(1), (1:imgsize(2)) - ci(2));
mask = uint8((xx .^ 2 + yy .^ 2) < ci(3) ^ 2);
orbcut = uint8(zeros(size(I2)));
orbcut(:, :, 1) = I2(:, :, 1) .* mask;
orbcut(:, :, 2) = I2(:, :, 2) .* mask;
orbcut(:, :, 3) = I2(:, :, 3) .* mask;
figure;
imshow(orbcut);

% Kesişim
imgsize = size(I2);
ci = [orb.Cy, orb.Cx, orb.Rbig]; 
[xx, yy] = ndgrid((1:imgsize(1)) - ci(1), (1:imgsize(2)) - ci(2));
mask = uint8((xx .^ 2 + yy .^ 2) < ci(3) ^ 2);
inter = uint8(zeros(size(I2)));
inter(:, :, 1) = I2(:, :, 1) .* mask;
inter(:, :, 2) = I2(:, :, 2) .* mask;
inter(:, :, 3) = I2(:, :, 3) .* mask;
%figure;
%imshow(inter);


inter = inter - orbcut;
figure, imshow(inter);

r1 = round(mean2(nonzeros(inter(:, :, 1))));
g1 = round(mean2(nonzeros(inter(:, :, 2))));
b1 = round(mean2(nonzeros(inter(:, :, 3))));
rgbImage(1, 1, :) = [r1, g1, b1]; % uint8


r = r1;
g = g1;
b = b1;
disp(r);
disp(g);
disp(b);

bluethreshold = 85;
bluethreshold2 = 200;
blue = (b > bluethreshold & b < bluethreshold2);
y = (blue);
if y == 1
    disp("BLUE");
    return
end


brownthreshold = 140;
brownthreshold2 = 170;
brown = (r >= brownthreshold & r < brownthreshold2);
y = (brown);
if y == 1
    disp("BROWN");
    return
end


greenthreshold = 130;
greenhreshold2 = 230;
green = (g > greenthreshold & g < greenhreshold2);
y = (green);
if y == 1
    disp("GREEN");
    return
  
    
else
    disp("HAZEL");
    return
end

disp("This eye color not included any color type");

