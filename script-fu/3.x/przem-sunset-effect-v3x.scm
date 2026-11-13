; przem-sunset-effect-v3x - imituje efekt zachodzącego słońca
; author: PRP
; licencja: Public Domain
; Gdańsk - 01-09-2025
; ver. 2.250901-0~beta

(define (shadows val)
     (/ (* 0.96 val) 2.55))

(define (midtones val)
     (/ val 2.55))

(define (highlights val)
     ; The result is used as "gimp-drawable-color-balance" color parameter
     ; and thus must be restricted to -100.0 <= highlights <= 100.0.
     (min (/ (* 1.108 val) 2.55) 100.0))

(define (rval col)
     (car col))

(define (gval col)
     (cadr col))

(define (bval col)
     (caddr col))


(define (przem-sunset-effect-v32 img drawable)
  (gimp-image-undo-group-start img)
  
  ; Tworzenie warstw dla różnych efektów
  (let* (
		(layer (vector-ref drawable 0))
        (sunset-layer (car (gimp-layer-copy layer TRUE)))
        ;(original-visible (car (gimp-drawable-get-visible drawable)))
        (original-visible (car (gimp-layer-copy layer TRUE)))
		(width (car (gimp-image-get-width img)))
        (height (car (gimp-image-get-height img)))
        )
    
    ; Dodawanie warstwy do obrazu
    (gimp-image-insert-layer img sunset-layer 0 -1)
    (gimp-layer-set-mode sunset-layer LAYER-MODE-MULTIPLY)
    (gimp-item-set-name sunset-layer _"Sunset Effect")

    
    ; Nakładanie gradientu ciepłych kolorów
    (gimp-context-set-foreground '(255 100 0))   ; pomarańczowy
    (gimp-context-set-background '(150 0 50))    ; różowo-czerwony
    
    ; Tworzenie gradientu
    (gimp-layer-set-mode sunset-layer LAYER-MODE-SUBTRACT) ; 
	(gimp-drawable-edit-gradient-fill sunset-layer
		GRADIENT-LINEAR 1 FALSE 1 0 TRUE
		0 0 width height)

   
	; cieplejsze cienie
    (gimp-drawable-color-balance sunset-layer TRANSFER-SHADOWS 1
                                  (shadows (rval '(30 0 -20)))
                                  (shadows (gval '(30 0 -20)))
                                  (shadows (bval '(30 0 -20))))
                                  
   ; cieplejsze średnie tony
    (gimp-drawable-color-balance sunset-layer TRANSFER-MIDTONES 1
                                  (midtones (rval '(40 0 -10)))
                                  (midtones (gval '(40 0 -10)))
                                  (midtones (bval '(40 0 -10))))
                                  
    ; cieplejsze światła
    (gimp-drawable-color-balance sunset-layer TRANSFER-HIGHLIGHTS 1
                                  (highlights (rval '(20 0 -5)))
                                  (highlights (gval '(20 0 -5)))
                                  (highlights (bval '(20 0 -5))))

    
    ; Zwiększenie kontrastu
    ;(gimp-levels sunset-layer 0 20 230 1.0 0 255)
    (gimp-drawable-levels sunset-layer 0
                           0 0.20 0 TRUE
                           1.0
                           0.0 1.0 TRUE)

    ; Dodanie lekkiego rozmycia dla miękkiego efektu
    ;(plug-in-gauss-iir 1 img sunset-layer 5 TRUE TRUE)
    (gimp-drawable-merge-new-filter sunset-layer "gegl:gaussian-blur" 1 LAYER-MODE-REPLACE 1.0 "std-dev-x" 5 "std-dev-y" 5 "filter" "auto")

    (gimp-image-undo-group-end img)
    (gimp-displays-flush)
  )
)

(script-fu-register-filter "przem-sunset-effect-v32"
                    _"Sunset Effect"
                    _"Imitacja kolorystyki zachodu słońca"
                    "P.R.P."
                    "Public Domain"
                    "2025-09-01"
                    "*"
                    SF-ONE-OR-MORE-DRAWABLE)

(script-fu-menu-register "przem-sunset-effect-v32"
                         "<Image>/Filters/PIETRASZCZYK/")
