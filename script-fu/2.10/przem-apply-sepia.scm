; przem-apply-sepia - Script-fu dodający prawdziwą sepie do zdjęcia
; author: PRP
; licencja: Public Domain
; Gdańsk - 07-02-2025
; ver. 1.250213-0

(define (przem-apply-sepia image drawable value-slider-sepia gradient-reverse gradient-shape)
  
  (let* (
       (image-width (car (gimp-image-width image)))
       (image-height (car (gimp-image-height image)))
       (center-x (/ image-width 2))
       (center-y (* image-height 0.5)) ; either is OK
       (sepia-layer (car (gimp-layer-new image image-width image-height RGBA-IMAGE "Sepia Layer" 100 NORMAL-MODE)))
       (is-nocolorful (car (gimp-drawable-is-gray drawable))) ; czy obraz jest w odcieniach szarości
       (radius (sqrt (+ (* center-x center-x) (* center-y center-y))))
       )
  
  (gimp-image-undo-group-start image)

  ; jeśli obraz jest szary to konwertuje go na RGB - tak na sztukę
  (if (= is-nocolorful TRUE)
    (gimp-image-convert-rgb image)
  )
  
  ; Konwersja obrazu do skali szarości
  (gimp-desaturate drawable)
  
  ; Dodanie koloru sepii
  (gimp-context-set-foreground '(112 66 20)) ; Kolor sepii
  (gimp-context-set-background '(233 213 186)) ; Kolor sepii


  (gimp-image-insert-layer image sepia-layer 0 -1)

  (gimp-selection-all image)

  (if (= gradient-reverse TRUE)
    (begin

      (if (= gradient-shape TRUE)
       (begin
         (gimp-edit-blend sepia-layer FG-BG-RGB-MODE NORMAL-MODE GRADIENT-LINEAR 100 0 REPEAT-NONE FALSE TRUE 3 0 TRUE 0 0   image-width image-height)
       )
	   (begin
         (gimp-edit-blend sepia-layer CUSTOM-MODE NORMAL-MODE
                     GRADIENT-RADIAL 100 0 REPEAT-NONE FALSE
                     FALSE 0 0 TRUE
                     center-x center-y radius 0)
      ) ) )
    (begin

      (if (= gradient-shape TRUE)
       (begin
         (gimp-edit-blend sepia-layer FG-BG-RGB-MODE NORMAL-MODE GRADIENT-LINEAR 100 0 REPEAT-NONE FALSE TRUE 3 0 TRUE 0 0   image-width image-height)
       )
	   (begin
         (gimp-edit-blend sepia-layer CUSTOM-MODE NORMAL-MODE
                     GRADIENT-RADIAL 100 0 REPEAT-NONE FALSE
                     FALSE 0 0 TRUE
                     center-x center-y radius 0)
      ) ) ) )


     ; )
  ; Zmiana krycia warstwy
  (gimp-layer-set-opacity sepia-layer value-slider-sepia)
  
  (gimp-image-merge-down image sepia-layer CLIP-TO-IMAGE)
  
  (gimp-image-undo-group-end image)
  
  (gimp-displays-flush)
) )

(script-fu-register "przem-apply-sepia"
  _"Apply a sepia effect to the image"
  _"Tworzy obraz sepii"
  "Przemyslaw R. Pietraszczyk"
  "Public Domain"
  "2025-02-07"
  "RGB* GRAY*"
  SF-IMAGE "Image" 0
  SF-DRAWABLE "Drawable" 0
  SF-ADJUSTMENT "Sepia intensity" '(50 0 100 1 10 0 0)
  SF-TOGGLE     "Gradient reverse" FALSE
  SF-TOGGLE     "Shape" TRUE
) 

(script-fu-menu-register "przem-apply-sepia"
                         "<Image>/Filters/PIETRASZCZYK/")
