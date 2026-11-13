; przem-dramatic-light-3x Tworzy dramatyczne światło, wysoki kontrast.
; Przmeysław R. Pietraszczyk
; 2026-07-21
; ver 2.260723-0
; editor: KWrite


(define (przem-dramatic-light-v3x img drawable grain mono)

  (gimp-context-push)
  (gimp-image-undo-group-start img)

  (let* (
        (base-layer (vector-ref drawable 0))
        (type (car (gimp-drawable-type-with-alpha base-layer)))
        (grain-layer 0))

        (if (= mono TRUE) (begin
          (if (= type RGBA-IMAGE)
          (gimp-drawable-desaturate base-layer DESATURATE-LUMINANCE))))

        (set! grain-layer (car (gimp-layer-copy base-layer TRUE)))

        ;; Apply strong curves to push light from top
        (let* (
            (light-layer (car (gimp-layer-copy base-layer TRUE)))
            (contrast-layer (car (gimp-layer-copy base-layer TRUE))))

            (gimp-image-insert-layer img light-layer 0 -1)
            (gimp-image-insert-layer img contrast-layer 0 -1)

			(gimp-drawable-curves-spline light-layer HISTOGRAM-VALUE #(0 0  64 180  128 230  255 255))
            (gimp-layer-set-mode light-layer LAYER-MODE-OVERLAY)
			(gimp-layer-set-opacity light-layer 100)

			(gimp-drawable-curves-spline contrast-layer HISTOGRAM-VALUE #(0 0  64 40  128 128  192 220  255 255))
			(gimp-layer-set-mode contrast-layer LAYER-MODE-HARDLIGHT)
			(gimp-layer-set-opacity contrast-layer 85))

        (if (= grain TRUE) (begin
          (gimp-drawable-merge-new-filter grain-layer "gegl:noise-hsv" "Noise-HSV" LAYER-MODE-NORMAL 0.7 "holdness" 2 "hue-distance" 0.3 "saturation-distance" 0.5 "value-distance" 0.5 "seed" 42)
          (gimp-image-insert-layer img grain-layer 0 -1)))

        (let* ((merged-layer (car (gimp-image-merge-visible-layers img CLIP-TO-IMAGE))))
			(gimp-item-set-visible merged-layer TRUE))
    )

  (gimp-image-undo-group-end img)
  (gimp-displays-flush)
  (gimp-context-pop)
)

(script-fu-register-filter "przem-dramatic-light-v3x"
 _"Dramatic Light Effect"
 _"Tworzy dramatyczne światło, wysoki kontrast"
 "Przemysław R. Pietraszczyk"
 "Public Domain"
 "21-07-2026"
 "RGB* GRAY*"
  SF-ONE-OR-MORE-DRAWABLE
  SF-TOGGLE _"Grain" FALSE
  SF-TOGGLE _"Monochromatic" TRUE

)
(script-fu-menu-register "przem-dramatic-light-v3x"
                         "<Image>/Filters/PIETRASZCZYK/")



