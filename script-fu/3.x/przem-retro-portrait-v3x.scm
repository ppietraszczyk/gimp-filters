; przem-retro-portrait-v3x - Stare fotografie
; author: PRP
; licencja: Public Domain
; Gdańsk - 01-11-2026
; ver. 2.261102-3
; Ten script-fu wykorzystuje funkcje ze skryptu 'chrome-it.scm'
; Autorstwa Spencer Kimball

(define (midtones val)
	(/ val 2.55))

(define (rval col)
	(car col))

(define (gval col)
    (cadr col))

(define (bval col)
    (caddr col))

(define (color-balance layer)
  (let* (
    (c1 '(10 0 -10))
    )
    (gimp-drawable-color-balance layer TRANSFER-MIDTONES 1
      (midtones (rval c1))
      (midtones (gval c1))
      (midtones (bval c1)))))


(define ( przem-retro-portrait-v3x image drawable brightness contrast saturation palette black hue dithering)

  (let* (
        (layer (vector-ref drawable 0))
        (type (car (gimp-drawable-type-with-alpha layer)))
        (mask (car (gimp-channel-new image "Engraving Mask" (car (gimp-image-get-width image)) (car (gimp-image-get-height image)) black '(0.4 0.4 0.2 0.0 0.0 0.0 0.0 0.0 0.0))))
        (gradient-layer 0)
        (blur-layer 0)
        (color-layer 0)
        )
    (gimp-context-push)
    (gimp-image-undo-group-start image)
    ;; Desaturacja
    (if (= type RGBA-IMAGE)
    (gimp-drawable-desaturate layer DESATURATE-LIGHTNESS))

    (gimp-layer-set-mode layer 0) ; NORMAL mode

    ;; jeśli obraz jest szary to konwertuje go na RGB - tak na sztukę
		(if (> (car (gimp-drawable-type layer)) 1)
        (gimp-image-convert-rgb image))

    ;; Dodaj ciepłe kolory przez saturację i odcień
    ;(gimp-drawable-brightness-contrast layer (/ brightness 100) 0)
    ; Odcień 30 = ciepłe kolory
    ;(gimp-drawable-hue-saturation layer HUE-RANGE-ALL 0 0 (/ saturation 100) 30)

    (let* (
        (color-response (gimp-palette-get-entry-color palette 0))
        (color (car color-response))
        )
        (gimp-context-set-foreground color)
    )

    ; dla obrazów przestrzeni RGB i Gray, utworzenie nowej warstwy, dopiero po kowersji na rgb
    (set! gradient-layer (car (gimp-layer-new image "Gradient" (car (gimp-image-get-width image)) (car (gimp-image-get-height image)) RGBA-IMAGE  100 LAYER-MODE-NORMAL)))

    (gimp-image-insert-channel image mask -1 0)
    (gimp-image-insert-layer image gradient-layer 0 -1)
    (gimp-drawable-edit-gradient-fill gradient-layer
				      GRADIENT-LINEAR 0
				      FALSE 1 0
				      TRUE
				      0 0 0 0)
    (gimp-layer-set-opacity gradient-layer 100)

    ;; profil koloru sRGB - sgray.icc
    ;(gimp-image-set-color-profile-from-file image "/usr/share/ghostscript/10.08.0/iccprofiles/srgb.icc")
    ; przywrócenie domyslnego
    ;(gimp-image-set-color-profile image 0)


    ; Argumenty funkcji gimp-image-convert-indexed:
    ; 1. Obraz (img)
    ; 2. Typ ditheringu kolorów: 0 = Brak, 1 = Floyd-Steinberg (zwykły), 2 = Floyd-Steinberg (zredukowany blef), 3 = Pozycja
    ; 3. Typ palety: 0 = Wygeneruj optymalną paletę, 1 = Użyj palety WWW, 2 = Użyj niestandardowej palety, 3 = Użyj palety czarno-białej
    ; 4. Liczba kolorów: 16
    ; 5. Dithering alfy (przezroczystości): TRUE lub FALSE
    ; 6. Usuwanie nieużywanych kolorów z finalnej palety: TRUE lub FALSE
    ; 7. Nazwa niestandardowej palety (używane tylko gdy typ palety to 2, w innych przypadkach dowolny string np. "")

    (gimp-image-convert-indexed image dithering 0 hue FALSE FALSE "")
    (gimp-image-convert-rgb image)

    (gimp-layer-set-mode layer 0) ; NORMAL mode
    (set! blur-layer  (car (gimp-layer-copy layer TRUE)))
    (set! color-layer  (car (gimp-layer-copy layer TRUE)))

    (gimp-image-insert-layer image blur-layer 0 -1)
    (gimp-image-insert-layer image color-layer 0 -1)

    (gimp-drawable-merge-new-filter blur-layer "gegl:gaussian-blur"  RUN-NONINTERACTIVE LAYER-MODE-REPLACE 0.90 "std-dev-x" 10.0 "std-dev-y" 10.0  "filter" "auto")
    (gimp-layer-set-opacity blur-layer 70)
    (gimp-layer-set-mode blur-layer LAYER-MODE-NORMAL) ; NORMAL mode
    (gimp-item-set-visible blur-layer TRUE)

    ;(gimp-image-merge-down image blur-layer EXPAND-AS-NECESSARY)

    ;# W GIMP 3.0 używamy operacji GEGL przez PDB dla uzyskania ziarna
    (gimp-drawable-merge-new-filter layer "gegl:noise-rgb" RUN-NONINTERACTIVE LAYER-MODE-REPLACE 0.80 "red" 0.05 "green" 0.05 "blue" 0.05  "alpha" 0.0 "seed" 0)

    (gimp-drawable-merge-new-filter layer "gimp:brightness-contrast" 0 LAYER-MODE-REPLACE 0.80
                 "brightness" (/ brightness 100)
                 "contrast"   (/ contrast 100))
    (gimp-layer-set-opacity layer 55)
    (gimp-item-set-visible layer TRUE)

    ;# Delikatne przesunięcie kolorów w stronę żółci/czerwieni w cieniach i półtonach
    (color-balance color-layer)
    (gimp-layer-set-mode color-layer LAYER-MODE-NORMAL) ; NORMAL mode
    (gimp-layer-set-opacity color-layer 40)

    (gimp-image-undo-group-end image)

    (gimp-displays-flush)
    (gimp-context-pop)
    ))

(script-fu-register-filter
  "przem-retro-portrait-v3x"
  _"The Atmosphere of Analog Portrait"
  _"Stworzenie klimatu czarno-białego portretu analogowego z ziarnem i miękkim światłem"
  "P.R.P"
  "MIT"
  "01-11-2026"
  "RGB* GRAY*"
  SF-ONE-OR-MORE-DRAWABLE
  SF-ADJUSTMENT "Brightness"  '(0 -100 100 1 10 0 0)
  SF-ADJUSTMENT "Contrast" '(0 -100 100 1 10 0 0)
  SF-ADJUSTMENT "Saturation" '(0 -100 100 1 10 0 0)
  SF-PALETTE  _"Palette"  "Default"
  SF-ADJUSTMENT "Black" '(5 0 100 1 10 0 0)
  SF-ADJUSTMENT "Hue" '(2 1 16 1 10 0 0)
  SF-OPTION "Dithering" '("None" "Floyd-Steinberg (normal)" "Floyd-Steinberg (reduced bluff)" "Position")

)
(script-fu-menu-register "przem-retro-portrait-v3x"
"<Image>/Filters/PIETRASZCZYK/")
