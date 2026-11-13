; przem-film-curves-v3x Nakłada filmowe krzywe na obraz.
; Przmeysław R. Pietraszczyk
; 2026-08-01
; ver 2.260802-1
; editor: Kate

;; Krzywa luminancji
  (define curve-luma-sepia
    #(
      0 2 4 6 8 10 12 14 16 18
      20 22 24 26 28 30 32 34 36 38
      40 42 44 46 48 50 52 54 56 58
      60 62 64 66 68 70 72 74 76 78
      80 82 84 86 88 90 92 94 96 98
      100 103 106 109 112 115 118 121 124 127
      130 133 136 139 142 145 148 151 154 157
      160 163 166 169 172 175 178 181 184 187
      190 192 194 196 198 200 202 204 206 208
      210 212 214 216 218 220 222 224 226 228
      230 232 234 236 238 240 242 244 246 248
      250 251 252 253 254 255
    )
  )

  ;; Filmowy split-tone: ciepłe cienie, chłodne światła
  (define curve-blue-sepia
    #(
      0 0 1 2 3 4 5 6 7 8
      9 10 11 12 13 14 15 16 17 18
      19 20 21 22 23 24 25 26 27 28
      29 30 31 32 33 34 35 36 37 38
      39 40 41 42 43 44 45 46 47 48
      49 50 51 52 53 54 55 56 57 58
      59 60 61 62 63 64 65 66 67 68
      69 70 71 72 73 74 75 76 77 78
      79 80 81 82 83 84 85 86 87 88
      89 90 91 92 93 94 95 96 97 98
      99 100 102 104 106 108 110 112 114 116
      118 120 122 124 126 128 130 132 134 136
      138 140 142 144 146 148 150 152 154 156
      158 160 162 164 166 168 170 172 174 176
      178 180 182 184 186 188 190 192 194 196
      198 200 202 204 206 208 210 212 214 216
      218 220 222 224 226 228 230 232 234 236
      238 240 242 244 246 248 250 252 254 255
    )
  )

  ;; Ocieplenie średnich tonów
  (define curve-red-sepia
    #(
      0 1 2 3 4 5 6 7 8 9
      10 11 12 13 14 15 16 17 18 19
      20 21 22 23 24 25 26 27 28 29
      30 31 32 33 34 35 36 37 38 39
      40 41 42 43 44 45 46 47 48 49
      50 52 54 56 58 60 62 64 66 68
      70 72 74 76 78 80 82 84 86 88
      90 92 94 96 98 100 102 104 106 108
      110 112 114 116 118 120 122 124 126 128
      130 132 134 136 138 140 142 144 146 148
      150 152 154 156 158 160 162 164 166 168
      170 172 174 176 178 180 182 184 186 188
      190 192 194 196 198 200 202 204 206 208
      210 212 214 216 218 220 222 224 226 228
      230 232 234 236 238 240 242 244 246 248
      250 251 252 253 254 255
    )
  )

  ;; Delikatne ochłodzenie świateł
  (define curve-green-sepia
    #(
      0 1 2 3 4 5 6 7 8 9
      10 11 12 13 14 15 16 17 18 19
      20 21 22 23 24 25 26 27 28 29
      30 31 32 33 34 35 36 37 38 39
      40 41 42 43 44 45 46 47 48 49
      50 51 52 53 54 55 56 57 58 59
      60 61 62 63 64 65 66 67 68 69
      70 71 72 73 74 75 76 77 78 79
      80 81 82 83 84 85 86 87 88 89
      90 91 92 93 94 95 96 97 98 99
      100 101 102 103 104 105 106 107 108 109
      110 111 112 113 114 115 116 117 118 119
      120 121 122 123 124 125 126 127 128 129
      130 131 132 133 134 135 136 137 138 139
      140 141 142 143 144 145 146 147 148 149
      150 152 154 156 158 160 162 164 166 168
      170 172 174 176 178 180 182 184 186 188
      190 192 194 196 198 200 202 204 206 208
      210 212 214 216 218 220 222 224 226 228
      230 232 234 236 238 240 242 244 246 248
      250 251 252 253 254 255
    )
  )

  (define curve-red
  #(0 0 64 55 128 120 192 185 255 255)
  )
  (define curve-green
  #(0 0 64 55 128 118 192 180 255 255)
  )
  (define curve-blue
  #(0 0 64 70 128 150 192 210 255 255)
  )
  (define curve-luma
  #(0 0 64 40 128 140 192 210 255 255)
  )



(define (przem-film-curves-v3x img drawable mono sepia value)

  (gimp-context-push)
  (gimp-image-undo-group-start img)

  (let* ((base-layer (vector-ref drawable 0))
        (type (car (gimp-drawable-type-with-alpha base-layer))))

        (if (= mono TRUE) (begin
          (if (= type RGBA-IMAGE)
            (gimp-drawable-desaturate base-layer DESATURATE-LUMINANCE))))

        (let* (
          (luma-layer (car (gimp-layer-copy base-layer TRUE)))
          (red-layer (car (gimp-layer-copy base-layer TRUE)))
          (green-layer (car (gimp-layer-copy base-layer TRUE)))
          (blue-layer (car (gimp-layer-copy base-layer TRUE))))

          ;; Zastosowanie krzywych
          ;(gimp-drawable-curves-spline luma-layer HISTOGRAM-LUMINANCE curve-luma)
          ; Błąd w PDB Gimpa wyklucza HISTOGRAM-LUMINANCE i trzeba obchodzić przez HISTOGRAM-VALUE
          (if (= value TRUE) (begin
            (gimp-image-insert-layer img luma-layer 0 -1)
            (if (= sepia TRUE) (begin
              (gimp-drawable-curves-spline luma-layer HISTOGRAM-VALUE curve-luma-sepia))
              (begin
                (gimp-drawable-curves-spline luma-layer HISTOGRAM-VALUE curve-luma)))
            (gimp-layer-set-mode luma-layer LAYER-MODE-OVERLAY)
            (gimp-layer-set-opacity luma-layer 100)))

          (gimp-image-insert-layer img red-layer 0 -1)
          (if (= sepia TRUE) (begin
            (gimp-drawable-curves-spline red-layer HISTOGRAM-RED curve-red-sepia))
            (begin
              (gimp-drawable-curves-spline red-layer HISTOGRAM-RED curve-red)))
          (gimp-layer-set-mode red-layer LAYER-MODE-OVERLAY)
          (gimp-layer-set-opacity red-layer 90)

          (gimp-image-insert-layer img green-layer 0 -1)
          (if (= sepia TRUE) (begin
            (gimp-drawable-curves-spline green-layer HISTOGRAM-GREEN curve-green-sepia))
            (begin
              (gimp-drawable-curves-spline red-layer HISTOGRAM-GREEN curve-green)))
          (gimp-layer-set-mode green-layer LAYER-MODE-OVERLAY)
          (gimp-layer-set-opacity green-layer 80)

          (gimp-image-insert-layer img blue-layer 0 -1)
          (if (= sepia TRUE) (begin
            (gimp-drawable-curves-spline blue-layer HISTOGRAM-BLUE curve-blue-sepia))
            (begin
              (gimp-drawable-curves-spline red-layer HISTOGRAM-BLUE curve-blue)))
          (gimp-layer-set-mode blue-layer LAYER-MODE-OVERLAY)
          (gimp-layer-set-opacity blue-layer 70)
        )

 ;(let* ((merged-layer (car (gimp-image-merge-visible-layers img CLIP-TO-IMAGE))))
;			(gimp-item-set-visible merged-layer TRUE))

  )
  (gimp-image-undo-group-end img)
  (gimp-displays-flush)
  (gimp-context-pop)
)

(script-fu-register-filter
 _"przem-film-curves-v3x"
 _"Film curves"
 "Nakłada filmowe krzywe na obraz"
 "PRP"
 "Public Domain"
 "2026-08-01"
 "*"
 SF-ONE-OR-MORE-DRAWABLE
 SF-TOGGLE "_Monochromatic" TRUE
 SF-TOGGLE "_Sepia" FALSE
 SF-TOGGLE "_Value" FALSE

)

(script-fu-menu-register "przem-film-curves-v3x" "<Image>/Filters/PIETRASZCZYK/")
