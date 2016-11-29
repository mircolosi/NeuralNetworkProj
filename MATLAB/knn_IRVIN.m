clc; clear all; close all;

SM = load('ST_SM.mat');
SM = SM.SM3;

%% Retrieving the name of the files
midi_folder = uigetdir(pwd, 'Select DATASET folder');
authors_folders = dir(midi_folder);
authors_folders = authors_folders(3:end);

dataset_size = 0;
X = {};
Y = {};
N = {};
for i = 1:length(authors_folders)
    author_files = dir(fullfile(midi_folder,authors_folders(i).name));
    author_files = author_files(3:end);
    
    for j = 1:length(author_files)
        X(i, j) = {fullfile(midi_folder,authors_folders(i).name,author_files(j).name)};
        Y(i, j) = {authors_folders(i).name};
        N(i, j) = {[authors_folders(i).name,'_',int2str(j)]};
        dataset_size = dataset_size + 1;
    end
end

X = reshape(X',dataset_size,1);
X = horzcat(X,reshape(N',dataset_size,1));
Y = reshape(Y',dataset_size,1);

%% Building test-set data structure.
test_set_folder = uigetdir(pwd, 'Select TEST-SET folder');
[parent_folder,~,~] = fileparts(test_set_folder);
authors_folders = dir(test_set_folder);
authors_folders = authors_folders(3:end);

test_set_size = 0;
X_new = {};
N_new = {};

for i = 1:length(authors_folders)
    author_files = dir(fullfile(test_set_folder,authors_folders(i).name));
    author_files = author_files(3:end);
    
    for j = 1:length(author_files)
        X_new(i, j) = {fullfile(test_set_folder,authors_folders(i).name,author_files(j).name)};
        N_new(i, j) = {[authors_folders(i).name(1),authors_folders(i).name(end),'_test_',int2str(j)]};
        test_set_size = test_set_size + 1;
    end
end

X_new = reshape(X_new',test_set_size,1);
X_new = horzcat(X_new,reshape(N_new',test_set_size,1));

