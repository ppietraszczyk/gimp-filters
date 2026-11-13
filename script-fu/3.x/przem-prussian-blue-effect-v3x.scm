; przem-prussian-blue-effect-v3x  - nieudalna próba nawiązania do efektu cyjanotypii
; author: PRP
; licencja: Public Domain
; Gdańsk - 22-6-2025
; ver. 2.250712-0~beta

(define (przem-prussian-blue-effect-v32 img drawable mode black value-blue brightness contrast invert)
  
  ;(script-fu-use-v3)

  (let* ((gradient-layer 0)
		(in-layer (vector-ref drawable 0))
        (mask (car (gimp-channel-new img "Engraving Mask" (car (gimp-image-get-width img)) (car (gimp-image-get-height img)) black '(0.0 0.0 1.0 0.0 0.0 1.0 0.0 0.0 1.0))))
		)
  (gimp-context-push)
  (gimp-image-undo-group-start img)
  (gimp-context-set-defaults)

  (if (> (car (gimp-drawable-type in-layer)) 1)
        (gimp-image-convert-rgb img))
  ; dla obrazów przestrzeni RGB i Gray, utworzenie nowej warstwy, dopiero po kowersji na rgb
  (set! gradient-layer (car (gimp-layer-new img "Prussian Blue" (car (gimp-image-get-width img)) (car (gimp-image-get-height img)) RGBA-IMAGE  100 LAYER-MODE-NORMAL)))
  
  (gimp-image-insert-layer img gradient-layer 0 -1)
  (gimp-context-set-foreground '(0 51 102)) ; Kolor błękitu pruskiego
  (gimp-context-set-background '(0 0 0))
  
  (gimp-drawable-brightness-contrast gradient-layer brightness contrast)

  (gimp-image-insert-channel img mask -1 0)
  
  (if (= mode 0) (begin (gimp-layer-set-mode gradient-layer LAYER-MODE-NORMAL)
				(gimp-drawable-edit-gradient-fill gradient-layer
				      GRADIENT-LINEAR 1
				      FALSE 1 0
				      TRUE
				      0 0 0 0)))
  (if (= mode 1) (begin (gimp-layer-set-mode gradient-layer LAYER-MODE-SUBTRACT)
				(gimp-drawable-edit-gradient-fill gradient-layer
				      GRADIENT-LINEAR 1
				      FALSE 1 0
				      TRUE
				      0 0 0 0)))
  (if (= mode 2) (begin (gimp-layer-set-mode gradient-layer LAYER-MODE-ADDITION)
				(gimp-drawable-edit-gradient-fill gradient-layer
				      GRADIENT-LINEAR 1
				      FALSE 1 0
				      TRUE
				      0 0 0 0)))
  (if (= mode 3) (begin (gimp-layer-set-mode gradient-layer LAYER-MODE-DARKEN-ONLY)
				(gimp-drawable-edit-gradient-fill gradient-layer
				      GRADIENT-LINEAR 1
				      FALSE 1 0
				      TRUE
				      0 0 0 0)))
  (if (= mode 3) (begin (gimp-layer-set-mode gradient-layer LAYER-MODE-DIFFERENCE)
				(gimp-drawable-edit-gradient-fill gradient-layer
				      GRADIENT-LINEAR 1
				      FALSE 1 0
				      TRUE
				      0 0 0 0)))
				      
  ;(if (= invert TRUE) (gimp-invert gradient-layer))
	
  (gimp-layer-set-opacity gradient-layer value-blue)

  (let* ((merged-layer (car (gimp-image-merge-visible-layers img CLIP-TO-IMAGE))))
	(gimp-item-set-visible merged-layer TRUE))

  (gimp-image-undo-group-end img)
  (gimp-displays-flush)
  (gimp-context-pop)
  )
)

(script-fu-register-filter "przem-prussian-blue-effect-v32"
  _"Apply prussian blue effect"
  _"Nakłada efekt błękitu pruskiego na zdjęcie."
  "PRP"
  "Public Domain"
  "2025-06-22"
  "RGB* GRAY*"
  SF-ONE-OR-MORE-DRAWABLE
  SF-OPTION "Mode" '("NORMAL" "SUBTRACT" "ADDITION" "DARKEN-ONLY" "DIFFERENCE")
  SF-ADJUSTMENT "Black" '(5 0 100 1 10 0 0)
  SF-ADJUSTMENT "Blue intensity" '(60 0 100 1 10 0 0)
  SF-ADJUSTMENT "Brightness" '(0 -1 1 0.0001 0.0001 2 0)
  SF-ADJUSTMENT "Contrast" '(0 -1 1 0.0001 0.0001 2 0)
  SF-TOGGLE "Invert" FALSE
)

(script-fu-menu-register "przem-prussian-blue-effect-v32"
                         "<Image>/Filters/PIETRASZCZYK/")
