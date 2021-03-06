%% Generate State Table from Maze Image
FILENAME = 'Maze_14x14.png';
img = imread(FILENAME);

%% Constants
num_maze_row = 14;
num_maze_column = 14;

cell_size = size(img,1) / num_maze_column;

%% Check Boarder Thickness and Cell Size
%{
***-----***-----***
 3   5   3   5   3   ==> n 
%}
changepoint = find(diff(img(floor(cell_size/2),:,1) < 250));
n = [changepoint, size(img,1)] - [0, changepoint]; % should be odd number.

if mod(numel(n),2) ~= 1 
    error('The size of the difference array is not odd number!');
end

boarder_thickness = mean(n(1:2:end));

cell_size = (size(img,1) - boarder_thickness * (num_maze_column+1)) / num_maze_column + boarder_thickness;

clearvars changepoint n


%% Check left and right boarders
lrboarders = zeros(num_maze_row, num_maze_column+1); % left right boarders => [mazesize(1)+1, mazesize(2)]
for r = 1 : num_maze_row
    for c = 1 : num_maze_column+1
        coor_ = [...
            cell_size * (c-1) + 1,...
            cell_size * (r-1) + cell_size/2];
        if c == num_maze_column+1 % last column
            coor_(1) = coor_(1) - (coor_(1)+boarder_thickness - size(img,2));
        end
        coor = round(coor_);
        % if any pixel from coor to <half-boarder size pixel> right from coor is black, there is a boarder
        if any(img(coor(2), coor(1):coor(1)+round(boarder_thickness), 1) < 250) 
            for k = 0 : round(boarder_thickness)
                img(coor(2), coor(1)+k, 1) = 255;
                img(coor(2), coor(1)+k, 2) = 0;
                img(coor(2), coor(1)+k, 3) = 0;
            end
            lrboarders(r,c) = 1;
        else
            for k = 0 : round(boarder_thickness)
                img(coor(2), coor(1)+k, 1) = 0;
                img(coor(2), coor(1)+k, 2) = 0;
                img(coor(2), coor(1)+k, 3) = 255;
            end
            lrboarders(r,c) = 0;
        end
    end
end
%% Check up and down boarders
udboarders = zeros(num_maze_row+1, num_maze_column); % up down boarders => [mazesize(1), mazesize(2)+1]
for r = 1 : num_maze_row+1
    for c = 1 : num_maze_column
        coor_ = [...
            cell_size * (c-1) + cell_size/2,...
            cell_size * (r-1) + 1];
        if r == num_maze_row+1 % last row
            coor_(2) = coor_(2) - (coor_(2) + boarder_thickness - size(img,1));
        end
        coor = round(coor_);
        % if any pixel from coor to <half-boarder size pixel> down from coor is black, there is a boarder
        if any(img(coor(2):coor(2)+round(boarder_thickness), coor(1), 1) < 250)
            for k = 0 : round(boarder_thickness)
                img(coor(2)+k, coor(1), 1) = 255;
                img(coor(2)+k, coor(1), 2) = 0;
                img(coor(2)+k, coor(1), 3) = 0;
            end
            udboarders(r,c) = 1;    
        else
            for k = 0 : round(boarder_thickness)
                img(coor(2)+k, coor(1), 1) = 0;
                img(coor(2)+k, coor(1), 2) = 0;
                img(coor(2)+k, coor(1), 3) = 255;
            end
            udboarders(r,c) = 0;
        end
    end
end

output = zeros(num_maze_row * num_maze_column,4);
for r = 1 : num_maze_row
    for c = 1 : num_maze_column
        num = num_maze_column*(r-1) + c;
        % action1 
        if udboarders(r,c) == 1
            output(num,1) = num;
        else
            output(num,1) = num - num_maze_column;
        end
        % action2
        if udboarders(r+1,c) == 1
            output(num,2) = num;
        else
            output(num,2) = num + num_maze_column;
        end
        % action3 
        if lrboarders(r,c) == 1
            output(num,3) = num;
        else
            output(num,3) = num - 1;
        end
        % action4 
        if lrboarders(r,c+1) == 1
            output(num,4) = num;
        else
            output(num,4) = num + 1;
        end
        
    end
end
output = output - 1;
imshow(img);
dlmwrite(strcat(FILENAME,'_table.txt'),output,'delimiter','\t');