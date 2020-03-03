%% Generate State Table from Maze Image
% maze image must be square sized and resized to match the maze size * integer!!!
% sizemateched image = img

%% Constants
num_maze_row = 30;
num_maze_column = 30;

cell_size = size(img,1) / num_maze_row; % this must be integer.

%% Check Boarders for each cells

%% Check left and right boarders
lrboarders = zeros(num_maze_row, num_maze_column+1); % left right boarders => [mazesize(1)+1, mazesize(2)]
for r = 1 : num_maze_row
    for c = 1 : num_maze_column+1
        coordinate_to_check = [...
            cell_size * (c-1),...
            cell_size * (r-1) + cell_size/2];
        if c ~= num_maze_column+1 % not the last column
            coordinate_to_check = coordinate_to_check + 1; % w/o this, first corrdinate for the first column is 0
        end
        
        if img(coordinate_to_check(1), coordinate_to_check(2), 1) < 250 % not white. i.e. there is a boarder
            img(coordinate_to_check(1), coordinate_to_check(2), 1) = 255;
            img(coordinate_to_check(1), coordinate_to_check(2), 2) = 0;
            img(coordinate_to_check(1), coordinate_to_check(2), 3) = 0;
            lrboarders(r,c) = 1;
        else
            img(coordinate_to_check(1), coordinate_to_check(2), 1) = 0;
            img(coordinate_to_check(1), coordinate_to_check(2), 2) = 0;
            img(coordinate_to_check(1), coordinate_to_check(2), 3) = 255;
            lrboarders(r,c) = 0;
        end
    end
end
%% Check up and down boarders
udboarders = zeros(num_maze_row+1, num_maze_column); % up down boarders => [mazesize(1), mazesize(2)+1]
for r = 1 : num_maze_row+1
    for c = 1 : num_maze_column
        coordinate_to_check = [...
            cell_size * (c-1) + cell_size/2,...
            cell_size * (r-1)];
        if r ~= num_maze_row+1 % not the last row
            coordinate_to_check = coordinate_to_check + 1; % w/o this, first corrdinate for the first column is 0
        end
        
        if img(coordinate_to_check(1), coordinate_to_check(2), 1) < 250 % not white. i.e. there is a boarder
            img(coordinate_to_check(1), coordinate_to_check(2), 1) = 255;
            img(coordinate_to_check(1), coordinate_to_check(2), 2) = 0;
            img(coordinate_to_check(1), coordinate_to_check(2), 3) = 0;
            udboarders(r,c) = 1;
        else
            img(coordinate_to_check(1), coordinate_to_check(2), 1) = 0;
            img(coordinate_to_check(1), coordinate_to_check(2), 2) = 0;
            img(coordinate_to_check(1), coordinate_to_check(2), 3) = 255;
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