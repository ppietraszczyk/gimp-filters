; apply-waves-effect-v3x - Script-fu dodający efekt falowania
; author: PRP
; licencja: Public Domain
; Gdańsk - 25-02-2025
; ver. 1.260725-0

;(define (przem-apply-waves-effect-v3x image drawable amplitude frequency)
(define (przem-apply-waves-effect-v3x image drawable)

	(let* (
         (width (car (gimp-image-get-width image)))
         (height (car (gimp-image-get-height image)))
         (new-image (car (gimp-image-duplicate image)))
		 (new-drawable 0)
		 (brush (car (gimp-brush-new "Pixel Brush")))
		 (resize-y 0)
		 (resize-x 0)
		 (y 0)
		 (x 0)
		 (amplitude 5)
		 (frequency 0.1)
		 (phase 0)
		 (counter 0))
	(gimp-selection-none new-image)

    (gimp-context-push)
    (gimp-context-set-defaults)

	(gimp-brush-set-shape brush BRUSH-GENERATED-CIRCLE)
	(gimp-context-set-paint-method "gimp-paintbrush")
    (gimp-context-set-paint-mode LAYER-MODE-NORMAL)
	(gimp-brush-set-radius brush (/ 1 2))
	(gimp-context-set-brush-size 1)
	;(gimp-context-set-brush-angle 0.0)
	(gimp-context-set-brush-hardness 1.0)
	(gimp-context-set-opacity 100.0)
    (gimp-context-set-brush brush)


	; symulacja
	(while (< y  height)
      (while (< x width)
		  (set! resize-x (+ x (* amplitude (sin (+ (* frequency x) phase)))))
          (set! resize-y (+ y (* amplitude (cos (+ (* frequency y) phase)))))
		  (set! x (+ x 1))
		  (set! counter (+ counter 1))
	   )
	   (set! x 0)
	   (set! y (+ y 1)) 
     )
     
     
    (gimp-image-scale new-image resize-x resize-y)
	(set! new-drawable (vector-ref (car (gimp-image-get-selected-layers new-image)) 0))

	(set! x 0)
	(set! y 0)
	
    ; Przejdź przez każdy piksel obrazu
    (while (< y  height)
      (while (< x width)
        (let* (
          (new-x (+ x (* amplitude (sin (+ (* frequency x) phase)))))
          (new-y (+ y (* amplitude (cos (+ (* frequency y) phase)))))
          (color (car (gimp-image-pick-color image drawable x y FALSE FALSE 1))) 
		  (how-many-points 1)
		  (point (vector new-x new-y))
		  )
		  (gimp-context-set-foreground color)
		  ;(gimp-brushes-refresh)

          (gimp-pencil new-drawable point how-many-points) ; Narysuj punkt
		) 
		(set! x (+ x 1))
	  )
	    (set! x 0)
		(set! y (+ y 1)) 
	)

    (gimp-context-pop)
    (gimp-display-new new-image)

	(gimp-selection-none new-image)

	(gimp-displays-flush)
	
) ) 
 
(define displayln (lambda (obj) (display obj) (display "\n")))


( script-fu-register-filter "przem-apply-waves-effect-v3x"
	"Apply a waves effect to the image."
	"Dodaje efekt fali do zdjęcia"
	"Przenmysław R. Pietraszczyk"
	"Public Domain"
	"2025-02-25"
	"RGB*, GRAY*"
	SF-ONE-OR-MORE-DRAWABLE
)

(script-fu-menu-register "przem-apply-waves-effect-v3x" "<Image>/Filters/PIETRASZCZYK")
