clc; clear all; close all;

full_7 = load('test_FULL_7.mat');
st_7 = load('test_ST_7.mat');

Y_full = full_7.Y_new;
Y_st = st_7.Y_new;

%% retrieving ground truth
midi_folder = fullfile(pwd,'..','MIDI_TestSet_ST');
authors_folders = dir(midi_folder);
authors_folders = authors_folders(3:end);

dataset_size = 0;
Y_truth = {};
for i = 1:length(authors_folders)
    author_files = dir(fullfile(midi_folder,authors_folders(i).name));
    author_files = author_files(3:end);
    
    for j = 1:length(author_files)
        Y_truth(i, j) = {authors_folders(i).name};
        dataset_size = dataset_size + 1;
    end
end
Y_truth = reshape(Y_truth',dataset_size,1);

%% Predict Label based on KNN
authors = {};
for i = 1:length(authors_folders)
    authors{i} = authors_folders(i).name;
end

pred_labels_FULL_7 = cell(dataset_size,1);
pred_labels_FULL_5 = cell(dataset_size,1);
pred_labels_FULL_3 = cell(dataset_size,1);

pred_labels_ST_7 = cell(dataset_size,1);
pred_labels_ST_5 = cell(dataset_size,1);
pred_labels_ST_3 = cell(dataset_size,1);

for i = 1:dataset_size
    pred_labels_FULL_7(i) = getkNNLabel(Y_full{i,2}, authors);
    pred_labels_FULL_5(i) = getkNNLabel(Y_full{i,2}(1:5,:), authors);
    pred_labels_FULL_3(i) = getkNNLabel(Y_full{i,2}(1:3,:), authors);
    
    pred_labels_ST_7(i) = getkNNLabel(Y_st{i,2}, authors);
    pred_labels_ST_5(i) = getkNNLabel(Y_st{i,2}(1:5,:), authors);
    pred_labels_ST_3(i) = getkNNLabel(Y_st{i,2}(1:3,:), authors);
end

%% Confusion Matrices
CM_full_7 = confusionmat(Y_truth, pred_labels_FULL_7)
CM_full_5 = confusionmat(Y_truth, pred_labels_FULL_5)
CM_full_3 = confusionmat(Y_truth, pred_labels_FULL_3)

CM_st_7 = confusionmat(Y_truth, pred_labels_ST_7)
CM_st_5 = confusionmat(Y_truth, pred_labels_ST_5)
CM_st_3 = confusionmat(Y_truth, pred_labels_ST_3)

% PLOTS
% figure('Name','CM_full_7');
% plotconfusion(Y_truth,pred_labels_FULL_7);
% figure('Name','CM_full_5');
% plotconfusion(Y_truth,pred_labels_FULL_5);
% figure('Name','CM_full_3');
% plotconfusion(Y_truth,pred_labels_FULL_3);
% 
% figure('Name','CM_st_7');
% plotconfusion(Y_truth,pred_labels_ST_7);
% figure('Name','CM_st_5');
% plotconfusion(Y_truth,pred_labels_ST_5);
% figure('Name','CM_st_3');
% plotconfusion(Y_truth,pred_labels_ST_3);