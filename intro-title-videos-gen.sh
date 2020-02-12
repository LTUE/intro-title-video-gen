# DESCRIPTION
# Creates still title videos in Exo font from (intended purpose) a list of film
# titles, origin countries, and film durations. See USAGE.

# USAGE
# Get yeself a list of film titles in a format like this:
# Ana and the Flames\\nFrance [0:16:37]
# Evanescent\\nUkraine [0:03:00]
# Legend Of Ancient Borneo\\nMalaysia [0:08:43]
# Hunting Gamusinos\\nSpain [0:05:27]
# Nursery Crimes: The Case of Humpty Dumpty\\nCanada [0:07:57]
# (where the \\n is intended to be a newline)
# in a file named LTUE_2020_FF_selection_stats.txt (see the end of the script
# to hack it to something else)
# -- and run this script (with that file and Exo-Medium.ttf (a Google open
# font) in the same directory.
# It produces title videos of 15 second duration which read e.g.
# Film Title <newline> Origin Country [duration]. alongside the image stills
# it uses to render the title videos.

# DEPENDENCIES
# A 'nixy (bash) environment, ffmpeg, imagemagick.


# CODE
# sanitizes strings to be file-friendly; re: https://stackoverflow.com/a/44811468/1397555
sanitize() {
   local s="${1?need a string}" # receive input in first argument
   # get rid of darn windows problems; THIS DOES SO MORE EFFICIENTLY than any other method I've found; re: https://stackoverflow.com/a/19347380/1397555
   s=${element//[$'\t\r\n']}
   s="${s/\\n/-}"             # replace commented newline with __
   s="${s/\//-}"              # replace / with -
   s="${s/,/}"                # remove ,
   s="${s/,/}"                # again
   s="${s/./}"                # remove .
   s="${s/./}"                # again
   s="${s/[/}"                # remove [
   s="${s/]/}"                # remove ]
   s="${s/:/-}"               # repl. : with -
   s="${s/:/-}"               # again
   s="${s/:/-}"               # again
   # This is ridiculous:
   s="${s/ /__}"              # space to double-underline
   s="${s/ /__}"              # space to double-underline
   s="${s/ /__}"              # space to double-underline
   s="${s/ /__}"              # space to double-underline
   s="${s/ /__}"              # space to double-underline
   s="${s/ /__}"              # space to double-underline
   s="${s/ /__}"              # space to double-underline
   s="${s/ /__}"              # space to double-underline
   s="${s/ /__}"              # space to double-underline
   s="${s/ /__}"              # space to double-underline
   echo $s
}

while read element
do
	# regrettably the -gravity Center switch and parameter simply doesn't work in gm (graphicsmagick):
	sanitized_string=`sanitize $element`
	echo generating title image $sanitized_string
	magick convert -background "#203468" -fill "#ffffff" -font Exo-Medium.ttf -pointsize 140 -size 1920x1080 -gravity Center caption:"Next:\n$element" $sanitized_string.png
	# make a still video from that:
	ffmpeg -y -loop 1 -i $sanitized_string.png -crf 16 -t 15 "$sanitized_string"__"intro_title".mp4
done < LTUE_2020_FF_selection_stats.txt

