;  przem-sepia-dust-v3xTworzy dramatyczne światło, wysoki kontrast.
; Przmeysław R. Pietraszczyk
; 2026-08-05
; ver 2.260805-1
; editor: Kate

(define (przem-sepia-dust-v3x image drawable)
  (let* (
          (image-width (car ( gimp-image-get-width image)))
          (image-height (car (gimp-image-get-height image)))
          (new-layer 0)
          (grain-layer 0)
          (curves-layer 0)
          (base-layer (vector-ref drawable 0))
          (type (car (gimp-drawable-type-with-alpha base-layer)))
        )

    (gimp-image-undo-group-start image)

    ; 1. Desaturacja (konwersja na czarno-biały)
    ;(gimp-desaturate drawable DESATURATE-LUMINOSITY)
    (if (= type RGBA-IMAGE)
      (gimp-drawable-desaturate base-layer DESATURATE-LIGHTNESS)
    )
    (set! new-layer (car (gimp-layer-copy base-layer TRUE)))
    (set! grain-layer (car (gimp-layer-copy base-layer TRUE)))
    (set! curves-layer (car (gimp-layer-copy base-layer TRUE)))


    ; 2. Warstwa koloryzująca (Sepia Brown)
    (gimp-image-insert-layer image new-layer 0 -1)
    (gimp-context-set-background '(165 142 123)) ; Kolor: #A58E7B
    ;(gimp-edit-fill new-layer FILL-FOREGROUND)
    (gimp-drawable-edit-fill new-layer FILL-BACKGROUND)

    (gimp-layer-set-mode new-layer LAYER-MODE-NORMAL)
    (gimp-layer-set-opacity new-layer 25)

    ; 3. Warstwa szumu (Ziarno filmowe)
    (gimp-image-insert-layer image grain-layer 0 -1)
    (gimp-context-set-foreground '(128 128 128)) ; 50% szarości
    ;(gimp-edit-fill grain-layer FILL-FOREGROUND)
    (gimp-drawable-edit-fill new-layer FILL-FOREGROUND)
    ;(plug-in-noise-hurl 1 grain-layer 0 FALSE 50 50 50)
    (gimp-drawable-merge-new-filter grain-layer "gegl:noise-hsv" "Noise-HSV" LAYER-MODE-NORMAL 0.8 "holdness" 2 "hue-distance" 0.3 "saturation-distance" 0.5 "value-distance" 0.5 "seed" 50)

    ;(plug-in-gauss-rle 1 grain-layer 1.5 TRUE TRUE) ; Miękkie rozmycie szumu
    (gimp-drawable-merge-new-filter grain-layer "gegl:gaussian-blur" "Gauss-Blur" LAYER-MODE-NORMAL 0.8  "std-dev-x" 1.5 "std-dev-y" 1.5)

    (gimp-layer-set-mode grain-layer LAYER-MODE-OVERLAY)
    ;(gimp-layer-set-opacity grain-layer 25)

    ; 4. Warstwa krzywych (Podbicie czerni - mleczny wygląd)
    (gimp-image-insert-layer image curves-layer 0 -1)
    (gimp-layer-set-mode curves-layer LAYER-MODE-NORMAL)
    (gimp-layer-set-opacity curves-layer 25)

    ; Tworzymy krzywą (wejście 0 -> wyjście 30, wejście 255 -> wyjście 245)
    (let* (
            (channels #(0 0 0))
            (curve-points #(0 30 255 245))
          )
      ;(gimp-curves-explicit curves-layer HISTOGRAM-VALUE channels curve-points)
      (gimp-drawable-curves-spline curves-layer HISTOGRAM-VALUE curve-points)
    )

    ; Spłaszczenie i koniec
    (gimp-image-merge-visible-layers image CLIP-TO-IMAGE)
    (gimp-image-undo-group-end image)
    (gimp-displays-flush)
  )
)

(script-fu-register-filter "przem-sepia-dust-v3x"
  _"Sepia Dust Effect"
  _"Tworzy vintage'owy efekt sepii z szumem i mlecznymi czerniami"
  "Przemysław R. Pietraszczyk"
  "Public Domain"
  "2026-08-04"
  "RGB* GRAY*"
  SF-ONE-OR-MORE-DRAWABLE
)

(script-fu-menu-register "przem-sepia-dust-v3x" "<Image>/Filters/PIETRASZCZYK/"
)
