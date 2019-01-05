#!/bin/bash

MONITORDIR="/home/docker/consume/"
DONEDIR="/home/docker/done/"
inotifywait -m -r -e close_write --format '%f' "${MONITORDIR}" | 
	while read file; do
		ocrmypdf -l dan --deskew --clean --rotate-pages --skip-text "${MONITORDIR}/${file}" "${DONEDIR}/${file%.*}.pdf"
	done
