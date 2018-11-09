function [ P, N ] = perms_reps( vec, reps )
%Create permutations of "vec" with repitition allowed for "reps"
%   rep 개의 vec 요소를 permutation 시킴.
%% perms_reps
%   @knowblesse
%   Created on : 2016-10-20
%   Last Modified on : 2016-11-02

if size(vec) ~= size(reps)
    error('Error\n size of vec and reps does not match');
end
numElement = sum(reps);
n = length(vec);

if numElement == 0
    P = [];
elseif numElement == 1
    P = vec(find(reps));
else
    P = [];
    for i = 1 : n
        if reps(i) > 0
            repst = reps;
            repst(i) = repst(i) - 1;
            P_i = perms_reps(vec,repst);
            numP_i = size(P_i,1);
            P = [P;...
                [repmat(vec(i),numP_i,1),P_i]];
        end
    end
    N = size(P,1);
end
end

