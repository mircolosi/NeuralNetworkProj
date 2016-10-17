clc; clear all; close all;

addpath('../matlab-midi-master/src');

% dataset_folder = uigetdir(pwd, 'Select DATASET folder');
% 
% dataset_folder = '../MIDI_Dataset'
%[SM3, name_list] = sim_matrix3(dataset_folder);

[SM3, name_list] = new_born('../MIDI_Dataset', false, true);

%imshow(SM3);