%% Create State Table
%   @knowblesse
%   Created on : 2016-11-02
%   Last Modified on : 2016-11-02
%   ƽ���信�� �߻��� �� �ִ� ��� State���� 9���� ���ڷ� ������ ���̺��� �����մϴ�.
%   E : ��ĭ | O : O �� ���� �ڸ�. | X : X �� ���� �ڸ�.
%   StateTable{�� Ƚ��} = (����, ����) �� ���·� �Ǿ��ֽ��ϴ�.
%   ���� : ������ State �鿡���� ������ ���ӿ��� �߻����� �ʴ� ���, 
%         Ư�� O�� X ��� 3���� ������ ��찡 ���Ե˴ϴ�.

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