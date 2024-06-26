# RSA
Representation similarity analysis using single trials.

## betaCorrespondence.m
List of condition names. For example, *'[[subjectName]]_exp1_lim1'*.

## defineUserOptions.m
RSA options.

## modelRDMs_7T.m
Hypothesis RDMs to be tested.
* Atom pairs tanimoto
* MCS tanimoto
* Haddad 2008
* Odor space
* mriintensity
* mrivalence
* mrisimilariy
* bointensity
* bovalence
* bosimilariy
* random

## Recipe_fMRI.m
Main workflow for ROI analysis. Correlation matrice for model and neuro RDMs are averaged across subjects or use the averaged model and neuro RDMs to compute.

## saverclass.m
Save within class and between class correlations from RDMs.

## rclass.m
Function used in `saveclass.m` to compute within class and between class correlations from RDMs.