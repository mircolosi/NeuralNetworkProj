function [ tmp, midi_new ] = convert_to_single_track( file_path, output_file_path )
%CONVERT_TO_SINGLE_TRACK Summary of this function goes here
%   Detailed explanation goes here

midi = readmidi(file_path);

Notes = midiInfo(midi, 0);

[v, idx] = unique(Notes(:,5));

tmp = Notes(idx,1:6);
tmp(:,1)    = ones(length(tmp), 1);
tmp(:,2)    = zeros(length(tmp), 1);
tmp(:,5)    = linspace(1,length(tmp),length(tmp))';
tmp(:,6)    = linspace(2,length(tmp)+1,length(tmp))';

midi_new = matrix2midi(tmp,midi.ticks_per_quarter_note);

writemidi(midi_new, output_file_path);

end

