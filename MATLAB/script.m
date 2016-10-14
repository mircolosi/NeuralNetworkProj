clc; clear all; close all;

addpath('/Users/mircocolosi/Documents/MATLAB/matlab-midi-master/src');

dataset_folder = uigetdir(pwd, 'Select DATASET folder');

[SM3, name_list] = sim_matrix3(dataset_folder);

imshow(SM3);