; przem-soften-light - script-fu na rozjaśnienie światła / przyciemniania
; author: PRP
; licencja: Public Domain
; Gdańsk - 02-07-2025
; ver. 2.250702-0
(define (przem-soften-light img drawable blur-radius opacity mode)
  
  ; Tworzy kopię warstwy
  (let* (
        (copy-layer (car (gimp-layer-copy drawable TRUE)))
        )
        
    (gimp-context-push)
	(gimp-image-undo-group-start img)
  
    (gimp-image-insert-layer img copy-layer 0 -1)
    (gimp-item-set-name copy-layer "Soft Light Blur")
    
    ; Rozmywa kopię warstwy (Gaussian Blur)
    (plug-in-gauss RUN-NONINTERACTIVE img copy-layer blur-radius blur-radius TRUE)
    
    (if (= mode TRUE)
    (gimp-layer-set-mode copy-layer ADDITION-MODE)
    (gimp-layer-set-mode copy-layer OVERLAY-MODE)
	)
    
    (gimp-layer-set-opacity copy-layer opacity)
	(gimp-image-merge-down img copy-layer CLIP-TO-IMAGE)

    (gimp-image-undo-group-end img)
	(gimp-context-pop)
	(gimp-displays-flush)
  )
)

; Rejestracja skryptu w menu GIMP
(script-fu-register "przem-soften-light"
  _"Soften Light..."
  _"Tworzy efekt miękkiego światła"
  "PRP"
  "Public Domain"
  "2025-07-02"
  "RGB*, GRAY*"
  SF-IMAGE "Image" 0
  SF-DRAWABLE "Drawable" 0
  SF-ADJUSTMENT "Blur Radius"    '(15 1 100 1 10 0 1)
  SF-ADJUSTMENT "Opacity (%)"    '(70 0 100 1 10 0 1)
  SF-TOGGLE "Addition mode" FALSE
)

(script-fu-menu-register "przem-soften-light"
                         "<Image>/Filters/PIETRASZCZYK/")
