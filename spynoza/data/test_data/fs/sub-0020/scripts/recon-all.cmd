

#---------------------------------
# New invocation of recon-all wo 26 apr 2017 10:41:58 CEST 

 mri_convert /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/sub-0020_T1w.nii.gz /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/sub-0020/mri/orig/001.mgz 



#---------------------------------
# New invocation of recon-all wo 26 apr 2017 10:42:24 CEST 
#--------------------------------------------
#@# MotionCor wo 26 apr 2017 10:42:25 CEST

 cp /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/sub-0020/mri/orig/001.mgz /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/sub-0020/mri/rawavg.mgz 


 mri_convert /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/sub-0020/mri/rawavg.mgz /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/sub-0020/mri/orig.mgz --conform 


 mri_add_xform_to_header -c /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/sub-0020/mri/transforms/talairach.xfm /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/sub-0020/mri/orig.mgz /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/sub-0020/mri/orig.mgz 

#--------------------------------------------
#@# Talairach wo 26 apr 2017 10:42:32 CEST

 mri_nu_correct.mni --no-rescale --i orig.mgz --o orig_nu.mgz --n 1 --proto-iters 1000 --distance 50 


 talairach_avi --i orig_nu.mgz --xfm transforms/talairach.auto.xfm 

talairach_avi log file is transforms/talairach_avi.log...

 cp transforms/talairach.auto.xfm transforms/talairach.xfm 

#--------------------------------------------
#@# Talairach Failure Detection wo 26 apr 2017 10:43:43 CEST

 talairach_afd -T 0.005 -xfm transforms/talairach.xfm 


 awk -f /usr/local/freesurfer/bin/extract_talairach_avi_QA.awk /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/sub-0020/mri/transforms/talairach_avi.log 


 tal_QC_AZS /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/sub-0020/mri/transforms/talairach_avi.log 

#--------------------------------------------
#@# Nu Intensity Correction wo 26 apr 2017 10:43:43 CEST

 mri_nu_correct.mni --i orig.mgz --o nu.mgz --uchar transforms/talairach.xfm --n 2 


 mri_add_xform_to_header -c /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/sub-0020/mri/transforms/talairach.xfm nu.mgz nu.mgz 

#--------------------------------------------
#@# Intensity Normalization wo 26 apr 2017 10:45:00 CEST

 mri_normalize -g 1 -mprage nu.mgz T1.mgz 

#--------------------------------------------
#@# Skull Stripping wo 26 apr 2017 10:46:24 CEST

 mri_em_register -rusage /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/sub-0020/touch/rusage.mri_em_register.skull.dat -skull nu.mgz /usr/local/freesurfer/average/RB_all_withskull_2016-05-10.vc700.gca transforms/talairach_with_skull.lta 


 mri_watershed -rusage /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/sub-0020/touch/rusage.mri_watershed.dat -T1 -brain_atlas /usr/local/freesurfer/average/RB_all_withskull_2016-05-10.vc700.gca transforms/talairach_with_skull.lta T1.mgz brainmask.auto.mgz 


 cp brainmask.auto.mgz brainmask.mgz 

#-------------------------------------
#@# EM Registration wo 26 apr 2017 10:59:44 CEST

 mri_em_register -rusage /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/sub-0020/touch/rusage.mri_em_register.dat -uns 3 -mask brainmask.mgz nu.mgz /usr/local/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta 

#--------------------------------------
#@# CA Normalize wo 26 apr 2017 11:08:53 CEST

 mri_ca_normalize -c ctrl_pts.mgz -mask brainmask.mgz nu.mgz /usr/local/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta norm.mgz 

#--------------------------------------
#@# CA Reg wo 26 apr 2017 11:09:58 CEST

 mri_ca_register -rusage /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/sub-0020/touch/rusage.mri_ca_register.dat -nobigventricles -T transforms/talairach.lta -align-after -mask brainmask.mgz norm.mgz /usr/local/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.m3z 

#--------------------------------------
#@# SubCort Seg wo 26 apr 2017 12:41:17 CEST

 mri_ca_label -relabel_unlikely 9 .3 -prior 0.5 -align norm.mgz transforms/talairach.m3z /usr/local/freesurfer/average/RB_all_2016-05-10.vc700.gca aseg.auto_noCCseg.mgz 


 mri_cc -aseg aseg.auto_noCCseg.mgz -o aseg.auto.mgz -lta /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/sub-0020/mri/transforms/cc_up.lta sub-0020 

#--------------------------------------
#@# Merge ASeg wo 26 apr 2017 13:10:46 CEST

 cp aseg.auto.mgz aseg.presurf.mgz 

#--------------------------------------------
#@# Intensity Normalization2 wo 26 apr 2017 13:10:46 CEST

 mri_normalize -mprage -aseg aseg.presurf.mgz -mask brainmask.mgz norm.mgz brain.mgz 

#--------------------------------------------
#@# Mask BFS wo 26 apr 2017 13:12:51 CEST

 mri_mask -T 5 brain.mgz brainmask.mgz brain.finalsurfs.mgz 

#--------------------------------------------
#@# WM Segmentation wo 26 apr 2017 13:12:52 CEST

 mri_segment -mprage brain.mgz wm.seg.mgz 


 mri_edit_wm_with_aseg -keep-in wm.seg.mgz brain.mgz aseg.presurf.mgz wm.asegedit.mgz 


 mri_pretess wm.asegedit.mgz wm norm.mgz wm.mgz 

#--------------------------------------------
#@# Fill wo 26 apr 2017 13:14:08 CEST

 mri_fill -a ../scripts/ponscc.cut.log -xform transforms/talairach.lta -segmentation aseg.auto_noCCseg.mgz wm.mgz filled.mgz 

#--------------------------------------------
#@# Tessellate lh wo 26 apr 2017 13:14:34 CEST

 mri_pretess ../mri/filled.mgz 255 ../mri/norm.mgz ../mri/filled-pretess255.mgz 


 mri_tessellate ../mri/filled-pretess255.mgz 255 ../surf/lh.orig.nofix 


 rm -f ../mri/filled-pretess255.mgz 


 mris_extract_main_component ../surf/lh.orig.nofix ../surf/lh.orig.nofix 

#--------------------------------------------
#@# Tessellate rh wo 26 apr 2017 13:14:37 CEST

 mri_pretess ../mri/filled.mgz 127 ../mri/norm.mgz ../mri/filled-pretess127.mgz 


 mri_tessellate ../mri/filled-pretess127.mgz 127 ../surf/rh.orig.nofix 


 rm -f ../mri/filled-pretess127.mgz 


 mris_extract_main_component ../surf/rh.orig.nofix ../surf/rh.orig.nofix 

#--------------------------------------------
#@# Smooth1 lh wo 26 apr 2017 13:14:40 CEST

 mris_smooth -nw -seed 1234 ../surf/lh.orig.nofix ../surf/lh.smoothwm.nofix 

#--------------------------------------------
#@# Smooth1 rh wo 26 apr 2017 13:14:43 CEST

 mris_smooth -nw -seed 1234 ../surf/rh.orig.nofix ../surf/rh.smoothwm.nofix 

#--------------------------------------------
#@# Inflation1 lh wo 26 apr 2017 13:14:47 CEST

 mris_inflate -no-save-sulc ../surf/lh.smoothwm.nofix ../surf/lh.inflated.nofix 

#--------------------------------------------
#@# Inflation1 rh wo 26 apr 2017 13:15:08 CEST

 mris_inflate -no-save-sulc ../surf/rh.smoothwm.nofix ../surf/rh.inflated.nofix 

#--------------------------------------------
#@# QSphere lh wo 26 apr 2017 13:15:30 CEST

 mris_sphere -q -seed 1234 ../surf/lh.inflated.nofix ../surf/lh.qsphere.nofix 

#--------------------------------------------
#@# QSphere rh wo 26 apr 2017 13:17:49 CEST

 mris_sphere -q -seed 1234 ../surf/rh.inflated.nofix ../surf/rh.qsphere.nofix 

#--------------------------------------------
#@# Fix Topology Copy lh wo 26 apr 2017 13:20:19 CEST

 cp ../surf/lh.orig.nofix ../surf/lh.orig 


 cp ../surf/lh.inflated.nofix ../surf/lh.inflated 

#--------------------------------------------
#@# Fix Topology Copy rh wo 26 apr 2017 13:20:19 CEST

 cp ../surf/rh.orig.nofix ../surf/rh.orig 


 cp ../surf/rh.inflated.nofix ../surf/rh.inflated 

#@# Fix Topology lh wo 26 apr 2017 13:20:19 CEST

 mris_fix_topology -rusage /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/sub-0020/touch/rusage.mris_fix_topology.lh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 sub-0020 lh 

#@# Fix Topology rh wo 26 apr 2017 13:24:37 CEST

 mris_fix_topology -rusage /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/sub-0020/touch/rusage.mris_fix_topology.rh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 sub-0020 rh 


 mris_euler_number ../surf/lh.orig 


 mris_euler_number ../surf/rh.orig 


 mris_remove_intersection ../surf/lh.orig ../surf/lh.orig 


 rm ../surf/lh.inflated 


 mris_remove_intersection ../surf/rh.orig ../surf/rh.orig 


 rm ../surf/rh.inflated 

#--------------------------------------------
#@# Make White Surf lh wo 26 apr 2017 13:30:48 CEST

 mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -whiteonly -mgz -T1 brain.finalsurfs sub-0020 lh 

#--------------------------------------------
#@# Make White Surf rh wo 26 apr 2017 13:34:00 CEST

 mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -whiteonly -mgz -T1 brain.finalsurfs sub-0020 rh 

#--------------------------------------------
#@# Smooth2 lh wo 26 apr 2017 13:37:12 CEST

 mris_smooth -n 3 -nw -seed 1234 ../surf/lh.white.preaparc ../surf/lh.smoothwm 

#--------------------------------------------
#@# Smooth2 rh wo 26 apr 2017 13:37:15 CEST

 mris_smooth -n 3 -nw -seed 1234 ../surf/rh.white.preaparc ../surf/rh.smoothwm 

#--------------------------------------------
#@# Inflation2 lh wo 26 apr 2017 13:37:18 CEST

 mris_inflate -rusage /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/sub-0020/touch/rusage.mris_inflate.lh.dat ../surf/lh.smoothwm ../surf/lh.inflated 

#--------------------------------------------
#@# Inflation2 rh wo 26 apr 2017 13:37:39 CEST

 mris_inflate -rusage /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/sub-0020/touch/rusage.mris_inflate.rh.dat ../surf/rh.smoothwm ../surf/rh.inflated 

#--------------------------------------------
#@# Curv .H and .K lh wo 26 apr 2017 13:38:01 CEST

 mris_curvature -w lh.white.preaparc 


 mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 lh.inflated 

#--------------------------------------------
#@# Curv .H and .K rh wo 26 apr 2017 13:38:45 CEST

 mris_curvature -w rh.white.preaparc 


 mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 rh.inflated 


#-----------------------------------------
#@# Curvature Stats lh wo 26 apr 2017 13:39:29 CEST

 mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/lh.curv.stats -F smoothwm sub-0020 lh curv sulc 


#-----------------------------------------
#@# Curvature Stats rh wo 26 apr 2017 13:39:31 CEST

 mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/rh.curv.stats -F smoothwm sub-0020 rh curv sulc 

#--------------------------------------------
#@# Sphere lh wo 26 apr 2017 13:39:33 CEST

 mris_sphere -rusage /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/sub-0020/touch/rusage.mris_sphere.lh.dat -seed 1234 ../surf/lh.inflated ../surf/lh.sphere 

#--------------------------------------------
#@# Sphere rh wo 26 apr 2017 13:55:43 CEST

 mris_sphere -rusage /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/sub-0020/touch/rusage.mris_sphere.rh.dat -seed 1234 ../surf/rh.inflated ../surf/rh.sphere 

#--------------------------------------------
#@# Surf Reg lh wo 26 apr 2017 14:11:32 CEST

 mris_register -curv -rusage /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/sub-0020/touch/rusage.mris_register.lh.dat ../surf/lh.sphere /usr/local/freesurfer/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/lh.sphere.reg 

#--------------------------------------------
#@# Surf Reg rh wo 26 apr 2017 14:41:21 CEST

 mris_register -curv -rusage /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/sub-0020/touch/rusage.mris_register.rh.dat ../surf/rh.sphere /usr/local/freesurfer/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/rh.sphere.reg 

#--------------------------------------------
#@# Jacobian white lh wo 26 apr 2017 15:13:30 CEST

 mris_jacobian ../surf/lh.white.preaparc ../surf/lh.sphere.reg ../surf/lh.jacobian_white 

#--------------------------------------------
#@# Jacobian white rh wo 26 apr 2017 15:13:32 CEST

 mris_jacobian ../surf/rh.white.preaparc ../surf/rh.sphere.reg ../surf/rh.jacobian_white 

#--------------------------------------------
#@# AvgCurv lh wo 26 apr 2017 15:13:33 CEST

 mrisp_paint -a 5 /usr/local/freesurfer/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/lh.sphere.reg ../surf/lh.avg_curv 

#--------------------------------------------
#@# AvgCurv rh wo 26 apr 2017 15:13:34 CEST

 mrisp_paint -a 5 /usr/local/freesurfer/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/rh.sphere.reg ../surf/rh.avg_curv 

#-----------------------------------------
#@# Cortical Parc lh wo 26 apr 2017 15:13:35 CEST

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-0020 lh ../surf/lh.sphere.reg /usr/local/freesurfer/average/lh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.annot 

#-----------------------------------------
#@# Cortical Parc rh wo 26 apr 2017 15:13:44 CEST

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-0020 rh ../surf/rh.sphere.reg /usr/local/freesurfer/average/rh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.annot 

#--------------------------------------------
#@# Make Pial Surf lh wo 26 apr 2017 15:13:51 CEST

 mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs sub-0020 lh 

#--------------------------------------------
#@# Make Pial Surf rh wo 26 apr 2017 15:22:43 CEST

 mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs sub-0020 rh 

#--------------------------------------------
#@# Surf Volume lh wo 26 apr 2017 15:31:31 CEST
#--------------------------------------------
#@# Surf Volume rh wo 26 apr 2017 15:31:33 CEST
#--------------------------------------------
#@# Cortical ribbon mask wo 26 apr 2017 15:31:34 CEST

 mris_volmask --aseg_name aseg.presurf --label_left_white 2 --label_left_ribbon 3 --label_right_white 41 --label_right_ribbon 42 --save_ribbon sub-0020 

#-----------------------------------------
#@# Parcellation Stats lh wo 26 apr 2017 15:37:42 CEST

 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-0020 lh white 


 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.pial.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-0020 lh pial 

#-----------------------------------------
#@# Parcellation Stats rh wo 26 apr 2017 15:38:28 CEST

 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-0020 rh white 


 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.pial.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-0020 rh pial 

#-----------------------------------------
#@# Cortical Parc 2 lh wo 26 apr 2017 15:39:08 CEST

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-0020 lh ../surf/lh.sphere.reg /usr/local/freesurfer/average/lh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.a2009s.annot 

#-----------------------------------------
#@# Cortical Parc 2 rh wo 26 apr 2017 15:39:20 CEST

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-0020 rh ../surf/rh.sphere.reg /usr/local/freesurfer/average/rh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.a2009s.annot 

#-----------------------------------------
#@# Parcellation Stats 2 lh wo 26 apr 2017 15:39:32 CEST

 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.a2009s.stats -b -a ../label/lh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-0020 lh white 

#-----------------------------------------
#@# Parcellation Stats 2 rh wo 26 apr 2017 15:39:53 CEST

 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.a2009s.stats -b -a ../label/rh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-0020 rh white 

#-----------------------------------------
#@# Cortical Parc 3 lh wo 26 apr 2017 15:40:13 CEST

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-0020 lh ../surf/lh.sphere.reg /usr/local/freesurfer/average/lh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.DKTatlas.annot 

#-----------------------------------------
#@# Cortical Parc 3 rh wo 26 apr 2017 15:40:22 CEST

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-0020 rh ../surf/rh.sphere.reg /usr/local/freesurfer/average/rh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.DKTatlas.annot 

#-----------------------------------------
#@# Parcellation Stats 3 lh wo 26 apr 2017 15:40:32 CEST

 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.DKTatlas.stats -b -a ../label/lh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-0020 lh white 

#-----------------------------------------
#@# Parcellation Stats 3 rh wo 26 apr 2017 15:40:54 CEST

 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.DKTatlas.stats -b -a ../label/rh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-0020 rh white 

#-----------------------------------------
#@# WM/GM Contrast lh wo 26 apr 2017 15:41:15 CEST

 pctsurfcon --s sub-0020 --lh-only 

#-----------------------------------------
#@# WM/GM Contrast rh wo 26 apr 2017 15:41:18 CEST

 pctsurfcon --s sub-0020 --rh-only 

#-----------------------------------------
#@# Relabel Hypointensities wo 26 apr 2017 15:41:22 CEST

 mri_relabel_hypointensities aseg.presurf.mgz ../surf aseg.presurf.hypos.mgz 

#-----------------------------------------
#@# AParc-to-ASeg aparc wo 26 apr 2017 15:41:34 CEST

 mri_aparc2aseg --s sub-0020 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /usr/local/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt 

#-----------------------------------------
#@# AParc-to-ASeg a2009s wo 26 apr 2017 15:44:20 CEST

 mri_aparc2aseg --s sub-0020 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /usr/local/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --a2009s 

#-----------------------------------------
#@# AParc-to-ASeg DKTatlas wo 26 apr 2017 15:47:04 CEST

 mri_aparc2aseg --s sub-0020 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /usr/local/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --annot aparc.DKTatlas --o mri/aparc.DKTatlas+aseg.mgz 

#-----------------------------------------
#@# APas-to-ASeg wo 26 apr 2017 15:49:47 CEST

 apas2aseg --i aparc+aseg.mgz --o aseg.mgz 

#--------------------------------------------
#@# ASeg Stats wo 26 apr 2017 15:49:51 CEST

 mri_segstats --seg mri/aseg.mgz --sum stats/aseg.stats --pv mri/norm.mgz --empty --brainmask mri/brainmask.mgz --brain-vol-from-seg --excludeid 0 --excl-ctxgmwm --supratent --subcortgray --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --etiv --surf-wm-vol --surf-ctx-vol --totalgray --euler --ctab /usr/local/freesurfer/ASegStatsLUT.txt --subject sub-0020 

#-----------------------------------------
#@# WMParc wo 26 apr 2017 15:51:26 CEST

 mri_aparc2aseg --s sub-0020 --labelwm --hypo-as-wm --rip-unknown --volmask --o mri/wmparc.mgz --ctxseg aparc+aseg.mgz 


 mri_segstats --seg mri/wmparc.mgz --sum stats/wmparc.stats --pv mri/norm.mgz --excludeid 0 --brainmask mri/brainmask.mgz --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --subject sub-0020 --surf-wm-vol --ctab /usr/local/freesurfer/WMParcStatsLUT.txt --etiv 

INFO: fsaverage subject does not exist in SUBJECTS_DIR
INFO: Creating symlink to fsaverage subject...

 cd /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs; ln -s /usr/local/freesurfer/subjects/fsaverage; cd - 

#--------------------------------------------
#@# BA_exvivo Labels lh wo 26 apr 2017 15:57:41 CEST

 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/lh.BA1_exvivo.label --trgsubject sub-0020 --trglabel ./lh.BA1_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/lh.BA2_exvivo.label --trgsubject sub-0020 --trglabel ./lh.BA2_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/lh.BA3a_exvivo.label --trgsubject sub-0020 --trglabel ./lh.BA3a_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/lh.BA3b_exvivo.label --trgsubject sub-0020 --trglabel ./lh.BA3b_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/lh.BA4a_exvivo.label --trgsubject sub-0020 --trglabel ./lh.BA4a_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/lh.BA4p_exvivo.label --trgsubject sub-0020 --trglabel ./lh.BA4p_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/lh.BA6_exvivo.label --trgsubject sub-0020 --trglabel ./lh.BA6_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/lh.BA44_exvivo.label --trgsubject sub-0020 --trglabel ./lh.BA44_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/lh.BA45_exvivo.label --trgsubject sub-0020 --trglabel ./lh.BA45_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/lh.V1_exvivo.label --trgsubject sub-0020 --trglabel ./lh.V1_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/lh.V2_exvivo.label --trgsubject sub-0020 --trglabel ./lh.V2_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/lh.MT_exvivo.label --trgsubject sub-0020 --trglabel ./lh.MT_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/lh.entorhinal_exvivo.label --trgsubject sub-0020 --trglabel ./lh.entorhinal_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/lh.perirhinal_exvivo.label --trgsubject sub-0020 --trglabel ./lh.perirhinal_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/lh.BA1_exvivo.thresh.label --trgsubject sub-0020 --trglabel ./lh.BA1_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/lh.BA2_exvivo.thresh.label --trgsubject sub-0020 --trglabel ./lh.BA2_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/lh.BA3a_exvivo.thresh.label --trgsubject sub-0020 --trglabel ./lh.BA3a_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/lh.BA3b_exvivo.thresh.label --trgsubject sub-0020 --trglabel ./lh.BA3b_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/lh.BA4a_exvivo.thresh.label --trgsubject sub-0020 --trglabel ./lh.BA4a_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/lh.BA4p_exvivo.thresh.label --trgsubject sub-0020 --trglabel ./lh.BA4p_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/lh.BA6_exvivo.thresh.label --trgsubject sub-0020 --trglabel ./lh.BA6_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/lh.BA44_exvivo.thresh.label --trgsubject sub-0020 --trglabel ./lh.BA44_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/lh.BA45_exvivo.thresh.label --trgsubject sub-0020 --trglabel ./lh.BA45_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/lh.V1_exvivo.thresh.label --trgsubject sub-0020 --trglabel ./lh.V1_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/lh.V2_exvivo.thresh.label --trgsubject sub-0020 --trglabel ./lh.V2_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/lh.MT_exvivo.thresh.label --trgsubject sub-0020 --trglabel ./lh.MT_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/lh.entorhinal_exvivo.thresh.label --trgsubject sub-0020 --trglabel ./lh.entorhinal_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/lh.perirhinal_exvivo.thresh.label --trgsubject sub-0020 --trglabel ./lh.perirhinal_exvivo.thresh.label --hemi lh --regmethod surface 


 mris_label2annot --s sub-0020 --hemi lh --ctab /usr/local/freesurfer/average/colortable_BA.txt --l lh.BA1_exvivo.label --l lh.BA2_exvivo.label --l lh.BA3a_exvivo.label --l lh.BA3b_exvivo.label --l lh.BA4a_exvivo.label --l lh.BA4p_exvivo.label --l lh.BA6_exvivo.label --l lh.BA44_exvivo.label --l lh.BA45_exvivo.label --l lh.V1_exvivo.label --l lh.V2_exvivo.label --l lh.MT_exvivo.label --l lh.entorhinal_exvivo.label --l lh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose 


 mris_label2annot --s sub-0020 --hemi lh --ctab /usr/local/freesurfer/average/colortable_BA.txt --l lh.BA1_exvivo.thresh.label --l lh.BA2_exvivo.thresh.label --l lh.BA3a_exvivo.thresh.label --l lh.BA3b_exvivo.thresh.label --l lh.BA4a_exvivo.thresh.label --l lh.BA4p_exvivo.thresh.label --l lh.BA6_exvivo.thresh.label --l lh.BA44_exvivo.thresh.label --l lh.BA45_exvivo.thresh.label --l lh.V1_exvivo.thresh.label --l lh.V2_exvivo.thresh.label --l lh.MT_exvivo.thresh.label --l lh.entorhinal_exvivo.thresh.label --l lh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose 


 mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.stats -b -a ./lh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-0020 lh white 


 mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.thresh.stats -b -a ./lh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-0020 lh white 

#--------------------------------------------
#@# BA_exvivo Labels rh wo 26 apr 2017 16:00:38 CEST

 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/rh.BA1_exvivo.label --trgsubject sub-0020 --trglabel ./rh.BA1_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/rh.BA2_exvivo.label --trgsubject sub-0020 --trglabel ./rh.BA2_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/rh.BA3a_exvivo.label --trgsubject sub-0020 --trglabel ./rh.BA3a_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/rh.BA3b_exvivo.label --trgsubject sub-0020 --trglabel ./rh.BA3b_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/rh.BA4a_exvivo.label --trgsubject sub-0020 --trglabel ./rh.BA4a_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/rh.BA4p_exvivo.label --trgsubject sub-0020 --trglabel ./rh.BA4p_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/rh.BA6_exvivo.label --trgsubject sub-0020 --trglabel ./rh.BA6_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/rh.BA44_exvivo.label --trgsubject sub-0020 --trglabel ./rh.BA44_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/rh.BA45_exvivo.label --trgsubject sub-0020 --trglabel ./rh.BA45_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/rh.V1_exvivo.label --trgsubject sub-0020 --trglabel ./rh.V1_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/rh.V2_exvivo.label --trgsubject sub-0020 --trglabel ./rh.V2_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/rh.MT_exvivo.label --trgsubject sub-0020 --trglabel ./rh.MT_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/rh.entorhinal_exvivo.label --trgsubject sub-0020 --trglabel ./rh.entorhinal_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/rh.perirhinal_exvivo.label --trgsubject sub-0020 --trglabel ./rh.perirhinal_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/rh.BA1_exvivo.thresh.label --trgsubject sub-0020 --trglabel ./rh.BA1_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/rh.BA2_exvivo.thresh.label --trgsubject sub-0020 --trglabel ./rh.BA2_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/rh.BA3a_exvivo.thresh.label --trgsubject sub-0020 --trglabel ./rh.BA3a_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/rh.BA3b_exvivo.thresh.label --trgsubject sub-0020 --trglabel ./rh.BA3b_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/rh.BA4a_exvivo.thresh.label --trgsubject sub-0020 --trglabel ./rh.BA4a_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/rh.BA4p_exvivo.thresh.label --trgsubject sub-0020 --trglabel ./rh.BA4p_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/rh.BA6_exvivo.thresh.label --trgsubject sub-0020 --trglabel ./rh.BA6_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/rh.BA44_exvivo.thresh.label --trgsubject sub-0020 --trglabel ./rh.BA44_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/rh.BA45_exvivo.thresh.label --trgsubject sub-0020 --trglabel ./rh.BA45_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/rh.V1_exvivo.thresh.label --trgsubject sub-0020 --trglabel ./rh.V1_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/rh.V2_exvivo.thresh.label --trgsubject sub-0020 --trglabel ./rh.V2_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/rh.MT_exvivo.thresh.label --trgsubject sub-0020 --trglabel ./rh.MT_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/rh.entorhinal_exvivo.thresh.label --trgsubject sub-0020 --trglabel ./rh.entorhinal_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /media/lukas/data/Software/Spynoza/spynoza/spynoza/data/test_data/fs/fsaverage/label/rh.perirhinal_exvivo.thresh.label --trgsubject sub-0020 --trglabel ./rh.perirhinal_exvivo.thresh.label --hemi rh --regmethod surface 


 mris_label2annot --s sub-0020 --hemi rh --ctab /usr/local/freesurfer/average/colortable_BA.txt --l rh.BA1_exvivo.label --l rh.BA2_exvivo.label --l rh.BA3a_exvivo.label --l rh.BA3b_exvivo.label --l rh.BA4a_exvivo.label --l rh.BA4p_exvivo.label --l rh.BA6_exvivo.label --l rh.BA44_exvivo.label --l rh.BA45_exvivo.label --l rh.V1_exvivo.label --l rh.V2_exvivo.label --l rh.MT_exvivo.label --l rh.entorhinal_exvivo.label --l rh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose 


 mris_label2annot --s sub-0020 --hemi rh --ctab /usr/local/freesurfer/average/colortable_BA.txt --l rh.BA1_exvivo.thresh.label --l rh.BA2_exvivo.thresh.label --l rh.BA3a_exvivo.thresh.label --l rh.BA3b_exvivo.thresh.label --l rh.BA4a_exvivo.thresh.label --l rh.BA4p_exvivo.thresh.label --l rh.BA6_exvivo.thresh.label --l rh.BA44_exvivo.thresh.label --l rh.BA45_exvivo.thresh.label --l rh.V1_exvivo.thresh.label --l rh.V2_exvivo.thresh.label --l rh.MT_exvivo.thresh.label --l rh.entorhinal_exvivo.thresh.label --l rh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose 


 mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.stats -b -a ./rh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-0020 rh white 


 mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.thresh.stats -b -a ./rh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-0020 rh white 

