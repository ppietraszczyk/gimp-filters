; przem-warm-grayscale-v3x - imituje efekt ciepłej czernii
; author: PRP
; licencja: Public Domain
; Gdańsk - 23-10-2026
; ver. 2.261024-0

(define (przem-warm-grayscale-v3x image drawable brightness saturation palette black)

  (let* (
        (layer (vector-ref drawable 0))
        (type (car (gimp-drawable-type-with-alpha layer)))
        (mask (car (gimp-channel-new image "Engraving Mask" (car (gimp-image-get-width image)) (car (gimp-image-get-height image)) black '(0.4 0.4 0.2 0.0 0.0 0.0 0.0 0.0 0.0))))
        (gradient-layer 0)
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
    (gimp-drawable-brightness-contrast layer (/ brightness 100) 0)
    ; Odcień 30 = ciepłe kolory
    (gimp-drawable-hue-saturation layer HUE-RANGE-ALL 0 0 (/ saturation 100) 30)

    ; dla obrazów przestrzeni RGB i Gray, utworzenie nowej warstwy, dopiero po kowersji na rgb
    (set! gradient-layer (car (gimp-layer-new image "Gradient" (car (gimp-image-get-width image)) (car (gimp-image-get-height image)) RGBA-IMAGE  100 LAYER-MODE-NORMAL)))

    (let* (

        (color-response (gimp-palette-get-entry-color palette 0))
        (color (car color-response))
        )
        (gimp-context-set-foreground color)
    )
    (gimp-image-insert-channel image mask -1 0)
    (gimp-image-insert-layer image gradient-layer 0 -1)
    (gimp-drawable-edit-gradient-fill gradient-layer
				      GRADIENT-LINEAR 0
				      FALSE 1 0
				      TRUE
				      0 0 0 0)
    (gimp-layer-set-opacity gradient-layer 5)

    ;; profil koloru sRGB - sgray.icc
    ;(gimp-image-set-color-profile-from-file image "/usr/share/ghostscript/10.08.0/iccprofiles/srgb.icc")
    ; przywrócenie domyslnego
    ;(gimp-image-set-color-profile image 0)

    (gimp-image-undo-group-end image)

    (gimp-displays-flush)
    (gimp-context-pop)
    ))

(script-fu-register-filter
  "przem-warm-grayscale-v3x"
  "Warm Grayscale"
  "Converts a color image to a warm grayscale image (with orange/yellow
tones)"
  "P.R.P"
  "MIT"
  "23-10-2026"
  "RGB* GRAY*"
  SF-ONE-OR-MORE-DRAWABLE
  SF-ADJUSTMENT "Brightness"  '(0 -100 100 1 10 0 0)
  SF-ADJUSTMENT  "Saturation" '(0 -100 100 1 10 0 0)
  SF-PALETTE  _"Palette"  "Default"
  SF-ADJUSTMENT "Black" '(5 0 100 1 10 0 0)
)
(script-fu-menu-register "przem-warm-grayscale-v3x"
"<Image>/Filters/PIETRASZCZYK/")
