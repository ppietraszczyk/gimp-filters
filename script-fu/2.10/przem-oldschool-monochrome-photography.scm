(define (apply-quick-tint drawable tint-type)
  (cond
   ((= tint-type 0)  ; Ciepły (sepia)
    (gimp-drawable-color-balance drawable 0 TRUE 0.15 0.0 -0.1))
   
   ((= tint-type 1)  ; Chłodny (niebieski)
    (gimp-drawable-color-balance drawable 0 TRUE -0.1 0.0 0.15))
   
   ((= tint-type 2)  ; Zielony (retro)
    (gimp-drawable-color-balance drawable 0 TRUE 0.0 0.15 -0.05))
   
   ((= tint-type 3)  ; Magenta (dramatyczny)
    (gimp-drawable-color-balance drawable 0 TRUE 0.1 -0.15 0.05))
  )
)

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

(define (przem-oldschool-monochrome-photogrphy image drawable temperature strength tint-use
	tint-type contrast highlights shadows whites blacks)

	(let* (
        (temperature-factor (/ (- temperature 6500) 1000))
        (red-adjust (* temperature-factor (- strength)))
        (blue-adjust (* temperature-factor strength))
        (contrast-value (/ contrast 100))
        (adjust-value (/ highlights 100))
        (adjust-value-shadow (/ shadows 100))
        (whites-value (/ whites 100))
        (blacks-value (/ blacks 100))
        )
    (gimp-image-undo-group-start image)
	(gimp-context-push)
	
    ; Balans kolorów z kontrolą siły efektu
    (gimp-drawable-color-balance drawable 0 TRUE red-adjust 0 blue-adjust)
    
    (if (= tint-use TRUE)
    (apply-quick-tint drawable tint-type))
    
    (gimp-drawable-brightness-contrast drawable 0 contrast-value)

	; Regulacja świateł przez krzywe
    (gimp-drawable-curves-explicit drawable 0 256 (create-highlights-curve adjust-value))

	; Regulacja cieni przez krzywe
    (gimp-drawable-curves-explicit drawable 0 256 (create-shadows-curve adjust-value-shadow))

	; Regulacja przez poziomy
	; low imput - high input - gamma - output range
    (gimp-drawable-levels drawable 0 
		blacks
        whites
        1.0 0 255 0 0)             


    (gimp-image-undo-group-end image)
    (gimp-displays-flush)
	(gimp-context-pop)
  )
)

(script-fu-register "przem-oldschool-monochrome-photogrphy"
  _"Oldchool monochrome photography"
  _"Fotografia ze starej szkoły"
  "PRP"
  "Public Domain"
  "2025-09-25"
  "RGB*"
  SF-IMAGE "Image" 0
  SF-DRAWABLE "Drawable" 0
  SF-ADJUSTMENT "Temperatura (K)" '(5150 1000 10000 100 1000 0 1)
  SF-ADJUSTMENT "Siła efektu" '(1.0 0.1 3.0 0.1 0.5 1 0)
  SF-TOGGLE "Tint use" FALSE
  SF-OPTION "Typ Tint" '("Ciepły" "Chłodny" "Zielony" "Magenta")
  SF-ADJUSTMENT "Kontrast" '(-30 -100 100 1 10 0 0)
  SF-ADJUSTMENT "Światła" '(-80 -100 100 1 10 0 0)
  SF-ADJUSTMENT "Shadow" '(30 -100 100 1 10 0 0)
  SF-ADJUSTMENT "Whites" '(0.1 -1.0 1.0 0.1 0.01 0.1 3)
  SF-ADJUSTMENT "Blacks" ''(-0.35 -1.0 1.0 0.1 0.01 0.1 3)
)

(script-fu-menu-register "przem-oldschool-monochrome-photogrphy"
                         "<Image>/Filters/PIETRASZCZYK/")
