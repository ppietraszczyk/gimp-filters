#!/bin/bash
# przem-soft-focus-noninteractive-TIFF.sh - Filtr dodający miękki focus
# 2025-06-16 - PRP
# Public Domain

files=$(ls *.ARW)

for file in $files; do
	if [ $file = "DSC09234.ARW" ]; then
        base_name=${file%.ARW}  # wycina rozszerzenie
        loadtiff=$base_name.tiff
        baseout=$base_name.pejzaz.tiff
        savename=PEJZAZ/$baseout
        dcraw -v -r 2.726191 1.000000 1.479328 1.064126 -H 0 -b 1.0 -o 1 -q 3 -6 -T  $file
		while [ ! -e $base_name.tiff  ]; do
            	echo "czekam"
        done
        convert  $loadtiff  -bordercolor white -border 30  -compress lzw $baseout
		
flatpak run org.gimp.GIMP -i -f -b "

  (let* (
		(img (car (gimp-file-load RUN-NONINTERACTIVE \"$baseout\" \"$savename\")))
		(drawable (car (gimp-image-get-active-layer img)))
        (soft-layer (car (gimp-layer-copy drawable FALSE)))
        (blur-radius 100)
        (opacity 100)
        )
  
    (gimp-image-insert-layer img soft-layer 0 -1)
    (gimp-item-set-name soft-layer \"soft\")
    (gimp-image-set-active-layer img soft-layer)
    (gimp-image-remove-layer img drawable)

    ; Rozmycie Gaussa
    (plug-in-gauss RUN-NONINTERACTIVE img soft-layer blur-radius blur-radius 0)

    ; Zmień tryb mieszania na Overlay lub Screen
    (gimp-layer-set-mode soft-layer OVERLAY-MODE)
    
    ; Dostosuj przezroczystość
    (gimp-layer-set-opacity soft-layer opacity)
	;(gimp-image-merge-down img soft-layer CLIP-TO-IMAGE)

	;(let* (
        ;(merged-layer (car (gimp-image-merge-visible-layers img EXPAND-AS-NECESSARY)))
        ;(merged-layer (car (gimp-image-merge-down img soft-layer CLIP-TO-IMAGE)))
        ;)
    (file-tiff-save  RUN-NONINTERACTIVE img soft-layer \"$savename\" \"$baseout\" 1) ; 1 - lZW
    (gimp-image-undo-enable img)
    ;)

	;(gimp-file-save RUN-NONINTERACTIVE img soft-layer \"$savename\" \"$loadtiff\")

    (gimp-image-delete img)

))

" -b "(gimp-quit 0)"
	rm $base_name.pejzaz.tiff
    rm $base_name.tiff
	fi
done
