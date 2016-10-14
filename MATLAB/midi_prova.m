clc; clear all; close all;

midi = readmidi('bach_846.mid');

Notes = midiInfo(midi, 0);

Notes2 = Notes;
Notes2(:,1:2) = ones(size(Notes,1),2);

Notes2 = Notes2(:,1:6);
midi_new = matrix2midi(Notes2);%,midi.ticks_per_quarter_note);
midi_new = matrix2midi(Notes);

writemidi(midi_new, 'canzoni/prova.mid');


