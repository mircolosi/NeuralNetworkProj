clc; clear all;

matlab_folder = pwd;

cd ../MIDI_zip/;
zip_folders = dir;

zip_folders = zip_folders(3:end);

directorys = containers.Map;

for i = 1:length(zip_folders)
    zip_folder = zip_folders(i);
    if (strfind(zip_folder.name,'_') )
        authors = regexp(zip_folder.name,'(\w+)_(\w+)','tokens');
        cd(zip_folder.name);
        midi_files = dir;
        midi_files = midi_files(3:end);
        for j = 1:length(midi_files)
            directorys(midi_files(j).name) = authors;
        end
        cd ../;
    else 
        author = zip_folder.name;
        cd (author);
        midi_files = dir;
        midi_files = midi_files(3:end);
        for j = 1:length(midi_files)
            directorys(midi_files(j).name) = author;
        end
        cd ../;
    end
end

for i = 1:length(zip_folders)
    zip_folder = zip_folders(i);
    if (strfind(zip_folder.name,'_') )
        
    else 
        author = zip_folder.name;
        cd (author);
        midi_files = dir;
        midi_files = midi_files(3:end);
        for j = 1:length(midi_files)
            directorys(midi_files(j).name) = author;
        end
        cd ../;
    end
end


cd(matlab_folder)

