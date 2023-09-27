#!/bin/bash

set -x

FILE="$1"
TITLE="$2"

SCRIPT_DIR=$(dirname "$0")
LA_DIR=$(dirname "$FILE")
EN_DIR=$LA_DIR/english
TMP_DIR=$SCRIPT_DIR/.tmp

rm -rfv $TMP_DIR
mkdir -v $TMP_DIR

NUM=$(basename --suffix=".txt" "$FILE")
echo $TMP_DIR/$NUM

F_TMP="$TMP_DIR"/"$NUM".tmp

# add verse number
nl -w1 -s'}\hspace{1ex}{\Large ' $FILE > $F_TMP
# format verse number
sed -i 's/^/\\filbreak\\noindent\\textsuperscript{ /' $F_TMP
# end of line
sed -i 's/$/}\\newline/' $F_TMP

F_EN="$EN_DIR"/"$NUM".txt
F_EN_TMP="$TMP_DIR"/"$NUM"EN.tmp

cp $F_EN $F_EN_TMP
# format english text
sed -i 's/^/\\noindent{\\scriptsize /' $F_EN_TMP
# end of line
sed -i 's/$/}/' $F_EN_TMP

F_TEX=$TMP_DIR/$NUM.tex
# interleave
awk '{print; if(getline < "'$F_EN_TMP'") print}' $F_TMP >> $F_TEX

# line breaks
sed -i '0~2 a\\' $F_TEX

# chapter title
NAME=$(basename --suffix=".tex" "$F_TEX")
NUM=$((10#$NAME))
STR="\\\section{$TITLE $NUM}"
sed -i "1s/^/$STR/" $F_TEX
echo "\Needspace{8\baselineskip}" >> $F_TEX

echo """
\documentclass[10pt,openany]{book}

\usepackage{fontspec}

\setmainfont [
  Path = ./../fonts/charis-sil/,
  Extension = .ttf,
  UprightFont = *R,
  BoldFont = *B,
  ItalicFont = *I,
  BoldItalicFont= *BI,
]{CharisSIL}

\usepackage{indentfirst}
\usepackage[skip=10pt plus1pt, indent=0pt]{parskip}

\usepackage{titlesec}
\usepackage{needspace}

\titleformat{\chapter}
  {\normalfont\LARGE\bfseries\centering}{\thechapter}{1em}{}
\titlespacing*{\chapter}{0pt}{-40pt}{30pt}

\titleformat{\section}
  {\LARGE\bfseries\centering}{\thesection}{1em}{}

\setcounter{secnumdepth}{0}

\usepackage[
  papersize={8.75in,11.25in},
  layout=letterpaper,
  layouthoffset=0.125in,
  layoutvoffset=0.125in,
  right=0.75in,
  left=0.75in,
  top=1.25in,
  bottom=1.25in
]{geometry}

\usepackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}
\fancyheadoffset[]{-2.0in}
\fancyfootoffset[]{-2.0in}
\fancyhead[CE,CO]{\textsl{\rightmark}}
%\fancyhead[RE]{\textsl{\leftmark}}
\fancyfoot[C]{\thepage}
\setlength{\headheight}{15pt}
\renewcommand{\footrulewidth}{0.4pt}% default is 0pt

\hyphenpenalty 10000
\exhyphenpenalty 10000

\begin{document}

\begin{flushleft}
""" >> $TMP_DIR/000.tex

echo """
\end{flushleft}

\end{document}
""" >> $TMP_DIR/999.tex

cat $TMP_DIR/*.tex > $TMP_DIR/out.tex

xelatex -halt-on-error -output-directory $TMP_DIR $TMP_DIR/out.tex

cp $TMP_DIR/*.pdf $SCRIPT_DIR
