; przem-lith-effect-v30 - imitacja odbitki litowej
; author: PRP
; licencja: Public Domain
; Gdańsk - 25-12-2025
; ver. 2.260108-0~beta

(define (przem-lith-effect-v3 img drawable shades)
  (let* (
    (source-layer (vector-ref (car (gimp-image-get-layers img)) 0 ))
	(type-layer (vector-ref drawable 0))
    (type (car (gimp-drawable-type type-layer)))
    (hot-lith (list 150 75 0))
    (light-lithium-brown (list 217 169 121))
	(warm-honey-brown (list 200 146 90))
	(golden-clay (list 185 125 74))
	(amber-brown (list 168 106 58))
	(lit 0)
	)
  (gimp-context-push)
  (gimp-image-undo-group-start img)

  ;; jeśli obraz jest szary to konwertuje go na RGB - tak na sztukę
  (if (> (car (gimp-drawable-type type-layer)) 1)
	(gimp-image-convert-rgb img))

   ; Konwersja obrazu do skali szarości
   (if (= type RGB-IMAGE)
      (gimp-drawable-desaturate type-layer DESATURATE-LIGHTNESS)
   )

  ;; 1. Mocny kontrast (levels)
	(gimp-drawable-merge-new-filter 
		type-layer
		"gegl:levels"
		0
		LAYER-MODE-REPLACE
		0.5         
		"in-low" 0.15
		"in-high" 0.85
	)

  ;; 2. Miękkie światła (soft-kight)
	(gimp-drawable-merge-new-filter 
		type-layer
		"gegl:soft-light"
		0
		LAYER-MODE-REPLACE
		0.5
	)

	(if (= shades 0)
       (begin
       (set! lit hot-lith)
     ))
	(if (= shades 1)
       (begin
       (set! lit light-lithium-brown)
     ))
     (if (= shades 2)
       (begin
       (set! lit warm-honey-brown)
     ))
     (if (= shades 3)
       (begin
       (set! lit golden-clay)
     ))
     (if (= shades 4)
       (begin
       (set! lit amber-brown)
     ))
	;; 3. Tonowanie (ciepły lith)
	(gimp-drawable-merge-new-filter 
		type-layer
		"gegl:color"
		0
		LAYER-MODE-REPLACE
		0.5         
		"value" lit
	)

  ;; 4. Ziarno (noise-rgb)
	(gimp-drawable-merge-new-filter
		type-layer
		"gegl:noise-rgb"
		0
		LAYER-MODE-NORMAL
		0.5
        "red" 0.2
        "green" 0.2
        "blue" 0.2
        "alpha" 0.0
        "independent" TRUE
   )

  (gimp-image-undo-group-end img)
  (gimp-displays-flush)
  (gimp-context-pop)
  )
)

(script-fu-register-filter "przem-lith-effect-v3"
 "_Lith effect"
 "_Odbitka Litowa"
 "P.R.P"
 "Public Domain"
 "25-12-2025"
 "RGB* GRAY*"
 SF-ONE-OR-MORE-DRAWABLE
 SF-OPTION     _"Shades of lithium" '("Hot Lith" "Light Lithium Brown" "Warm Honey Brown" "Golden Clay" "Amber Brown")

)

(script-fu-menu-register "przem-lith-effect-v3"
                         "<Image>/Filters/PIETRASZCZYK/")
