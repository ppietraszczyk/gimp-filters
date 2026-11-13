; przem-soft-focus - Tworzy efekt miękkiego focusa
; author: PRP
; licencja: Public Domain
; Gdańsk - 15-09-2025
; ver. 2.250615-0

(define (przem-soft-focus img drawable blur-radius opacity)

  (let* (
        (soft-layer (car (gimp-layer-copy drawable FALSE)))
        )
	(gimp-context-push)
	(gimp-image-undo-group-start img)
  
    (gimp-image-insert-layer img soft-layer 0 -1)
    (gimp-item-set-name soft-layer "Soft Focus")
    
    ; Rozmycie Gaussa
    (plug-in-gauss 1 img soft-layer blur-radius blur-radius 0)

    ; Zmień tryb mieszania na Overlay lub Screen
    (gimp-layer-set-mode soft-layer OVERLAY-MODE)
    
    ; Dostosuj przezroczystość
    (gimp-layer-set-opacity soft-layer opacity)
    (gimp-image-merge-down img soft-layer CLIP-TO-IMAGE)
  
  
  (gimp-image-undo-group-end img)
  (gimp-displays-flush)
  (gimp-context-pop)
))

; Rejestracja skryptu w menu GIMP
(script-fu-register "przem-soft-focus"
  _"Apply a Soft Focus..."
  _"Tworzy efekt miękkiego focusu"
  "PRP"
  "Public Domain"
  "2025-06-15"
  "RGB*, GRAY*"
  SF-IMAGE "Image" 0
  SF-DRAWABLE "Drawable" 0
  SF-ADJUSTMENT "Blur (px)" '(15 1 100 1 10 0 1)
  SF-ADJUSTMENT "Transparency (%)" '(50 0 100 1 10 0 1)
)

(script-fu-menu-register "przem-soft-focus"
                         "<Image>/Filters/PIETRASZCZYK/")
