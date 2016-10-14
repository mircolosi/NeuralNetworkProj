clc;clear all; close all;

matlab_folder = pwd;
K = [];
[parent_folder,name,ext] = fileparts(matlab_folder);
[no_folder,name_parent,ext] = fileparts(parent_folder);
if (strcmp(name_parent,'NN_Project'))
    zip_folder = fullfile(parent_folder,'MIDI_zip');
    midi_folder = fullfile(parent_folder,'MIDI_Dataset');
    midi_text = fullfile(parent_folder, 'MIDI_text');
    
    authors_folders = dir(midi_folder);        % cartelle in midi_folder
    authors_folders = authors_folders(3:end);
    
    if exist(midi_text, 'dir')
        rmdir(midi_text, 's');
    end
    if exist(zip_folder, 'dir')
        rmdir(zip_folder, 's');
    end
    mkdir(midi_text);
    mkdir(zip_folder);
    
    n_author = 0;
    
    list_name_files = cellstr('');
    
    for i = 1:length(authors_folders)
        author = authors_folders(i).name;
        current_folder = fullfile(midi_folder, author);
        
        midi_files = dir(current_folder);
        midi_files = midi_files(3:end);
        zip_author_folder = fullfile(zip_folder, author);
        midi_author_folder = fullfile(midi_text, author);
        mkdir(midi_author_folder);
        mkdir(zip_author_folder);
        
        for j = 1:length(midi_files);
            if (strfind(midi_files(j).name, '.mid'))
                fid = fopen(fullfile(current_folder, midi_files(j).name));
                file_text_name = fullfile(midi_author_folder, strcat(midi_files(j).name(1), num2str(j), '.txt'));
                fid_text = fopen(file_text_name, 'w');
                text = fread(fid, '*char');
                fprintf(fid_text,text);
                fclose(fid);
                fclose(fid_text);
                list_name_files = vertcat(list_name_files, strcat(midi_files(j).name(1), num2str(j), '.txt'));
                n_author = n_author+1;
            end
        end
    end
    
    list_name_files = list_name_files(2:end);
    
    SM = zeros(n_author);
    % leggiamo i file a due a due e li concateniamo in un file di testo
    author_text_folders = dir(midi_text);
    author_text_folders = author_text_folders(3:end);
    n_author = 0;
    n_other_author = 0;
    
    n = 1;
    
    for i = 1:length(author_text_folders)               % author_text_folders: contiene le cartelle con i nomi degli autori
        author = author_text_folders(i).name;           % author: il nome dell'autore corrente
        current_folder = fullfile(midi_text, author); % current_folder: '../MIDI_text/nomeAutore'
        text_files = dir(current_folder);               % text_files: lista di file in current_folder
        text_files = text_files(3:end);
        for j = 1: length(text_files)
            name_text_file1 = text_files(j).name;
            m = 1;
            
            if(strfind(name_text_file1, '.txt'))
                fid_1 = fopen(fullfile(current_folder, name_text_file1));
                text1 = fread(fid_1, '*char');
                fclose(fid_1);
                for k = 1:length(author_text_folders)
                    other_author = author_text_folders(k).name;
                    
                    other_folder = fullfile(midi_text, other_author);
                    other_text_files = dir(other_folder);
                    other_text_files = other_text_files(3:end);
                    folder_cat = fullfile(midi_text, strcat(author,'_',other_author));
                    inv_folder_cat = fullfile(midi_text, strcat(other_author,'_',author));
                    zip_cat = fullfile(zip_folder, strcat(author,'_',other_author));
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
                    
                    
                    for l = 1:length(other_text_files)
                        name_text_file2 = other_text_files(l).name;
                        if (strfind(name_text_file2,'.txt'))
                            fid_2 = fopen(fullfile(other_folder, name_text_file2));
                            text2 = fread(fid_2,'*char');
                            fclose(fid_2);
                            a = strrep(name_text_file1, '.txt','');
                            b = strrep(name_text_file2, '.txt','');
                            if (~exist(fullfile(folder_cat, strcat(a, '_', b, '.txt')),'file') || ...
                                    ~exist(fullfile(inv_folder_cat, strcat(b, '_', a, '.txt')),'file'))
                                fid_cat = fopen(fullfile(folder_cat, strcat(a, '_', b, '.txt')), 'w+');
                                textcat = vertcat(text1,text2);
                                fprintf(fid_cat, textcat);
                                fclose(fid_cat);
                                inv_fid_cat = fopen(fullfile(inv_folder_cat, strcat(b, '_', a, '.txt')),'w+');
                                inv_textcat = vertcat(text2,text1);
                                fprintf(inv_fid_cat, inv_textcat);
                                fclose(inv_fid_cat);
                            end
                            zip_file1 = fullfile(zip_folder, author,strcat(a, '.zip'));
                            
                            if(~exist(zip_file1,'file'))
                                zip(zip_file1, fullfile(current_folder, strcat(a, '.txt')));
                            end

                            zip_file2 = fullfile(zip_folder, other_author, strcat(b, '.zip'));
                            if (~exist(zip_file2, 'file'))
                                zip(zip_file2, fullfile(other_folder, strcat(b, '.txt')));
                            end
                            %fare zip concatenati e inv_concatenati
                            
                            
                            %calcolare le distanze (2x dS  e 2x d)
                            zip_file12 = fullfile(zip_cat, strcat(a, '_', b, '.zip'));
                            zip_file21 = fullfile(inv_zip_cat, strcat(b, '_', a, '.zip'));

                            if (~exist(zip_file12,'file') || ~exist(zip_file21,'file'))
                                zip(zip_file12, fullfile(folder_cat, strcat(a, '_', b, '.txt')));
                                
                                zip(zip_file21, fullfile(inv_folder_cat, strcat(b, '_', a, '.txt')));
                                
                            end
                            
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
                            
                            ds_12 = (K12 - K2 + K21 - K1)/K12;
                            ds_21 = (K21 - K1 + K12 - K2)/K21;

                            SM(n,m) = ds_12;
                            SM(m,n) = ds_21;
                            
                            m = m + 1;
                            
                        end
                    end
                end
            end
            n = n+1;
        end
       
    end
    
end
