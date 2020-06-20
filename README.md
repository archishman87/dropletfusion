# dropletfusion
Following a successful fusion experiment as described in the article 'Fusion speed of biomolecular condensates' by Ghosh and Zhou, deposit the hd5 file and corresponding video exported from BlueLake (of LUMICKS C-Trap) in different folders containing the respective matlab files for analysis.
Run matlab.
Run the file 'forcefit.m' on hdf file containing force data to obtain the value of fusion time 'Tau'.
Command line execution example: Tau = forcefit('forcefile.h5','k.','r')
Run the file 'fusionvideo.m' on a series of tiff files contrasted and generated from the fusion video of the same. Note that all tiff files should be in a separate folder containing the 'fusionvideo.m' file.
Commandline execution example: fusionvideo(25, 0.25) where 25 and 0.25 are typical frame rate and image binarization threshold values. Use as needed.
Analyzed video will be in the same folder as 'Fusionvideo.avi'.
