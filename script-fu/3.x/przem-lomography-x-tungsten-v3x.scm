; Filtr symulujący Lomography X Tungsten 64 (Cross-Processed)
; Przemysław R. Pietraszczyk
; 07-11-2026
; ver. 2.261107-0
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

(define (balance layer2)
	(let* (
        ; Cienie: dodanie blueego i magenty
        (c1 '(20 0 25)); Cyan-Red (ujemny = więcej cyjanu/blueego) ; Yellow-Blue (dodatni = więcej niebieskiego)
        (c2 '(10 0 12)) ; Midtony: delikatny fiolet
        (c3 '(5 0 8)) ; więcej czerwieni, mniej niebieskiego w światłach
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


(define (przem-lomography-x-tungsten-v3x image drawable brightness contrast saturation)
  (let* (
        (layer (vector-ref drawable 0))
        )
    (gimp-image-undo-group-start image)
    ; 1. Delikatne rozjaśnienie i podniesienie kontrastu (symulacja slajdu)
    (gimp-drawable-brightness-contrast layer (/ 1 brightness) (/ 1 contrast))

    ; 2. Kluczowy Balans Kolorów (Color Balance)
    ; Symulacja przesunięcia w stronę fioletu/niebieskiego (Tungsten w świetle dziennym)
    ; Cienie: dodanie niebieskiego i magenty
    (balance layer)

    ; 3. Zwiększenie nasycenia (X Tungsten ma żywe kolory)
    (gimp-drawable-hue-saturation layer HUE-RANGE-ALL 0 saturation 0)

    ; Zakończenie grupy cofania
    (gimp-image-undo-group-end image)
    (gimp-displays-flush)
  )
)

; Rejestracja skryptu w GIMP-ie
(script-fu-register-filter
  "przem-lomography-x-tungsten-v3x"
  "Lomography X Tungsten 64 Simulation"
  "Symuluje wygląd filmu Lomography X Tungsten 64"
  "Przemysław R. Pietraszczyk"
  "MIT"
  "2026-11-07"
  "RGB*"
  SF-ONE-OR-MORE-DRAWABLE
  SF-ADJUSTMENT "Brightness"      '(20 1 50 1 10 0 1)
  SF-ADJUSTMENT "Contrast"        '(10 1 50 1 10 0 1)
  SF-ADJUSTMENT "Saturation"      '(0 -25 25 1 10 0 1)
)

; Umieszczenie w menu
(script-fu-menu-register "przem-lomography-x-tungsten-v3x" "<Image>/Filters/PIETRASZCZYK/")
