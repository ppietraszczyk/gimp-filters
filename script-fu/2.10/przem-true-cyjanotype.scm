; przem-true-cyjantype - imituje efekt prawdziwej cyjanotypii
; author: PRP
; licencja: Public Domain
; Gdańsk - 21-09-2025
; ver. 2.250922-1

(define (przem-true-cyjantype image drawable r g b normalize value-blue invert replace)
	(let* ((gradient-layer (car (gimp-layer-new image (car (gimp-image-width image)) (car (gimp-image-height image)) RGBA-IMAGE "Prussian Blue" 50 NORMAL-MODE)))
        (is-nocolorful (car (gimp-drawable-is-gray drawable))))

		(gimp-image-undo-group-start image)
		(gimp-context-push)
  
		; jeśli obraz jest szary to konwertuje go na RGB - tak na sztukę
		(if (= is-nocolorful TRUE)
			(gimp-image-convert-rgb image))
  
		(gimp-image-insert-layer image gradient-layer 0 -1)
				
		 (let* (
			; oczekujemy procentów (np. 40, 40, 20)
			(sum (+ r g b))
			(r1 (if (and normalize (> sum 0)) (/ r sum) (/ r 100.0)))
			(g1 (if (and normalize (> sum 0)) (/ g sum) (/ g 100.0)))
			(b1 (if (and normalize (> sum 0)) (/ b sum) (/ b 100.0)))
			)
			(plug-in-colors-channel-mixer
				RUN-NONINTERACTIVE
				image drawable
				TRUE               
				r1 g1 b1
				0.0 0.0 0.0
				0.0 0.0 0.0
			)
		)
		(gimp-curves-spline
			drawable
			0
			6
			#(0   0
			32  40
			128 140
			220 230
			255 255)
		)
		(gimp-layer-set-mode gradient-layer LAYER-MODE-OVERLAY) ; Tryb mieszania: Overlay
		; hue-range: 0 = Master, 1 = Reds, 2 = Yellows, 3 = Greens, 4 = Cyans, 5 = Blues, 6 = Magentas
		; hue-offset: -180..180 (stopnie), lightness: -100..100, saturation: -100..100
		;(gimp-hue-saturation gradient-layer 0 160 0 30) ; Niebieski odcień
		;; --- 2. Koloryzacja ---
		;; hue: 0–360 (odcień), sat: -100..100, light: -100..100
		;(gimp-colorize drawable 160 0 30)
		(gimp-context-set-foreground '(0 51 102)) ; Kolor błękitu pruskiego
		(gimp-context-set-background '(0 0 0))
		;(gimp-layer-set-mode gradient-layer OVERLAY-MODE)
		(gimp-edit-blend gradient-layer FG-BG-RGB-MODE NORMAL-MODE GRADIENT-LINEAR 100 0 REPEAT-NONE FALSE FALSE 0 0 TRUE 0 0 0 0)
		(gimp-layer-set-opacity gradient-layer value-blue)

		(if (= invert TRUE)
		(gimp-invert drawable))
		
		(if (= replace TRUE)
			; Wybierz tylko czarne piksele
			(gimp-image-select-color image CHANNEL-OP-REPLACE drawable '(0 0 0))
  
			; Wypełnij wybrane obszary kolorem granatowym
			(gimp-context-set-foreground '(0 0 128)) ; RGB dla granatowego
			(gimp-edit-bucket-fill drawable BUCKET-FILL-FG LAYER-MODE-NORMAL 100 0 FALSE 0 0)
			  ; Odznacz selekcję
			(gimp-selection-none image))
  
		(gimp-image-undo-group-end image)
		(gimp-displays-flush)
		(gimp-context-pop)
  )
)

(script-fu-register "przem-true-cyjantype"
  _"Apply true cyjanotype effect"
  _"Pseudo-prawdziwa próba imitacji cyjanotypii"
  "PRP"
  "Public Domain"
  "2025-09-21"
  "RGB*, GRAY*"
  SF-IMAGE "Image" 0
  SF-DRAWABLE "Drawable" 0
  SF-ADJUSTMENT "Participation R (%)" '(40  -200 200 1 10 0 1)
  SF-ADJUSTMENT "Participation G (%)" '(40  -200 200 1 10 0 1)
  SF-ADJUSTMENT "Participation B (%)" '(20  -200 200 1 10 0 1)
  SF-TOGGLE "Normalize to 100%" TRUE
  SF-ADJUSTMENT "Blue intensity" '(50 0 100 1 10 0 0)
  SF-TOGGLE "Invert colors" FALSE
  SF-TOGGLE "Replace black" FALSE


)

(script-fu-menu-register "przem-true-cyjantype"
                         "<Image>/Filters/PIETRASZCZYK/")
