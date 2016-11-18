clc; clear all; close all;

SM = load('new_born_SM.mat');
SM = SM.SM3;

%% Retrieving the name of the files
midi_folder = uigetdir(pwd, 'Select DATASET folder');
[parent_folder,~,~] = fileparts(midi_folder);
authors_folders = dir(midi_folder);
% all the subfolder of the dataset (categorized by author)
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
        N(i, j) = {[authors_folders(i).name(1),authors_folders(i).name(end),'_',int2str(j)]};
        dataset_size = dataset_size + 1;
    end
end

X = reshape(X',dataset_size,1);
X = horzcat(X,reshape(N',dataset_size,1));
Y = reshape(Y',dataset_size,1);