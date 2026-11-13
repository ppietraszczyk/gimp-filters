; przem-wet-collodion-v3x - imituje efekt mokrego kolodionu
; author: PRP
; licencja: Public Domain
; Gdańsk - 24-08-2025
; ver. 2.250824-1~beta

(define (add-hsv-noise img drawable intensity-h intensity-s intensity-v grain)
  (let* (
        (width (car (gimp-image-get-width img)))
        (height (car (gimp-image-get-height img)))
        (noise-layer (car (gimp-layer-new img "Noise" width height RGB-IMAGE 100 LAYER-MODE-NORMAL)))
        )
    
    ; Konwertuj do HSV jeśli to konieczne
    ;(if (not (= (car (gimp-drawable-is-rgb drawable)) 1))
    ;    (gimp-image-convert-rgb img))
    
   (gimp-image-insert-layer img noise-layer 0 -1)
   (gimp-drawable-fill noise-layer FILL-TRANSPARENT)
      
   ; Generuj szum
   ;(plug-in-solid-noise RUN-NONINTERACTIVE img noise-layer 0 0 (random 1000) 0 4 4)
   (let* ((noise-width  (cadddr (gimp-drawable-mask-intersect drawable)))
           (noise-height (caddr (cddr (gimp-drawable-mask-intersect drawable)))))

   (gimp-drawable-merge-new-filter noise-layer "gegl:noise-solid" 0 LAYER-MODE-REPLACE 1.0 "tileable" FALSE "turbulent" FALSE "seed" (random 100)
                                                                                               "detail" 1 "x-size" 4.0 "y-size" 4.0
                                                                                               "width" noise-width "height"noise-height))

   
   
   ; Ustaw odpowiednie intensywności dla każdego kanału HSV
   (let* (
         (h-channel (car (gimp-layer-new img "H Channel" width height RGB-IMAGE 100 LAYER-MODE-HSV-HUE)))
         (s-channel (car (gimp-layer-new img "S Channel" width height RGB-IMAGE 100 LAYER-MODE-HSV-SATURATION)))
         (v-channel (car (gimp-layer-new img "V Channel" width height RGB-IMAGE 100 LAYER-MODE-HSV-VALUE))))
        
        ; Dodaj kanały
        (gimp-image-insert-layer img h-channel 0 -1)
        (gimp-image-insert-layer img s-channel 0 -1)
        (gimp-image-insert-layer img v-channel 0 -1)
        
        ; Skopiuj szum do każdego kanału
        (gimp-edit-copy (vector noise-layer))
        ; czy to potrzebne ?
        (gimp-edit-copy (vector drawable))
        (let* (
        (pasted (car (gimp-edit-paste h-channel TRUE)))
         (num-pasted (vector-length pasted))
         (floating-sel (vector-ref pasted (- num-pasted 1)))
         )
		(gimp-layer-set-offsets floating-sel 0 0)
		(gimp-floating-sel-anchor floating-sel))
        
		(gimp-edit-copy (vector drawable))
        (let* (
        (pasted (car (gimp-edit-paste s-channel TRUE)))
         (num-pasted (vector-length pasted))
         (floating-sel (vector-ref pasted (- num-pasted 1)))
         )
		(gimp-layer-set-offsets floating-sel 0 0)
		(gimp-floating-sel-anchor floating-sel))
        
        
        (gimp-edit-copy (vector drawable))
        (let* (
        (pasted (car (gimp-edit-paste v-channel TRUE)))
         (num-pasted (vector-length pasted))
         (floating-sel (vector-ref pasted (- num-pasted 1)))
         )
		(gimp-layer-set-offsets floating-sel 0 0)
		(gimp-floating-sel-anchor floating-sel))
		
        (gimp-layer-set-opacity noise-layer 80)

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




(define (przem-wet-collodion-v32 image drawable mode intensity-h intensity-s intensity-v grain blur)
  (let* (
		 (layer (vector-ref drawable 0))
		 (type (car (gimp-drawable-type-with-alpha layer)))
         (width (car (gimp-image-get-width image)))
         (height (car (gimp-image-get-height image)))
         (mode-blur 0)
        )
    (gimp-context-push)
    (gimp-image-undo-group-start image)

    ;; Desaturacja
    (if (= type RGBA-IMAGE)
    (gimp-drawable-desaturate layer DESATURATE-LIGHTNESS))

    ;; Dodanie winiety
    (let* ((w-layer (car (gimp-layer-copy layer TRUE))))
      (gimp-image-insert-layer image w-layer 0 -1)
      (gimp-drawable-merge-new-filter w-layer "gegl:gaussian-blur" 0 LAYER-MODE-REPLACE 1.0 "std-dev-x" 200 "std-dev-y" 200 "filter" "auto")
      (gimp-layer-set-mode w-layer LAYER-MODE-MULTIPLY)
      (gimp-layer-set-opacity w-layer 60)
    )

    ;; Dodanie szumu
	(add-hsv-noise image layer intensity-h intensity-s intensity-v grain)
	;;(plug-in-noisify RUN-NONINTERACTIVE image layer FALSE grain grain grain 0)

    ;; Dodanie lekkiego rozmycia
    (if (= mode 0) (begin (set! mode-blur "auto")))
    (if (= mode 1) (begin (set! mode-blur "iir")))
    (if (= mode 2) (begin (set! mode-blur "fir")))
    (gimp-drawable-merge-new-filter layer "gegl:gaussian-blur" 0 LAYER-MODE-REPLACE 1.0 "std-dev-x" blur "std-dev-y" blur "filter" mode-blur)

    (gimp-image-undo-group-end image)
    (gimp-displays-flush)
    (gimp-context-pop)
  )
)

(script-fu-register-filter "przem-wet-collodion-v32"
 _"Wet Collodion"
 _"Imituje efekt mokrego kolodionu"
 "PRP"
 "Public Domain"
 "2025-07-15"
 "RGB* GRAY*"
 SF-ONE-OR-MORE-DRAWABLE
 SF-OPTION "Mode" '("AUTO" "IIR" "FIR")
 SF-ADJUSTMENT "Hue Noise Intensity" '(30 0 100 1 10 0 0)
 SF-ADJUSTMENT "Saturation Noise Intensity" '(20 0 100 1 10 0 0)
 SF-ADJUSTMENT "Value Noise Intensity" '(15 0 100 1 10 0 0)
 SF-ADJUSTMENT "Grain" '(0.2 0 1 0.1 0.1 2 0)
 SF-ADJUSTMENT "Blur" '(2 0 100 1 10 0 0)
)

(script-fu-menu-register "przem-wet-collodion-v32"
                         "<Image>/Filters/PIETRASZCZYK/")
