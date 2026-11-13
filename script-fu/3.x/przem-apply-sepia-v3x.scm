; przem-apply-sepia-v3x - Script-fu dodający prawdziwą sepie do zdjęcia
; author: PRP
; licencja: GPL v3
; Gdańsk - 07-02-2025
; ver. 2.260116-1~beta for GIMP 3
;
; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 3 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <https://www.gnu.org/licenses/>.
;

(define (przem-apply-sepia-v32 image drawable value-slider-sepia shadow-sepia gradient-reverse in-sepia gradient-shape)
  (let* (
       (image-width (car (gimp-image-get-width image)))
       (image-height (car (gimp-image-get-height image)))
       (layer (vector-ref drawable 0))
       (type (car (gimp-drawable-type layer)))
       (center-x (/ image-width 2))
       (center-y (/ image-height 2))
       (radius (sqrt (+ (* center-x center-x) (* center-y center-y))))
       (the-layer 0)
       )
  (gimp-context-push)
  (gimp-image-undo-group-start image)
  

  (if (> (car (gimp-drawable-type layer)) 1)
        (gimp-image-convert-rgb image)
        )
        
  (if (= type RGB-IMAGE)
	(gimp-drawable-desaturate layer DESATURATE-LIGHTNESS)
  )

  (gimp-selection-all image)
  (set! the-layer (car (gimp-image-flatten image)))
     
   (if (= in-sepia TRUE)
      (begin (gimp-drawable-desaturate the-layer DESATURATE-LIGHTNESS)
             (gimp-drawable-brightness-contrast the-layer -0.078125 -0.15625)
             (gimp-drawable-color-balance the-layer TRANSFER-SHADOWS TRUE 30 0 -30)
      )
   )

  (let (
      (sepia-layer (car (gimp-layer-new image "Sepia" image-width image-height RGB-IMAGE 100 LAYER-MODE-NORMAL)))
	)
	
     (gimp-context-set-foreground '(112 66 20)) ; sepia ciemniejszy
     (gimp-context-set-background '(233 213 186)) ; sepia jasniejszy
     ;(gimp-context-set-background '(210 180 140)) ; sepia jasniejsza
  
     ; Dodanie koloru sepii
     (gimp-image-insert-layer image sepia-layer 0 -1)

     (gimp-context-push)
  
     ;(plug-in-checkerboard #:run-mode    RUN-NONINTERACTIVE
     ;                        #:image       image
     ;                        #:drawables   (vector drawable)
     ;                        #:psychobilly 0
     ;                        #:check-size  8)
     (plug-in-checkerboard RUN-NONINTERACTIVE image (vector sepia-layer) 0 8)
  
     (gimp-context-pop)

     (gimp-context-push)

     ;(gimp-selection-all image)
     ; tak było w v. 2.10
     ;(gimp-edit-blend sepia-layer FG-BG-RGB-MODE NORMAL-MODE GRADIENT-LINEAR 100 0 REPEAT-NONE FALSE TRUE 3 0 TRUE 0 0 image-width image-height)
     (gimp-context-set-gradient-fg-bg-rgb)
     (if (= gradient-shape 1)
       (begin
         (gimp-context-set-gradient-reverse gradient-reverse)
         (gimp-drawable-edit-gradient-fill sepia-layer
				      GRADIENT-LINEAR (- 100 shadow-sepia)
				      FALSE 1 0
				      TRUE
				      0 0 image-width image-height)
	   ) )
	   (if (= gradient-shape 2)
	     (begin
			(gimp-context-set-gradient-reverse gradient-reverse)
			(gimp-drawable-edit-gradient-fill sepia-layer
				      GRADIENT-SHAPEBURST-DIMPLED  (- 100 shadow-sepia)
				      FALSE 1 0
				      TRUE
				      0 0 center-x center-y)
	     )
	   )
	   (if (= gradient-shape 0)
	     (begin
			(gimp-context-set-gradient-reverse gradient-reverse)
			(gimp-drawable-edit-gradient-fill sepia-layer
				      GRADIENT-BILINEAR (- 100 shadow-sepia)
				      FALSE 1 0
				      TRUE
				      (/ (+ (* 2 center-x) center-y -1) 2) 0
				      0 0)
			)
	    )

     ; Zmiana krycia warstwy
     (gimp-layer-set-opacity sepia-layer value-slider-sepia)
  
     (gimp-image-merge-down image sepia-layer CLIP-TO-IMAGE)
     ) ; let
  (gimp-selection-none image)

  
  (gimp-image-undo-group-end image)
  ;(gimp-image-undo-enable image)
  
  (gimp-displays-flush)
  (gimp-context-pop)

) )

(script-fu-register-filter "przem-apply-sepia-v32"
  _"_Apply a sepia effect to the image"
  _"Tworzy obraz sepii"
  "Przemyslaw R. Pietraszczyk"
  "GPL v3"
  "2025-02-07"
  "RGB* GRAY*"
  SF-ONE-OR-MORE-DRAWABLE
  SF-ADJUSTMENT _"Sepia intensity" '(50 0 100 1 10 0 0)  ; Suwak poziomy
  SF-ADJUSTMENT _"Shadow Sepia" '(30 0 100 1 10 0 0)  ; Suwak poziomy
  SF-TOGGLE     _"Gradient reverse" FALSE
  SF-TOGGLE     _"Sepia" TRUE
  SF-OPTION     _"Shape" '("Bilinear" "Linear" "Shapeburst")



) 
 
(script-fu-menu-register "przem-apply-sepia-v32"
                         "<Image>/Filters/PIETRASZCZYK/")
