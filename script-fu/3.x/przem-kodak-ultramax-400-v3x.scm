; przem-kodak-ultramax-400 - script-fu imitujący Kodak Ultramax 400 - Na podstawie charakterystyki: lekkie ocieplenie, umiarkowany kontrast, delikatna saturacja
; © Przemysław R. Pietraszczyk
; 2026-11-12
; ver. 2.261112-0
;
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

(define (warm layer warmth)
	(let* (
		(c2 '(0.04 0 -0.04))
		)

		(gimp-drawable-color-balance layer TRANSFER-MIDTONES 1
                                  (midtones (rval c2))
                                  (midtones (gval c2))
                                  (midtones (bval c2)))

	))


(define (przem-kodak-ultramax-400 image drawable)
  (let* (
         ; Definicja warstw i parametrów
         (warmth 0.04)      ; Delikatne ocieplenie (0.0 - 1.0)
         (contrast-val 0.02) ; Lekki kontrast
         (saturation-val 0.15) ; Umiarkowana saturacja
         (layer (vector-ref drawable 0))

        )

    ; Rozpocznij grupę operacji (Undo)
    (gimp-image-undo-group-start image)

    ; 1. KOREKCJA KOLORU (Ocieplenie)
    ; Zwiększamy lekko kanał czerwony i zmniejszamy niebieski, aby uzyskać ciepły ton
    ;                    warmth             ; Wartość dla Cyan/Red (dodajemy czerwieni)
    ;                    0                  ; Magenta/Green (bez zmian)
    ;                    (- warmth)         ; Yellow/Blue (odejmujemy niebieskiego)
    (warm layer warmth)
    ; 2. KONTRAST I JASNOŚĆ
    ; Delikatne podbicie kontrastu dla uzyskania "filmowego" wyglądu
    (gimp-drawable-brightness-contrast layer 0 contrast-val)

    ; 3. SATURACJA
    ; Ultramax ma nieco żywsze kolory niż standardowe filmy, ale bez przesady
    ;                     HUE_RANGE_ALL; Wszystkie kolory
    ;                     0            ; Przesunięcie barwy
    ;                     0            ; Jasność
    ;                     (* saturation-val 100) ; Saturacja (przeliczenie na skalę)
    (gimp-drawable-hue-saturation layer HUE-RANGE-ALL 0 0 (* saturation-val 100) 30)





    ; 4. DELIKATNE ZMIEKZCZENIE (opcjonalne, imitujące "halację")
    ; Bardzo subtelne rozmycie, aby złagodzić ostrość typową dla filmu
    ;(plug-in-gauss RUN-NONINTERACTIVE image drawable 0.5 0.5 0)
    (gimp-drawable-merge-new-filter layer "gegl:gaussian-blur" 0 LAYER-MODE-REPLACE 1.0 "std-dev-x" 0.5 "std-dev-y" 0.5 "filter" "auto")

    ; Zakończ grupę operacji
    (gimp-image-undo-group-end image)
    (gimp-displays-flush)
  )
)

; Rejestracja skryptu w menu GIMP-a
(script-fu-register-filter
  "przem-kodak-ultramax-400"
  "Kodak Ultramax 400 Emulation"
  "Imituje wygląd filmu Kodak Ultramax 400 (ocieplenie, kontrast, saturacja)."
  "Prezmysław R. Pietraszczyk"
  "MIT"
  "2026-11-12"
  "RGB*"
  SF-ONE-OR-MORE-DRAWABLE
)

; Umieszczenie skryptu w menu
(script-fu-menu-register "przem-kodak-ultramax-400" "<Image>/Filters/PIETRASZCZYK/")
