; przem-lomography-redscale-xr - zupełne luźne nawiązanie do filmu Lomography Redscale XR 35 mm - jest zbyt czerwono
; Przmeysław R. Pietraszczyk
; 2026-11-10
; ver 2.261110-0
; editor: Kate

(define (przem-lomography-redscale-xr image drawable iso-setting)
  (let* (
         (curve-size 256)
         (red-array   (cons-array (* 2 curve-size) 'byte))
         (green-array (cons-array (* 2 curve-size) 'byte))
         (blue-array  (cons-array (* 2 curve-size) 'byte))
         (i 0)
         ;; intensity-factor: 0.0 przy ISO 50, 1.0 przy ISO 200
         (intensity-factor (/ (- iso-setting 50) 150.0))
         (layer (vector-ref drawable 0))
        )

    (gimp-image-undo-group-start image)

    ;; ===== KRZYWA CZERWONA =====
    ;; Łagodne rozjaśnienie cieni, ale BEZ przesady.
    ;; Wykładnik 0.85 -> 0.95 (mniej agresywnie niż 0.60).
    (set! i 0)
    (while (< i curve-size)
      (let* ((x (/ i 255.0))
             (y 0.0))
        ;; im wyższe ISO, tym bardziej "płaska" krzywa (mniej rozjaśnienia)
        (set! y (* 255.0 (expt x (- 0.95 (* 0.10 intensity-factor)))))
        ;; delikatne podbicie w wysokich światłach tylko przy ISO > 150
        (if (> iso-setting 150)
            (set! y (min 255 (+ y (* 8 intensity-factor)))))
        (vector-set! red-array (* 2 i) i)
        (vector-set! red-array (+ (* 2 i) 1) (inexact->exact (round y)))
        (set! i (+ i 1))))

    ;; ===== KRZYWA ZIELONA =====
    ;; KLUCZ: zieleń MUSI pozostać wysoka w światłach, żeby dać ŻÓŁĆ.
    ;; Tłumimy tylko cienie i półcienie (rdzawy odcień), nie światła.
    (set! i 0)
    (while (< i curve-size)
      (let* ((x (/ i 255.0))
             (y 0.0))
        ;; x^1.15 – lekko przyciemnione cienie, światła prawie bez zmian
        (set! y (* 255.0 (expt x 1.15)))
        ;; przy ISO > 100 lekkie obniżenie zieleni w środku tonalnym,
        ;; ale NIE w światłach (mnożnik zależny od x)
        (if (> iso-setting 100)
            (set! y (* y (- 1.0 (* 0.20 intensity-factor (- 1.0 x))))))
        (vector-set! green-array (* 2 i) i)
        (vector-set! green-array (+ (* 2 i) 1)
                     (inexact->exact (round (max 0 (min 255 y)))))
        (set! i (+ i 1))))

    ;; ===== KRZYWA NIEBIESKA =====
    ;; Mocne, równomierne obcięcie – bez podnoszenia w cieniach!
    (set! i 0)
    (while (< i curve-size)
      (let* ((x (/ i 255.0))
             (y 0.0))
        ;; x^2.2 -> 2.6 w zależności od ISO (mocniejsze cięcie przy wyższym ISO)
        (set! y (* 255.0 (expt x (+ 2.2 (* 0.4 intensity-factor)))))
        (vector-set! blue-array (* 2 i) i)
        (vector-set! blue-array (+ (* 2 i) 1)
                     (inexact->exact (round (max 0 (min 255 y)))))
        (set! i (+ i 1))))

    ;; ===== APLIKACJA =====
    (gimp-drawable-curves-spline layer HISTOGRAM-RED   red-array)
    (gimp-drawable-curves-spline layer HISTOGRAM-GREEN green-array)
    (gimp-drawable-curves-spline layer HISTOGRAM-BLUE  blue-array)

    (gimp-image-undo-group-end image)
    (gimp-displays-flush)))

;; ===== REJESTRACJA =====
(script-fu-register-filter
  "przem-lomography-redscale-xr"
  "Lomography Redscale XR 50-200"
  "Symuluje film Lomography Redscale XR. Zmień ISO, aby uzyskać różne odcienie."
  "P.R.P>"
  "MIT"
  "2026-11-10"
  "RGB*"
  SF-ONE-OR-MORE-DRAWABLE
  SF-ADJUSTMENT "ISO (50-200)" '(200 50 200 1 10 0 1))

(script-fu-menu-register "przem-lomography-redscale-xr"
                         "<Image>/Filters/PIETRASZCZYK/")

