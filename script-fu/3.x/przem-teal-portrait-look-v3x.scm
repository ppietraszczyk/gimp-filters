; przem-teal-portrait-look-v3x - Fotografia portretowa na sterydach
; 2026-04-06 - Przemysław R. Pietraszczyk
; licence: GPL v3
; ver. 2.260409-0
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

(define (saturation layer1)
	; drawable, HUE-Range ( Red, Yellow, Green, Cyan, Blue, Magenta, or All),
	; Hue Offset (-180 180), lightness (-100 100), saturation (-100 100) overlap (0 100)
 	; Lekko przygaszona saturacja globalnie
 	(gimp-drawable-hue-saturation layer1 HUE-RANGE-ALL
                                   0.0
                                   0.0
                                   -30
                                   0.0)
                                   
    ;Podbicie cyjanów / zieleni (turkus szalika, chłodniejsze tło)                              
	(gimp-drawable-hue-saturation layer1 HUE-RANGE-CYAN
                                   5
                                   2
                                   15
                                   0.0)
                                   
    (gimp-drawable-hue-saturation layer1 HUE-RANGE-GREEN
                                   3
                                   2
                                   10
                                   0.0)  
                                   
    ;Delikatne ocieplenie tonów skóry (czerwienie/żółcie)                               
    (gimp-drawable-hue-saturation layer1 HUE-RANGE-RED
                                   -3
                                   2
                                   8
                                   0.0) 
                                                                     
    (gimp-drawable-hue-saturation layer1 HUE-RANGE-YELLOW
                                   -2
                                   1
                                   6
                                   0.0))

(define (teal layer2) 
	(let* (
		;cyan-red -5, magenta-green 0, yellow-blue +5  
		(c1 '(-5 0 5))
		(c2 '(-3 0 3))
		(c3 '(5 0 -3))
		)                                                                                             
		(gimp-drawable-color-balance layer2 TRANSFER-SHADOWS 1
                                  (shadows (rval c1))
                                  (shadows (gval c1))
                                  (shadows (bval c1)))
		(gimp-drawable-color-balance layer2 TRANSFER-MIDTONES 1
                                  (midtones (rval c2))
                                  (midtones (gval c2))
                                  (midtones (bval c2)))
		(gimp-drawable-color-balance layer2 TRANSFER-HIGHLIGHTS 1
                                  (highlights (rval c3))
                                  (highlights (gval c3))
                                  (highlights (bval c3)))
	))
	
(define (sand layer2) 
	(let* (
		;cyan-red (+) 30
		;magenta-green (+) 10
		;yellow-blue (+) 35
		(c2 '(30 10 35))
		(c3 '(20 5 25))
		)    
		(gimp-drawable-color-balance layer2 TRANSFER-MIDTONES 1
                                  (midtones (rval c2))
                                  (midtones (gval c2))
                                  (midtones (bval c2)))
		(gimp-drawable-color-balance layer2 TRANSFER-HIGHLIGHTS 1
                                  (highlights (rval c3))
                                  (highlights (gval c3))
                                  (highlights (bval c3)))
	))
	
(define (przem-teal-portrait-look-v32 img drawable mode noise)

  (let* (
		(ref-layer (vector-ref drawable 0))
        (work-layer (car (gimp-layer-copy ref-layer TRUE)))
        (color-layer (car (gimp-layer-copy ref-layer TRUE)))
		(the-layer 0)
		(width (car (gimp-image-get-width img)))
        (height (car (gimp-image-get-height img)))
        (noise-layer (car (gimp-layer-new img "Noise" width height RGB-IMAGE 100 LAYER-MODE-NORMAL)))
        (fg-color '(203 182 138))
        ;(fg-color '(217 199 161))
        )
	(gimp-context-push)
	(gimp-image-undo-group-start img)

	(if (= noise TRUE) (begin 
		(gimp-image-insert-layer img noise-layer 0 -1)
		(gimp-context-set-foreground fg-color)
		(gimp-drawable-fill noise-layer FILL-TRANSPARENT)
		(gimp-layer-set-mode noise-layer LAYER-MODE-MULTIPLY)))

    ;(gimp-selection-all img)
	(set! the-layer (car (gimp-image-flatten img))) 
	(gimp-layer-set-opacity the-layer 100)

	(gimp-image-insert-layer img color-layer 0 -1)  
	(if (= mode 0) (begin 
		;; Delikatne przyciemnienie i zwiększenie kontrastu
		;; brightness: -5, contrast: 15
		(gimp-drawable-brightness-contrast the-layer -0.5 0.15)
		(teal color-layer)))
	(if (= mode 1) (begin 
		(gimp-drawable-brightness-contrast the-layer 0.10 0.5)
		(sand color-layer)))
	(gimp-layer-set-opacity color-layer 5)

	(gimp-image-insert-layer img work-layer 0 -1)  
	(saturation work-layer)
	(gimp-layer-set-opacity work-layer 40)
	
	;(let* ((merged-layer (car (gimp-image-merge-visible-layers img CLIP-TO-IMAGE))))
	;		(gimp-item-set-visible merged-layer TRUE))
    ;(gimp-selection-none img)

    (gimp-image-undo-group-end img)
	(gimp-displays-flush)
	(gimp-context-pop)
	))
	
(script-fu-register-filter "przem-teal-portrait-look-v32"
  _"_Teal portrait look"
  _"Nadaje zdjęciu miękki portretowy look: lekko przygaszone kolory, podbity turkus, ocieplona skóra, umiarkowany kontrast."
  "Przemysław R. Pietraszczyk"
  "GPL v3"
  "2026-04-06"
  "RGB* GRAY*"
  SF-ONE-OR-MORE-DRAWABLE
  SF-OPTION _"Colors Balance" '("TEAL" "SAND")
  SF-TOGGLE _"Sand Noise" FALSE
) 
 
(script-fu-menu-register "przem-teal-portrait-look-v32"
                         "<Image>/Filters/PIETRASZCZYK/")
