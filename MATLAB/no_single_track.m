clc; clear all;close all;

[root_folder,~,~] = fileparts(pwd);

midi_folder = fullfile(root_folder,'MIDI_TrainingSet_FULL');
authors_folders = dir(midi_folder);
% all the subfolder of the dataset (categorized by author)
authors_folders = authors_folders(3:end);

midi_text = fullfile(root_folder, 'MIDI_TrainingSet_text_FULL');
n_files = 0;

convert_txt = true;
if (convert_txt == true)
    list_name_files = cellstr('');
    
    disp('Converting the files into text files');
    
    % reset la directory dei midi_txt
    if exist(midi_text, 'dir')
        rmdir(midi_text, 's');
    end
    mkdir(midi_text);
    
    for i = 1:length(authors_folders)
        author = authors_folders(i).name;
        current_folder = fullfile(midi_folder, author)
        
        midi_files = dir(current_folder);
        midi_files = midi_files(3:end);
        midi_author_folder = fullfile(midi_text, author);
        % create dir for each author both in zip and midi_text folder
        mkdir(midi_author_folder);
        
        for j = 1:length(midi_files);
            if (strfind(midi_files(j).name, '.mid'))
                % the current file is opened and wrote as a text file
                fid = fopen(fullfile(current_folder, midi_files(j).name));
                
                %file_text_name = fullfile(midi_author_folder, strcat(midi_files(j).name, num2str(j), '.txt'));
                file_text_name = fullfile(midi_author_folder, [midi_files(j).name(1:end-4), '.txt']);
                fid_text = fopen(file_text_name, 'w');
                
                
                text = fread(fid, Inf, '*char');
                fprintf(fid_text,'%c',text);
                
                fclose(fid);
                fclose(fid_text);
                
                %list_name_files = vertcat(list_name_files, strcat(midi_files(j).name, num2str(j), '.txt'));
                %list_name_files = vertcat(list_name_files, [midi_files(j).name(1:end-4), '.txt']);
                list_name_files = vertcat(list_name_files, file_text_name);
                n_files = n_files+1;
            end
        end
    end
end
list_name_files = list_name_files(2:end);
cnt = 0;
for i = 1:length(list_name_files)
    for j = i:length(list_name_files)
        cnt = cnt + 1;
    end
end

cnt

%% Computing SM

SM = zeros(n_files);
disp('Starting computation similarity matrix!');
curr = 0;
tmp_folder = fullfile(root_folder, 'tmp_folder');
mkdir(tmp_folder);
for i = 1:length(list_name_files)
    [current_folder,a,~] = fileparts(list_name_files{i});
    [~,author,~] = fileparts(current_folder);
    
    fid_1 = fopen(list_name_files{i});
    text1 = fread(fid_1, Inf, '*char');
    fclose(fid_1);
    [~,name1,~] = fileparts(list_name_files{i});
    z1 = fullfile(tmp_folder,[name1,'.zip']);
    
    zip(z1,list_name_files{i});
    fid1 = fopen(z1);
    c_file1 = fread(fid1, Inf, '*char');
    fclose(fid1);
    K1 = length(c_file1);
    delete(z1);
    for j = i:length(list_name_files)
        
        [other_folder,b,~] = fileparts(list_name_files{j});
        [~,other_author,~] = fileparts(other_folder);
        
        fid_2 = fopen(list_name_files{j});
        text2 = fread(fid_2, Inf, '*char');
        fclose(fid_2);
        
        [~,name2,~] = fileparts(list_name_files{j});
        z2 = fullfile(tmp_folder,[name2,'.zip']);
        zip(z2,list_name_files{j});
        fid2 = fopen(z2);
        c_file2 = fread(fid2, Inf, '*char');
        fclose(fid2);
        K2 = length(c_file2);
        delete(z2);
        
        tmp_txt_file1 = fullfile(tmp_folder, [name1, '_', name2, '.txt']);
        fid_cat = fopen(tmp_txt_file1, 'w+');
        textcat = vertcat(text1,text2);
        fprintf(fid_cat, '%c', textcat);
        fclose(fid_cat);
        
        z12 = fullfile(tmp_folder, [name1, '_', name2, '.zip']);
        zip(z12,tmp_txt_file1);
        fid12 = fopen(z12);
        c_file12 = fread(fid12, Inf, '*char');
        fclose(fid12);
        K12 = length(c_file12);
        delete(tmp_txt_file1);
        delete(z12);
        
        tmp_txt_file2 = fullfile(tmp_folder, [name2, '_', name1, '.txt']);
        inv_fid_cat = fopen(tmp_txt_file2,'w+');
        inv_textcat = vertcat(text2,text1);
        fprintf(inv_fid_cat, '%c', inv_textcat);
        fclose(inv_fid_cat);
        
        z21 = fullfile(tmp_folder, [name2, '_', name1, '.zip']);
        zip(z21, tmp_txt_file2);
        fid21 = fopen(z21);
        c_file21 = fread(fid21, Inf, '*char');
        fclose(fid21);
        K21 = length(c_file21);
        delete(tmp_txt_file2);
        delete(z21);
        
        ds_12 = (K12 - K2 + K21 - K1)/K12;
        ds_21 = (K21 - K1 + K12 - K2)/K21;
        
        % fill the Similiarity matrix with the distances
        SM(i,j) = ds_12;
        SM(j,i) = ds_21;
        
        curr = curr + 1;
        
        perc = curr * 100 / cnt;
        if mod(perc, 1) == 0
            disp([int2str(perc),'% completed']);
        end
        
    end
    
end
