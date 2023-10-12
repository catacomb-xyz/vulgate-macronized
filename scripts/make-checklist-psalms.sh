#!/bin/bash

set -x

SCRIPT_DIR=$(realpath $(dirname "$0"))
cd $SCRIPT_DIR

rm -rf psalms
mkdir psalms

readarray -t ARRAY < ../01-vetus-testamentum/21-psalmi/checklist.txt

for i in "${ARRAY[@]}"
do
  NUM="$i"
  ./make-chapter-pdf.sh ../01-vetus-testamentum/21-psalmi/$NUM.txt PSALMUS
  mv out.pdf psalms/$NUM.pdf
done

