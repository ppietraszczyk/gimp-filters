; przem-serigraphy - imituje efekt mokrego kolodionu
; author: PRP
; licencja: Public Domain
; Gdańsk - 02-08-2025
; ver. 2.250802-0~beta

(define (przem-serigraphy img drawable levels detail transparency dark-color light-color)
  (let* (
        (width (car (gimp-image-width img)))
        (height (car (gimp-image-height img)))
        (old-bg (car (gimp-context-get-background)))
        (old-fg (car (gimp-context-get-foreground)))
        (layer-copy (car (gimp-layer-copy drawable FALSE)))
        ;(gamma 0)
        )
        
    (gimp-context-push)
    (gimp-image-undo-group-start img)
    
    ; Ustaw kolory
    (gimp-context-set-background light-color)
    (gimp-context-set-foreground dark-color)
    
    ; Utwórz kopię warstwy do pracy
    (gimp-image-insert-layer img layer-copy 0 -1)
    (gimp-item-set-name layer-copy "Serigraphy Effect")
    (gimp-layer-set-mode layer-copy LAYER-MODE-MULTIPLY)
    
    ; Konwersja do czarno-białego z kontrolą poziomów
    (gimp-desaturate-full layer-copy DESATURATE-LIGHTNESS)
    ;(set! gamma (truncate (/ 10 (- levels 1))))
    (gimp-levels layer-copy HISTOGRAM-VALUE 0 200 (/ 10 (- levels 1)) 0 255)
    
    ; Wzmocnij krawędzie dla efektu sitodruku
    (plug-in-unsharp-mask RUN-NONINTERACTIVE img layer-copy 5.0 0.5 0)
    
    ; Utwórz warstwę koloru tła
    (let* ((bg-layer (car (gimp-layer-new img width height RGB-IMAGE "Background" 100 LAYER-MODE-NORMAL))))
      (gimp-image-insert-layer img bg-layer 0 -1)
      (gimp-drawable-fill bg-layer FILL-BACKGROUND)
      (gimp-layer-set-opacity bg-layer transparency)

      ; Połącz warstwy dla końcowego efektu
      (let* ((merged (car (gimp-image-merge-down img layer-copy CLIP-TO-IMAGE))))
        (gimp-item-set-name merged "Serigraphy Output")
      )
    )
    
    ; Przywróć oryginalne kolory
    (gimp-context-set-background old-bg)
    (gimp-context-set-foreground old-fg)
    
    (gimp-image-undo-group-end img)
    (gimp-context-pop)
    (gimp-displays-flush)
  )
)

(script-fu-register "przem-serigraphy"
  _"Serigraphy..."
  _"Tworzy efekt serigrafii (sitodruku)"
  "PRP"
  "Public Domain"
  "2025-08-02"
  "RGB* GRAY*"
  SF-IMAGE "Image" 0
  SF-DRAWABLE "Drawable" 0
  SF-ADJUSTMENT "Color levels" '(4 2 8 1 1 0 0)
  SF-ADJUSTMENT "Details" '(0.5 0.1 1.0 0.1 0.1 1 0)
  SF-ADJUSTMENT "Background transparency" '(1 1 10 1 1 1 0)
  SF-COLOR "Dark color" '(50 50 150)
  SF-COLOR "Light color" '(250 240 200)
  
)

(script-fu-menu-register "przem-serigraphy"
                         "<Image>/Filters/PIETRASZCZYK/")
