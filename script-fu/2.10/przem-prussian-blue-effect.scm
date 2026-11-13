; przem-prussian-blue-effect  - nieudalna próba nawiązania do efektu cyjanotypii
; author: PRP
; licencja: Public Domain
; Gdańsk - 22-6-2025
; ver. 2.250622-0~beta

(define (przem-prussian-blue-effect img drawable mode invert value-blue)
  
  (let* ((gradient-layer (car (gimp-layer-new img (car (gimp-image-width img)) (car (gimp-image-height img)) RGBA-IMAGE "Prussian Blue" 50 NORMAL-MODE)))
        (is-nocolorful (car (gimp-drawable-is-gray drawable))))
  
  (gimp-image-undo-group-start img)
  (gimp-context-push)
  
  ; jeśli obraz jest szary to konwertuje go na RGB - tak na sztukę
  (if (= is-nocolorful TRUE)
    (gimp-image-convert-rgb img)
  )
  
  (gimp-image-insert-layer img gradient-layer 0 -1)
  (gimp-context-set-foreground '(0 51 102)) ; Kolor błękitu pruskiego
  (gimp-context-set-background '(0 0 0))
  (if (= mode 0) (gimp-layer-set-mode gradient-layer OVERLAY-MODE))
  (if (= mode 1) (gimp-layer-set-mode gradient-layer SCREEN-MODE))

  (plug-in-colors-channel-mixer TRUE img gradient-layer TRUE 0.0 0.0 1.0 0.0 0.0 1.0 0.0 0.0 1.0)
  
  ;(gimp-edit-blend gradient-layer FG-BG-RGB-MODE NORMAL-MODE GRADIENT-LINEAR 100 0 REPEAT-NONE FALSE FALSE 0 0 TRUE (car (gimp-image-width img)) (car (gimp-image-height img)) 0 0)
  (gimp-edit-blend gradient-layer FG-BG-RGB-MODE NORMAL-MODE GRADIENT-LINEAR 100 0 REPEAT-NONE FALSE FALSE 0 0 TRUE 0 0 0 0)
  
  (if (= invert TRUE) (gimp-invert gradient-layer))

  (gimp-layer-set-opacity gradient-layer value-blue)
  (gimp-image-merge-down img gradient-layer CLIP-TO-IMAGE)

  (gimp-image-undo-group-end img)
  (gimp-displays-flush)
  (gimp-context-pop))
)

(script-fu-register "przem-prussian-blue-effect"
  _"Apply prussian blue effect"
  _"Nakłada efekt błękitu pruskiego na zdjęcie."
  "PRP"
  "Public Domain"
  "2025-06-22"
  "RGB*, GRAY*"
  SF-IMAGE "Image" 0
  SF-DRAWABLE "Drawable" 0
  SF-OPTION "Mode" '("OVERLAY MODE" "SCREEN MODE")
  SF-TOGGLE "Invert Color" FALSE
  SF-ADJUSTMENT "Blue intensity" '(50 0 100 1 10 0 0)

)

(script-fu-menu-register "przem-prussian-blue-effect"
                         "<Image>/Filters/PIETRASZCZYK/")
