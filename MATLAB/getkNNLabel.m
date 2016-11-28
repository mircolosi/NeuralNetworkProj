function predicted_label = getkNNLabel( labels_vector, authors )
% This function retrieves the most common label among the ones
% closer to the new instance.
count_vector = zeros(length(authors),1);

for i = 1:length(authors)
    bool_vect = strcmp(authors(i),labels_vector);
    count_vector(i) = sum(bool_vect);
end
[~, label_idx] = sort(count_vector,'descend');
predicted_label = authors(label_idx(1));
end

