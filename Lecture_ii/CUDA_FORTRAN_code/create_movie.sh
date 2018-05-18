#!/bin/bash
ffmpeg -framerate 10 -i julia_%03d.png -s:v 600x600 -c:v libx264 -profile:v high -pix_fmt yuv420p julia.mp4
rm julia_*.dat
rm julia_*.png
