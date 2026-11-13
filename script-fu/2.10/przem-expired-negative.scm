; przem-expired-negative - luźne nawiązanie do przeterminowanego negatywu ORWO
; author: PRP
; licencja: Public Domain
; Gdańsk - 22-05-2025
; ver. 2.250610-5~beta

(define (is-portrait? image)
  (let* ((width (car (gimp-image-width image)))
         (height (car (gimp-image-height image)))
         (ratio (/ (min width height) (max width height))))
    
    ; Jeśli stosunek boków jest większy niż 0.7 i wysokość > szerokości
    ;(and (> ratio 0.7) (> height width))
    (> height width)
  )
)


(define (portrait image fog-layer-right fog-layer-left position-right width cut-left density color)

	; PORTRET
		; prawa strona
		; Dodaj nową warstwę dla mgły
		(gimp-image-insert-layer image fog-layer-right 0 -1)
    
		(gimp-context-set-background color)
		(gimp-context-set-foreground '(#x0 #x0 #x0)) ; mgła jest biała/szara

		; Wypełnij warstwę przezroczystością
		(gimp-drawable-fill fog-layer-right FILL-TRANSPARENT)

		; Utwórz gradient od przezroczystego do białego (mgła)
		(gimp-edit-blend fog-layer-right BLEND-FG-TRANSPARENT LAYER-MODE-NORMAL
                     GRADIENT-LINEAR 100 0 REPEAT-NONE FALSE
                     FALSE 0 0 TRUE
                     position-right 0 ; X1 = 3/4 szerokości
                     width 0)   ; X2 = pełna szerokość

		; Lekko rozmyj mgłę dla naturalnego efektu
		(plug-in-gauss 1 image fog-layer-right density density 1) ; dostosuj wartość rozmycia (8)

		; Ustaw maskę warstwy, aby stopniowo zanikała
		(let ((mask (car (gimp-layer-create-mask fog-layer-right ADD-MASK-WHITE))))
		(gimp-layer-add-mask fog-layer-right mask)
 
		(gimp-context-set-background color)
		(gimp-context-set-foreground '(#x0 #x0 #x0)) ; mgła jest biała/szara
		(gimp-edit-blend mask BLEND-FG-TRANSPARENT LAYER-MODE-NORMAL
                       GRADIENT-LINEAR 100 0 REPEAT-NONE FALSE
                       FALSE 0 0 TRUE
                       position-right 0
                       width 0))
     
          
         
        
		;lewa strona
		; Dodaj nową warstwę dla mgły
		(gimp-image-insert-layer image fog-layer-left 0 -1)
		(gimp-context-set-background color)
		(gimp-context-set-foreground '(#x0 #x0 #x0)) ; mgła jest biała/szara
    
		; Wypełnij warstwę przezroczystością
		(gimp-drawable-fill fog-layer-left FILL-TRANSPARENT)

		; Utwórz gradient od przezroczystego do białego (mgła)
		(gimp-edit-blend fog-layer-left BLEND-FG-TRANSPARENT LAYER-MODE-NORMAL
                     GRADIENT-LINEAR 100 0 REPEAT-NONE FALSE
                     FALSE 0 0 TRUE
					 cut-left 0 0 0)

		; Lekko rozmyj mgłę dla naturalnego efektu
		(plug-in-gauss 1 image fog-layer-left density density 1) ; dostosuj wartość rozmycia (8)

		; Ustaw maskę warstwy, aby stopniowo zanikała
		(let ((mask (car (gimp-layer-create-mask fog-layer-left ADD-MASK-WHITE))))
			(gimp-layer-add-mask fog-layer-left mask)
			(gimp-context-set-background color)
			(gimp-context-set-foreground '(#x0 #x0 #x0)) ; mgła jest biała/szara

			(gimp-edit-blend mask BLEND-FG-TRANSPARENT LAYER-MODE-NORMAL
                       GRADIENT-LINEAR 100 0 REPEAT-NONE FALSE
                       FALSE 0 0 TRUE
					   cut-left 0 0 0))
               
                      
)

(define (landscape image fog-layer-up fog-layer-bottom width height cut-up size density color)

	 ; KRAJOBRAZ              
        ; dól
		; Dodaj nową warstwę dla mgły
		(gimp-image-insert-layer image fog-layer-up 0 -1)
    
		(gimp-context-set-background color)
		(gimp-context-set-foreground '(#x0 #x0 #x0)) ; mgła jest biała/szara

		; Wypełnij warstwę przezroczystością
		(gimp-drawable-fill fog-layer-up FILL-TRANSPARENT)

		; Utwórz gradient od przezroczystego do białego (mgła)
		(gimp-edit-blend fog-layer-up BLEND-FG-TRANSPARENT LAYER-MODE-NORMAL
                     GRADIENT-LINEAR 100 0 REPEAT-NONE FALSE
                     FALSE 0 0 TRUE
                     0 (- height cut-up) 0 height) ; size 

		; Lekko rozmyj mgłę dla naturalnego efektu
		(plug-in-gauss 1 image fog-layer-up density density 1) ; dostosuj wartość rozmycia (8)

		; Ustaw maskę warstwy, aby stopniowo zanikała
		(let ((mask (car (gimp-layer-create-mask fog-layer-bottom ADD-MASK-WHITE))))
		(gimp-layer-add-mask fog-layer-up mask)
 
		(gimp-context-set-background color)
		(gimp-context-set-foreground '(#x0 #x0 #x0)) ; mgła jest biała/szara
		(gimp-edit-blend mask BLEND-FG-TRANSPARENT LAYER-MODE-NORMAL
                       GRADIENT-LINEAR 100 0 REPEAT-NONE FALSE
                       FALSE 0 0 TRUE
                       0 (- height cut-up) 0 height)) ; size
                       
                       
                  
        ; gora
		; Dodaj nową warstwę dla mgły
		(gimp-image-insert-layer image fog-layer-bottom 0 -1)
    
		(gimp-context-set-background color)
		(gimp-context-set-foreground '(#x0 #x0 #x0)) ; mgła jest biała/szara

		; Wypełnij warstwę przezroczystością
		(gimp-drawable-fill fog-layer-bottom FILL-TRANSPARENT)

		; Utwórz gradient od przezroczystego do białego (mgła)
		(gimp-edit-blend fog-layer-bottom BLEND-FG-TRANSPARENT LAYER-MODE-NORMAL
                     GRADIENT-LINEAR 100 0 REPEAT-NONE FALSE
                     FALSE 0 0 TRUE
                     0 cut-up
                     0 0)

		; Lekko rozmyj mgłę dla naturalnego efektu
		(plug-in-gauss 1 image fog-layer-bottom density density 1) ; dostosuj wartość rozmycia (8)

		; Ustaw maskę warstwy, aby stopniowo zanikała
		(let ((mask (car (gimp-layer-create-mask fog-layer-bottom ADD-MASK-WHITE))))
		(gimp-layer-add-mask fog-layer-bottom mask)
 
		(gimp-context-set-background color)
		(gimp-context-set-foreground '(#x0 #x0 #x0)) ; mgła jest biała/szara
		(gimp-edit-blend mask BLEND-FG-TRANSPARENT LAYER-MODE-NORMAL
                       GRADIENT-LINEAR 100 0 REPEAT-NONE FALSE
                       FALSE 0 0 TRUE
                       0 cut-up
                       0 0))
           
    
       
)                      


(define (przem-expired-negative image drawable size density color)
  (let* (
        (width (car (gimp-image-width image)))
        (height (car (gimp-image-height image)))
        (frame-size-left size)
        (frame-size-right (- 1 size))
        (frame-size-up size)
        (position-right (* width frame-size-right))
        (position-left (* width frame-size-left))
        
        (position-up (* height frame-size-up))
        (num-size-up (/ height position-up))
        (cut-up (- height (* position-up (- num-size-up 1)))) 
		(is-colorful (car (gimp-drawable-is-rgb drawable))) ; czy obraz jest kolorowy

        (num-size-left (/ width position-left))
        (cut-left (- width (* position-left (- num-size-left 1)))) ; 3
        (fog-layer-right (car (gimp-layer-new image width height GRAY-IMAGE "Fog-Right-Up" 100 LAYER-MODE-NORMAL)))
        (fog-layer-left (car (gimp-layer-new image  width height GRAY-IMAGE "Fog-Left-Bottom" 100 LAYER-MODE-NORMAL)))
        )
	
	(gimp-image-undo-group-start image)
	
	(if (= is-colorful TRUE)
		(gimp-image-convert-grayscale image)
	)
	
    (if (is-portrait? image)
		(begin
		;(gimp-message (string-append "width: " (number->string width)))
		;(gimp-message (string-append "position-right: " (number->string position-right)))
		;(gimp-message (string-append "cut-left: " (number->string cut-left)))
		(portrait image fog-layer-right fog-layer-left position-right width cut-left density color))
		(begin
		;(gimp-message (string-append "height: " (number->string height)))
		;(gimp-message (string-append "size: " (number->string (* size 1000))))
		;(gimp-message (string-append "cut-up: " (number->string cut-up)))
		(landscape image fog-layer-right fog-layer-left width height cut-up (* size 1000) density color))

    )
    (gimp-image-undo-group-end image) ;)       
              
	(gimp-displays-flush)   
  )
)

(script-fu-register "przem-expired-negative"
	_"Convert photographs to photograph from expired negative"
	_"Konwertuje na fotografie z przeterminowanego negatywu"
	"Przemyslaw R. Pietraszczyk"
	"Public Domain"
	"2025-05-22"
	"RGB* GRAY*"
	SF-IMAGE "Image" 0
	SF-DRAWABLE "Drawable" 0
	SF-ADJUSTMENT "Size" '(0.20 0.05 0.50 0.01 0.01 2 0)
	SF-ADJUSTMENT "Density" '(8 8 128 8 8 1 0)
	SF-COLOR "Color" '(#x74 #x73 #x73)     ;color variable
) 

(script-fu-menu-register "przem-expired-negative"
                         "<Image>/Filters/PIETRASZCZYK/")
