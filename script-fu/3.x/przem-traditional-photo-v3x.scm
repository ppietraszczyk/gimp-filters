; przem-traditional-photo-v3x - luźne nawiązanie do chemii tradycyjnej fototgrafii
; author: PRP
; licencja: Public Domain
; Gdańsk - 15-02-2025
; ver. 2.250217-0~beta for GIMP 3


(define (przem-traditional-photo-v32 image drawable crossing contrast-colors balance-color)
	(let (
       ;(the-image (car (gimp-image-duplicate image)) image)
       (the-layer 0)
       (image-width (car (gimp-image-get-width image)))
       (image-height (car (gimp-image-get-height image)))
       )
	(gimp-image-undo-group-start image)
	
	;(gimp-selection-all the-image)

	(set! the-layer (car (gimp-image-flatten image)))

	(if (= crossing TRUE)
		(cross image image-width image-height))
	;(if (= grain TRUE)
	;  (gimp-noise-hurl drawable 1 0.02))
	(if (= contrast-colors TRUE)
		; Zmniejsz kontrast i dodaj kolor
		(gimp-drawable-brightness-contrast the-layer -0.078125 -0.15625)
		(gimp-drawable-color-balance the-layer TRANSFER-SHADOWS TRUE balance-color 0 -30))
	
	;(gimp-selection-none the-tmage)
	
	
	(gimp-image-undo-group-end image)
	(gimp-displays-flush)
) )

(define (cross image width height)
	; crossing photo
	;(gimp-drawable-curves-spline layer1 HISTOGRAM-VALUE (spline-chrome-it))
	(let* ((layer (gimp-layer-new image "Cross" width height RGB-IMAGE 100 LAYER-MODE-NORMAL))

		(set! layer (gimp-image-merge-visible-layers image CLIP-TO-IMAGE))

		(gimp-drawable-curves-spline layer HISTOGRAM-VALUE 10 #(0 0 64 90 128 160 192 230 255 255))
		(gimp-drawable-curves-spline layer HISTOGRAM-RED 10 #(0 0 64 50 128 180 192 230 255 255))
		(gimp-drawable-curves-spline layer HISTOGRAM-GREEN 10 #(0 0 64 80 128 120 192 200 255 255))
		(gimp-drawable-curves-spline layer HISTOGRAM-BLUE 10 #(0 0 64 30 128 150 192 220 255 255))
		; lub
		;(define value #(0 0 64 90 128 160 192 230 255 255))
		;(gimp-drawable-curves-spline drawable HISTOGRAM-VALUE 10 value)
	))
)

(script-fu-register-filter "przem-traditional-photo-v32"
	_"_Convert photographs to neotraditional"
	_"Konwertuje na neotradycyjną fotografię"
	"Przemyslaw R. Pietraszczyk"
	"Public Domain"
	"2025-02-15"
	"RGB*"
	SF-ONE-OR-MORE-DRAWABLE
	SF-TOGGLE _"Crossing" FALSE
	SF-TOGGLE _"Contrast and Color corection" TRUE
	;SF-ADJUSTMENT _"Contrast" (list -0.15625 -1 1 0.00010 0.00100 0 0) ; źle działa dodanie jako parametru
	SF-ADJUSTMENT _"Balance Color" (list -30 -100 100 1 1 0 0)
) 

(script-fu-menu-register "przem-traditional-photo-v32"
                         "<Image>/Filters/PIETRASZCZYK/")
