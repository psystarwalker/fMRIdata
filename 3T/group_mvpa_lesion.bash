#! /bin/bash

datafolder=/Volumes/WD_F/gufei/3T_cw
# datafolder=/Volumes/WD_D/allsub/
cd "${datafolder}" || exit
# roi
for roi in Amy OFC_AAL
do
if [ "$roi" = "whole" ]; then
      mask=group/mask/bmask.nii
      out=whole
elif [ "$roi" = "OFC_AAL" ]; then
      mask=group/mask/OFC_AAL+tlrc
      out=OFC_AAL
elif [ "$roi" = "Amy" ]; then
      mask=group/mask/Amy8_align.freesurfer+tlrc
      out=Amy
else
      mask=group/mask/$roi+tlrc
      out=$roi
fi

# if the first input exist and is sm
if [ -n "$1" ] && [ "$1" = "sm" ]; then
      pre="sm_"
else
      pre=""
fi

# for each pvalue
for p in 0.001 #0.05  
do
    for brick in face_vis face_inv odor_all
    do              
      # convert to short data first if not exist
      if [ ! -f group/mvpa/lesion/${pre}${roi}_${brick}_t+tlrc.HEAD ]; then
            3dcalc \
            -a group/plotmask/${pre}${roi}_${brick}_t+tlrc \
            -prefix group/mvpa/lesion/${pre}${roi}_${brick}_t \
            -expr 'a' \
            -datum short
      fi
      # find maxima in RAI coordinate
      # use -dset_coords to convert to LPI      
      # rm group/mvpa/lesion/${pre}${roi}_${brick}_max*
      3dmaxima \
      -input group/mvpa/lesion/${pre}${roi}_${brick}_t+tlrc \
      -spheres_1toN -out_rad 4 -prefix group/mvpa/lesion/${pre}${roi}_${brick}_max \
      -min_dist 8 -thresh 1.65 -coords_only > group/mvpa/lesion/${pre}${roi}_${brick}.txt
      # find the first two sphere
      for i in 1 2
      do
            # sphere masks
            3dcalc \
            -a group/mvpa/lesion/${pre}${roi}_${brick}_max+tlrc \
            -expr "equals(a,$i)" \
            -prefix group/mvpa/lesion/${pre}${roi}_${brick}_p${i}
            # generate mask with out the cluster
            # rm group/mvpa/lesion/${pre}${roi}_${brick}_l${i}*
            3dcalc \
            -a group/mvpa/lesion/${pre}${roi}_${brick}_p${i}+tlrc \
            -b group/mvpa/${pre}${roi}_${brick}_${p}+tlrc \
            -expr "step(bool(b)-a)" \
            -prefix group/mvpa/lesion/${pre}${roi}_${brick}_l${i}
      done

    done    
done

done