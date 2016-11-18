function [d_vec, s_vec]  = kNNSimilaritySearch( new_instance, data_points_vec, distance_matrix, k )

if length(new_instance ~= 2)
    disp('Error, bad instance');
end

ni_name = new_instance(2);
dp_names = data_points_vec(:,2);

bool_idx = strcmp(ni_name,dp_names);
if (any(bool_idx)) % already in the datapoints
    ni_idx = find(bool_idx);
    [d_vec, sort_idx] = sort(distance_matrix(ni_idx,:));
    s_vec = dp_names(sort_idx);
else
    % PLACEHOLDER
    % compute the distances between this file and all the others.
    % since we have the abs path of all files, this can be done
    % pretty easily and with not so much time.
end
    d_vec = d_vec(1:k);
    s_vec = s_vec(1:k);
end

