;  przem-lomochrome-turquoise-v3x - całkiem wierne nawiązanie do filmu LomoChrome Turquoise
; 2026-11-01- Przemysław R. Pietraszczyk
; licence: GPL v3
; ver. 2.261101-0
(define (przem-lomochrome-turquoise-v3x image drawable)
    (let* (
        (base-layer (vector-ref drawable 0))
        )

  (gimp-image-undo-group-start image)

  ;; GIMP 3.0 używa silnika GEGL dla większości operacji na kolorach.
  ;; Używamy operacji 'gegl:channel-mixer' w celu przesunięcia kanałów.
  ;; Ustawienia symulują mapowanie kolorów Lomo Turquoise:
  ;; Kanał Czerwony: dostaje głównie komponenty niebieskie i zielone (Turkus)
  ;; Kanał Zielony: zamienia się miejscami, dostając komponenty czerwieni i niebieskiego
  ;; Kanał Niebieski: zostaje zdominowany przez zieleń i czerwień (Złoto/Pomarańcz)
  (gimp-drawable-merge-new-filter base-layer
                "gegl:channel-mixer" "Channel-mixed"  LAYER-MODE-REPLACE 0.95 "rr-gain" 0.0 "rg-gain" 0.6 "rb-gain" 0.4 "gr-gain" 0.4 "gg-gain" 0.0 "gb-gain" 0.6 "br-gain" 0.8 "bg-gain" 0.2 "bb-gain" 0.0)

  ;; Opcjonalne delikatne podbicie kontrastu i saturacji dla stylu Lomo
  (gimp-drawable-merge-new-filter base-layer "gegl:color-enhance" "color-enhance"  LAYER-MODE-REPLACE 0.90)
  (gimp-image-undo-group-end image)
  (gimp-displays-flush)
))

(script-fu-register-filter "przem-lomochrome-turquoise-v3x"
  "LomoChrome Turquoise Effect"
  "Imituje charakterystyczne przesunięcie kolorów (turkusy i złoto) znane z filmu LomoChrome Turquoise."
  "P.R.P."
  "Public Domain"
  "2026-11-01"
  "RGB*"
  SF-ONE-OR-MORE-DRAWABLE
)

(script-fu-menu-register "przem-lomochrome-turquoise-v3x" "<Image>/Filters/PIETRASZCZYK/")
