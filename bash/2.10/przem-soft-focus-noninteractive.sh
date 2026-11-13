#!/bin/bash
# przem-soft-focus-noninteractive.sh - Filtr dodający miękki focus
# 2025-06-16 - PRP
# Public Domain

files=$(ls *.jpg)

for file in $files; do
	#if [ $file = "DSC09223.jpg" ]; then
        base_name=${file%.jpg}  # wycina rozszerzenie
        savename=FOCUS/$base_name.jpg

flatpak run org.gimp.GIMP -i -f -b "

  (let* (
		(img (car (gimp-file-load RUN-NONINTERACTIVE \"$file\" \"$savename\")))
		(drawable (car (gimp-image-get-active-layer img)))
        (soft-layer (car (gimp-layer-copy drawable FALSE)))
        (blur-radius 30)
        (opacity 100)
        )
  
    (gimp-image-insert-layer img soft-layer 0 -1)
    (gimp-item-set-name soft-layer \"soft\")
    
    ; Rozmycie Gaussa
    (plug-in-gauss RUN-NONINTERACTIVE img soft-layer blur-radius blur-radius 0)

    ; Zmień tryb mieszania na Overlay lub Screen
    (gimp-layer-set-mode soft-layer OVERLAY-MODE)
    
    ; Dostosuj przezroczystość
    (gimp-layer-set-opacity soft-layer opacity)
	
	(gimp-file-save RUN-NONINTERACTIVE img soft-layer \"$savename\" \"$file\")

    (gimp-image-delete img)

))

" -b "(gimp-quit 0)"

	#fi
done
