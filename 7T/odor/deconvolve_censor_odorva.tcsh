#!/bin/tcsh
# set sub=S04
if ( $# > 0 ) then
set sub = $1
set analysis=pabiode
set datafolder=/Volumes/WD_E/gufei/7T_odor/${sub}
# set datafolder=/Volumes/WD_D/gufei/7T_odor/${sub}/
cd "${datafolder}"

set subj = ${sub}.${analysis}
cd ${subj}.results

# rm *odorVIva*
# no regressor for odors, but add mean valence and intensity
set filedec = odorVI_noblur

# run the regression analysis
3dDeconvolve -input pb05.${subj}.r*.volreg+orig.HEAD                \
    -censor motion_${subj}_censor.1D                                \
    -ortvec mot_demean.r01.1D mot_demean_r01                        \
    -ortvec mot_demean.r02.1D mot_demean_r02                        \
    -ortvec mot_demean.r03.1D mot_demean_r03                        \
    -ortvec mot_demean.r04.1D mot_demean_r04                        \
    -ortvec mot_demean.r05.1D mot_demean_r05                        \
    -ortvec mot_demean.r06.1D mot_demean_r06                        \
    -polort 3                                                       \
    -num_stimts 7                                                   \
    -stim_times 1 ../behavior/lim.txt 'BLOCK(2,1)'             \
    -stim_label 1 lim                                          \
    -stim_times 2 ../behavior/tra.txt 'BLOCK(2,1)'             \
    -stim_label 2 tra                                          \
    -stim_times 3 ../behavior/car.txt 'BLOCK(2,1)'             \
    -stim_label 3 car                                          \
    -stim_times 4 ../behavior/cit.txt 'BLOCK(2,1)'             \
    -stim_label 4 cit                                          \
    -stim_times 5 ../behavior/ind.txt 'BLOCK(2,1)'             \
    -stim_label 5 ind                                          \
    -stim_times_AM1 6 ../behavior/valence.txt 'dmBLOCK(1)'     \
    -stim_label 6 val                                          \
    -stim_times_AM1 7 ../behavior/intensity.txt 'dmBLOCK(1)'   \
    -stim_label 7 int                                               \
    -jobs 10                                                        \
    -x1D_uncensored X.nocensor.${filedec}.xmat.1D                   \
    -x1D X.xmat.${filedec}.1D -xjpeg X.${filedec}.jpg               \
    -noFDR                                                          \
    -cbucket cbucket.${subj}.${filedec}

# cannot use -nobucket, otherwise cbucket will not be generated
# so, remove Decon*
rm Decon*

# cat all runs
if (! -e allrun.volreg.${subj}+orig.HEAD) then
    # echo nodata
    3dTcat -prefix allrun.volreg.${subj} pb05.${subj}.r*.volreg+orig.HEAD
endif

# synthesize fitts of no interests, use -dry for debug
3dSynthesize -cbucket cbucket.${subj}.${filedec}+orig -matrix X.nocensor.${filedec}.xmat.1D -select baseline val int -prefix NIfitts.${subj}.${filedec}

# cbucket generated by afni_proc.py ( this is blurred! )
# 3dSynthesize -cbucket all_betas.${subj}+orig -matrix X.xmat.1D -select baseline val int odor_va -prefix NIfitts.${subj}.${filedec}

# subtract fitts of no interests from all runs
3dcalc -a allrun.volreg.${subj}+orig -b NIfitts.${subj}.${filedec}+orig -expr 'a-b' -prefix NIerrts.${subj}.${filedec}

else
 echo "Usage: $0 <Subjname>"

endif