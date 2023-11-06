#! /bin/csh

touch command.txt
cat /dev/null >! command.txt

foreach run (`count -dig 2 6 29`)
  # echo tcsh deconvolve_odors.tcsh S${run} >> command.txt
  echo bash group_mvpa_lesion.bash S${run} >> command.txt
end
# cat command.txt

parallel -a command.txt

rm command.txt
