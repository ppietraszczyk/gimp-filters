; apply-waves-effect - Script-fu dodający efekt falowania
; author: PRP
; licencja: Public Domain
; Gdańsk - 25-02-2025
; ver. 1.250225-2

(define (przem-apply-waves-effect image drawable amplitude frequency phase)
	(let* (
         (width (car (gimp-image-width image)))
         (height (car (gimp-image-height image)))
         (new-image (car (gimp-image-duplicate image)))
         (new-drawable (car (gimp-image-get-active-drawable new-image)))
		 (resize-y 0)
		 (resize-x 0)
		 (y 0)
		 (x 0)
		 (counter 0))
	(gimp-selection-none new-image)

    (gimp-context-push)
    (gimp-context-set-defaults)

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
    (set! new-drawable (car (gimp-image-get-active-drawable new-image)))

	(set! x 0)
	(set! y 0)
	
    ; Przejdź przez każdy piksel obrazu
    (while (< y  height)
      (while (< x width)
        (let* (
          (new-x (+ x (* amplitude (sin (+ (* frequency x) phase)))))
          (new-y (+ y (* amplitude (cos (+ (* frequency y) phase)))))
          (color (car (gimp-image-pick-color image drawable x y FALSE FALSE 1))) 
		  )
		  (gimp-context-set-foreground color)
		  ;(gimp-brushes-refresh)
		  (gimp-context-set-brush "Circle (01)")
		  (gimp-context-set-brush-size 1)
		  (gimp-context-set-brush-angle 0.0)
		  (gimp-context-set-brush-hardness 1.0)
		  (gimp-context-set-opacity 100.0)
          (gimp-pencil new-drawable 2 (vector new-x new-y)) ; Narysuj punkt
		  
		  (gimp-message "Wait...")
		  ;(display "pixel: ")        (displayln pixel)
		) 
		(set! x (+ x 1))
	  )
	    (set! x 0)
		(set! y (+ y 1)) 
	)
    ;(gimp-image-set-resolution image newdpi newdpi)


    (gimp-context-pop)
    (gimp-display-new new-image)

	(gimp-selection-none new-image)

	(gimp-displays-flush)
	
) ) 
 
(define displayln (lambda (obj) (display obj) (display "\n")))


(script-fu-register "przem-apply-waves-effect"
  _"Apply a waves effect to the image."
  _"Dodaje efekt fali do zdjęcia"
  "Przenmysław R. Pietraszczyk"
  "Public Domain"
  "2025-02-25"
  "RGB*, GRAY*"
  SF-IMAGE "Image" 0
  SF-DRAWABLE "Drawable" 0
  SF-VALUE "Amplitude" "10"
  SF-VALUE "Frequency" "0.1"
  SF-VALUE "Phase" "0"
)

(script-fu-menu-register "przem-apply-waves-effect" "<Image>/Filters/PIETRASZCZYK")
