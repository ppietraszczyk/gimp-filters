#!/usr/bin/env python3
# przem-waved-cubism - filtr dodający efekt falowania obrazu
# 2025-03-04 © Przemysław R. Pietraszczyk
# licencja: Public Domain
# edytor: Geany
# ver. 2.250306-0~beta

import gi
gi.require_version('Gimp', '3.0')
from gi.repository import Gimp
gi.require_version('GimpUi', '3.0')
from gi.repository import GimpUi
gi.require_version('Gegl', '0.4')
from gi.repository import Gegl
from gi.repository import GObject
from gi.repository import GLib
from gi.repository import Gio
import time
import sys
import math

def N_(message): return message
def _(message): return GLib.dgettext(None, message)

def sincos_func( data, sincos):

    h = True
    angle1 = 0.1
    angle2 = 0.1
    width = len(data[0])
    height = len(data)
    for y in range(0, height):

        for x in range(0, width):
            mod1 = x % 25
            if mod1 == 0:
                angle1 *= -1
            mod2 = x % 25
            if mod2 == 0:
                if h == True:
                    angle1 = 0.1
                    h = False
                else:
                    angle1 = -0.1
                    h = True

            if h == True:
                angle1 += -0.1
            else:
                angle1 += 0.1


            

            lineX = int(10*math.sin(angle1) + x)
            lineY = int(10*math.sin(angle1) + y)
            
            print ("lineX: " + str(lineX) + "  lineY: " + str(lineY))
            if lineX >= width:
                continue
            if lineY >= height:
                continue
            if lineX < 0:
                continue
            if lineY < 0:
                continue

            #if x >= width:
            #    continue
            #if y >= height:
            #    continue
            ##else:
            #    print ("ZA: "+ str(x) + "   " + str(y))
            #sincos[lineY][lineX] = (data[y][x][0], data[y][x][1], data[y][x][2])
            sincos[y][x] = (data[lineY][lineX][0], data[lineY][lineX][1], data[lineY][lineX][2])
"""
def get_pixel_color(pixbuf, x, y):
    # Pobierz szerokość i wysokość obrazu
    width = pixbuf.get_width()
    height = pixbuf.get_height()

    # Sprawdź, czy współrzędne są w granicach obrazu
    if x < 0 or x >= width or y < 0 or y >= height:
        raise ValueError("Współrzędne poza zakresem obrazu")

    # Pobierz dane pikseli
    pixels = pixbuf.get_pixels()
    rowstride = pixbuf.get_rowstride()
    n_channels = pixbuf.get_n_channels()

    # Oblicz pozycję piksela w danych
    offset = y * rowstride + x  * n_channels


    # Pobierz wartości kanałów koloru (R, G, B, A)
    red = pixels[offset]
    green = pixels[offset + 1]
    blue = pixels[offset + 2]
    alpha = pixels[offset + 3] if n_channels == 4 else 255

    #return (red, green, blue, alpha)
    return (red, green, blue)
"""

def create_pixbuf_from_rgb_tuples(drawable, colors, width, height):
    # Sprawdź, czy liczba kolorów odpowiada wymiarom obrazu
    #if len(colors) != width * height:
    #    raise ValueError("Liczba kolorów musi być równa width * height")

    # Przekształć krotki RGB na dane pikseli
    pixels = bytearray()
    x = 0
    y = 0
    for row in colors:
        for color in row:
            r, g, b = color  # Rozpakuj krotkę (R, G, B)
            pixels.extend([r, g, b])
    
    
            # Ustawienie koloru pierwszego planu (np. czerwony)
            #pdb.gimp_context_set_foreground((r, g, b))
            Gimp.context_set_foreground((r, g, b))

            # Wybór pędzla (np. "Circle (11)")
            #pdb.gimp_context_set_brush("Circle (01)")
            Gimp.context_set_brush("Circle (01)")

            # Rysowanie linii od punktu (50, 50) do punktu (450, 450)
            #pdb.gimp_paintbrush_default(drawable, 2, [x, y, x, y])
            Gimp.paintbrush_default(drawable, 2, [x, y, x, y])

            x += 1
        x = 0
        y += 1
    
    
    
    
    
    #return pixbuf

def plugin_func(procedure, run_mode, image, drawable, config, data):
    
    width = image.width
    height = image.height
    #duplicate_image = pdb.gimp_image_duplicate(image)
    #duplicate_drawable = pdb.gimp-image-get-active-drawable(duplicate_image)
    
    if run_mode == Gimp.RunMode.INTERACTIVE:
        GimpUi.init('przem-waved-cubism')

        dialog = GimpUi.ProcedureDialog(procedure=procedure, config=config)
        dialog.fill(None)
        if not dialog.run():
            dialog.destroy()
            return procedure.new_return_values(Gimp.PDBStatusType.CANCEL, GLib.Error())
        else:
            dialog.destroy()
    
    color = config.get_property('color')


    
    # Dodaj skopiowany obraz do listy obrazów w GIMPie
    #gimp.Display(duplicate_image)
    
    Gimp.context_push()
    image.undo_group_start()
    
    #pdb.gimp-selection-none(duplicate_image)
    #pdb.gimp-context-push()
    #pdb.gimp-context-set-defaults()
    grid = []
    for y in range (0, height):
        pix_width = []
        for x in range (0, width):
            #pix_width.append(get_pixel_color(duplicate_drawable, x, y))
            pix_width.append(drawable.get_pixel(x, y))
        grid.append(pix_width)

    sincos = []
    for y in range (0, height):
       pix_width = []
       for x in range (0, width):
           pix_width.append((0, 0, 0))
       sincos.append(pix_width)

    sincos_func(grid, sincos)
    create_pixbuf_from_rgb_tuples(drawable, sincos, width, height)
    
    Gimp.displays_flush()

    image.undo_group_end()
    Gimp.context_pop()


    return procedure.new_return_values(Gimp.PDBStatusType.SUCCESS, GLib.Error())



class WavedCubism (Gimp.PlugIn):
    ## GimpPlugIn virtual methods ##
    def do_set_i18n(self, procname):
        return True, 'gimp30-python', None

    def do_query_procedures(self):
        return ['przem-waved-cubism']

    def do_create_procedure(self, name):
        Gegl.init(None)

        _color = Gegl.Color.new("black")
        _color.set_rgba(0.94, 0.71, 0.27, 1.0)
        
        procedure = Gimp.Procedure.new(self, name,
                                       Gimp.PDBProcType.PLUGIN,
                                       plugin_func, None)
       
        if procedure is not None:
            
            procedure.set_image_types("RGB*, GRAY*")

            
            procedure.set_menu_label(_("Make waved cubism on image"))
            procedure.set_documentation ('Make waved cubism on image',
                                         'Make waved cubism on image',
                                         name)

            procedure.set_attribution("Przemysław R. Pietraszczyk",
                                      "Public Domain", "2025-03-04")


            #procedure.add_string_argument ("name", _("Layer _name"), _("Layer name"),
            #                           _("Clouds"), GObject.ParamFlags.READWRITE)

            procedure.add_color_argument ("color", _("_BG color"), _("BG color"),
                                      True, _color, GObject.ParamFlags.READWRITE)

            procedure.add_menu_path ("<Image>/Filters/PIETRASZCZYK")

        return procedure

Gimp.main(WavedCubism.__gtype__, sys.argv)

