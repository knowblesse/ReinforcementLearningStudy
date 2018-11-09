%% Create State Table
%   @knowblesse
%   Created on : 2016-11-02
%   Last Modified on : 2016-11-02
%   틱텍토에서 발생할 수 있는 모든 State들을 9개의 문자로 나열한 테이블을 생성합니다.
%   E : 빈칸 | O : O 가 놓은 자리. | X : X 가 놓은 자리.
%   StateTable{둔 횟수} = (종류, 상태) 의 형태로 되어있습니다.
%   참고 : 나열된 State 들에서는 실제로 게임에서 발생하지 않는 경우, 
%         특히 O와 X 모두 3줄을 형성한 경우가 포함됩니다.

%% Create State Table
StateTable = cell(1,9);
StateTable{1} = perms_reps(['E','O','X'],[8,0,1]);
StateTable{2} = perms_reps(['E','O','X'],[7,1,1]);
StateTable{3} = perms_reps(['E','O','X'],[6,1,2]);
StateTable{4} = perms_reps(['E','O','X'],[5,2,2]);
StateTable{5} = perms_reps(['E','O','X'],[4,2,3]);
StateTable{6} = perms_reps(['E','O','X'],[3,3,3]);
StateTable{7} = perms_reps(['E','O','X'],[2,3,4]);
StateTable{8} = perms_reps(['E','O','X'],[1,4,4]);
StateTable{9} = perms_reps(['E','O','X'],[0,4,5]);
save('StateTable.mat','StateTable');