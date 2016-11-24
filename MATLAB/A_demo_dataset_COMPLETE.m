clc; clear all; close all;

SM_ST = load('ST_SM.mat');
SM_ST = SM_ST.SM3;

SM_FULL = load('FULL_SM.mat');
SM_FULL = SM_FULL.SM;

%% Retrieving the name of the files for ST
midi_folder = fullfile(pwd,'..','MIDI_TrainingSet_ST');
authors_folders = dir(midi_folder);
authors_folders = authors_folders(3:end);

dataset_size = 0;
X_ST = {};
Y_ST = {};
N_ST = {};
for i = 1:length(authors_folders)
    author_files = dir(fullfile(midi_folder,authors_folders(i).name));
    author_files = author_files(3:end);
    
    for j = 1:length(author_files)
        X_ST(i, j) = {fullfile(midi_folder,authors_folders(i).name,author_files(j).name)};
        Y_ST(i, j) = {authors_folders(i).name};
        N_ST(i, j) = {[authors_folders(i).name,'_',int2str(j)]};
        dataset_size = dataset_size + 1;
    end
end

X_ST = reshape(X_ST',dataset_size,1);
X_ST = horzcat(X_ST,reshape(N_ST',dataset_size,1));
Y_ST = reshape(Y_ST',dataset_size,1);


%% Retrieving the name of the files for FULL
midi_folder = fullfile(pwd,'..','MIDI_TestSet_FULL');
authors_folders = dir(midi_folder);
authors_folders = authors_folders(3:end);

dataset_size = 0;
X_FULL = {};
Y_FULL = {};
N_FULL = {};
for i = 1:length(authors_folders)
    author_files = dir(fullfile(midi_folder,authors_folders(i).name));
    author_files = author_files(3:end);
    
    for j = 1:length(author_files)
        X_FULL(i, j) = {fullfile(midi_folder,authors_folders(i).name,author_files(j).name)};
        Y_FULL(i, j) = {authors_folders(i).name};
        N_FULL(i, j) = {[authors_folders(i).name,'_',int2str(j)]};
        dataset_size = dataset_size + 1;
    end
end

X_FULL = reshape(X_FULL',dataset_size,1);
X_FULL = horzcat(X_FULL,reshape(N_FULL',dataset_size,1));
Y_FULL = reshape(Y_FULL',dataset_size,1);







%% TEST SETS
% Single Track with K = 3
[X_new_ST_3, Y_new_ST_3] = retrieveNewLabels(fullfile(pwd,'..','MIDI_TrainingSet_ST'), X_ST, Y_ST, SM_ST, 3);

% Single Track with K = 5
[X_new_ST_5, Y_new_ST_5] = retrieveNewLabels(fullfile(pwd,'..','MIDI_TrainingSet_ST'), X_ST, Y_ST, SM_ST, 5);

% Single Track with K = 7
[X_new_ST_7, Y_new_ST_7] = retrieveNewLabels(fullfile(pwd,'..','MIDI_TrainingSet_ST'), X_ST, Y_ST, SM_ST, 7);


% Full Track with K = 3
[X_new_Full_3, Y_new_Full_3] = retrieveNewLabels(fullfile(pwd,'..','MIDI_TrainingSet_ST'), X_FULL, Y_FULL, SM_FULL, 3);

% Full Track with K = 5
[X_new_Full_5, Y_new_Full_5] = retrieveNewLabels(fullfile(pwd,'..','MIDI_TrainingSet_ST'), X_FULL, Y_FULL, SM_FULL, 5);

% Full Track with K = 7
[X_new_Full_7, Y_new_Full_7] = retrieveNewLabels(fullfile(pwd,'..','MIDI_TrainingSet_ST'), X_FULL, Y_FULL, SM_FULL, 7);

%%
amp=10; 
fs=20500;  % sampling frequency
duration=0.3;
freq=880;
values=0:1/fs:duration;
a=amp*sin(2*pi* freq*values);
sound(a)
