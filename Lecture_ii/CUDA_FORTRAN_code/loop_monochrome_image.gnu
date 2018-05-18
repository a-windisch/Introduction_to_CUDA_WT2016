unset key
set terminal png transparent crop size 1024,1024
set object rectangle from screen 0,0 to screen 1,1 behind fillcolor rgb 'blue' fillstyle solid noborder
unset tics
unset border
do for [t=0:399] {
outfile = sprintf('julia_%03.0f.png',t)
set output outfile
stats sprintf('julia_%03i.dat', t) using 1:2 nooutput
xmin = (STATS_min_x)
xmax = (STATS_max_x)
#ymin = (STATS_min_y)
#ymax = (STATS_max_y)
ymin=xmin
ymax=xmax
set xrange[xmin:xmax]
set yrange[ymin:ymax]
set object 1 rectangle from xmin,ymin to xmax+5,ymax+5 behind fillcolor rgb 'blue' fillstyle solid noborder
plot sprintf('julia_%03i.dat', t) using 1:(-$2) with dots lc rgb "yellow"
}
