#! /bin/bash

datafolder=/Volumes/WD_F/gufei/3T_cw
# datafolder=/Volumes/WD_D/allsub/
cd "${datafolder}" || exit
suffix=${1}
outsuffix=${2}
# define mask according to the second input
if [[ "${2}" == Amy* ]]; then
    mask="${2}.freesurfer"
# if start with Pir
elif [[ "${2}" == Pir* ]]; then
    mask="${2}.draw"
# if start with Pir
elif [[ "${2}" == FFA* ]]; then
    mask="${2}"
# otherwise exit
else
    # echo "Please input the correct mask name!"
    # exit
    echo "Use the default mask: ${2}*"
    mask="${2}*"
fi

# 8 conditions for each subject
# if file exsit then remove it
if [ -e "stats/indi8con_${outsuffix}.txt" ]; then
    rm stats/indi8con_${outsuffix}.txt
fi
for sub in S{03..29}
do
    analysis=de
    subj=${sub}.${analysis}
        
    # if is the first loop then add header
    if [ "${sub}" == "S03" ]; then
        3dROIstats -nzmean -mask ${sub}/mask/${mask}+orig.HEAD \
            "${sub}/${subj}.results/stats.${sub}.${suffix}+orig[1,4,7,10,13,16,19,22]" \
            >> stats/indi8con_${outsuffix}.txt
    else
        # remove the first row
        3dROIstats -nzmean -mask ${sub}/mask/${mask}+orig.HEAD \
            "${sub}/${subj}.results/stats.${sub}.${suffix}+orig[1,4,7,10,13,16,19,22]" \
            | sed '1d' >> stats/indi8con_${outsuffix}.txt
    fi
done

# mask=group/mask/${2}+tlrc

# # 8 conditions
# 3dROIstats -nzmean -mask ${mask} \
# "S03/S03.de.results/stats.S03.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
# "S04/S04.de.results/stats.S04.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
# "S05/S05.de.results/stats.S05.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
# "S06/S06.de.results/stats.S06.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
# "S07/S07.de.results/stats.S07.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
# "S08/S08.de.results/stats.S08.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
# "S09/S09.de.results/stats.S09.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
# "S10/S10.de.results/stats.S10.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
# "S11/S11.de.results/stats.S11.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
# "S12/S12.de.results/stats.S12.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
# "S13/S13.de.results/stats.S13.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
# "S14/S14.de.results/stats.S14.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
# "S15/S15.de.results/stats.S15.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
# "S16/S16.de.results/stats.S16.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
# "S17/S17.de.results/stats.S17.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
# "S18/S18.de.results/stats.S18.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
# "S19/S19.de.results/stats.S19.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
# "S20/S20.de.results/stats.S20.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
# "S21/S21.de.results/stats.S21.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
# "S22/S22.de.results/stats.S22.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
# "S23/S23.de.results/stats.S23.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
# "S24/S24.de.results/stats.S24.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
# "S25/S25.de.results/stats.S25.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
# "S26/S26.de.results/stats.S26.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
# "S27/S27.de.results/stats.S27.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
# "S28/S28.de.results/stats.S28.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
# "S29/S29.de.results/stats.S29.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
# > group/conditions_${outsuffix}.txt
