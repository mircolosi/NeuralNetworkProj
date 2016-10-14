function [] = zip_dataset()
%ZIP_DATASET Summary of this function goes here
%   Detailed explanation goes here
 matlab_folder = pwd;

[parent_folder,name,ext] = fileparts(matlab_folder);
[no_folder,name_parent,ext] = fileparts(parent_folder) 
if (strcmp(name_parent,'NN_Project'))
    zip_folder = strcat(parent_folder,'/MIDI_zip/');
    midi_folder = strcat(parent_folder,'/MIDI_Dataset/');
    
    authors_folders = dir(midi_folder);        % cartelle in midi_folder
    authors_folders = authors_folders(3:end);

    for i = 1:length(authors_folders)
        author = authors_folders(i).name;
        current_folder = strcat(midi_folder, author);
        midi_files = dir(current_folder);
        midi_files = midi_files(3:end);
        zip_author_folder = strcat(zip_folder, author, '/');
        mkdir(zip_author_folder);
        for j = 1:length(midi_files);
            if (strfind(midi_files(j).name, '.mid'))
                zip(strcat(zip_author_folder,strrep(midi_files(j).name, '.mid', '.zip')), ...
                    midi_files(j).name, current_folder);      
            end
        end
    end 
else
    disp('Move to NN_Project/MATLAB directory');
end

