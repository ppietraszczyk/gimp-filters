; przem-soft-focus-noninteractive-v3x.scm - Filtr dodający miękki focus
; 2025-06-19 - PRP
; Public Domain
; ver. 2025-06-19

;(define (przem-soft-focus-noninteractive-v3 basout savename)
(define (przem-soft-focus-noninteractive-v3x ask-fileglob)

  (let* (
        (glob-result (cadr (file-glob ask-fileglob 0)))
        (pattern glob-result)
        ;(savename (cadr glob-result))

        ;; Inicjalizacja zmiennych obrazu (tylko jeśli plik istnieje)
        (image (gimp-file-load RUN-NONINTERACTIVE pattern pattern))

        ;(image (car (gimp-file-load RUN-NONINTERACTIVE baseout savename)))
        (selected-layers-array (car (gimp-image-get-selected-layers image)))
        (num-selected-layers (vector-length selected-layers-array))
        (width (car (gimp-image-get-width image)))
        (height (car (gimp-image-get-height image)))
        (active-layer 0)
        (blur-radius 100)
        (opacity 100)
        )
    (gimp-message (string-append "Wartość pattern to: " ask-fileglob)) ; lub użyj samego pattern jeśli podejrzewasz że to string

	;(gimp-message (string-append \"baseout: \" (number->string baseout)))
	;(gimp-message (string-append \"savename: \" (number->string savename)))

    (set! active-layer (vector-ref selected-layers-array (- num-selected-layers 1)))
    

    ; Rozmycie Gaussa
    ;(plug-in-gauss RUN-NONINTERACTIVE image active-layer blur-radius blur-radius 0)

	(gimp-drawable-merge-new-filter active-layer "gegl:gaussian-blur"  RUN-NONINTERACTIVE LAYER-MODE-REPLACE 1.0 "std-dev-x" blur-radius "std-dev-y" 0.0  "filter" "auto")

    ; Zmień tryb mieszania na Overlay lub Screen
    (gimp-layer-set-mode active-layer LAYER-MODE-OVERLAY)
    
    ; Dostosuj przezroczystość
    (gimp-layer-set-opacity active-layer opacity)
	;(gimp-image-merge-down image active-layer CLIP-TO-IMAGE)

	;(let* (
        ;(merged-layer (car (gimp-image-merge-visible-layers image EXPAND-AS-NECESSARY)))
        ;(merged-layer (car (gimp-image-merge-down image active-layer CLIP-TO-IMAGE)))
        ;)
    ;(file-tiff-save  RUN-NONINTERACTIVE image active-layer savename baseout 1) ; 1 - lZW
    ;(gimp-file-save RUN-NONINTERACTIVE image active-layer savename savename)

    (gimp-image-undo-enable image)
    ;)


    (gimp-image-delete image)
	
))
