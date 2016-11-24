function [X_new, Y_new] = retrieveNewLabels( path_to_dataset, X, Y, SM, K )
test_set_folder = path_to_dataset;
authors_folders = dir(test_set_folder);
authors_folders = authors_folders(3:end);

name_file = strsplit(test_set_folder,'_');
name_file = strcat('test_', name_file(end), '_', int2str(K),'.mat');
disp(strcat('Generating file', name_file));

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


%% Gathering new labels
Y_new = cell(length(X_new),2);
tic
for i = 1:length(X_new)
    [dists, labels] = kNNSimilaritySearch(X_new(i,:), X, Y, SM, K);
    Y_new{i,1} = dists;
    Y_new{i,2} = labels;
    
    cnt = i * 100 / length(X_new);
    if mod(cnt,5) == 0
        disp([int2str(cnt),'% completed']);
    end
end
toc
save(name_file, 'X_new', 'Y_new');

end

