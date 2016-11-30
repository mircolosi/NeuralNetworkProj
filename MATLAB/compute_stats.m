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
wanna_plot = false;
if wanna_plot
    f = figure('Name','CM_full_7');
    imagesc(CM_full_7)
    set(gca, 'XTick', [1:1:6],'XTickLabel',authors);
    set(gca, 'YTick', [1:1:6],'YTickLabel',authors);
    set(gca,'DataAspectRatio',[1 1 1]);
    f.Position = [f.Position(1), f.Position(2),f.Position(3)*2,f.Position(4)*2];
    print('CM_full_7.png', '-dpng');
    % colormap jet % # to change the default grayscale colormap
    
    f = figure('Name','CM_full_5');
    imagesc(CM_full_5)
    set(gca, 'XTick', [1:1:6],'XTickLabel',authors);
    set(gca, 'YTick', [1:1:6],'YTickLabel',authors);
    set(gca,'DataAspectRatio',[1 1 1]);
    f.Position = [f.Position(1), f.Position(2),f.Position(3)*2,f.Position(4)*2];
    print('CM_full_5.png', '-dpng');
    % colormap jet % # to change the default grayscale colormap
    
    f = figure('Name','CM_full_3');
    imagesc(CM_full_3)
    set(gca, 'XTick', [1:1:6],'XTickLabel',authors);
    set(gca, 'YTick', [1:1:6],'YTickLabel',authors);
    set(gca,'DataAspectRatio',[1 1 1]);
    f.Position = [f.Position(1), f.Position(2),f.Position(3)*2,f.Position(4)*2];
    print('CM_full_3.png', '-dpng');
    % colormap jet % # to change the default grayscale colormap
    
    f = figure('Name','CM_st_7');
    imagesc(CM_st_7)
    set(gca, 'XTick', [1:1:6],'XTickLabel',authors);
    set(gca, 'YTick', [1:1:6],'YTickLabel',authors);
    set(gca,'DataAspectRatio',[1 1 1]);
    f.Position = [f.Position(1), f.Position(2),f.Position(3)*2,f.Position(4)*2];
    print('CM_st_7.png', '-dpng');
    % colormap jet % # to change the default grayscale colormap
    
    f = figure('Name','CM_st_5');
    imagesc(CM_st_5)
    set(gca, 'XTick', [1:1:6],'XTickLabel',authors);
    set(gca, 'YTick', [1:1:6],'YTickLabel',authors);
    set(gca,'DataAspectRatio',[1 1 1]);
    f.Position = [f.Position(1), f.Position(2),f.Position(3)*2,f.Position(4)*2];
    print('CM_st_5.png', '-dpng');
    % colormap jet % # to change the default grayscale colormap
    
    f = figure('Name','CM_st_3');
    imagesc(CM_st_3)
    set(gca, 'XTick', [1:1:6],'XTickLabel',authors);
    set(gca, 'YTick', [1:1:6],'YTickLabel',authors);
    set(gca,'DataAspectRatio',[1 1 1]);
    f.Position = [f.Position(1), f.Position(2),f.Position(3)*2,f.Position(4)*2];
    print('CM_st_3.png', '-dpng');
    % colormap jet % # to change the default grayscale colormap
end

%% Precision and recall

precision = @(confusionMat) diag(confusionMat)./sum(confusionMat,2);

recall = @(confusionMat) diag(confusionMat)./sum(confusionMat,1)';


precision_full_7 =  precision(CM_full_7);
recall_full_7 =     recall(CM_full_7);
mean_precision_full_7 = mean(precision_full_7);
   mean_recall_full_7 =    mean(recall_full_7);

precision_full_5 =  precision(CM_full_5);
recall_full_5 =     recall(CM_full_5);
mean_precision_full_5 = mean(precision_full_5);
   mean_recall_full_5 =    mean(recall_full_5);
   
precision_full_3 =  precision(CM_full_3);
recall_full_3 =     recall(CM_full_3);
mean_precision_full_3 = mean(precision_full_3);
   mean_recall_full_3 =    mean(recall_full_3);
   
global_precision_full_mean = mean([mean_precision_full_7, mean_precision_full_5, mean_precision_full_3])
global_recall_full_mean = mean([mean_recall_full_7, mean_recall_full_5, mean_recall_full_3])

precision_st_7 =  precision(CM_st_7);
recall_st_7 =     recall(CM_st_7);
mean_precision_st_7 = mean(precision_st_7);
   mean_recall_st_7 =    mean(recall_st_7);

precision_st_5 =  precision(CM_st_5);
recall_st_5 =     recall(CM_st_5);
mean_precision_st_5 = mean(precision_st_5);
   mean_recall_st_5 =    mean(recall_st_5);

precision_st_3 =  precision(CM_st_3);
recall_st_3 =     recall(CM_st_3);
mean_precision_st_3 = mean(precision_st_3);
   mean_recall_st_3 =    mean(recall_st_3);

global_precision_st_mean = mean([mean_precision_st_7, mean_precision_st_5, mean_precision_st_3])
global_recall_st_mean = mean([mean_recall_st_7, mean_recall_st_5, mean_recall_st_3])


