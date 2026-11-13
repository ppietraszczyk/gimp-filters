; przem-kodachrome-v3x - Fotografia z okresu 20-sto lecia między wojennego
; 2025-09-25 - Przemysław R. Pietraszczyk
; licence: Public Domain
; ver. 2.250929-0
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

(define (create-highlights-curve adjustment)
  (let ((curve-data (make-vector 256 'byte)))
    (do ((i 0 (+ i 1)))
        ((= i 256))
      (if (> i 128)
          ; Światła - zastosuj regulację
          (aset curve-data i (min 255 (max 0 (+ i (* (- i 128) adjustment)))))
          ; Cienie - bez zmian
          (aset curve-data i i)
      )
    )
    curve-data
  )
)

(define (create-shadows-curve adjustment)
  (let ((curve-data (make-vector 256 'byte)))
    (do ((i 0 (+ i 1)))
        ((= i 256))
      (if (< i 128)
          ; Cienie - zastosuj regulację
          (aset curve-data i (min 255 (max 0 (+ i (* i adjustment)))))
          ; Światła - bez zmian
          (aset curve-data i i)
      )
    )
    curve-data
  )
)

;(define (przem-oldschool-photogrphy-v3 image drawable temperature strength tint-use
;	brightness contrast highlights shadows whites blacks saturation lightness hc cc)
(define (przem-kodachrome-v32 image drawable highlights shadows saturation lightness hc cc)
		
	; use v3 binding of return args from PDB
	;(script-fu-use-v3)

	(let* (
        ;(temperature-factor (/ (- temperature 6500) 1000))
        ;(red-adjust (* temperature-factor (- strength)))
        ;(blue-adjust (* temperature-factor strength))
        ;(brightness-value (/ brightness 100))
        ;(contrast-value (/ contrast 100))
        (adjust-value-highlights (/ highlights 100))
        (adjust-value-shadow (/ shadows 100))
        (width (car (gimp-image-get-width image)))
        (height (car (gimp-image-get-height image)))
        (layer (vector-ref drawable 0))
        (work-layer (car (gimp-layer-copy layer TRUE)))
        (work-layer-second (car (gimp-layer-copy layer TRUE)))
        ;(work-layer-levels (car (gimp-layer-copy layer TRUE)))
        ;(work-layer-brightness-contrast (car (gimp-layer-copy layer TRUE)))
        (curves-layer (gimp-layer-new image "Cross" width height RGB-IMAGE 100 LAYER-MODE-NORMAL))
        (blacks 1)
        (whites 0)
        )
    (gimp-image-undo-group-start image)
	(gimp-context-push)
	
	(gimp-image-insert-layer image work-layer 0 -1)    
	(gimp-image-insert-layer image work-layer-second 0 -1)    

	(apply-quick-tint image work-layer work-layer-second width height saturation lightness hc cc)
	
	; Regulacja przez poziomy
	; low imput - high input - gamma - output range
    (gimp-drawable-levels work-layer 0 
		blacks
        whites
        1.0 1.0 1.0 0 0)    
		

    (gimp-image-undo-group-end image)
    (gimp-displays-flush)
	(gimp-context-pop)
  )
)

(script-fu-register-filter "przem-kodachrome-v32"
  _"Kodachrome"
  _"Imitacja Kodachrome"
  "PRP"
  "Public Domain"
  "2025-09-25"
  "RGB*"
  SF-ONE-OR-MORE-DRAWABLE
  SF-ADJUSTMENT _"Highlights" '(-80 -100 100 1 10 0 0)
  SF-ADJUSTMENT _"Shadow" '(30 -100 100 1 10 0 0)
  SF-ADJUSTMENT _"Saturation" '(-80 -100 100 1 10 0 0)
  SF-ADJUSTMENT _"Lightness"  '(24 -100 100 1 10 0 0)
  SF-COLOR      _"Highlight balance"  '(211 95 0)
  SF-COLOR      _"Chrome balance"     "black"
)

(script-fu-menu-register "przem-kodachrome-v32"
                         "<Image>/Filters/PIETRASZCZYK/")
