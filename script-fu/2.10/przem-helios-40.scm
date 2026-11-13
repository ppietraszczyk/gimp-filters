; przem-helios-40  - Symuluje charakterystyczną kolorystykę obiektywu Helios-40
; author: PRP
; licencja: Public Domain
; Gdańsk - 14-7-2025
; ver. 2.250714-0~beta

(define (przem-helios-40 img drawable blur-amount warmth-amount bloom-effect)

  (gimp-context-push)

  ; Zapisz oryginalną selekcję
  (let* ((orig-selection (car (gimp-selection-save img))))
    
    (gimp-image-undo-group-start img)

    ; Dodaj warstwę dla efektów
    (let* ((helios-layer (car (gimp-layer-copy drawable FALSE))))
      (gimp-image-insert-layer img helios-layer 0 -1)
      (gimp-item-set-name helios-layer "Helios-40 Effect")
      
      ; Efekt ciepłych tonów
      (if (> warmth-amount 0)
          (begin
            (gimp-color-balance helios-layer 0 TRUE 0 warmth-amount 0)
            (gimp-color-balance helios-layer 1 TRUE warmth-amount 0 0)))
      
      ; Lekkie rozmycie dla charakterystycznego looku
      (if (> blur-amount 0)
          (plug-in-gauss 1 img helios-layer blur-amount blur-amount 0))
      
      ; Zmniejsz kontrast
      (gimp-brightness-contrast helios-layer 0 -20)
      
      ; Efekt bloom (dla symulacji bokeh)
      (if (> bloom-effect 0)
          (begin
            (let* ((bloom-layer (car (gimp-layer-copy helios-layer FALSE))))
              (gimp-image-insert-layer img bloom-layer 0 -1)
              (gimp-layer-set-mode bloom-layer 13) ; Tryb nakładania - Overlay
              (plug-in-gauss 1 img bloom-layer (* bloom-effect 3) (* bloom-effect 3) 0)
              (gimp-layer-set-opacity bloom-layer 50))))
      
      ; Przywróć oryginalną selekcję
      (gimp-selection-load orig-selection)
      (gimp-image-remove-channel img orig-selection))
      ;(gimp-image-merge-visible-layers img EXPAND-AS-NECESSARY)

    (gimp-image-undo-group-end img)
    (gimp-displays-flush)
    )
    (gimp-context-pop)
    )
  
(script-fu-register "przem-helios-40"
                    _"Helios-40 Effect..."
                    _"Symuluje charakterystyczną kolorystykę obiektywu Helios-40"
                    "PRP"
                    "Public Domain"
                    "2025-07-14"
                    "RGB*"
                    SF-IMAGE "Image" 0
                    SF-DRAWABLE "Drawable" 0
                    SF-ADJUSTMENT "Rozmycie (0-20)" '(3 0 20 1 1 0 0)
                    SF-ADJUSTMENT "Ciepłe tony (0-100)" '(30 0 100 1 1 0 0)
                    SF-ADJUSTMENT "Efekt bloom (0-5)" '(2 0 5 1 1 0 0))

(script-fu-menu-register "przem-helios-40"
                         "<Image>/Filters/PIETRASZCZYK/")
