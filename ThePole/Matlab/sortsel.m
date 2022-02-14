function [SelectedValue, SelectedIndex] = sortsel(values, num2Select, sortMethod)
% sort the values and select [num2Select] number of items
[v,i] = sort(values,sortMethod);
SelectedValue = v(1:num2Select);
SelectedIndex = i(1:num2Select);
end



