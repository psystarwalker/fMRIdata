# default values"
path <- "/Volumes/WD_F/gufei/3T_cw/"
# subs no 12 15 30
subs <- c(sprintf('S%02d',c(3:29)))
# rois
roibase <- c('Amy8_at165','corticalAmy_at165','CeMeAmy_at165','BaLaAmy_at165')
roiname <- c("Amy","Cortical","CeMe","BaLa")
suf <- c("14","14p")
rois <- c("at165","atfix165","atfixdu165")
# render roistats
for (roi_i in rois){
  # replace roi with rois
  roi <- gsub("at165",roi_i,roibase)
  for (s in suf) {
    suffix <- paste0("_tent_", s, ".txt")
    rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/3T/roistatas3t.Rmd",
                      output_dir = paste0(path,"results_labels_r"),
                      output_file = paste("ROIstatas",roi_i,s,sep = "_"),
                      params = list(path = path, sub = subs, roi = roi, roiname = roiname, suffix = suffix))
  }
}