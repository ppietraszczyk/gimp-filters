; przem-ilford-expired-v3x - Fotografia imitująca przeterminowany film Ilforda
; 2025-10-05 - Przemysław R. Pietraszczyk
; licence: Public Domain
; ver. 2.251006-0
; Ten script-fu wykorzystuje funkcje ze skryptu 'chrome-it.scm' 
; Autorstwa Spencer Kimball

(define (shadows val)
	(/ (* 0.96 val) 2.55))

(define (midtones val)
	(/ val 2.55))

(define (highlights val)
	; The result is used as "gimp-drawable-color-balance" color parameter
	; and thus must be restricted to -100.0 <= highlights <= 100.0.
	(min (/ (* 1.108 val) 2.55) 100.0))

(define (rval col)    
	(car col))

(define (gval col)
    (cadr col))

(define (bval col)
    (caddr col))



(define (apply-quick-tint img layer1 layer2 width height saturation lightness hc cc)

	(gimp-drawable-color-balance layer1 TRANSFER-SHADOWS 1
                                  (shadows (rval hc))
                                  (shadows (gval hc))
                                  (shadows (bval hc)))
     (gimp-drawable-color-balance layer1 TRANSFER-MIDTONES 1
                                 (midtones (rval hc))
                                  (midtones (gval hc))
                                  (midtones (bval hc)))
     (gimp-drawable-color-balance layer1 TRANSFER-HIGHLIGHTS 1
                                  (highlights (rval hc))
                                  (highlights (gval hc))
                                  (highlights (bval hc)))
                                 
     (gimp-drawable-color-balance layer2 TRANSFER-SHADOWS 1
                                  (shadows (rval cc))
                                  (shadows (gval cc))
                                  (shadows (bval cc)))
     (gimp-drawable-color-balance layer2 TRANSFER-MIDTONES 1
                                  (midtones (rval cc))
                                  (midtones (gval cc))
                                  (midtones (bval cc)))
     (gimp-drawable-color-balance layer2 TRANSFER-HIGHLIGHTS 1
                                  (highlights (rval cc))
                                  (highlights (gval cc))
                                  (highlights (bval cc)))
                            
     (gimp-drawable-hue-saturation layer2 HUE-RANGE-ALL
                                   0.0
                                   lightness
                                   saturation
                                   0.0))



(define (przem-ilford-expired-v32 image drawable temperature strength apply brightness contrast saturation lightness hc cc)

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
        (work-layer-second (car (gimp-layer-copy layer TRUE)))
        (work-layer-brightness-contrast (car (gimp-layer-copy layer TRUE)))
        (image-width (car (gimp-image-get-width image)))
        (image-height (car (gimp-image-get-height image)))
        )
        
        (gimp-image-undo-group-start image)
		(gimp-context-push)
	
		(gimp-image-insert-layer image work-layer 0 -1)  
		(gimp-image-insert-layer image work-layer-second 0 -1)    
  
		(if (= apply TRUE)
			(gimp-image-insert-layer image work-layer-brightness-contrast 0 -1)) 
			
		; Balans kolorów na podstawie temp. barwowej z kontrolą siły efektu
    ;   (gimp-message (string-append "Choice "))
		(gimp-drawable-color-balance work-layer TRANSFER-SHADOWS TRUE red-adjust 0 blue-adjust)
		(gimp-drawable-color-balance work-layer TRANSFER-MIDTONES TRUE red-adjust 0 blue-adjust)
		(gimp-drawable-color-balance work-layer TRANSFER-HIGHLIGHTS TRUE red-adjust 0 blue-adjust)
		(if (= apply TRUE)
			(gimp-drawable-brightness-contrast work-layer-brightness-contrast brightness-value contrast-value)  
			(gimp-layer-set-opacity work-layer-brightness-contrast 40))

		(apply-quick-tint image work-layer work-layer-second image-width image-height saturation lightness hc cc)
		(gimp-layer-set-opacity work-layer 40)

		(let* ((finish-layer (car (gimp-layer-copy work-layer-brightness-contrast TRUE)))
			(gimp-drawable-curves-spline finish-layer HISTOGRAM-VALUE 8 #(0 0 24 22 129 138 255 255))
			(gimp-layer-set-opacity finish-layer 40)

		))
		(let* ((merged-layer (car (gimp-image-merge-visible-layers image CLIP-TO-IMAGE))))
			;(gimp-image-merge-visible-layers image CLIP-TO-IMAGE)
			(gimp-item-set-visible merged-layer TRUE))


		(gimp-image-undo-group-end image)
		(gimp-displays-flush)
		(gimp-context-pop)
	)
)

(script-fu-register-filter "przem-ilford-expired-v32"
  _"Ilford film expired"
  _"Fotografia imitująca przeterminowany film Ilforda"
  "Przemysław R. Pietraszczyk"
  "Public Domain"
  "2025-10-05"
  "RGB*"
  SF-ONE-OR-MORE-DRAWABLE
  SF-ADJUSTMENT "Temperatura (K)" '(5550 1000 10000 100 1000 0 1)
  SF-ADJUSTMENT "Siła efektu" '(1.0 0.1 3.0 0.1 0.5 1 0)
  SF-TOGGLE _"Apply Brightness and Contrast" FALSE
  SF-ADJUSTMENT _"Brightness" '(1 -100 100 1 10 0 0)
  SF-ADJUSTMENT _"Contrast" '(5 -100 100 1 10 0 0)
  SF-ADJUSTMENT _"Saturation" '(5 -100 100 1 10 0 0)
  SF-ADJUSTMENT _"Lightness"  '(-35 -100 100 1 10 0 0)
  SF-COLOR      _"Highlight balance"  '(211 95 0)
  SF-COLOR      _"Chrome balance"     "black"
  
)

(script-fu-menu-register "przem-ilford-expired-v32"
                         "<Image>/Filters/PIETRASZCZYK/")

