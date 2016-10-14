clc; clear all; close all;
midi = readmidi('../MIDI_Dataset/Bach/Bach0.mid');

Notes = midiInfo(midi, 0);

[val, idx] = unique(Notes(:,5));

tmp = Notes(idx,1:6);
tmp(:,1) = ones(length(tmp), 1);

midi_new = matrix2midi(tmp,midi.ticks_per_quarter_note);

writemidi(midi_new, 'prova.mid');
% Notes2 = Notes;
% Notes2(:,1:2) = ones(size(Notes,1),2);
% 
% Notes2 = Notes2(:,1:6);
% midi_new = matrix2midi(Notes2),midi.ticks_per_quarter_note);
% %midi_new = matrix2midi(Notes);
% 
% writemidi(midi_new, 'canzoni/prova.mid');
% 
% 
