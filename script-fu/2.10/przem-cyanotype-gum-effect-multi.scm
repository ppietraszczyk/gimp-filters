; przem-cyanotype-gum-effect-multi - Efekty cyjanotypii i gumy dwuchromianowej
; author: PRP
; licencja: Public Domain
; Gdańsk - 18-06-2025
; ver. 2.250618-1

(define (przem-cyanotype-gum-effect-multi img drawable blue grain)
  ;(gimp-image-undo-group-start img)
  
  (gimp-context-push)
  (gimp-image-undo-group-start img)
  
  ; Cyjanotypia (zostaw tylko niebieski kanał)
  (let* (
    (cyan-layer (car (gimp-layer-copy drawable TRUE))))
    (gimp-image-insert-layer img cyan-layer 0 -1)
    (gimp-item-set-name cyan-layer "Cyanotype")
    (gimp-layer-set-mode cyan-layer LAYER-MODE-SCREEN) ; Tryb mieszania: Screen
    (plug-in-colors-channel-mixer TRUE img cyan-layer TRUE 0.0 0.0 1.0 0.0 0.0 1.0 0.0 0.0 1.0)
    ;(gimp-invert cyan-layer)
    (gimp-hue-saturation cyan-layer 0 blue 50 0)
  )
  
 
  
  ; Guma dwuchromianowa (sepia + ziarno)
  (let* (
    (gum-layer (car (gimp-layer-copy drawable TRUE))))
    (gimp-image-insert-layer img gum-layer 0 -1)
    (gimp-item-set-name gum-layer "Gum Bichromate")
    (gimp-layer-set-mode gum-layer LAYER-MODE-OVERLAY) ; Tryb mieszania: Overlay
    (gimp-hue-saturation gum-layer 0 40 25 0) ; Brązowy odcień
    (plug-in-noisify TRUE img gum-layer FALSE grain grain grain 0) ; Lekkie ziarno 0.1
  )
  
  (gimp-image-undo-group-end img)
  (gimp-displays-flush)
  (gimp-context-pop))


(script-fu-register "przem-cyanotype-gum-effect-multi"
  _"Add Cyanotype+Gum Multi..."
  _"Efekty cyjanotypii i gumy dwuchromianowej"
  "PRP"
  "Public Domain"
  "2025-06-18"
  "RGB*"
  SF-IMAGE "Image" 0
  SF-DRAWABLE "Drawable" 0
  SF-ADJUSTMENT "Pastel blue" '(40 30 70 1 10 1 0)
  SF-ADJUSTMENT "Grain" '(0.1 0 1 0.1 0.1 2 0))

(script-fu-menu-register "przem-cyanotype-gum-effect-multi"
                         "<Image>/Filters/PIETRASZCZYK/")

