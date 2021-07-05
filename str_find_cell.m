function B=str_find_cell(cell_input,search_value)

A=strfind(cell_input,search_value);

for i=1:length(A)
     
    if isempty(A{i})
        B(i,1)=0;
    else
        B(i,1)=1;
    end
     
end

% if ~isempty(find(B))
%     
%     out_put=1;
% else
%     out_put=0;
% end