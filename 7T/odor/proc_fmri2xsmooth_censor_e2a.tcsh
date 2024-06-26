#! /bin/csh

# set sub=S01_yyt
# use input as sub
if ( $# > 0 ) then
    set sub = $1
    set datafolder=/Volumes/WD_E/gufei/7T_odor/${sub}
    # set datafolder=/Volumes/WD_D/gufei/7T_odor/${sub}/
    cd "${datafolder}"

    set bio=.biop.
    set analysis=pabioe2a

    # ==========================processing========================== # 
    afni_proc.py                                                                            \
    -subj_id ${sub}.${analysis}                                                             \
    -dsets ${sub}.run?+orig.HEAD                                                            \
    -blip_reverse_dset ${sub}.pa+orig.HEAD                                                  \
    -copy_anat ${sub}_anat_warped/anatSS.${sub}.nii                                         \
    -anat_has_skull no                                                                      \
    -blocks despike ricor tshift align tlrc volreg blur mask scale regress                  \
    -ricor_regs ./phy/${sub}${bio}run?.slibase.1D                                           \
    -radial_correlate_blocks tcat volreg                                                    \
    -align_opts_aea -cost lpc+ZZ -giant_move                                                \
    -tlrc_base MNI152_2009_template_SSW.nii.gz                                              \
    -tlrc_NL_warp                                                                           \
    -tlrc_NL_warped_dsets                                                                   \
            ${sub}_anat_warped/anatQQ.${sub}.nii                                            \
            ${sub}_anat_warped/anatQQ.${sub}.aff12.1D                                       \
            ${sub}_anat_warped/anatQQ.${sub}_WARP.nii                                       \
    -volreg_align_to MIN_OUTLIER                                                            \
    -volreg_align_e2a                                                                       \
    -volreg_tlrc_warp                                                                       \
    -blur_size 2.2                                                                          \
    -regress_stim_times                                                                     \
            behavior/lim.txt                                                                \
            behavior/tra.txt                                                                \
            behavior/car.txt                                                                \
            behavior/cit.txt                                                                \
            behavior/ind.txt                                                                \
            behavior/valence.txt                                                            \
            behavior/intensity.txt                                                          \
    -regress_stim_labels                                                                    \
            lim tra car cit ind val int                                                     \
    -regress_stim_types                                                                     \
            times times times times times AM1 AM1                                           \
    -regress_basis_multi                                                                    \
            'BLOCK(2,1)' 'BLOCK(2,1)' 'BLOCK(2,1)' 'BLOCK(2,1)' 'BLOCK(2,1)' 'dmBLOCK(1)' 'dmBLOCK(1)'   \
    -regress_opts_3dD                                                                       \
            -jobs 12                                                                        \
            -gltsym 'SYM: lim -tra'       -glt_label 1 lim-tra                              \
            -gltsym 'SYM: car -tra'       -glt_label 2 car-tra                              \
            -gltsym 'SYM: cit -tra'       -glt_label 3 cit-tra                              \
            -gltsym 'SYM: car -lim'       -glt_label 4 car-lim                              \
            -gltsym 'SYM: cit -lim'       -glt_label 5 cit-lim                              \
            -gltsym 'SYM: car -cit'       -glt_label 6 car-cit                              \
            -gltsym 'SYM: ind -lim'       -glt_label 7 car-cit                              \
            -gltsym 'SYM: ind -tra'       -glt_label 8 car-cit                              \
            -gltsym 'SYM: ind -car'       -glt_label 9 car-cit                              \
            -gltsym 'SYM: ind -cit'       -glt_label 10 car-cit                             \
    -regress_motion_per_run                                                                 \
    -regress_censor_motion 0.3                                                              \
    -regress_run_clustsim no
    # -regress_make_cbucket yes                                                               
    # -execute
    # more options for 3dD can be added by -regress_opts_3dD
    # -volreg_align_e2a                                        \    
    # -volreg_tlrc_warp   

else
 echo "Usage: $0 <Subjname> <analysis>"

endif
