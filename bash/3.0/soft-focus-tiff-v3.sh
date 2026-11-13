#!/bin/bash
# przem-soft-focus-noninteractive-TIFF.sh - Filtr dodający miękki focus
# 2025-06-16 - PRP
# Public Domain

files=$(ls *.ARW)

for file in $files; do
	if [ $file = "DSC09250.ARW" ]; then
        base_name=${file%.ARW}  # wycina rozszerzenie
        loadtiff=$base_name.tiff
        baseout=$base_name.siec.tiff
        savename=SIEC/$baseout
        dcraw -v -r 2.726191 1.000000 1.479328 1.064126 -H 0 -b 1.0 -o 1 -q 3 -6 -T  $file
		while [ ! -e $base_name.tiff  ]; do
            	echo "czekam"
        done
        convert  $loadtiff  -bordercolor white -border 30  -compress lzw $baseout
		
gimp -i -f --batch-interpreter plug-in-script-fu-eval -b "

(define (soft-focus-tiff-v3 ask-fileglob)
  (let* (
		(thefiles (cadr (file-glob ask-fileglob 0)))
		(baseout (car thefiles))
		(savename (cad thefiles)) 
		(image (car (gimp-file-load RUN-NONINTERACTIVE baseout savename)))
		;(drawable (car (gimp-image-get-active-layer image)))
        (selected-layers-array (car (gimp-image-get-selected-layers image)))
        (num-selected-layers vector-length selected-layers-array)
        ;(width (car (gimp-image-get-width image)))
        ;(height (car (gimp-image-get-height image)))
        (active-layer 0)
        (blur-radius 100)
        (opacity 100)
        )

	;(gimp-message (string-append \"baseout: \" (number->string baseout)))
	;(gimp-message (string-append \"savename: \" (number->string savename)))


    (set! active-layer (vector-ref selected-layers-array (- num-selected-layers 1)))
    

    ; Rozmycie Gaussa
    ;(plug-in-gauss RUN-NONINTERACTIVE image active-layer blur-radius blur-radius 0)

	(gimp-drawable-merge-new-filter active-layer \"gegl:gaussian-blur\"  RUN-NONINTERACTIVE LAYER-MODE-REPLACE 1.0 \"std-dev-x\" blur-radius \"std-dev-y\" 0.0  \"filter\" \"auto\")

    ; Zmień tryb mieszania na Overlay lub Screen
    (gimp-layer-set-mode active-layer OVERLAY-MODE)
    
    ; Dostosuj przezroczystość
    (gimp-layer-set-opacity active-layer opacity)
	;(gimp-image-merge-down image active-layer CLIP-TO-IMAGE)

	;(let* (
        ;(merged-layer (car (gimp-image-merge-visible-layers image EXPAND-AS-NECESSARY)))
        ;(merged-layer (car (gimp-image-merge-down image active-layer CLIP-TO-IMAGE)))
        ;)
    (file-tiff-save  RUN-NONINTERACTIVE image active-layer savename baseout 1) ; 1 - lZW
    (gimp-image-undo-enable image)
    ;)

	;(gimp-file-save RUN-NONINTERACTIVE image active-layer \"$savename\" \"$loadtiff\")

    (gimp-image-delete image)
	
))
soft-focus-tiff-v3 '\"$baseout\" \"$savename\"'
" -b "(gimp-quit 0)"
	rm $base_name.siec.tiff
    rm $base_name.tiff
	fi
done
