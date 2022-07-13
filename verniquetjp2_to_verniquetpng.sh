#!/bin/bash

for FILE in verniquet_digitalization/ATLAS_VERNIQUET_1791/*; do
    x=${FILE%.jp2}
    echo "converting ${FILE##*/}"
    convert -monitor $FILE "cantaloupdata/${x##*/}.png"
    # echo "cantaloupdata/${x##*/}.png"
done
