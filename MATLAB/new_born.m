function [ SM, list_name_files ] = new_born( dataset_folder, single_track, convert_txt )
%NEW_BORN This function returns two arguments:
% the similarity matrix based on the kolmogorov distance of the midi
% dataset (passed by the argument df) and the vector of all the name
% of the files in the dataset

%% Initialization Folders and names
midi_folder = dataset_folder;

[parent_folder,~,~] = fileparts(midi_folder);

authors_folders = dir(midi_folder);
% all the subfolder of the dataset (categorized by author)
authors_folders = authors_folders(3:end);

% folder for the zip files
zip_folder = fullfile(parent_folder,'MIDI_zip');
% folder for the text_files
midi_text = fullfile(parent_folder, 'MIDI_text');
single_track_df = fullfile(parent_folder, 'MIDI_single_track');
n_author = 0;

%% PRE-PROCESSING
% SINGLE-TRACK CONVERSION
if single_track == true
    
    if exist(single_track_df, 'dir')
        rmdir(single_track_df, 's');
    end
    disp('Single track folder created');
    mkdir(single_track_df);
    
    disp('Converting the files into single-track midi files');
    for i = 1:length(authors_folders)
        author = authors_folders(i).name;
        current_folder = fullfile(midi_folder, author);
        
        midi_files = dir(current_folder);
        midi_files = midi_files(3:end);
        
        midi_author_folder = fullfile(single_track_df, author);
        mkdir(midi_author_folder);
        disp(midi_author_folder);
        
        for j = 1:length(midi_files)
            if (strfind(midi_files(j).name, '.mid'))
                convert_to_single_track(fullfile(current_folder, midi_files(j).name), [midi_author_folder,'/',midi_files(j).name]);
            end
        end
        
    end
else
    disp('No need to convert files into single-track midi files')
end


%% Convert to txt files

if (convert_txt == true)
    list_name_files = cellstr('');
    
    disp('Converting the files into text files');
    
    % reset la directory dei midi_txt
    if exist(midi_text, 'dir')
        rmdir(midi_text, 's');
    end
    mkdir(midi_text);
    
    % reset la directory dei midi zip
    if exist(zip_folder, 'dir')
        rmdir(zip_folder, 's');
    end
    mkdir(zip_folder);

    
    for i = 1:length(authors_folders)
        author = authors_folders(i).name;
        %current_folder = fullfile(midi_folder, author);
        current_folder = fullfile(single_track_df , author)
        
        midi_files = dir(current_folder);
        midi_files = midi_files(3:end);
        zip_author_folder = fullfile(zip_folder, author);
        midi_author_folder = fullfile(midi_text, author);
        % create dir for each author both in zip and midi_text folder
        mkdir(midi_author_folder);
        mkdir(zip_author_folder);
        
        % scan all the files in each subfolder
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
                n_author = n_author+1;
            end
        end
    end
end

list_name_files = list_name_files(2:end);

% author_text_folders: contains dirs with the name of the authors
author_text_folders = dir(midi_text);
author_text_folders = author_text_folders(3:end);



%% Computing Similarity Matrix
% In this section we execute a double iteration of the text subfolder to
% compute the distance of the file based on the extimation of the
% kolmogorov distance.

SM = zeros(n_author);


n = 1;
achepuntosiamo=1;

disp('Starting computation similarity matrix!');
for i = 1:length(author_text_folders)
    % author: the name of the current author
    author = author_text_folders(i).name;
    % current_folder: '../MIDI_text/authorName'
    current_folder = fullfile(midi_text, author);
    % text_files: list of all the files in the current folder
    text_files = dir(current_folder);
    text_files = text_files(3:end);
    
    disp(strcat('Converting files between author ', author));
    
    % scan all the text files in the current_folder
    for j = 1: length(text_files)
        
        name_text_file1 = text_files(j).name;
        m = 1;
        
        if(strfind(name_text_file1, '.txt'))
            % read the current text file
            fid_1 = fopen(fullfile(current_folder, name_text_file1));
            text1 = fread(fid_1, Inf, '*char');
            fclose(fid_1);
            % rescan the all the text subfolder
            for k = 1:length(author_text_folders)
                % name of the second author to be compared with
                other_author = author_text_folders(k).name;
                % folder with the other_author's name
                other_folder = fullfile(midi_text, other_author);
                % files within the other_folder
                other_text_files = dir(other_folder);
                other_text_files = other_text_files(3:end);
                
                % now we have to compute the concatenation between the
                % two files taken into account in oreder to compute their
                % distance
                
                % folder for the concatenation of the two file in direct
                % order
                folder_cat = fullfile(midi_text, strcat(author,'_',other_author));
                % folder for the concatenation of the two file in invers
                % order
                inv_folder_cat = fullfile(midi_text, strcat(other_author,'_',author));
                
                % folder that stores the concatenation of the two file in direct
                % order
                zip_cat = fullfile(zip_folder, strcat(author,'_',other_author));
                % folder that stores the concatenation of the two file in inverse
                % order
                inv_zip_cat = fullfile(zip_folder, strcat(other_author,'_',author));
                
                if ~exist(folder_cat, 'dir')
                    mkdir(folder_cat);
                end
                if ~exist(inv_folder_cat, 'dir')
                    mkdir(inv_folder_cat);
                end
                if ~exist(zip_cat, 'dir')
                    mkdir(zip_cat);
                end
                if ~exist(inv_zip_cat, 'dir')
                    mkdir(inv_zip_cat);
                end
                
                % scan all the other_text_files that will be compare with
                % text1
                for l = 1:length(other_text_files)
                    % name of the second file taken into account
                    name_text_file2 = other_text_files(l).name;
                    
                    if (strfind(name_text_file2,'.txt'))
                        % read the second file
                        fid_2 = fopen(fullfile(other_folder, name_text_file2));
                        text2 = fread(fid_2, Inf, '*char');
                        fclose(fid_2);
                        
                        a = strrep(name_text_file1, '.txt','');
                        b = strrep(name_text_file2, '.txt','');
                        
                        % if the concatenation between 'a' and 'b'
                        % or 'b' and 'a' wasn't already done concatenate
                        % the two files in direct and inverse order
                        
                        if (~exist(fullfile(folder_cat, strcat(a, '_', b, '.txt')),'file') || ...
                                ~exist(fullfile(inv_folder_cat, strcat(b, '_', a, '.txt')),'file'))
                            tmp_txt_file1 = fullfile(folder_cat, strcat(a, '_', b, '.txt'));
                            fid_cat = fopen(tmp_txt_file1, 'w+');
                            textcat = vertcat(text1,text2);
                            fprintf(fid_cat, '%c', textcat);
                            fclose(fid_cat);
                            tmp_txt_file2 = fullfile(inv_folder_cat, strcat(b, '_', a, '.txt'));
                            inv_fid_cat = fopen(tmp_txt_file2,'w+');
                            inv_textcat = vertcat(text2,text1);
                            fprintf(inv_fid_cat, '%c', inv_textcat);
                            fclose(inv_fid_cat);
                        end
                        
                        % zip the two files
                        zip_file1 = fullfile(zip_folder, author,strcat(a, '.zip'));
                        
                        if(~exist(zip_file1,'file'))
                            zip(zip_file1, fullfile(current_folder, strcat(a, '.txt')));
                        end
                        
                        zip_file2 = fullfile(zip_folder, other_author, strcat(b, '.zip'));
                        if (~exist(zip_file2, 'file'))
                            zip(zip_file2, fullfile(other_folder, strcat(b, '.txt')));
                        end
                        
                        % zip the direct and inverse concatenated files
                        zip_file12 = fullfile(zip_cat, strcat(a, '_', b, '.zip'));
                        zip_file21 = fullfile(inv_zip_cat, strcat(b, '_', a, '.zip'));
                        
                        if (~exist(zip_file12,'file') || ~exist(zip_file21,'file'))
                            zip(zip_file12, fullfile(folder_cat, strcat(a, '_', b, '.txt')));
                            
                            zip(zip_file21, fullfile(inv_folder_cat, strcat(b, '_', a, '.txt')));
                            
                        end
                        
                        % calulate the lenght of the zipped files
                        
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
                        SM(n,m) = ds_12;
                        SM(m,n) = ds_21;
                        
                        m = m + 1;
                        
                        delete(tmp_txt_file2);
                        delete(tmp_txt_file1);
                        achepuntosiamo = achepuntosiamo +1
                        
                    end
                end
            end
        end
        n = n+1;
    end
    
end
end


