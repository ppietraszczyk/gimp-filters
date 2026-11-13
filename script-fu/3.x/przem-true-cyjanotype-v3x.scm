; przem-true-cyjantype-v3x - imituje efekt prawdziwej cyjanotypii
; author: PRP
; licencja: Public Domain
; Gdańsk - 14-10-2025
; ver. 2.251104-1

(define (przem-true-cyjantype-v32 image drawable black normalize value-blue invert replace tone-curve)
	(let* ((gradient-layer 0)
        (type-layer (vector-ref drawable 0))
        (mask (car (gimp-channel-new image "Engraving Mask" (car (gimp-image-get-width image)) (car (gimp-image-get-height image)) black '(0.4 0.4 0.2 0.0 0.0 0.0 0.0 0.0 0.0))))
		(layer (vector-ref drawable 0))
		(type (car (gimp-drawable-type layer)))
		(gradient-reverse FALSE)
        )
		(gimp-context-push)
		(gimp-image-undo-group-start image)
  
		;; jeśli obraz jest szary to konwertuje go na RGB - tak na sztukę
		(if (> (car (gimp-drawable-type type-layer)) 1)
        (gimp-image-convert-rgb image))
        
        ; Konwersja obrazu do skali szarości
		(if (= type RGB-IMAGE)
		(gimp-drawable-desaturate type-layer DESATURATE-LIGHTNESS)
		)
        
        
        ; dla obrazów przestrzeni RGB i Gray, utworzenie nowej warstwy, dopiero po kowersji na rgb
		(set! gradient-layer (car (gimp-layer-new image "Prussian Blue" (car (gimp-image-get-width image)) (car (gimp-image-get-height image)) RGBA-IMAGE  100 LAYER-MODE-NORMAL)))

		(gimp-context-set-foreground '(0 51 102)) ; Kolor błękitu pruskiego
		(gimp-context-set-background '(0 0 0))
		
		(gimp-image-insert-channel image mask -1 0)

  
		(gimp-image-insert-layer image gradient-layer 0 -1)
		
		(gimp-context-set-gradient-reverse gradient-reverse)
		(gimp-drawable-edit-gradient-fill gradient-layer
				      GRADIENT-LINEAR 0
				      FALSE 1 0
				      TRUE
				      0 0 0 0)
		(gimp-layer-set-opacity gradient-layer value-blue)
		
		; w przeciwieństwie do wer. 2.10 krzywe tonalne działają inaczej
		(if (= tone-curve TRUE)
		(let* ((curves-layer (car (gimp-layer-copy gradient-layer TRUE)))
			;(gimp-drawable-curves-spline curves-layer HISTOGRAM-VALUE 10 #(0 0 32 40 128 140 220 230 255 255))
			; nie trzeba już deklarować długości vektora
			(gimp-drawable-curves-spline curves-layer HISTOGRAM-VALUE #(0 0 (/ 32 255) (/ 40 255) (/ 128 255) (/ 140 255) (/ 220 255) (/ 230 255) (/ 255 255) (/ 255 255)))
		)
		(gimp-image-insert-layer image curves-layer 0 -1)
		(gimp-item-set-visible curves-layer TRUE)
		))

		(if (= invert TRUE)
		(gimp-drawable-invert type-layer FALSE))
		
		;(if (= replace TRUE)
		;	; Wybierz tylko czarne piksele
		;	(gimp-image-select-color image CHANNEL-OP-REPLACE drawable '(0 0 0))
  
		;	; Wypełnij wybrane obszary kolorem granatowym
		;	(gimp-context-set-foreground '(0 0 128)) ; RGB dla granatowego
		;	(gimp-edit-bucket-fill drawable BUCKET-FILL-FG LAYER-MODE-NORMAL 100 0 FALSE 0 0)
		;	  ; Odznacz selekcję
		;	(gimp-selection-none image))
  
		(let* ((merged-layer (car (gimp-image-merge-visible-layers image CLIP-TO-IMAGE))))
			(gimp-item-set-visible merged-layer TRUE))

  
		(gimp-image-undo-group-end image)
		(gimp-displays-flush)
		(gimp-context-pop)
  )
)

(script-fu-register-filter "przem-true-cyjantype-v32"
  _"Apply true cyjanotype effect"
  _"Pseudo-prawdziwa próba imitacji cyjanotypii"
  "Przemysław R. Pietraszczyk"
  "Public Domain"
  "2025-09-21"
  "RGB* GRAY*"
  SF-ONE-OR-MORE-DRAWABLE
  SF-ADJUSTMENT "Black" '(5 0 100 1 10 0 0)
  SF-TOGGLE "Normalize to 100%" TRUE
  SF-ADJUSTMENT "Blue intensity" '(50 0 100 1 10 0 0)
  SF-TOGGLE "Invert colors" FALSE
  SF-TOGGLE "Replace black" FALSE
  SF-TOGGLE "Tone Curve" TRUE

)

(script-fu-menu-register "przem-true-cyjantype-v32"
                         "<Image>/Filters/PIETRASZCZYK/")
