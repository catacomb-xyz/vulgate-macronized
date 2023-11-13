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

  nl -w1 -s'} {\filbreak\Large ' $F > $F_TMP
  #sed -i 's/^/\\filbreak\\noindent\\textsuperscript{\\color{red} /' $F_TMP
  sed -i 's/^/\\subsection{/' $F_TMP
  sed -i 's/$/}\\newline/' $F_TMP

  F_EN="$EN_DIR"/"$NUM".txt
  F_EN_TMP="$TMP_DIR"/"$NUM"EN.tmp

  cp $F_EN $F_EN_TMP
  sed -i 's/^/\\noindent\\emph{\\scriptsize  /' $F_EN_TMP
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
  STR="\\\section{SECUNDUM MARCUM $NUM}\\n"
  sed -i "1s/^/$STR/" $F
  echo "\Needspace{8\baselineskip}" >> $F
done

echo """
\documentclass[10pt,openany]{book}

\usepackage{fontspec}
%\setmainfont [
%  Path = ./../fonts/charis-sil/,
%  Extension = .ttf,
%  UprightFont = *R,
%  BoldFont = *B,
%  ItalicFont = *I,
%  BoldItalicFont= *BI,
%]{CharisSIL}

\setmainfont [
  Path = ./../fonts/eczar/,
  Extension = .ttf,
  UprightFont = *-Medium,
  BoldFont = *-Bold,
  ItalicFont = *-Regular,
  BoldItalicFont= *-ExtraBold,
]{Eczar}

%\defaultfontfeatures{LetterSpace=100}

\usepackage{indentfirst}
\usepackage[skip=10pt plus1pt, indent=0pt]{parskip}

\usepackage[explicit]{titlesec}
\usepackage{titlepic}
\usepackage{color}
\usepackage{needspace}

\usepackage{graphicx}
\graphicspath{ {images/} }

\title{\huge\bfseries\color{red} ĒVANGELIUM}
\author{\bfseries\color{red} SECUNDUM MARCUM}
\date{\scriptsize \today} % Sets date for date compiled
\titlepic{\includegraphics[scale=0.25]{red-cross.png}}

%\titleformat{\chapter}
%  {\LARGE\bfseries\centering\color{red}}
%  {\thechapter}{1em}{}

\titleformat{\section}[hang]
  {\LARGE\bfseries\centering\color{red}}
  {\thesection}{0em}{• #1 •}[]

\titleformat{\subsection}[runin]
  {\bfseries\color{red}}
  {\thesubsection}{0em}{\textsuperscript{#1}}[]

\setcounter{secnumdepth}{0}

\usepackage[
  paperwidth=6.08in,
  paperheight=8.52in,
  %margin=1in
  right=0.6in,
  left=0.7in,
  top=1.0in,
  bottom=1.0in
]{geometry}

%\usepackage[
%  papersize={8.75in,11.25in},
%  layout=letterpaper,
%  layouthoffset=0.125in,
%  layoutvoffset=0.125in,
%  right=0.75in,
%  left=0.75in,
%  top=1.25in,
%  bottom=1.25in
%]{geometry}

\usepackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}
\fancyhead[CE,CO]{\scriptsize{\rightmark}}
\fancyfoot[C]{\thepage}
\renewcommand{\headrulewidth}{0.0pt}
\renewcommand{\footrulewidth}{0.0pt}

\renewcommand{\sectionmark}[1]{%
  \gdef\currsection{#1}%
}
\renewcommand{\subsectionmark}[1]{%
  \markright{\addfontfeature{LetterSpace=5.0}\currsection\ :\ #1}%
}

\hyphenpenalty 10000
\exhyphenpenalty 10000

\begin{document}

\addfontfeature{LetterSpace=1.5}

\maketitle

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
