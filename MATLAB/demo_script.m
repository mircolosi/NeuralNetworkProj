clc; clear all; close all;

disp('Loading training matrix');
SM = load('ST_SM.mat');
SM = SM.SM3;

%% Retrieving the name of the files
midi_folder = fullfile(pwd,'..','MIDI_TrainingSet_ST');
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
        N(i, j) = {[authors_folders(i).name,int2str(j)]};
        dataset_size = dataset_size + 1;
    end
end

X = reshape(X',dataset_size,1);
X = horzcat(X,reshape(N',dataset_size,1));
Y = reshape(Y',dataset_size,1);

%% Building test-set data structure.
disp('Select test set file');
[file, file_path, ~] = uigetfile('*.mid','Select test file','..');

[~, file_name, ~] = fileparts(file);

X_new = {[file_path,file]};
N_new = {file_name};

X_new = horzcat(X_new,N_new);

%% K-NN
[dist_vec, labels] = kNNSimilaritySearch( X_new, X, Y, SM, 3 )
% [dist_vec, labels] = kNNSimilaritySearch_REV( X_new, X, Y, SM, 3 )

