; przem-wet-collodion - imituje efekt mokrego kolodionu
; author: PRP
; licencja: Public Domain
; Gdańsk - 15-07-2025
; ver. 2.250718-0~beta

(define (add-hsv-noise img drawable intensity-h intensity-s intensity-v grain)
  (let* (
        (width (car (gimp-drawable-width drawable)))
        (height (car (gimp-drawable-height drawable)))
        (noise-layer (car (gimp-layer-new img width height RGB-IMAGE "Noise" 100 NORMAL-MODE)))
        )
        
    ; Rozpocznij edycję
    ;(gimp-image-undo-group-start img)
    
    ; Konwertuj do HSV jeśli to konieczne
    ;(if (not (= (car (gimp-drawable-is-rgb drawable)) 1))
    ;    (gimp-image-convert-rgb img))
    
   (gimp-image-insert-layer img noise-layer 0 -1)
   (gimp-drawable-fill noise-layer FILL-TRANSPARENT)
      
   ; Generuj szum
   (plug-in-solid-noise RUN-NONINTERACTIVE img noise-layer 0 0 (random 1000) 0 4 4)
   
   ; Ustaw odpowiednie intensywności dla każdego kanału HSV
   (let* (
         (h-channel (car (gimp-layer-new img width height RGB-IMAGE "H Channel" 100 LAYER-MODE-HSV-HUE)))
         (s-channel (car (gimp-layer-new img width height RGB-IMAGE "S Channel" 100 LAYER-MODE-HSV-SATURATION)))
         (v-channel (car (gimp-layer-new img width height RGB-IMAGE "V Channel" 100 LAYER-MODE-HSV-VALUE))))
        
        ; Dodaj kanały
        (gimp-image-insert-layer img h-channel 0 -1)
        (gimp-image-insert-layer img s-channel 0 -1)
        (gimp-image-insert-layer img v-channel 0 -1)
        
        ; Skopiuj szum do każdego kanału
        (gimp-edit-copy noise-layer)
        (gimp-floating-sel-anchor (car (gimp-edit-paste h-channel TRUE)))
        (gimp-floating-sel-anchor (car (gimp-edit-paste s-channel TRUE)))
        (gimp-floating-sel-anchor (car (gimp-edit-paste v-channel TRUE)))
        (gimp-layer-set-opacity noise-layer 0)

        ; Ustaw przezroczystość dla każdego kanału
        (gimp-layer-set-opacity h-channel intensity-h)
        (gimp-layer-set-opacity s-channel intensity-s)
        (gimp-layer-set-opacity v-channel intensity-v)
        
        ; Połącz kanały z oryginalnym obrazem
        (gimp-image-merge-down img h-channel EXPAND-AS-NECESSARY)
        (gimp-image-merge-down img s-channel EXPAND-AS-NECESSARY)
        (gimp-image-merge-down img v-channel EXPAND-AS-NECESSARY)
        

    )
    ;(gimp-image-remove-layer img noise-layer)
  )
)




(define (przem-wet-collodion image drawable intensity-h intensity-s intensity-v grain blur)
  (let* (
         (width (car (gimp-image-width image)))
         (height (car (gimp-image-height image)))
        )
    (gimp-image-undo-group-start image)

    ;; Desaturacja
    (gimp-desaturate-full drawable DESATURATE-LUMINOSITY)

    ;; Dodanie winiety
    (let* ((layer (car (gimp-layer-copy drawable TRUE))))
      (gimp-image-insert-layer image layer 0 -1)
      (plug-in-gauss-iir2 RUN-NONINTERACTIVE image layer 200 200)
      (gimp-layer-set-mode layer MULTIPLY-MODE)
      (gimp-layer-set-opacity layer 60)
    )

    ;; Dodanie szumu
	(add-hsv-noise image drawable intensity-h intensity-s intensity-v grain)
	(plug-in-noisify RUN-NONINTERACTIVE image drawable FALSE grain grain grain 0)

    ;; Dodanie lekkiego rozmycia
    (plug-in-gauss-iir2 RUN-NONINTERACTIVE image drawable blur blur)

    (gimp-image-undo-group-end image)
    (gimp-displays-flush)
  )
)

(script-fu-register "przem-wet-collodion"
 _"Wet Collodion"
 _"Imituje efekt mokrego kolodionu"
 "PRP"
 "Public Domain"
 "2025-07-15"
 "RGB*"
 SF-IMAGE "Image" 0
 SF-DRAWABLE "Drawable" 0
 SF-ADJUSTMENT "Hue Noise Intensity" '(30 0 100 1 10 0 0)
 SF-ADJUSTMENT "Saturation Noise Intensity" '(20 0 100 1 10 0 0)
 SF-ADJUSTMENT "Value Noise Intensity" '(15 0 100 1 10 0 0)
 SF-ADJUSTMENT "Grain" '(0.2 0 1 0.1 0.1 2 0)
 SF-ADJUSTMENT "Blur" '(2 0 100 1 10 0 0)
)

(script-fu-menu-register "przem-wet-collodion"
                         "<Image>/Filters/PIETRASZCZYK/")
