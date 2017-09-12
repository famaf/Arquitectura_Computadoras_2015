#!/usr/bin/python
# Nota: requiere instalar python-imaging

import sys
from PIL import Image, ImageDraw

# Colores para representar: del negro al rojo, al amarillo, al blanco
palette = [(i,0,0) for i in range(256)]+[(255,i,0) for i in range(256)]+[(255,255,i) for i in range(256)]

# Leer matriz y calcular valor maximo para escalar colores
top = -float("inf")
T = []
for l in sys.stdin:
    row = map(float, l.split())
    T.append(row)
    top = max(top, max(row))
N = len(T)

# Generar imagen
output = Image.new("RGB", (N, N))
draw = ImageDraw.Draw(output)
for y, row in enumerate(T):
    for x, value in enumerate(row):
        cindex = int((len(palette)-1)*value/top)
        color = palette[cindex]
        draw.point([x,y], color)

# Mostrar (ampliando/reduciendo si hace falta)
output.resize((600, 600)).show()
