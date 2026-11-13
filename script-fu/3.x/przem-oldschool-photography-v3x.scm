; przem-oldschool-photography-v3x - Fotografia z okresu 20-sto lecia między wojennego
; 2025-10-01 - Przemysław R. Pietraszczyk
; licence: Public Domain
; ver. 2.251001-0



(define (curves image width height)
	;(gimp-drawable-curves-spline layer1 HISTOGRAM-VALUE (spline-chrome-it))
	(let* ((layer (gimp-layer-new image "Curves" width height RGB-IMAGE 100 LAYER-MODE-NORMAL))
		(set! layer (gimp-image-merge-visible-layers image CLIP-TO-IMAGE))
		(gimp-drawable-curves-spline layer HISTOGRAM-VALUE 12 #(0 0 51 45 102 95 153 158 204 209 255 255))
	))
)


(define (przem-oldschool-photography-v32 image drawable temperature strength apply brightness contrast)
	
	; use v3 binding of return args from PDB
	;(script-fu-use-v3)
	
	(let* (
		(temperature-factor (/ (- temperature 6500) 1000))
        (red-adjust (* temperature-factor (- strength)))
        (blue-adjust (* temperature-factor strength))
        (brightness-value (/ brightness 100))
        (contrast-value (/ contrast 100))
        (layer (vector-ref drawable 0))
        (work-layer (car (gimp-layer-copy layer TRUE)))
        (work-layer-brightness-contrast (car (gimp-layer-copy layer TRUE)))
        (image-width (car (gimp-image-get-width image)))
        (image-height (car (gimp-image-get-height image)))
		)
		
		(gimp-image-undo-group-start image)
		(gimp-context-push)
	
		(gimp-image-insert-layer image work-layer 0 -1)    
		(if (= apply TRUE)
			(gimp-image-insert-layer image work-layer-brightness-contrast 0 -1))   

	    ; Balans kolorów na podstawie temp. barwowej z kontrolą siły efektu
    ;   (gimp-message (string-append "Choice "))
		(gimp-drawable-color-balance work-layer TRANSFER-SHADOWS TRUE red-adjust 0 blue-adjust)
		(gimp-drawable-color-balance work-layer TRANSFER-MIDTONES TRUE red-adjust 0 blue-adjust)
		(gimp-drawable-color-balance work-layer TRANSFER-HIGHLIGHTS TRUE red-adjust 0 blue-adjust)
		(if (= apply TRUE)
			(gimp-drawable-brightness-contrast work-layer-brightness-contrast brightness-value contrast-value))

		(curves image image-width image-height)

		(gimp-image-undo-group-end image)
		(gimp-displays-flush)
		(gimp-context-pop)
	)
)

(script-fu-register-filter "przem-oldschool-photography-v32"
  _"Oldschool Photography"
  _"Nawiązanie do fotografii 20-sto lecia międzywojennego"
  "PRP"
  "Public Domain"
  "2025-10-01"
  "RGB*"
  SF-ONE-OR-MORE-DRAWABLE
  SF-ADJUSTMENT "Temperatura (K)" '(5150 1000 10000 100 1000 0 1)
  SF-ADJUSTMENT "Siła efektu" '(1.0 0.1 3.0 0.1 0.5 1 0)
  SF-TOGGLE _"Apply Brightness and Contrast" FALSE
  SF-ADJUSTMENT _"Brightness" '(0 -100 100 1 10 0 0)
  SF-ADJUSTMENT _"Contrast" '(-30 -100 100 1 10 0 0)
  
)

(script-fu-menu-register "przem-oldschool-photography-v32"
                         "<Image>/Filters/PIETRASZCZYK/")
