#!/bin/bash

set -x

SCRIPT_DIR=$(dirname "$0")

LA_DIR=$SCRIPT_DIR/../02-novum-testamentum/02-marcus/
EN_DIR=$SCRIPT_DIR/../02-novum-testamentum/02-marcus/english
TMP_DIR=$SCRIPT_DIR/.tmp

rm -rfv $TMP_DIR
mkdir -v $TMP_DIR

for F in $LA_DIR/*.txt
do
  NUM=$(basename --suffix=".txt" "$F")
  echo $TMP_DIR/$NUM

  F_TMP="$TMP_DIR"/"$NUM".tmp

  nl -w1 -s'}\hspace{1ex}{\Large ' $F > $F_TMP
  sed -i 's/^/\\filbreak\\noindent\\textsuperscript{\\color{red} /' $F_TMP
  sed -i 's/$/}\\newline/' $F_TMP

  F_EN="$EN_DIR"/"$NUM".txt
  F_EN_TMP="$TMP_DIR"/"$NUM"EN.tmp

  cp $F_EN $F_EN_TMP
  sed -i 's/^/\\noindent{\\scriptsize /' $F_EN_TMP
  sed -i 's/$/}/' $F_EN_TMP

  awk '{print; if(getline < "'$F_EN_TMP'") print}' $F_TMP >> $TMP_DIR/$NUM.tex
done

# line breaks
for F in $TMP_DIR/*.tex
do
  sed -i '0~2 a\\' $F
done

# chapter title
for F in $TMP_DIR/*.tex
do
  NAME=$(basename --suffix=".tex" "$F")
  NUM=$((10#$NAME))
  STR="\\\section{SECUNDUM MARCUM $NUM}"
  sed -i "1s/^/$STR/" $F
  echo "\Needspace{8\baselineskip}" >> $F
done

# replace macron with apex (accent)
#for F in $TMP_DIR/*.tex
#do
  #sed -i "s/Ā/Á/g" $F
  #sed -i "s/Ē/É/g" $F
  #sed -i "s/Ī/Í/g" $F
  #sed -i "s/Ō/Ó/g" $F
  #sed -i "s/Ū/Ú/g" $F
  #sed -i "s/Ȳ/Ý/g" $F
  #sed -i "s/ā/á/g" $F
  #sed -i "s/ē/é/g" $F
  #sed -i "s/ī/í/g" $F
  #sed -i "s/ō/ó/g" $F
  #sed -i "s/ū/ú/g" $F
  #sed -i "s/ȳ/ý/g" $F
#done

# replace macron with circumflex
#for F in $TMP_DIR/*.tex
#do
  #sed -i "s/Ā/Â/g" $F
  #sed -i "s/Ē/Ê/g" $F
  #sed -i "s/Ī/Î/g" $F
  #sed -i "s/Ō/Ô/g" $F
  #sed -i "s/Ū/Û/g" $F
  #sed -i "s/Ȳ/Ŷ/g" $F
  #sed -i "s/ā/â/g" $F
  #sed -i "s/ē/ê/g" $F
  #sed -i "s/ī/î/g" $F
  #sed -i "s/ō/ô/g" $F
  #sed -i "s/ū/û/g" $F
  #sed -i "s/ȳ/ŷ/g" $F
#done

echo """
\documentclass[10pt,openany]{book}

\usepackage{fontspec}
%\setmainfont [
%  Path = ./../fonts/tex-gyre-schola/,
%  Extension = .ttf,
%  UprightFont = *-regular,
%  BoldFont = *-bold,
%  ItalicFont = *-italic,
%  BoldItalicFont= *-bold-italic,
%]{tex-gyre-schola}

%\setmainfont [
%  Path = ./../fonts/crimson/,
%  Extension = .ttf,
%  UprightFont = *-Roman,
%  BoldFont = *-Bold,
%  ItalicFont = *-Italic,
%  BoldItalicFont= *-BoldItalic,
%]{Crimson}

\setmainfont [
  Path = ./../fonts/charis-sil/,
  Extension = .ttf,
  UprightFont = *R,
  BoldFont = *B,
  ItalicFont = *I,
  BoldItalicFont= *BI,
]{CharisSIL}

%\setmainfont [
%  Path = ./../fonts/alegreya/,
%  Extension = .ttf,
%  UprightFont = *-Regular,
%  BoldFont = *-Bold,
%  ItalicFont = *-Italic,
%  BoldItalicFont= *-BoldItalic,
%]{Alegreya}

%\setmainfont[
%  Path = ./../fonts/sorts-mill-goudy/,
%  Extension = .otf,
%]{OFLGoudyStM}

\usepackage{indentfirst}
\usepackage[skip=10pt plus1pt, indent=0pt]{parskip}

\usepackage{titlesec}
\usepackage{titlepic}
\usepackage{color}
\usepackage{needspace}

\usepackage{graphicx}
\pdfimageresolution=300
\graphicspath{ {images/} }

\title{\huge\bfseries\color{red} ĒVANGELIUM}
\author{\bfseries\color{red} SECUNDUM MARCUM}
\date{\scriptsize \today} % Sets date for date compiled
\titlepic{\includegraphics[scale=0.25]{red-cross.png}}

\titleformat{\chapter}
  {\normalfont\LARGE\bfseries\centering}{\thechapter}{1em}{}
\titlespacing*{\chapter}{0pt}{-40pt}{30pt}

\titleformat{\section}
  {\LARGE\bfseries\centering\color{red}}{\thesection}{1em}{}

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

\begin{document} % All begin commands must be paired with an end command somewhere
\maketitle % creates title using information in preamble (title, author, date)

\newpage
\clearpage
\pagenumbering{arabic} 
\begin{flushleft}
""" >> $TMP_DIR/00.tex

echo """
\end{flushleft}

\begin{center}
\vfill
\includegraphics[scale=0.25]{red-cross.png}
\vfill
\end{center}

\end{document}
""" >> $TMP_DIR/99.tex

cat $TMP_DIR/*.tex > $TMP_DIR/evangelum_marcum.tex

xelatex -halt-on-error -output-directory $TMP_DIR $TMP_DIR/evangelum_marcum.tex

cp $TMP_DIR/*.pdf $SCRIPT_DIR
