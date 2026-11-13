; przem-burlesque-effect - Tworzy efekt burleski na zdjęciu z sepia, winietowaniem
; author: PRP
; licencja: Public Domain
; Gdańsk - 23-09-2025
; ver. 2.250923-0~beta

(define (przem-burlesque-effect img drawable size xpos ypos)
  (let* (
        (width (car (gimp-image-width img)))
        (height (car (gimp-image-height img)))
        (old-selection 0)
        (layer-copy 0)
        (vignette-layer 0)
        ;(texture-layer 0)
        )
    
    ; Zapisz oryginalne zaznaczenie
    (set! old-selection (car (gimp-selection-save img)))
    
    ; Rozpocznij undo group
    (gimp-image-undo-group-start img)
    
    ; Stwórz kopię warstwy
    (set! layer-copy (car (gimp-layer-copy drawable TRUE)))
    (gimp-image-insert-layer img layer-copy 0 -1)
    (gimp-item-set-name layer-copy "Burlesque Effect")
    
    ; Zastosuj sepia
    (gimp-desaturate layer-copy)
    (gimp-color-balance layer-copy 0 TRUE 40 0 -40) ; Ciepłe odcienie sepia
    
    ; Dodaj kontrast
    (gimp-levels layer-copy 0 50 200 1.0 0 255)
    
    ; Stwórz efekt winietowania
    (set! vignette-layer (car (gimp-layer-new img width height RGBA-IMAGE "Vignette" 100  DARKEN-ONLY-MODE)))
    (gimp-image-insert-layer img vignette-layer 0 -1)
    (gimp-context-set-background '(0 0 0))
    (gimp-edit-fill vignette-layer FILL-BACKGROUND)
    
    ; Utwórz eliptyczne zaznaczenie dla winietowania
    (gimp-ellipse-select img (/ width xpos) (/ height ypos) (/ width 2) (/ height 2) CHANNEL-OP-REPLACE TRUE FALSE 0)

    (gimp-selection-feather img size)
    ;(gimp-selection-invert img)
    ;(gimp-layer-set-opacity vignette-layer 60)
    ;(gimp-layer-add-mask vignette-layer (car (gimp-layer-create-mask vignette-layer ADD-SELECTION-MASK)))
    (gimp-edit-clear vignette-layer)

    (gimp-selection-none img)
    
    ; Przywróć oryginalne zaznaczenie
    (gimp-selection-load old-selection)
    (gimp-image-remove-channel img old-selection)
    
    (gimp-image-merge-visible-layers img CLIP-TO-IMAGE)
    
    
    ; Zakończ undo group
    (gimp-image-undo-group-end img)
    (gimp-displays-flush)
  )
)

(script-fu-register "przem-burlesque-effect"
  _"Burlesque Effect"
  _"Tworzy efekt burleski na zdjęciu z sepia, winietowaniem"
  "PRP"
  "Public Domain"
  "2025-09-23"
  "RGB* GRAY*"
  SF-IMAGE "Image" 0
  SF-DRAWABLE "Drawable" 0
  SF-VALUE "Size" "1000"
  SF-VALUE "X position" "4"
  SF-VALUE "Y position" "4"

)

(script-fu-menu-register "przem-burlesque-effect"
                         "<Image>/Filters/PIETRASZCZYK/")
