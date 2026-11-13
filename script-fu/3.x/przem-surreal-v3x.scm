; przem-surreal-v3x - imitacja surrealistycznych obrazów
; author: PRP
; licencja: Public Domain
; Gdańsk - 24-12-2025
; ver. 2.260505-0~beta

(define (przem-surreal-v32 img drawable shades)
  (let* (
         (width (car (gimp-image-get-width img)))
		 (height (car (gimp-image-get-height img)))
         (layer-copy 0)
         (source-layer 0)
         (green-layer 0)
		 (type-layer (vector-ref drawable 0))
		 (type (car (gimp-drawable-type type-layer)))
		 (blue-glow  (list 102 204 255))
		 (blue-pastel (list 153 221 255))
		 (blue 0)
        )
        
	(gimp-context-push)
	(gimp-image-undo-group-start img)

	(if (> (car (gimp-drawable-type type-layer)) 1)
        (gimp-image-convert-rgb img)
        )
    (set! source-layer (vector-ref (car (gimp-image-get-layers img)) 0 ))
	(set! layer-copy (car (gimp-layer-copy source-layer)))

    ; Dodajemy skopiowaną warstwę
    (gimp-image-insert-layer img layer-copy -1)
  
	;; jeśli obraz jest szary to konwertuje go na RGB - tak na sztukę
	(if (> (car (gimp-drawable-type type-layer)) 1)
    (gimp-image-convert-rgb img))
        
    ; Konwersja obrazu do skali szarości
	(if (= type RGB-IMAGE)
		(gimp-drawable-desaturate type-layer DESATURATE-LIGHTNESS)
	)
    
    (if (= shades 0)
       (begin
       (set! blue blue-glow)
     ))
	(if (= shades 1)
       (begin
       (set! blue blue-pastel)
     ))
    
    (let* (
    ;   ; 3. Tonowanie (niebieska poświata)
        (gimp-drawable-merge-new-filter
            layer-copy
            "gegl:color"
            "color-filter"
            LAYER-MODE-ADDITION
            0.1
            "value" blue
        )
        )
    )
    ; Rozmycie dla efektu mgły
	(gimp-drawable-merge-new-filter layer-copy "gegl:gaussian-blur"  RUN-NONINTERACTIVE LAYER-MODE-REPLACE 1.0 "std-dev-x" 10.0 "std-dev-y" 10.0  "filter" "auto")

    ; Tryb mieszania: Overlay
    (gimp-layer-set-mode layer-copy LAYER-MODE-ADDITION)
    (gimp-layer-set-opacity layer-copy 70.0)

    ; Dodajemy zieloną warstwę
    (set! green-layer (car (gimp-layer-new img "Green" width height RGB-IMAGE 100 LAYER-MODE-NORMAL)))

    (gimp-image-insert-layer img green-layer -1)
    (gimp-context-set-foreground '(60 120 60)) ; ciemna zieleń
    (gimp-drawable-edit-fill green-layer FILL-FOREGROUND)
    (gimp-layer-set-mode green-layer LAYER-MODE-MULTIPLY)
    (gimp-layer-set-opacity green-layer 25.0)

    (gimp-image-undo-group-end img)
	(gimp-displays-flush)
	(gimp-context-pop)
  )
)

(script-fu-register-filter "przem-surreal-v32"
 "_Surreal Toning with Green"
 "_Nadaje obrazowi chłodne barwy z zielonymi akcentami i efektem mgły"
 "P.R.P"
 "Public Domain"
 "24-12-2025"
 "RGB* GRAY*"
 SF-ONE-OR-MORE-DRAWABLE
 SF-OPTION     _"Shades of blue" '("Glow" "Pastel")

)

(script-fu-menu-register "przem-surreal-v32"
                         "<Image>/Filters/PIETRASZCZYK/")
