#!/usr/bin/env python
import sys, os, math
#gi.require_version("Gtk", "3.0")
#from gi.repository import Gtk, Gdk,  GdkPixbuf
#from gi.repository.GdkPixbuf import Pixbuf
#import cairo

from gimpfu import *


def get_pixel_color(layer, x, y):

    #width = layer.get_width()
    #height = layer.get_height()
    width, height = layer.width, layer.height

    if x > width or y > height:
        return None
    elif x < 0 or y < 0:
        return None

    if layer.type == RGB_IMAGE:
        n_channels = 3
    elif layer.type == RGBA_IMAGE:
        n_channels = 4
    elif layer.type == GRAY_IMAGE:
        n_channels = 1
    elif layer.type == GRAYA_IMAGE:
        n_channels = 2
    else:
        raise ValueError("Unsupportet channels")

    #pixels = layer.get_pixel(x, y)
    #pixels = pixbuf.get_pixels()
    #rowstride = pixbuf.get_rowstride()
    pixel_region = layer.get_pixel_rgn(0, 0, layer.width, layer.height, False, False)






    #pixChars=pixel_region[:,:]
    #bpp=pixel_region.bpp
    #return np.frombuffer(pixChars,dtype=np.uint8).reshape(1,1,bpp)

    # Get the rowstride from the pixel region
    #rowstride = pixel_region.rowstride
    #n_channels = pixbuf.get_n_channels()

    #offset = y * pixel_region.rowstride + x * n_channels
    #pixel_data = pixel_region[offset:offset + n_channels]

    pixel_data = pixel_region[0:width, 0:height]

    width, height = layer.width, layer.height
    rowstride = width * n_channels
    #for y in range(height):
    row_start = y * rowstride
    row_end = row_start + width * n_channels
    row_data = pixel_data[row_start:row_end]
    #for x in range(width):
    r = row_data[x * n_channels]
    g = row_data[x * n_channels + 1]
    b = row_data[x * n_channels + 2]
    #a = row_data[x * n_channels + 3]

    #if layer.type == RGB_IMAGE or layer.type == RGBA_IMAGE:
    #    # Dla RGB/RGBA (R, G, B) lub (R, G, B, A)
    #    return tuple(byte for byte in pixel_data)
    #elif layer.type == GRAY_IMAGE or layer.type == GRAYA_IMAGE:
    # Dla Grayscale
    #    return tuple(byte for byte in pixel_data)
    #else:
    #    raise ValueError("Unsupported type layer")

    #red = pixels[offset]
    #green = pixels[offset + 1]
    #blue = pixels[offset + 2]
    #alpha = pixels[offset + 3] if n_channels == 4 else 255

    #return (red, green, blue, alpha)
    #return (red, green, blue)

    #if r.isdigit() and g.isdigit() and b.isdigit():
    #   if r != 0 and g != 0 and b != 0:
    #       return (r, g, b)
    #return (0, 0, 0)

    #return float(''.join(map(str, (r, g, b))))
    #if r.isdigit() and g.isdigit() and b.isdigit():
        #if r != 0 and g != 0 and b != 0:
    #res=""
    #for i in (r, g, b):
    #   res+=str(i) #str
    #    #return int(res)
    #return res
    return (r, g, b)


def sincos_func( data, sincos):

    h = True
    angle1 = 0.1
    angle2 = 0.1
    width = len(data[0])
    height = len(data)
    m = int(width / 6.666666667)+1
    print("MNOZNIK: " +str(m))
    for y in range(0, height):

        for x in range(0, width):
            mod1 = x % 30
            if mod1 == 0:
                angle1 *= -1
            mod2 = x % 30
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
            #lineY = int(25*math.sin(angle1) + y*math.cos(angle1))
            #lineX = int(25*math.sin(angle1) + x*math.cos(angle1))
            #print ("lineX: " + str(lineX) + "  lineY: " + str(lineY))
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

def create_pixbuf_from_rgb_tuples(drawable, colors, width, height):

    #pixels = bytearray()
    x = 0
    y = 0
    pixels = bytearray()
    for row in colors:
        for color in row:
            r, g, b = color  # Rozpakuj krotke (R, G, B)
            #pixels.extend([r, g, b])
    
    
            # Ustawienie koloru pierwszego planu (np. czerwony)
            if r == u"\xef" or g == u"\xef" or b == u"\xef":
                continue
            pdb.gimp_context_set_foreground(float(r), float(g), float(b))

            # Wybor pedzla (np. "Circle (11)")
            pdb.gimp_context_set_brush("Circle (01)")

            # Rysowanie linii od punktu (50, 50) do punktu (450, 450)
            points = [x, y, x, y]
            pdb.gimp_paintbrush_default(drawable, len(points), points)
            x += 1
        print("LINIA: " + str(y))
        x = 0
        y += 1
    
    """
    # Pobieranie regionu do edycji
    region = drawable.get_pixel_rgn(0, 0, width, height, True, True)

    for row in colors:
        for color in row:
            #index = y * width + x
            #if index < len(color):
            #r, g, b = rgb_list[index]
            r, g, b = color  # Rozpakuj krotke (R, G, B)
            #pixels.extend([r, g, b])
    
            region[x, y] = chr(r) + chr(g) + chr(b)
            #else:
            #region[x, y] = chr(0) + chr(0) + chr(0)
            x += 1
        x = 0
        y += 1
    drawable.flush()
    drawable.update(0, 0, width, height)
    """
    
    #return pixbuf

def plugin_func(image, drawable, args):
    
    width = image.width
    height = image.height
    duplicate_image = pdb.gimp_image_duplicate(image)
    #duplicate_drawable = pdb.gimp-image-get-active-drawable(duplicate_image)
    duplicate_drawable = duplicate_image.active_layer
    
    # Dodaj skopiowany obraz do listy obrazow w GIMPie
    #gimp.Display(duplicate_image)
    #pdb.gimp-selection-none(duplicate_image)
    #pdb.gimp-context-push()
    #pdb.gimp-context-set-defaults()
    grid = []
    for y in range (0, height):
        pix_width = []
        for x in range (0, width):
            pix_width.append(get_pixel_color(duplicate_drawable, x, y))
            #pix_width.append(drawable.get_pixel(x, y))
        grid.append(pix_width)
        print(grid)
        print("GET: " +str(y))

    sincos = []
    for y in range (0, height):
       pix_width = []
       for x in range (0, width):
           pix_width.append((255, 255, 255))
       sincos.append(pix_width)

    sincos_func(grid, sincos)
    
    #new_image = gimp.Image(width, height, RGB)
    #layer = gimp.Layer(new_image, "New Layer", width, height, RGB_IMAGE, 100, NORMAL_MODE)
    #new_image.add_layer(layer, 0)

    
    create_pixbuf_from_rgb_tuples(duplicate_drawable, sincos, width, height)
    #pdb.gimp-context-pop()

    #pdb.gimp_displays_flush()
    duplicate_drawable.flush()
    duplicate_drawable.update(0, 0, width, height)
    display = gimp.Display(duplicate_image)
    pdb.gimp_displays_flush()

whoiam='\n'+os.path.abspath(sys.argv[0])

register(
    "przem-waved-cubism",
    N_("Make waved cubism on image")+whoiam,
    "Tworzy kubistyczne falowanie na obrazie",
    "Przemyslaw R. Pietraszczyk",
    "Public Domain",
    "2025-03-04",
    N_("Waved Cubism"),
    "RGB*,GRAY*",
    [
        (PF_IMAGE, "image", "Input image", None), # type, name, description, default
        (PF_DRAWABLE, "drawable", "Input drawable", None),
        (PF_STRING, "arg", "The argument", "default-value"),
    ],
    [],
    plugin_func,
    menu="<Image>/Filters/PIETRASZCZYK/",
    #domain=("gimp30-python", gimp.locale_directory)
)

main()
