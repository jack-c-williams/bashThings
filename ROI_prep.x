#!/usr/bin/bash
  # Jack Williams, April 2020
  # Inp: pc number and number of slices
  # outp: shifting all timepoints of DCE timecourse data to match registered DCE and T2


  # this is for getting the files in the rigt places to draw DCE timecourse cancer ROIs

pcNum=$(pwd | rev | cut -d "/" -f 1 | rev)
echo $pcNum

cd register

path7000='/data/pca1/pc7000-pc7999'
path8000='/data/pca1/pc8000-pc8454'
pathcpros='/data/cpros/path'
path6800='‎/data/pca1/pc6500-pc6999/pc6500-pc6999/pc6800-pc6999'
path6500='‎/data/pca1/pc6500-pc6999/pc6500-pc6999/pc6500-pc6499'


i=1

for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20

do
  # copy pcxxxx_zx.idf and pcxxx_zx_origloc.idf from perfusion to register
  cp ../perfusion/${pcNum}_z${i}.int2 .
  cp ../perfusion/${pcNum}_z${i}_origloc.idf .

  mv ${pcNum}_z${i}_origloc.idf ${pcNum}_z${i}.idf

  fix_rootname.x ${pcNum}_z${i}

  tail -n 4 "transform_matrices.txt"

  output=$(tail -n 4 "transform_matrices.txt")

  xshift=$(echo $output | cut -d " " -f 4)
  yshift=$(echo $output | cut -d " " -f 8)

  echo $xshift
  echo $yshift

  shiftidfcenter ${pcNum}_z${i} $xshift $yshift 0

  cp ${pcNum}_z${i}_shift.idf ${pcNum}_z${i}.idf

  fix_rootname.x ${pcNum}_z${i}

done
