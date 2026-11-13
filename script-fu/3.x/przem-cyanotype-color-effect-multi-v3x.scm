; przem-cyanotype-color-effect-multi-v3x - Efekty cyjanotypi na kolor
; author: PRP
; licencja: Public Domain
; Gdańsk - 24-08-2025
; ver. 2.250824-2

(define (przem-cyanotype-color-effect-multi-v32 img drawable black blue)
  
  (gimp-context-push)
  (gimp-image-undo-group-start img)
  
  ; Cyjanotypia (zostaw tylko niebieski kanał)
  (let* (
	(layer (vector-ref drawable 0))
	;(type (car (gimp-drawable-type-with-alpha cyan-layer)))
	(type (car (gimp-drawable-type-with-alpha (car (gimp-layer-copy (vector-ref drawable 0))))))

    ;(cyan-layer (car (gimp-layer-copy drawable TRUE)))
    (mask (car (gimp-channel-new img "Engraving Mask" (car (gimp-image-get-width img)) (car (gimp-image-get-height img)) black '(0.0 0.0 1.0 0.0 0.0 1.0 0.0 0.0 1.0))))
    )
    (if (> (car (gimp-drawable-type layer)) 1)
        (gimp-image-convert-rgb img))
    
    ;; Desaturacja
    ;(if (= type RGBA-IMAGE)
    ;(gimp-drawable-desaturate layer DESATURATE-LIGHTNESS))

    (let* (
    	(cyan-layer (car (gimp-layer-copy (vector-ref drawable 0))))
		)
		(gimp-context-set-foreground '(0 51 102)) ; Kolor błękitu pruskiego
		(gimp-image-insert-layer img cyan-layer 0 -1)
		(gimp-item-set-name cyan-layer "Cyanotype")
		(gimp-layer-set-mode cyan-layer LAYER-MODE-SCREEN) ; Tryb mieszania: Screen
	)
    ;(gimp-hue-saturation cyan-layer 0 blue 50 0)
    (gimp-image-insert-channel img mask -1 0)
  )
  
  (gimp-image-undo-group-end img)
  (gimp-displays-flush)
  (gimp-context-pop))


(script-fu-register-filter  "przem-cyanotype-color-effect-multi-v32"
  _"Add Cyanotype Color Multi..."
  _"Efekty cyjanotypii na kolor"
  "PRP"
  "Public Domain"
  "2025-08-24"
  "RGB* GRAY*"
  SF-ONE-OR-MORE-DRAWABLE
  SF-ADJUSTMENT "Black" '(5 0 100 1 10 0 0)
  SF-ADJUSTMENT "Pastel blue" '(40 30 70 1 10 1 0))

(script-fu-menu-register "przem-cyanotype-color-effect-multi-v32"
                         "<Image>/Filters/PIETRASZCZYK/")

