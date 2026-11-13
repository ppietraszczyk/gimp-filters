; przem-hitchcock-d400-film-effect-v3x - Imitacja filmu chińskiego HITCHOCK D400: kontrast, ciepłe światła, chłodne cienie, bloom
; author: Przemysław R. Pietraszczyk
; licencja: Public Domain
; Gdańsk - 14-06-2026
; ver. 2.260724-1

(define (przem-hitchcock-d400-film-effect-v3 image drawable
                                 lift-blacks-contrast
                                 warm-highlights
                                 cool-shadows
                                 bloom-strength)
	(gimp-context-push)
    (gimp-image-undo-group-start image)

  ;; Duplikat warstwy bazowej
  (let* (
         (type-layer (vector-ref drawable 0))
         (layer (vector-ref drawable 0))
         (work-layer (car (gimp-layer-copy layer TRUE)))
         (bloom-layer 0)
        )

    (if (> (car (gimp-drawable-type type-layer)) 1)
        (gimp-image-convert-rgb image)
        )

    (gimp-image-insert-layer image work-layer 0 -1)

    (let* ((finish-layer (car (gimp-layer-copy layer TRUE))))
      (gimp-image-insert-layer image finish-layer 0 -1)
      ; lift-blacks 0-40   contrast 0-80
      ;(gimp-drawable-curves-spline finish-layer HISTOGRAM-VALUE 10 #( 0 lift-blacks 64 (+ 48 contrast) 128 128 192 (- 208 contrast) 255 255))
      (cond
      ((= lift-blacks-contrast 0)
        (gimp-drawable-curves-spline finish-layer HISTOGRAM-VALUE #(0 40 64 68 128 128 192 188 255 255))
      )
      ((= lift-blacks-contrast 1)
        (gimp-drawable-curves-spline finish-layer HISTOGRAM-VALUE #(0 30 64 84 128 128 192 168 255 255))
      )
      ((= lift-blacks-contrast 2)
        (gimp-drawable-curves-spline finish-layer HISTOGRAM-VALUE #(0 20 64 104 128 128 192 148 255 255))
      )
      ((= lift-blacks-contrast 4)
        (gimp-drawable-curves-spline finish-layer HISTOGRAM-VALUE #(0 10 64 124 128 128 192 128 255 255))
      ))
            (gimp-layer-set-mode finish-layer LAYER-MODE-OVERLAY)
			(gimp-layer-set-opacity finish-layer 80)
      )
    ;; 2. Ciepłe światła – Color Balance (midtones + highlights)
    ; cyan-red - magenta-green - yellow-blue (ujemne = więcej żółtego, dodatnie = więcej niebieskiego)
    (gimp-drawable-color-balance work-layer TRANSFER-SHADOWS FALSE 0 0 cool-shadows)
    (gimp-drawable-color-balance work-layer TRANSFER-MIDTONES FALSE warm-highlights 0 (- warm-highlights))
    (gimp-drawable-color-balance work-layer TRANSFER-HIGHLIGHTS FALSE warm-highlights 0 (- warm-highlights))

    ;; 3. Delikatny bloom / glow (kopiujemy warstwę, rozmywamy, Soft light)
    (set! bloom-layer (car (gimp-layer-copy layer TRUE)))
    (gimp-image-insert-layer image bloom-layer 0 -1)
    (gimp-layer-set-mode bloom-layer LAYER-MODE-SUBTRACT)
    (gimp-drawable-merge-new-filter bloom-layer "gegl:gaussian-blur" 1 LAYER-MODE-REPLACE 1.0 "std-dev-x" 8.0 "std-dev-y" 8.0 "filter" "iir")
    (gimp-layer-set-opacity bloom-layer bloom-strength)

    (gimp-image-undo-group-end image)
    (gimp-displays-flush)
    (gimp-context-pop)
  )
)

(script-fu-register-filter "przem-hitchcock-d400-film-effect-v3"
 _"Hitchock d400 effect"
 _"Imitacja filmu chińskiego HITCHCOCK D400: kontrast, ciepłe światła, chłodne cienie, bloom."
 _"Przemysław R. Pietraszczyk"
 "Public Domain"
 "2026-06-14"
 "*"
 SF-ONE-OR-MORE-DRAWABLE
 SF-OPTION "Black up & Contrast" '("Lift Blacks Weak" "Lift Blacks Medium" "Lift Blacks Strong" "Lift Blacks Heavy")
 SF-ADJUSTMENT "Warm lights (–50 do 50)" '(15 -50 50 1 5 0 1)
 SF-ADJUSTMENT "Cool shadows (–50 do 50)" '(-10 -50 50 1 5 0 1)
 SF-ADJUSTMENT "Bloom – power (0–100)" '(35 0 100 1 5 0 1)
)

(script-fu-menu-register "przem-hitchcock-d400-film-effect-v3"
                         "<Image>/Filters/PIETRASZCZYK/")
