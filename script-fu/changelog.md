# [2.261112-0] przem-kodak-ultramax-400-v3x.scm
* Nowy filtr imitujący film 

# [2.261110-1] przem-lomography-redscale-xr-v3x.scm
* Nowy filtr

# [2.261107-9] przem-lomography-x-tungsten-v3x.scm
* Nowy filtr imitujący film

# [2.261102-3] przem-retro-portrait-v3x.scm
* Regres do wersji 2.261102-0

# [2.261102-2] przem-retro-portrait-v3x.scm
* Obsługa ditheringu

# [2.261101-2] przem-retro-portrait-v3x.scm
* Przebudowa filtra - na podstawie przem-warm-grayscale.scm

# [2.261101-1] przem-retro-portrait-v3.scm
* Nowy filtr nawiązujący do starej fotografii - SNAPSHOT

# [2.261101-0] przem-lomochrome-turquoise-v3x.scm
* Nowy filtr nawiązujący do filmu LomoChrome Turquoise

# [2.261024-0] przem-warm-grayscale.scm
* Odczyt profil koloru z pliku ICC - zaremowanie

# [2.261023-0] przem-warm-grayscale.scm
* Nowy filtr imitujący ciepłą czerń

# [2.260805-1] przem-sepia-dust-v3x.scm
* Kopiowanie warstw roboczych z base-layer
* FILL-BACKGROUND dla new-image

# [2.260805-0] przem-sepia-dust-v3x.scm
* Nowy filtr imitujący mleczną sepie

# [2.260802-1] przem-film-curves-v3x.scm
* Dodanie pseudo szarej sepii
* Opcjonalny HISTOGRAM-VALUE

# [2.260802-0] przem-film-curves-v3x.scm
* Uzyskanie użyteczności, jednak nie do końca o to chodziło

# [2.260801-0] przem-film-curves-v3x.scm
* Nowy filtr

# [2.260727-0]
* Dodanie katalogu SNAPSHOTS dla fitrów prealpha

# [2.260725-1] przem-apply-waves-effect-v3x.scm
* Nie faluje obrazu

# [2.260725-0] przem-apply-waves-effect-v3x.scm
* Próba portu filtra dla Gimpa 3.
* Nie widzi argumentow

# [2.260724-1] przem-hitchcock-d400-film-effect-v32.scm
* Implementacja ilości czerni i kontrastu w SF-OPTION

# [2.260722-3] przem-dramatic-light-3x.scm
* Prawdziwe dramatyczne światła i mroczny kontrast, działa ze zdjeciami kolorowymi

# [2.260722-1] przem-dramatic-light-3x.scm && przem-low-detail-v3x.scm
* Implementacja stałego ziarna w dramatic-light
* Nowy filtr redukujcy szczeguły

# [2.260722-1] przem-dramatic-light-3x.scm
* Rozpiska dla noise hsv - nie działa

# [2.260722-0] przem-dramatic-light-3x.scm
* LAYER-MODE-OVERLAY zamiast LAYER-MODE-NORMAL
* zaremowanie noise-hsv

# [2.260721-2] przem-dramatic-light-3x.scm
* Filtr tworzy dramatyczne światło, wysoki kontrast.

# [2.260721-0] przem-dramatic-light-3x.scm
* Prealpha nowego filtra 

# [2.260630-0]
* Połączenie linii filtrow dla wydań  3.0 i 3.2

# [2.260615-0] przem-hitchcock-d400-film-effect-v32.scm
* Przekopiowanie filtra dla Gimpa 3.2

# [2.260615-0] przem-hitchcock-d400-film-effect-v3.scm
* Poprawki literówek w gui

# [2.260614-1] przem-hitchcock-d400-film-effect-v3.scm
* Zakradł się błąd w nazwie

# [2.260614-0] przem-hitchock-d400-film-effect-v3.scm
* Reorganizacja kodu oraz finisz nowego filtra

# [2.260505-0] przem-surreal-v32.scm && przem-lith-effect-v32.scm
* Uzdatnienie w pelni filtra 'surreal'
* filtr 'lith' przeksztalca obraz na odcienie szarości zamiast sepii

# [2.260424-1] przem-hitchcock-d400-film-effect.scm
* Poprawka w nazwie filtra

# [2.260424-0] przem-hitchcock-d400-film-effect.scm
* Nowy filtr imitujący film Hitchcock d400 - alpha

# [2.260421-0] Repzytorium dla 3.2
* Init

# [2.260409-0] przem-teal-portrait-look-v3
* Nakłada samą warstwę MULTIPLE bez gegl:noise

# [2.260408-1] przem-teal-portrait-look-v3
* Nakłada kolorowy szum

# [2.260408-1] przem-teal-portrait-look-v3
* Czarno-biała kalka szumu

# [2.260408-0] przem-teal-portrait-look-v3
* Dodanie nowego balansu koloru - piaskowy (Sand)

# [2.260407-0] przem-teal-portrait-look-v3
* Dodanie odcieniu turkusu (nieco rozjaśnia obraz)

# [2.260406-1] przem-teal-portrait-look-v3
* Przyciemnienie, podbicie kontrastu, lekko przyduszona globalnie saturacja. Podbicie cyjanów i zieleni. Oraz Delikatne ocieplenie tonów skóry.

# [2.260406-0] przem-teal-portrait-look-v3
* Spojżenie na udany portret - nieskończone

# [2.260118-0] przem-surreal-v3
* Od teraz, filtr współpracuje z obrazami z odcieniami szarości

# [2.26016-1] przem-add-background-under-text-v3.scm  przem-apply-sepia-v3.scm
* przem-add-background-under-text-v3 : Dodaje kolorowy napis zrówno na obrazach kolorowych jaki odcieniach szarości
* przem-apply-sepia-v3 : tworzy sepie zarówno z kolorowych jak i czarnobialych zdjęć
* przem-apply-sepia-v3 : widać szachownicę przeźroczystości - również po zapisie do jpg

# [2.260116-0] przem-add-background-under-text-v3.scm
* Porządki, jednak filtr dalej nie dodaje kolorwego napisu do obrazów czarno-bialych

# [2.260109-0] przem-lith-effect-v3.scm, przem-surreal-v3.scm
* Dodanie checkboxa z wyborem odcienia dla Obróbki Litowej
* gegl:color dla surreal

# [2.260108-0]  przem-lith-effect-v3.scm
* Finalna wersja odbitki litowej

# [2.251225-1]  przem-lith-effect-v3.scm
* Propozycja nowej wtyczki dt. Odbitki Litowej

# [2.251225-0] przem-surreal-v3.scm
* gimp-colorize przez GEGL - schładzanie zdjęcia

# [2.251224-0] przem-surreal-v3.scm
* Implementacja script-fu imitującego surrealistyczne obrazy 

# [2.251104-1] przem-true-cyjanotype-v3.scm
* Implementacja krzywych tonalnych w wersji v3

# [2.251014-1] przem-true-cyjanotype-v3.scm
* Wstępna wersja, namiastka z wersji 2.10

# [2.251014-0] przem-true-cyjanotype-v3.scm
* Pierwsze koty za płoty z portem kolejnego filtra

# [2.251006-0] przem-ilford-expired-v3.scm
* Nadanie wartwom transparentności
* Polączenie i uwidoczniene powstałej warstwy

# [2.251005-0] przem-ilford-expired-v3.scm
* Nowy filtr, imitujący przeterminowane kolorowe filmy Ilforda

# [2.251001-0] przem-oldschool-photography-v3.scm
* Kolorowa fotografia przedwojenna, uzyskiwana za pomocą zmiany temeratury barwowej

# [2.250929-0] przem-kodachrome-v3.scm
* Ostateczne zmiany w script-fu dotyczącego imitacji Kodachrome, zmiana nazwy.

# [2.250926-0] przem-oldschool-photography-v3.scm
* Zdjęcia Chromatc dla  wersji 3.0
 
# [2.250925-2] przem-oldschool-photography-v3.scm przem-oldschool-photography.scm
* Nowe fitry dotyczące fotografi tradycyjnej

# [2.250923-0] przem-burlesque-effect
* Nowy filtr imitujący burleske z winietowaniem

# [2.250922-1] przem-true-cyjanotype.scm
* Próby podmiany czarnej barwy na navy - bez sukcesu

# [2.250922-0] przem-true-cyjanotype.scm
* Revers kolorów, zbliżamy się do ideału

# [2.250921-0] przem-true-cyjanotype.scm
* Nowy filtr, z nowym podejsćiem do cyjanotypii - bliższemu tradycyjnemu ideałowi 

# [2.250901-0] przem-sunset-effect-v3.scm
* Nowy filtr z imitacją zachodu słońca

# [2.250824-2] przem-cyanotype-color-effect-multi-v3.scm
* Uproszczona konwersja (bez gumy) przem-cyanotype-gum-effect.scm

# [2.250824-1] przem-wet-collodion-v3
* dodanie opcji MODE dla rozmycia z trybami: AUTO, IIR, FIR

# [2.250824-0] przem-wet-collodion-v3
* Mokry kolodion dla Gimpa 3.0

# [2.250802-0] przem-serigraphy
* Dodanie nowego filtra przem-serigraphy dla 2.10

# [2.250718-0] przem-wey-collodion
* Uspawnienia 

# [2.250715-0] przem-wet-collodion
* Mokry kolodion

# [2.250714-0] przem-helos-40
* Dodanie symulacji charakterystycznej kolorystyki obiektywu Helios-40

# [2.250712-0] przem-prossian-blue-effect-v3.scm
* Dodałem tryby mieszania warstwy
* Snapshot dla Helios-40.scm

# [2.250711-0] przem-prossian-blue-effect-v3.scm
* Dodałem łączenie warstw, więc można już dodać na przykład ramkę

# [2.250710-0] przem-prossian-blue-effect-v3.scm
* Port filtra dla Gimpa 3.0 

# [2.250622-0] przem-prossian-blue-effect.scm
* Dodane filtra imitującego "pruski błękit"

# [2.250619-3] przem-soft-focus-noninteractive-v3.scm
* Dodanie filtra wywolywanego z linii poleceń - nie uruchamia się

# [2.250618-0] przem-cyanotype-gum-effect.scm
* Dodanie efektu zastosowania cyjanotypi wraz z gumą dwuchromianową\

# [2.250616-0] przem-soft-focus-noninteractive.scm
* Dodanie filtra wywolywanego z linii poleceń

# [2.250615-0] przem-soft-focus.scm
* Dodanie filtra "miękkiego focusa' - w nawiązaniu do piktorializmu

# [2.250610-4] przem-expired-negative.scm
* Konwersja z RGB na colorspace Gray

# [2.250610-3] przem-expired-negative.scm
* Dzielnik mgły, zwiększony do 0.50

# [2.250610-2] przem-expired-negative.scm
* Dodanie suwaka density

# [2.250610-1] przem-expired-negative.scm
* Przy odwolywaniu się do wspólnej funkcji gradientu - filtr dzialą nieprawidlowo
* Możliwa zmiana odcieniu gradientu (background)

# [2.250608-3] przem-expired-negative.scm
* Dodaje efekt prawidłowo, zarówno na dole jak i na górze

# [2.250608-2] przem-expired-negative.scm
* Dodaje efekt expire ORWO do poziomego zdjęcia, jednak nie równomiernie

# [2.250525-1] przem-expired-negative.scm
* Rozróżnia rodzaj obrazu. Jednak prawidłowo przetwarza jedynie póki co portrety

# [2.250522-4] przem-expired-negative.scm
* Mgła jest prawidłowo rozmieszczana po przegach

# [2.250522-0] przem-expired-negative.scm
* Filtr imitujący przetermonowany negatyw ORWO - Inicjacja

# [2.250225-2] przem-apply-waves-effect.scm
* Filtr, działać, działa. Jednak wynik, trudno uzanć za falowanie.

# [2.250225-1] przem-apply-waves-effect.scm
* Pierwszy mały sukces

# [2.250225-0] przem-apply-waves-effect.scm
* Próba skopiowania barwy pixela

# [2.250224-0] przem-apply-waves-effect.scm
* Nowa propozycja z sincosinus

# [2.250223-3] przem-apply-cents-effect.scm
* Drobne literówki 

# [2.250223-2] przem-apply-cents-effect.scm
* Dodanie nowego filtra - centkowanie

# [2.250223-0] przem-apply-waves-effect.scm
* Dodanie nowego filtra

# [2.250222-0] przem-apply-sepia-v3.scm
* Korekta w SF_OPTION

# [2.250221-0] przem-apply-sepia-v3.scm
* Dodanie potrójnego pola wyboru dla rodzaju gradientu.

# [2.25021=20-0] przem-apply-sepia-v3.scm
* Przeniesienie 'gimp-layer-new' do wewnątrz skryptu - desaturate dalej zwraca błąd przy zdjęciach monochromatycznych

# [2.250219-1] przem-apply-sepia-v3.scm
* Dodanie 'gimp-image-flatten', bez efektu 

# [2.250219-0]  przem-apply-sepia-v3.scm
* Dodanie suwaka z shadow-sepia użytego jako argument 'gimp-drawable-edit-gradient-fill'

# [2.250217-0] przem-traditional-photo.scm && przem-traditional-photo-v3.scm
* Zmniejszyłem skrajne parametry do -100 i 100 dla skali kontrastu i balansu koloru

# [2.250216-3] przem-traditional-photo-v3.scm
* Dodanie krosowania. Jednak można odnieść wrażenie że zmiana balans koloru nie daje żądnego efektu

# [2.250216-2] przem-traditional-photo-v3.scm
* Rezygnacja ze suwaka kontrastu na rzecz zmiennej ( -0.15625 )- możliwe że wersja dla 2.10 wykrzącza się przez zbyt wysoki argument dla kontrastu

# [2.250216-1] przem-traditional-photo.scm
* Kosmetyka danych suwaka

# [2.250216-0] przem-traditional-photo.scm
* Dodanie suwaka ze zmianą kontrastu oraz suwaka z balansem koloru

# [2.250215-2] przem-traditional-photo.scm
* dodanie nowego skryptu korsującego zdjęcie

# [2.250215-1] przem-apply-sepia.scm - przem-add-background-under-text.scm
* Oba skrypty pracują nieprawidłowo z obrazem w odcieniach szarości

# [2.250215-0] przem-apply-sepia.scm
* BUG ? Nie potrafi przekonwertować obrazka GRAY na RGB - w przypadku szarego obrazu nakłąda jedynie gradient, bez sepii

# [1.250214-0] przem-apply-sepia.scm
* Częściowe dostosowanie wtyczki do nowego API z RC2 - póki co przetwarza jedynie kolorowe obrazy

# [1.250213-0]  przem-apply-sepia.scm
* Dodałem lepszy gradient, revers gradientu oraz kształt okręgu

# [1.250212-0] przem-apply-sepia.scm
* Opruje już jedynie na dwóch odcieniach sepii

# [1.250212-0] przem-add-background-under-text.scm
* Możliwość zmiany koloru tła i czcionki wewnątrz wtyczki, nie można zmienić czcionki. Potrafi się wykrzaczyć

# [1.250910-0~alpha]
* Wersja alpha 'przem-add-background-under-text.scm', pokazuje samo tło i w dodatku w złym miejscu

# [1.250910-2]
* Wersja stabilna 'przem-apply-sepia.scm' dla 3.0

# [1.250209-1]
* Wersja stabilna 'przem-add-background-under-text.scm' dla 2.10

# [0.250207-0]
* Incjacja skryptu 'przem-apply-sepia.scm'

# [0.250206-0]
* Incjacja skryptu 'przem-add-background-under-text.scm'
