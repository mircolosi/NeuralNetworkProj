import sys
import os
from argparse import ArgumentParser


def get_arguments():
	parser = ArgumentParser("")
	parser.add_argument('input_folder')
	args = parser.parse_args()
	return args

def main():
	args = get_arguments()
	input_folder = args.input_folder

	midi_folder = os.listdir(input_folder)

	for artist in midi_folder:
		artist_path = input_folder+artist
		if os.path.isdir(artist_path):
			midi_artist_files = os.listdir(artist_path)
			count = 0
			for f in midi_artist_files:
				tmp =  input_folder+artist+'/'+f
				tmp2 = input_folder+artist+'/'+'"'+ f+'"'
				print tmp
				if os.path.isfile(tmp):
					new_filename = artist+str(count)+'.mid'
					print artist_path + '/' + new_filename
					os.system('mv '+ tmp2 + ' ' + new_filename)
				else:
					print "ERRORE"
				count += 1

		


if __name__ == '__main__':
	main()