=======================================
Instructions to produce Julia set movie
=======================================
(in the following, the '$' symbol serves
as a placeholder for the command prompt)

(i) run executable: 
$ ./julia_set.run

(ii) run gnuplot script:
$ gnuplot loop_monochrome_image.gnu

(iii) run ffmpeg script:
$ ./create_movie.sh

(iv) the movie will be stored in this
directory, filename 'julia.mp4'
There is no video player installed,
so you have to copy this file to your
local machine (using scp on Linux or the
free program WinSCP on Windows)
Enjoy and experiment.

