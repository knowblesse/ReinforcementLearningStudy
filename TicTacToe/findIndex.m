function [ i ] = findIndex( States, targetState )
%% State에서 target state의 index 번호를 찾음
%% findIndex
%   @knowblesse
%   Created on : 2016-10-20
%   Last Modified on : 2016-11-02

for row = 1 : size(States,1)
    if States(row,:) == targetState
        i = row;
        break;
    end
end
end

