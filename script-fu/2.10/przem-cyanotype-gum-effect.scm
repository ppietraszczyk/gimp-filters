; przem-cyanotype-gum-effect - Tworzy efekt zastosowania cyjanotypi wraz z gumą dwuchromianową
; author: PRP
; licencja: Public Domain
; Gdańsk - 18-09-2025
; ver. 2.250618-0

(define (przem-cyanotype-gum-effect img drawable)
  (gimp-context-push)
  (gimp-image-undo-group-start img)
  
  ; Cyjanotypia
  (plug-in-colors-channel-mixer TRUE img drawable TRUE 0.0 0.0 1.0  0.0 0.0 1.0  0.0 0.0 1.0) ; Tylko niebieski kanał
  
  ; Efekt gumy
  (gimp-colorize drawable 40 25 0) ; Brązowe barwienie
  
  (gimp-image-undo-group-end img)
  (gimp-displays-flush)
  (gimp-context-pop))


(script-fu-register "przem-cyanotype-gum-effect"
  _"Add Cyanotype+Gum..."
  _"Łączy efekt cyjanotypii i gumy dwuchromianowej"
  "PRP"
  "Public Domain"
  "2025-06-18"
  "RGB*"
  SF-IMAGE "Image" 0
  SF-DRAWABLE "Drawable" 0)

(script-fu-menu-register "przem-cyanotype-gum-effect"
                         "<Image>/Filters/PIETRASZCZYK/")
