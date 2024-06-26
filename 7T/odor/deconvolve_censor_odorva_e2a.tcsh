#!/bin/tcsh
# set sub=S04
if ( $# > 0 ) then
set sub = $1
set analysis=pabioe2a
set datafolder=/Volumes/WD_E/gufei/7T_odor/${sub}
# set datafolder=/Volumes/WD_D/gufei/7T_odor/${sub}/
cd "${datafolder}"

set subj = ${sub}.${analysis}
cd ${subj}.results

# rm *odorVIva*
# no regressor for odors, but add mean valence and intensity
set filedec = odorVIva_noblur

# run the regression analysis
3dDeconvolve -input pb05.${subj}.r*.volreg+tlrc.HEAD                 \
    -censor motion_${subj}_censor.1D                                \
    -ortvec mot_demean.r01.1D mot_demean_r01                        \
    -ortvec mot_demean.r02.1D mot_demean_r02                        \
    -ortvec mot_demean.r03.1D mot_demean_r03                        \
    -ortvec mot_demean.r04.1D mot_demean_r04                        \
    -ortvec mot_demean.r05.1D mot_demean_r05                        \
    -ortvec mot_demean.r06.1D mot_demean_r06                        \
    -polort 3                                                       \
    -num_stimts 4                                                   \
    -stim_times_AM1 1 ../behavior/valence.txt 'dmBLOCK(1)'          \
    -stim_label 1 val                                               \
    -stim_times_AM1 2 ../behavior/intensity.txt 'dmBLOCK(1)'        \
    -stim_label 2 int                                               \
    -stim_times_AM1 3 ../behavior/odor_allvavg.txt 'BLOCK(2,1)'     \
    -stim_label 3 odor_va                                           \
    -stim_times_AM2 4 ../behavior/odor_alliavg.txt 'BLOCK(2,1)'     \
    -stim_label 4 odor_in                                           \
    -jobs 14                                                        \
    -x1D_uncensored X.nocensor.${filedec}.xmat.1D                   \
    -x1D X.xmat.${filedec}.1D -xjpeg X.${filedec}.jpg               \
    -noFDR                                                          \
    -cbucket cbucket.${subj}.${filedec}

# cannot use -nobucket, otherwise cbucket will not be generated
# so, remove Decon*
rm Decon*

# cat all runs
if (! -e allrun.volreg.${subj}+tlrc.HEAD) then
    # echo nodata
    3dTcat -prefix allrun.volreg.${subj} pb05.${subj}.r*.volreg+tlrc.HEAD
endif

# synthesize fitts of no interests, use -dry for debug
3dSynthesize -cbucket cbucket.${subj}.${filedec}+tlrc -matrix X.nocensor.${filedec}.xmat.1D -select baseline val int odor_va odor_in -prefix NIfitts.${subj}.${filedec}

# subtract fitts of no interests from all runs
3dcalc -a allrun.volreg.${subj}+tlrc -b NIfitts.${subj}.${filedec}+tlrc -expr 'a-b' -prefix NIerrts.${subj}.${filedec}

else
 echo "Usage: $0 <Subjname>"

endif
