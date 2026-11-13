; apply-cents-effect - Script-fu dodający efekt cętek
; author: PRP
; licencja: Public Domain
; Gdańsk - 26-02-2025
; ver. 1.250223-0

(define (przem-apply-cents-effect image drawable bright azimuth elevation depth polish)

  (let* (
         (width (car (gimp-image-width image)))
         (height (car (gimp-image-height image)))
         (bump-map (car (gimp-image-get-active-layer image)))
        )
    (gimp-image-undo-group-start image)
    
   (plug-in-solid-noise RUN-NONINTERACTIVE image drawable 0 0 0 1 5 5)
   (plug-in-bump-map RUN-NONINTERACTIVE image drawable bump-map azimuth elevation depth 0 0 0 0 TRUE FALSE 0)
   (if (= polish 0) (gimp-curves-spline drawable 0 18 #(0 255 30 0 65 255 95 0 125 255 160 0 190 255 222 0 255 255)));max
   (if (= polish 1) (gimp-curves-spline drawable 0 14 #(0 0 31 193 79 30 127 255 191 94 222 255 255 185)));med
   (if (= polish 2) (gimp-curves-spline drawable 0 14 #(0 0 32 160 94 63 127 223 190 161 222 255 255 255)));soft
   (gimp-brightness-contrast drawable bright bright)
   (gimp-selection-invert image)
  
   (gimp-image-undo-group-end image)
   (gimp-displays-flush)
  )
)


(script-fu-register "przem-apply-cents-effect"
  _"Apply a cents effect to the image."
  _"Dodaje efekt cętek do zdjęcia"
  "Przenmysław R. Pietraszczyk"
  "Public Domain"
  "2025-02-23"
  "RGB*, GRAY*"
  SF-IMAGE "Image" 0
  SF-DRAWABLE "Drawable" 0
  SF-ADJUSTMENT "Bright" '(50 0 100 1 10 0 0)
  SF-ADJUSTMENT "Azimuth" '(360 0 360 1 10 0 0)
  SF-ADJUSTMENT "Elevation" '(45 0 90 1 10 0 0)
  SF-ADJUSTMENT "Depth" '(5 1 50 1 10 0 0)
  SF-OPTION "Polish" '("MAX" "MED" "MIN")
  
)

(script-fu-menu-register "przem-apply-cents-effect" "<Image>/Filters/PIETRASZCZYK/")
