#These are the scripts for FFA&STS analysis
## 3Deconvolve
use 3dDeconvolve to get these results and align to structural image
* Visible > Invisible
* Fearful > Happy
* Unpleasant > Pleasant
## makeROI05
use 3dcalc to generate masks and use 3dROIstats to print the mean value to txt files

## ROIresample
Generate masks from BN_atlas and ROIresample
* STS_right
* FFA_right

## 3Deconvolvetent
get the same results as 3Deconvolve but use tent function

## ROIstatent
use 3dROIstats to print the mean value to txt files