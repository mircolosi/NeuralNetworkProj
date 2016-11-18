function [d_vec, s_vec]  = kNNSimilaritySearch( new_instance, data_points_vec, distance_matrix, k )

if length(new_instance ~= 2)
    disp('Error, bad instance');
end

ni_name = new_instance(2);
dp_names = data_points_vec(:,2);
dp_paths = data_points_vec(:,1);

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
    
    for i = 1:length(dp_paths)
        
        % 01. Open file 'new_instance'
        % 02. Open dp_paths(i) file
        
        % 03. Preprocessing
        % 04. Convert into txt
        % 05. Concatenate
        % 06. Zip
        % 07. Evaluate distance
        % 08. Accumulate distances in a row-vector called 'new_distances'
        % 09. Sort and take values
        new_distances = zeros(1:length(dp_paths));
        [d_vec, sort_idx] = sort(new_distances);
        s_vec = dp_names(sort_idx);
        % 10. Close, clean and delete generated files
    end
end
    d_vec = d_vec(1:k);
    s_vec = s_vec(1:k);
end

