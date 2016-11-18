%% Initialization Folders and names
%midi_folder = dataset_folder;
midi_folder = '../MIDI_Dataset';

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
n_files = 0;

single_track = true;
convert_txt = true;

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
                n_files = n_files+1;
            end
        end
        
    end
else
    disp('No need to convert files into single-track midi files')
end


%% Convert to txt files
n = 1;
X = zeros(n_files,1); Y = cell(n_files,1);
list_name_files = cell(n_files, 1);
if (convert_txt == true)
    %list_name_files = cellstr('');
    
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
                X(n,1) = length(text);
                fprintf(fid_text,'%c',text);
                Y{n,1} = author;
                
                fclose(fid);
                fclose(fid_text);
                
                %list_name_files = vertcat(list_name_files, strcat(midi_files(j).name, num2str(j), '.txt'));
                %list_name_files = vertcat(list_name_files, [midi_files(j).name(1:end-4), '.txt']);
                list_name_files{n,1} = file_text_name;
                n_author = n_author+1;
                n = n+1;
            end
        end
    end
end

prova = table(list_name_files, X, 'VariableNames', {'path' 'X'});

KNNMdl = fitcknn(prova,Y, 'Distance', @(x,y)k_dist(prova.path, prova.path, x,y));