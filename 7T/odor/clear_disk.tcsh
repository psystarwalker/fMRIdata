#! /bin/csh
foreach ub (`count -dig 2 13 18`)

set sub = S${ub}
# foreach sub (S01_yyt S01 S02 S03)
set datafolder=/Volumes/WD_E/gufei/7T_odor/${sub}
# set datafolder=/Volumes/WD_D/gufei/7T_odor/${sub}/
cd "${datafolder}"
# make dir to save masks
set analysis=pabiode
set subj = ${sub}.${analysis}
# rm -r ${sub}.pabioe2a.results
cd ${subj}.results
# move piriform roi to mask folder
# mv Piriform.seg* ../mask
# mv ../${subj}.results.old/Piriform.seg* ../mask

# remove files
# rm all_runs*
# rm pb0[0-4]*


# cd mvpa
# rm -r *br*
# rm -r *rpt*

set filedec = odorVIva_noblur
set pb=`ls pb0?.*.r01.volreg+orig.HEAD | cut -d . -f1`
# cat all runs
if (! -e allrun.volreg.${subj}+orig.HEAD) then
    # echo nodata
    3dTcat -prefix allrun.volreg.${subj} ${pb}.${subj}.r*.volreg+orig.HEAD
endif

# synthesize fitts of no interests, use -dry for debug
3dSynthesize -cbucket cbucket.${subj}.${filedec}+orig -matrix X.nocensor.${filedec}.xmat.1D -select baseline -prefix NIfittsbs.${subj}.${filedec}

# subtract fitts of no interests from all runs
3dcalc -a allrun.volreg.${subj}+orig -b NIfittsbs.${subj}.${filedec}+orig -expr 'a-b' -prefix NIerrts.${subj}.rmbs

rm NIfitts*
# rm tent.${subj}.odorVI+orig*
# rm NIerrts.${subj}.odorVIv_noblur+orig*
# rm NIerrts.${subj}.odorVIvat_noblur+orig*

end
