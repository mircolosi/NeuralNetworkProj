function [d_vec, s_vec]  = kNNSimilaritySearch( new_instance, data_points_vec, labels, distance_matrix, k )

if (length(new_instance) ~= 2)
    disp('Error, bad instance');
end

current_path = pwd;
temp_folder = fullfile(current_path, 'temp_folder');

ni_path = char(new_instance(1));
ni_name = char(new_instance(2));
dp_names = data_points_vec(:,2);
dp_paths = data_points_vec(:,1);

bool_idx = strcmp(ni_name,dp_names);

if (any(bool_idx))
    % already in the datapoints
    disp('This new_instance is aready in the data points.');
    ni_idx = find(bool_idx);
    [d_vec, sort_idx] = sort(distance_matrix(ni_idx,:));
    s_vec = labels(sort_idx);
else
    % Compute the distances between this file and all the others.
    % since we have the abs path of all files, this can be done
    % pretty easily and with not so much time.
    % These are the steps:
    % 01. Open, convert, zip and length of 'new_instance'
        % 02. Open dp_paths(i) file
        % 03. Convert into txt
        % 04. Concatenate - 1 is the new_istance, 2 is the other file
        % 05. Zip
        % 06. Evaluate distance
        % 07. Accumulate distances in a row-vector called 'new_distances'
        % 08. Close, clean and delete generated files    
    % 09. Sort and take values
    disp('This new_instance is not in the data points.');
    disp('Evaluating distances with data_points...');
    
    % Temp folder where all the stuff is stored - REMOVE AT THE END
    if ~exist(temp_folder, 'dir')
        mkdir(temp_folder, 's');
    end
    new_distances = zeros(1,length(dp_paths));
    
    % 01. Open, convert, zip and length of 'new_instance'
    % Supposed to be already Single Track
    ni_fid = fopen(ni_path);
    ni_txt_fid = fopen(fullfile(temp_folder,'new_instance.txt'),'w');
    
    ni_text = fread(ni_fid, Inf, '*char');
    fprintf(ni_txt_fid,'%c',ni_text);
    fclose(ni_fid);
    
    zip(fullfile(temp_folder,'new_instance.zip'),fullfile(temp_folder,'new_instance.txt'));
    
    ni_zip_fid = fopen(fullfile(temp_folder,'new_instance.zip'));
    ni_c_file = fread(ni_zip_fid, Inf, '*char');
    K1 = length(ni_c_file);
    
    fclose(ni_zip_fid);
    
    for i = 1:length(dp_paths)
        % 02. Open dp_paths(i) file
        fid = fopen(char(dp_paths(i)));
        
        % 03. Convert into txt
        filename_txt = [char(dp_names(i)), '.txt'];
        txt_fid = fopen(fullfile(temp_folder,filename_txt), 'w');
        text = fread(fid, Inf, '*char');
        fprintf(txt_fid,'%c',text);
        fclose(fid);
        fclose(txt_fid);
        
        % 04. Concatenate - 1 is the new_istance, 2 is the other file
        filename_c12 = 'conc_12';
        filename_c21 = 'conc_21';
        c12_fid = fopen(fullfile(temp_folder,[filename_c12,'.txt']), 'w+');
        c21_fid = fopen(fullfile(temp_folder,[filename_c21,'.txt']), 'w+');
        fprintf(c12_fid,'%c',vertcat(ni_text, text));
        fprintf(c21_fid,'%c',vertcat(text, ni_text));
        fclose(c12_fid);
        fclose(c21_fid);
        
        % 05. Zip
        zip(fullfile(temp_folder,[char(dp_names(i)),'.zip']),fullfile(temp_folder,[char(dp_names(i)),'.txt']));
        zip(fullfile(temp_folder,[filename_c12,'.zip']),fullfile(temp_folder,[filename_c12,'.txt']));
        zip(fullfile(temp_folder,[filename_c21,'.zip']),fullfile(temp_folder,[filename_c21,'.txt']));
        
        % 06. Evaluate distance
        fid_zip = fopen(fullfile(temp_folder,[char(dp_names(i)),'.zip']));
        fid_zip_12 = fopen(fullfile(temp_folder,[filename_c12,'.zip']));
        fid_zip_21 = fopen(fullfile(temp_folder,[filename_c21,'.zip']));
        
        c_file = fread(fid_zip, Inf, '*char');
        c_file12 = fread(fid_zip_12, Inf, '*char');
        c_file21 = fread(fid_zip_21, Inf, '*char');
        
        K2 = length(c_file);
        K12 = length(c_file12);
        K21 = length(c_file21);

        fclose(fid_zip);
        fclose(fid_zip_12);
        fclose(fid_zip_21);
        
        % Distance based on K-complexity
        d = (K12 - K2 + K21 - K1)/K12;
        
        % 07. Accumulate distances in a row-vector called 'new_distances'
        new_distances(i) = d;
        
        % 08. Close, clean and delete generated files
        delete(fullfile(temp_folder,filename_txt));
        delete(fullfile(temp_folder,[filename_c12,'.txt']));
        delete(fullfile(temp_folder,[filename_c21,'.txt']));
        delete(fullfile(temp_folder,[char(dp_names(i)),'.zip']));
        delete(fullfile(temp_folder,[filename_c12,'.zip']));
        delete(fullfile(temp_folder,[filename_c21,'.zip']));
        
        cnt = i * 100 / length(dp_paths);
        if mod(cnt,5) == 0
            disp([int2str(cnt),'% completed']);
        end
    end
    
    % 09. Sort and take values
    [d_vec, sort_idx] = sort(new_distances);
    s_vec = labels(sort_idx);
end
    if exist(temp_folder, 'dir')
        rmdir(temp_folder, 's');
    end
    d_vec = d_vec(1:k);
    s_vec = s_vec(1:k);
end