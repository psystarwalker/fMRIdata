#! /bin/csh
set datafolder=/Volumes/WD_D/allsub
# set datafolder=/Volumes/WD_D/Exp_odor_face/fMRI\ data_supplemental/
# 存放timing文件的目录的上一级
set timingfolder=/Volumes/WD_D/allsub
# 双引号避免空格路径问题
cd "${datafolder}"

if ( $# > 0 ) then
# echo `echo "`seq -s , 1 3 20`"
# foreach subj (`echo $*`)
# foreach subj (`ls -d S*`)
# foreach subj (S03)
#S22 S23 S24 S25 S26 S27 S28
set subj = $1

cd ${subj}
cd ppi
#############################   generate_regressors  ###########################
# 把mask移动过来
mv ../analysis/*Amy* ./
# 统计数目，实际是计算行数
# ls *Amy* | wc -l
# 去掉没有用的mask
# ls *Amy{.t196,+tlrc}* | wc -l

rm *Amy{.t196,+tlrc}*
# set OdorValence FaceValence
set valance=OdorValence
# 设置mask条件 Amy lateralAmy medialAmy FH HF UP PU
set mask=AmyPU
# there are 5 runs
set nruns = 5
# number of time points per run in TR
set n_tp = 196
set TR = 2
# two conditions
set condList = (Invisible Visible)

# create Gamma impulse response function
# 1@1 represent a single impulse
waver -dt 2 -GAM -peak 1 -inline 1@1 > GammaHR.1D

# for each run, extract seed time series, run deconvolution, and create interaction regressor
foreach run (`count -digits 1 1 $nruns`)
   # 提取ROI位置的平均信号
   3dmaskave -mask ${subj}.${valance}.${mask}.t196+tlrc -quiet ${subj}_run${run}+tlrc > Seed${run}${mask}.1D
   # 去掉线性漂移，由于接受的是row，所以后面要加上\'
   3dDetrend -polort 3 -prefix SeedR${run}${mask} Seed${run}${mask}.1D\'
   # 转置成为一列，去掉没有转置的
   1dtranspose SeedR${run}${mask}.1D Seed_ts${run}${mask}.1D
   rm SeedR${run}${mask}.1D
   # 用FALTUNG指定的核函数deconvolve，输出是行结构的文件，所以下面需要转置
   3dTfitter -RHS Seed_ts${run}${mask}.1D -FALTUNG GammaHR.1D Seed_Neur${run}${mask} 012 -1

   foreach cond ($condList)
      # 和相应条件的timing相乘
      1deval -a Seed_Neur${run}${mask}.1D\' -b ${timingfolder}/timing5run/${subj}.${cond}_run${run}.1D -expr 'a*b' > Inter_neu${cond}${run}${mask}.1D
      # 再卷积上gamma函数
      waver -GAM -peak 1 -TR 2 -input Inter_neu${cond}${run}${mask}.1D -numout ${n_tp} > Inter_ts${cond}${run}${mask}.1D
   end

end

# 合并5run到一个文件中
# catenate the two regressors across runs
cat Seed_ts?${mask}.1D > Seed_${mask}.1D
cat Inter_tsInvisible?${mask}.1D > Inter_Invisible_${mask}.1D
cat Inter_tsVisible?${mask}.1D > Inter_Visible_${mask}.1D

# 把mask放回去, avoid moving the Amy_PPI+tlrc
mv *Amy*.t196+tlrc* ../analysis/

#############################   3dDeconvolve  ###########################
# 移动需要的文件
mv ../analysis/${subj}_func_s+orig* ./
mv ../analysis/*.str_al+tlrc* ./
mv ../analysis/func_s.mot ./

3dDeconvolve -input ${subj}_func_s+orig.           \
     -jobs 2                                       \
     -polort A                                     \
     -num_stimts 11                                \
     -stim_times 1 ${timingfolder}/timingtxt/${subj}.Invisible.txt 'BLOCK(10,1)'  \
     -stim_label 1 Invisible                               \
     -stim_times 2 ${timingfolder}/timingtxt/${subj}.Visible.txt 'BLOCK(10,1)'    \
     -stim_label 2 Visible                                 \
     -stim_file 3 func_s.mot'[1]' \
     -stim_file 4 func_s.mot'[2]' \
     -stim_file 5 func_s.mot'[3]' \
     -stim_file 6 func_s.mot'[4]' \
     -stim_file 7 func_s.mot'[5]' \
     -stim_file 8 func_s.mot'[6]' \
     -stim_base 3 \
     -stim_base 4 \
     -stim_base 5 \
     -stim_base 6 \
     -stim_base 7 \
     -stim_base 8 \
     -stim_file 9 Seed_${mask}.1D -stim_label 9 Seed                        \
     -stim_file 10 Inter_Invisible_${mask}.1D -stim_label 10 InvisiblePPI    \
     -stim_file 11 Inter_Visible_${mask}.1D -stim_label 11 VisiblePPI        \
     -rout -tout                                                               \
     -bucket ${subj}.${mask}_PPI

# 对齐到标准空间的结构像
@auto_tlrc -apar ${subj}.str_al+tlrc. -input ${subj}.${mask}_PPI+orig

# 放回文件
mv ${subj}_func_s+orig* ../analysis/
mv *.str_al+tlrc* ../analysis/
mv func_s.mot ../analysis/

cd ..
cd ..


else
 echo "Usage: $0 <Subjname>"

endif
