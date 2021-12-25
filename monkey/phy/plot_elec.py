import gl
import sys
print(sys.version)
print(gl.version())
gl.resetdefaults()
gl.backcolor(255, 255, 255)
gl.loadimage(
    '/Volumes/WD_D/gufei/monkey_data/IMG/RM035_NMT/NMT2_in_RM035_anat.nii.gz')
#gl.overlayload('aal')
gl.overlayload(
    '/Volumes/WD_D/gufei/monkey_data/IMG/RM035_NMT/SARM_in_RM035_anat_amy.nii')
gl.overlayload(
    '/Volumes/WD_D/gufei/monkey_data/IMG/RM035_NMT/RM035_MRI_orien.nii')
gl.overlayload(
    '/Volumes/WD_D/gufei/monkey_data/IMG/RM035_NMT/RM035_MRI_allpos.nii')
gl.overlayloadsmooth(0)
gl.volume(1, 5)
#gl.atlashide(1)
#gl.atlasshow(1, (16, 41))
#gl.atlaslabels(1)
#gl.atlasmaxindex(1)
gl.colorname(1, 'linspecer')
gl.minmax(1, 15, 41)
gl.colorname(2, '3blue')
gl.colorname(3, '1red')
gl.opacity(0, 50)
gl.colorbarposition(0)
# glass shader
gl.shadername('glass')
gl.shaderquality1to10(4)
gl.shaderadjust('boundBrightness', 1)
gl.shaderadjust('boundThresh', 0.3)
gl.shaderadjust('specular', 0)
gl.shaderadjust('shininess', 0)
#gl.viewsagittal(2)
gl.viewcoronal(2)
gl.cameradistance(0.3)
# gl.savebmp('/Volumes/WD_D/gufei/monkey_data/IMG/RM035_NMT/all_elec.png')
# standard shader
# gl.shadername('standard')
# default shader
# gl.shadername('default')
# gl.shaderadjust('overlayFuzzy', 1)
# gl.opacity(0, 20)


# nifti_tool -overwrite -mod_hdr -mod_field intent_code 1002 -infiles SARM_in_RM035_anat.nii

# generate Amygdala ROI
# 3dcalc -a SARM_in_RM033_anat.nii.gz -expr 'a*within(a,16,41)' -prefix SARM_in_RM033_anat_amy.nii

# AFNI can not load data correctly if .nii and .nii.gz with the same name occur in the same folder

# output from help template
# atlashide (built-in function): 
#  atlashide(layer, indices...) -> Hide all (e.g. "atlashide(1)") or some (e.g. "atlashide(1, (17, 22))") regions of an atlas.
# atlaslabels (built-in function): 
#  atlasmaxindex(layer) -> Returns string listing all regions in an atlas
# atlasmaxindex (built-in function): 
#  atlasmaxindex(layer) -> Returns maximum region humber in specified atlas. For example, if you load the CIT168 atlas (which has 15 regions) as your background image, then atlasmaxindex(0) will return 15.
# atlasshow (built-in function): 
#  atlasshow(layer, indices...) -> Show all (e.g. "atlasshow(1)") or some (e.g. "atlasshow(1, (17, 22))") regions of an atlas.
# azimuthelevation (built-in function): 
#  azimuthelevation(azi, elev) -> Sets the render camera location.
# backcolor (built-in function): 
#  backcolor(r, g, b) -> changes the background color, for example backcolor(255, 0, 0) will set a bright red background
# bmptransparent (built-in function): 
#  bmptransparent(v) -> set if bitmaps use transparent (1) or opaque (0) background
# bmpzoom (built-in function): 
#  bmpzoom(z) -> changes resolution of savebmp(), for example bmpzoom(2) will save bitmaps at twice screen resolution
# cameradistance (built-in function): 
#  cameradistance(z) -> Sets the viewing distance from the object.
# clipazimuthelevation (built-in function): 
#  clipazimuthelevation(depth, azi, elev) -> Set a view-point independent clip plane.
# clipthick (built-in function): 
#  clipthick(thick) -> Set size of clip plane slab (0..1).
# colorbarposition (built-in function): 
#  colorbarposition(p) -> Set colorbar position (0=off, 1=top, 2=right).
# colorbarsize (built-in function): 
#  colorbarsize(p) -> Change width of color bar f is a value 0.01..0.5 that specifies the fraction of the screen used by the colorbar.
# coloreditor (built-in function): 
#  coloreditor(s) -> Show (1) or hide (0) color editor and histogram.
# colorfromzero (built-in function): 
#  colorfromzero(layer, isFromZero) -> Color scheme display range from zero (1) or from treshold value (0)?
# colorname (built-in function): 
#  colorname(layer, colorName) -> Set the colorscheme for the target overlay (0=background layer) to a specified name.
# colornode (built-in function): 
#  colornode(layer, index, intensity, r, g, b, a) -> Adjust color scheme for image.
# cutout (built-in function): 
#  cutout(L,A,S,R,P,I) -> Remove sector from volume.
# drawload (built-in function): 
#  drawload(filename) -> Load an image as a drawing (region of interest).
# extract (built-in function): 
#  extract(b,s,t) -> Remove haze from background image. Blur edges (b: 0=no, 1=yes, default), single object (s: 0=no, 1=yes, default), threshold (t: 1..5=high threshold, 5 is default, higher values yield larger objects)
# fullscreen (built-in function): 
#  fullscreen(max) -> Form expands to size of screen (1) or size is maximized (0).
# generateclusters (built-in function): 
#  generateclusters(layer, thresh, minClusterMM3, method, bimodal) -> create list of distinct regions. Optionally provide cluster intensity, minimum cluster size, neighbor method(1=faces,2=faces+edges,3=faces+edges+corners). If bimodal = 1, both dark and brig
# ht clusters are detected.
# graphscaling (built-in function): 
#  graphscaling(type) -> Vertical axis of graph is raw (0), demeaned (1) normalized -1..1 (2) normalized 0..1 (3) or percent (4).
# gui_input (built-in function): 
# gui_input(caption, prompt, default) -> allow user to type value into a dialog box.
# hiddenbycutout (built-in function): 
#  hiddenbycutout(layer, isHidden) -> Will cutout hide (1) or show (0) this layer?
# invertcolor (built-in function): 
#  invertcolor(layer, isInverted) -> Is color intensity inverted (1) or not (0) this layer?
# linecolor (built-in function): 
#  linecolor(r,g,b) -> Set color of crosshairs, so "linecolor(255,0,0)" will use bright red lines.
# linewidth (built-in function): 
#  linewidth(wid) -> Set thickness of crosshairs used on 2D slices.
# loadgraph (built-in function): 
#  loadgraph(graphName, add = 0) -> Load text file graph (e.g. AFNI .1D, FSL .par, SPM rp_.txt). If "add" equals 1 new graph added to existing graph
# loadimage (built-in function): 
#  loadimage(imageName) -> Close all open images and load new background image.
# minmax (built-in function): 
#  minmax(layer, min, max) -> Sets the color range for the overlay (layer 0 = background).
# modalmessage (built-in function): 
#  modalmessage(msg) -> Show a message in a dialog box, pause script until user presses "OK" button.
# mosaic (built-in function): 
#  mosaic(mosString) -> Create a series of 2D slices.
# opacity (built-in function): 
#  opacity(layer, opacityPct) -> Make the layer (0 for background, 1 for 1st overlay) transparent(0), translucent (~50) or opaque (100).
# orthoviewmm (built-in function): 
#  orthoviewmm(x,y,z) -> Show 3 orthogonal slices of the brain, specified in millimeters.
# overlayadditiveblending (built-in function): 
#  overlayadditiveblending(v) -> Merge overlays using additive (1) or multiplicative (0) blending.
# overlaycloseall (built-in function): 
#  overlaycloseall() -> Close all open overlays.
# overlaycount (built-in function): 
#  overlaycount() -> Return number of overlays currently open.
# overlayload (built-in function): 
#  overlayload(filename) -> Load an image on top of prior images.
# overlayloadsmooth (built-in function): 
#  overlayloadsmooth(0) -> Will future overlayload() calls use smooth (1) or jagged (0) interpolation?
# overlaymaskwithbackground (built-in function): 
# overlaymaskwithbackground(v) -> hide (1) or show (0) overlay voxels that are transparent in background image.
# pitch (built-in function): 
#  pitch(degrees) -> Sets the pitch of object to be rendered.
# quit (built-in function): 
#  quit() -> Terminate the application.
# removesmallclusters (built-in function): 
#  removesmallclusters(layer, thresh, mm, neighbors) -> only keep clusters where intensity exceeds thresh and size exceed mm. Clusters based on neighbors that share faces (1), faces+edges (2) or faces+edges+corners (3)
# resetdefaults (built-in function): 
#  resetdefaults() -> Revert settings to sensible values.
# savebmp (built-in function): 
#  savebmp(pngName) -> Save screen display as bitmap. For example "savebmp('test.png')"
# saveimg (built-in function): 
#  saveimg(filename) -> Save background image (layer 0) to disk. For example "saveimg('test.nii')", extension defines type (.nii=NIfTI, .osp=ospray, .bvox=blender)
# scriptformvisible (built-in function): 
#  scriptformvisible (visible) -> Show (1) or hide (0) the scripting window.
# shaderadjust (built-in function): 
#  shaderadjust(sliderName, sliderValue) -> Set level of shader property. Example "gl.shaderadjust('edgethresh', 0.6)"
# shaderlightazimuthelevation (built-in function): 
#  shaderlightazimuthelevation(a,e) -> Position the light that illuminates the rendering. For example, "shaderlightazimuthelevation(0,45)" places a light 45-degrees above the object
# shadermatcap (built-in function): 
#  shadermatcap(name) -> Set material capture file (assumes "matcap" shader. For example, "shadermatcap('mc01')" selects mc01 matcap.
# shadername (built-in function): 
#  shadername(name) -> Choose rendering shader function. For example, "shadername('mip')" renders a maximum intensity projection.
# shaderquality1to10 (built-in function): 
#  shaderquality1to10(i) -> Renderings can be fast (1) or high quality (10), medium values (6) balance speed and quality.
# shaderupdategradients (built-in function): 
#  shaderupdategradients() -> Recalculate volume properties.
# sharpen (built-in function): 
#  sharpen() -> apply unsharp mask to background volume to enhance edges
# smooth (built-in function): 
#  smooth2D(s) -> make 2D images blurry (linear interpolation, 1) or jagged (nearest neightbor, 0).
# toolformvisible (built-in function): 
#  toolformvisible(visible) -> Show (1) or hide (0) the tool panel.
# version (built-in function): 
#  version() -> Return the version of MRIcroGL.
# view (built-in function): 
#  view(v) -> Display Axial (1), Coronal (2), Sagittal (4), Flipped Sagittal (8), MPR (16), Mosaic (32) or Rendering (64)
# viewaxial (built-in function): 
#  viewaxial(SI) -> Show rendering with camera superior (1) or inferior (0) of volume.
# viewcoronal (built-in function): 
#  viewcoronal(AP) -> Show rendering with camera posterior (1) or anterior (0) of volume.
# viewsagittal (built-in function): 
#  viewsagittal(LR) -> Show rendering with camera left (1) or right (0) of volume.
# volume (built-in function): 
#  volume(layer, vol) -> For 4D images, set displayed volume (layer 0 = background; volume 0 = first volume in layer).
# wait (built-in function): 
#  wait(ms) -> Pause script for (at least) the desired milliseconds.
# yoke (built-in function): 
#  yoke(v) -> Yoke (1) instances so different instances show same view.
# zerointensityinvisible (built-in function): 
#  zerointensityinvisible(layer, bool) ->  For specified layer (0 = background) should voxels with intensity 0 be opaque (bool= 0) or transparent (bool = 1).
# zoomcenter (built-in function): 
#  zoomcenter(x,y,z) -> Set center of expansion for zoom scale (values in range 0..1 with 0.5 in volume center).
# zoomscale (built-in function): 
#  zoomscale2D(z) -> Enlarge 2D image (range 1..6).
