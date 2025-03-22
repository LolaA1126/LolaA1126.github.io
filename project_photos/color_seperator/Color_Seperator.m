clear all
close all
%% Seperate image into up to 5 RISO Colors

%% Define RISO Colors RBG Codes
black = RisoColor([1 1 1], "Black");
burgundy = RisoColor([145, 78, 114], "Burgundy");
blue = RisoColor([0 120 191], "Blue");
green = RisoColor([0 169 92], "Green");
medium_blue = RisoColor([50, 85, 164], "Medium Blue");
bright_red = RisoColor([241, 80, 96], "Bright Red");
risofederal_blue = RisoColor([61 85 136], "Risofederal Blue");
purple = RisoColor([118, 91, 167], "Purple");
teal = RisoColor([0 ,131, 138], "Teal");
flat_gold = RisoColor([187, 139, 65], "Flat Gold");
hunter_green = RisoColor([64, 112, 96], "Hunter Green");
red = RisoColor([255 102 94], "Red");
brown = RisoColor([146, 95, 82], "Brown");
yellow = RisoColor([255, 232, 0], "Yellow");
marine_red = RisoColor([210, 81, 94], "Marine Red");
orange = RisoColor([255, 108, 47], "Orange");
fluorescent_pink = RisoColor([255, 72, 176], "Fluorescent Pink");
light_gray = RisoColor([136, 137, 138], "Light Gray");
fluorescent_orange = RisoColor([255, 116, 119], "Fluorescent Orange");
sea_foam = RisoColor([98, 194, 177], "Sea Foam");
violet = RisoColor([157, 122, 210], "Violet");
sunflower = RisoColor([255, 181, 17], "Sunflower");
brick = RisoColor([167, 81, 84], "Brick");

paper_color=RisoColor([255, 255, 255],"Paper_Color");

%% Define the colors we will be using
ref_colors = [fluorescent_pink;
    blue;
    yellow;
    sea_foam;
    paper_color];
[numcolors,garb] = size(ref_colors);

ref_colors_rgb=[];
for a = ref_colors
    ref_colors_rgb=[ref_colors_rgb, a.RGB];
end
ref_colors_rgb = reshape(ref_colors_rgb,3,numcolors)';


ref_colors_names=[];
for a = ref_colors
    ref_colors_names=[ref_colors_names; a.Name]
end

% if ismember(black,ref_colors_names)
%     ref_colors.remove(black);
%     ref_colors=[ref_colors;black];
% end

inv_ref_colors=(ref_colors_rgb'*ref_colors_rgb)\ref_colors_rgb';

% Read the image
img = imread("hot_air_balloon.jpg");

% Get the dimensions of the image
[rows, cols, channels] = size(img)

% Initialize output image
output_img = zeros(rows, cols, 3);

% Initialize the correct number of output images for number of color
% channels and create a special one for black if it exists
if ismember("Black",ref_colors_names)
    numcolors=numcolors-1;
    black_map= zeros(rows, cols, 3);
    ref_colors_names.remove(black.Name);
end

c1_map= zeros(rows, cols, 3);
switch numcolors-1
    case 2
        c2_map= zeros(rows, cols, 3);
    case 3
        c2_map= zeros(rows, cols, 3);
        c3_map= zeros(rows, cols, 3);
    case 4
        c2_map= zeros(rows, cols, 3);
        c3_map= zeros(rows, cols, 3);
        c4_map= zeros(rows, cols, 3);
    case 5
        c2_map= zeros(rows, cols, 3);
        c3_map= zeros(rows, cols, 3);
        c4_map= zeros(rows, cols, 3);
        c5_map= zeros(rows, cols, 3);
    otherwise
        warning("Too Many Colors Selected")
end

tic

% Loop through each pixel
for i = 1:rows
    if i==round(rows/2)
        disp('50% Done')
    elseif i==round(rows/4)
        disp('25% Done')
    elseif i==round(3*rows/4)
        disp('75% Done')
    end

    for j = 1:cols
        % Extract RGB values
        pixel_rgb = double(squeeze(img(i, j, :)))';
        
        % Solve for linear combination weights using least squares
        weights = inv_ref_colors'*pixel_rgb';
        weights = max(weights,0);

        % Reconstruct the pixel using the linear combination
        reconstructed_pixel = max(0, min(255, weights' * ref_colors_rgb));

        % Assign to output image
        output_img(i, j, :) = reconstructed_pixel;
        
        c1_map(i, j, :) = (weights(1)'*ref_colors_rgb(1,:))+((1-weights(1))*ref_colors_rgb(numcolors,:));
        switch numcolors-1
            case 2
                if ismember("Black",ref_colors_names)
                    black_map(i, j, :) = (weights(numcolors)'*ref_colors_rgb(numcolors,:))+((1-weights(numcolors))*ref_colors_rgb(numcolors-1,:));
                else
                    c2_map(i, j, :) = (weights(2)'*ref_colors_rgb(2,:))+((1-weights(2))*ref_colors_rgb(numcolors,:));
                end
                c1_map(i, j, :) = (weights(1)'*ref_colors_rgb(1,:))+((1-weights(1))*ref_colors_rgb(numcolors,:));
            case 3
                if ismember("Black",ref_colors_names)
                    black_map(i, j, :) = (weights(numcolors)'*ref_colors_rgb(numcolors,:))+((1-weights(numcolors))*ref_colors_rgb(numcolors-1,:));
                else
                    c3_map(i, j, :) = (weights(3)'*ref_colors_rgb(3,:))+((1-weights(3))*ref_colors_rgb(numcolors,:));
                end
                c1_map(i, j, :) = (weights(1)'*ref_colors_rgb(1,:))+((1-weights(1))*ref_colors_rgb(numcolors,:));
                c2_map(i, j, :) = (weights(2)'*ref_colors_rgb(2,:))+((1-weights(2))*ref_colors_rgb(numcolors,:));
            case 4
                if ismember("Black",ref_colors_names)
                    black_map(i, j, :) = (weights(numcolors)'*ref_colors_rgb(numcolors,:))+((1-weights(numcolors))*ref_colors_rgb(numcolors-1,:));
                else
                    c4_map(i, j, :) = (weights(4)'*ref_colors_rgb(4,:))+((1-weights(4))*ref_colors_rgb(numcolors,:));
                end
                c1_map(i, j, :) = (weights(1)'*ref_colors_rgb(1,:))+((1-weights(1))*ref_colors_rgb(numcolors,:));
                c2_map(i, j, :) = (weights(2)'*ref_colors_rgb(2,:))+((1-weights(2))*ref_colors_rgb(numcolors,:));
                c3_map(i, j, :) = (weights(3)'*ref_colors_rgb(3,:))+((1-weights(3))*ref_colors_rgb(numcolors,:));
            case 5
                if ismember("Black",ref_colors_names)
                    black_map(i, j, :) = (weights(numcolors)'*ref_colors_rgb(numcolors,:))+((1-weights(numcolors))*ref_colors_rgb(numcolors-1,:));
                else
                    c5_map(i, j, :) = (weights(5)'*ref_colors_rgb(5,:))+((1-weights(5))*ref_colors_rgb(numcolors,:));
                end
                c1_map(i, j, :) = (weights(1)'*ref_colors_rgb(1,:))+((1-weights(1))*ref_colors_rgb(numcolors,:));
                c2_map(i, j, :) = (weights(2)'*ref_colors_rgb(2,:))+((1-weights(2))*ref_colors_rgb(numcolors,:));
                c3_map(i, j, :) = (weights(3)'*ref_colors_rgb(3,:))+((1-weights(3))*ref_colors_rgb(numcolors,:));
                c4_map(i, j, :) = (weights(4)'*ref_colors_rgb(4,:))+((1-weights(4))*ref_colors_rgb(numcolors,:));
            otherwise
                warning("Too Many Colors Selected")
        end

    end
end

toc

% Display the modified image
% Convert output image to uint8 and display
figure(1)
subplot(1,2,1)
imshow(img);
title('Original')

subplot(1,2,2)
output_img = uint8(output_img);
imshow(output_img);
title('Seperated')

% Display the Color Channels
figure(2)
switch numcolors-1
    case 2
        if ismember("Black",ref_colors_names)
            numcolors=numcolors-1;
            subplot(1,2,1)
            imshow(uint8(black_map));
            title('Black');
        else
            subplot(1,2,1)
            imshow(uint8(c2_map));
            title(ref_colors_names(2));
        end
        subplot(1,2,2)
        imshow(uint8(c1_map));
        title(ref_colors_names(1));

    case 3
        if ismember("Black",ref_colors_names)
            numcolors=numcolors-1;
            subplot(1,3,1)
            imshow(uint8(black_map));
            title('Black');
        else
            subplot(1,3,1)
            imshow(uint8(c3_map));
            title(ref_colors_names(3));
        end
        subplot(1,3,2)
        imshow(uint8(c1_map));
        title(ref_colors_names(1));

        subplot(1,3,3)
        imshow(uint8(c2_map));
        title(ref_colors_names(2));

    case 4
        if ismember("Black",ref_colors_names)
            numcolors=numcolors-1;
            subplot(2,2,1)
            imshow(uint8(black_map));
            title('Black');
        else
            subplot(2,2,1)
            imshow(uint8(c4_map));
            title(ref_colors_names(4));
        end
        subplot(2,2,2)
        imshow(uint8(c1_map));
        title(ref_colors_names(1));
        
        subplot(2,2,3)
        imshow(uint8(c2_map));
        title(ref_colors_names(2));

        subplot(2,2,4)
        imshow(uint8(c3_map));
        title(ref_colors_names(3));

    case 5
        if ismember("Black",ref_colors_names)
            numcolors=numcolors-1;
            subplot(2,3,1)
            imshow(uint8(black_map));
            title('Black');
        else
            subplot(2,3,1)
            imshow(uint8(c5_map));
            title(ref_colors_names(5));
        end
        subplot(2,3,2)
        imshow(uint8(c1_map));
        title(ref_colors_names(1));
        
        subplot(2,3,3)
        imshow(uint8(c2_map));
        title(ref_colors_names(2));

        subplot(2,3,4)
        imshow(uint8(c3_map));
        title(ref_colors_names(3));

        subplot(2,3,5)
        imshow(uint8(c4_map));
        title(ref_colors_names(4));

    otherwise
        warning("Too Many Colors Selected")
end




