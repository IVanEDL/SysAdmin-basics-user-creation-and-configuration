#!/bin/bash

sudo rsync -a --delete /home ./backup_$(date '+%Y%m%d_%H%M%S')

# Nota para Ivan mañana. Esto está bien pero no funciona, si resuelvo para que funcione es añadirle un crontab -e y editarlo de modo que se active cada semana a las 12am o alguna pendejada parecida.


