
fid=fopen('../util/track_files.txt');
tline = fgetl(fid);
file_list = {};
while ischar(tline)
    file_list = vertcat(file_list,tline);
    tline=fgetl(fid);
end
fclose(fid);
SM = zeros(length(file_list));
zip_folder = '../MIDI_zip/';
for i = 1:length(file_list)
    [path, name, ~] = fileparts(file_list{i});
    [~,author,~] = fileparts(path);
    for j = i:length(file_list)
        [other_path, other_name, ~] = fileparts(file_list{j});
        [~,other_author,~] = fileparts(other_path);
        zip_file1 = fullfile(zip_folder, author, [name, '.zip']);
        zip_file2 = fullfile(zip_folder, other_author, [other_name, '.zip']);
        zip_file12 = fullfile(zip_folder,[author,'_',other_author], [name,'_', other_name, '.zip'])
        zip_file21 = fullfile(zip_folder,[other_author,'_',author], [other_name,'_', name, '.zip']);
        
        
        fid1 = fopen(zip_file1);
        fid2 = fopen(zip_file2);
        fid12 = fopen(zip_file12);
        fid21 = fopen(zip_file21);
        
        c_file1 = fread(fid1, Inf, '*char');
        c_file2 = fread(fid2, Inf, '*char');
        c_file12 = fread(fid12, Inf, '*char');
        c_file21 = fread(fid21, Inf, '*char');
        
        K1 = length(c_file1);
        K2 = length(c_file2);
        K12 = length(c_file12);
        K21 = length(c_file21);
        
        fclose(fid1);
        fclose(fid2);
        fclose(fid12);
        fclose(fid21);
        % caluclate the distance based on the eximation of
        % Kolmogorov complexity
        ds_12 = (K12 - K2 + K21 - K1)/K12;
        ds_21 = (K21 - K1 + K12 - K2)/K21;
        
        % fill the Similiarity matrix with the distances
        SM(i,j) = ds_12;
        SM(j,i) = ds_21;
        
        
    end
end

SM


