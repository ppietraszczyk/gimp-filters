; przem-traditional-photo - luźne nawiązanie do chemii tradycyjnej fototgrafii
; author: PRP
; licencja: Public Domain
; Gdańsk - 15-02-2025
; ver. 2.250217-0~beta

(define (cross drawable)
	; crossing photo
	(gimp-curves-spline drawable HISTOGRAM-VALUE 10 #(0 0 64 90 128 160 192 230 255 255))
	(gimp-curves-spline drawable HISTOGRAM-RED 10 #(0 0 64 50 128 180 192 230 255 255))
	(gimp-curves-spline drawable HISTOGRAM-GREEN 10 #(0 0 64 80 128 120 192 200 255 255))
	(gimp-curves-spline drawable HISTOGRAM-BLUE 10 #(0 0 64 30 128 150 192 220 255 255))
	; lub
	;(define value #(0 0 64 90 128 160 192 230 255 255))
	;(gimp-drawable-curves-spline drawable HISTOGRAM-VALUE 10 value)
)

(define (przem-traditional-photo image drawable crossing contrast-colors contrast balance-color)

	(gimp-image-undo-group-start image)
	
	(if (= crossing TRUE)
		(cross drawable))
	;(if (= grain TRUE)
	;  (gimp-noise-hurl drawable 1 0.02))
	(if (= contrast-colors TRUE)
		; Zmniejsz kontrast i dodaj kolor
		(gimp-brightness-contrast drawable 10 contrast)
		(gimp-color-balance drawable FALSE 0 balance-color 0 10))
	
	(gimp-image-undo-group-end image)
	(gimp-displays-flush)
)

(script-fu-register "przem-traditional-photo"
	_"Convert photographs to neotraditional"
	_"Konwertuje na neotradycyjną fotografię"
	"Przemyslaw R. Pietraszczyk"
	"Public Domain"
	"2025-02-15"
	"RGB*"
	SF-IMAGE "Image" 0
	SF-DRAWABLE "Drawable" 0
	SF-TOGGLE "Crossing" FALSE
	;SF-TOGGLE "Grain" FALSE
	SF-TOGGLE "Contrast and Color corection" TRUE
	SF-ADJUSTMENT "Contrast" '(-30 -100 100 1 1 0 0)
	SF-ADJUSTMENT "Balance Color" '(-5 -100 100 1 1 0 0)
) 

(script-fu-menu-register "przem-traditional-photo"
                         "<Image>/Filters/PIETRASZCZYK/")
