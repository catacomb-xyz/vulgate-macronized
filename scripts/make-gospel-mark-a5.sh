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

  nl -w1 -s'} \begin{absolutelynopagebreak}{\Large ' $F > $F_TMP
  #sed -i 's/^/\\filbreak\\noindent\\textsuperscript{\\color{red} /' $F_TMP
  sed -i 's/^/\\subsection{/' $F_TMP
  sed -i 's/$/}\\newline/' $F_TMP

  F_EN="$EN_DIR"/"$NUM".txt
  F_EN_TMP="$TMP_DIR"/"$NUM"EN.tmp

  cp $F_EN $F_EN_TMP
  sed -i 's/^/\\noindent\\emph{\\scriptsize  /' $F_EN_TMP
  sed -i 's/$/}\\\end{absolutelynopagebreak}/' $F_EN_TMP

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
  STR="\\\pagebreak[3]\\\section{SECUNDUM MARCUM $NUM}\\n\\\begin{center}\\\includegraphics{separator.png}\\\end{center}"
  sed -i "1s/^/$STR/" $F
  echo "\Needspace{8\baselineskip}" >> $F
done

echo """
\documentclass[10pt,openany]{book}

\usepackage{fontspec}
\setmainfont [
  Path = ./../fonts/junicode2/,
  Extension = .otf,
  Numbers={Lining,Proportional},
  UprightFont = *-Regular,
  BoldFont = *-Bold,
  ItalicFont = *-Italic,
  BoldItalicFont= *-BoldItalic,
  Numbers = Proportional,
]{Junicode}

%\setmainfont [
%  Path = ./../fonts/eczar/,
%  Extension = .ttf,
%  UprightFont = *-Medium,
%  BoldFont = *-Bold,
%  ItalicFont = *-Regular,
%  BoldItalicFont= *-ExtraBold,
%]{Eczar}

%\defaultfontfeatures{LetterSpace=100}

\usepackage{indentfirst}
\usepackage[skip=10pt plus1pt, indent=0pt]{parskip}

\usepackage[explicit]{titlesec}
\usepackage{titlepic}
\usepackage{needspace}

\usepackage{xcolor}
\definecolor{deepred}{HTML}{E60000}

\usepackage{graphicx}
\graphicspath{ {images/} }

%\title{\huge\bfseries\color{deepred} ĒVANGELIUM}
%\author{\bfseries\color{deepred} SECUNDUM MARCUM}
%\date{\scriptsize \today}
%\titlepic{\includegraphics[scale=0.25]{red-cross.png}}

%\titleformat{\chapter}
%  {\LARGE\bfseries\centering\color{deepred}}
%  {\thechapter}{1em}{}

\titleformat{\section}[hang]
  {\LARGE\bfseries\centering\color{deepred}}
  {\thesection}{0em}{#1}[]

\titlespacing{\section}{0pt}{6ex}{0ex}

\titleformat{\subsection}[runin]
  {\bfseries\color{deepred}}
  {\thesubsection}{0em}{\textsuperscript{#1}}[]

\setcounter{secnumdepth}{0}

\usepackage[
  paperwidth=6.08in,
  paperheight=8.52in,
  %margin=1in
  right=0.8in,
  left=0.9in,
  top=1.0in,
  bottom=1.0in
]{geometry}

\usepackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}

\renewcommand{\sectionmark}[1]{
  \markboth{\addfontfeature{LetterSpace=15.0} #1}
           {\addfontfeature{LetterSpace=15.0} #1}
}

\fancyhead[CE]{\scriptsize{\rightmark}}
\fancyhead[CO]{\scriptsize{\rightmark}}
\fancyfoot[C]{\thepage}
\renewcommand{\headrulewidth}{0.0pt}
\renewcommand{\footrulewidth}{0.0pt}

\newenvironment{absolutelynopagebreak}
  {\par\nobreak\vfil\penalty0\vfilneg
   \vtop\bgroup}
  {\par\xdef\tpd{\the\prevdepth}\egroup
   \prevdepth=\tpd}

\hyphenpenalty 10000
\exhyphenpenalty 10000

\usepackage{setspace}

\begin{document}

% TITLE PAGE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\thispagestyle{empty} 
\begin{center}
\topskip0pt
\vspace*{\fill}
{\huge\bfseries\color{deepred} ĒVANGELIUM}
\vspace{2ex}

{\large\bfseries\color{deepred} SECUNDUM MARCUM}
\vspace{8ex}

{\huge\color{deepred} ✠}
\vspace*{\fill}
\end{center}
\newpage

% INFO PAGE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\thispagestyle{empty} 
\begin{flushleft}
\topskip0pt
\vspace*{\fill}
\begin{footnotesize}
\noindent
Evangelium Secundum Marcum, build date: \today

\noindent
This is a free and unencumbered work released into the public domain.

\noindent
Anyone is free to copy, modify, publish, use, sell, or distribute this work, either in print or digital form, for any purpose, commercial or non-commercial, and by any means.

\noindent
In jurisdictions that recognize copyright laws, the author or authors of this work dedicate any and all copyright interest in the work to the public domain. We make this dedication for the benefit of the public at large and to the detriment of our heirs and successors. We intend this dedication to be an overt act of relinquishment in perpetuity of all present and future rights to this document under copyright law.

\noindent
THE WORK IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE WORK OR THE USE OR OTHER DEALINGS IN THE WORK.
\vspace{4ex}

\noindent
For further information, comments, questions, or corrections, please visit \textbf{doctrinalatina.com}.

\end{footnotesize}
\vspace*{\fill}
\end{flushleft}
\newpage

% INTRO PRAYER PAGE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\thispagestyle{empty} 
\begin{center}
\topskip0pt
\vspace*{\fill}

\noindent{\large\bfseries\color{deepred} Ōrātiō ad Sānctum Spīritum}\vspace{-3ex}

\noindent\rule{3in}{0.1pt}

\noindent{Venī, Sānctē Spīritus, replē tuōrum corda fidēlium,}\vspace{-2ex}

\noindent\emph{\scriptsize Come, O Holy Spirit, fill the hearts of thy faithful,}

\noindent{et tuī amōris in eīs ignem accende.}\vspace{-2ex}

\noindent\emph{\scriptsize and kindle in them the fire of thy love.}

\noindent{Ēmitte Spīritum tuum et creābuntur,}\vspace{-2ex}

\noindent\emph{\scriptsize Send forth thy Spirit and they shall be created,}

\noindent{et renovābis faciem terrae.}\vspace{-2ex}

\noindent\emph{\scriptsize and thou shalt renew the face of the earth.}

\noindent{Deus, quī corda fidēlium Sānctī Spīritus illūstrātiōne docuistī,}\vspace{-2ex}

\noindent\emph{\scriptsize O God, who didst instruct the hearts of the faithful by the light of the Holy Spirit,}

\noindent{dā nōbīs in eōdem Spīritū rēcta sapere,}\vspace{-2ex}

\noindent\emph{\scriptsize grant us in the same Spirit to be truly wise,}

\noindent{et dē eius semper cōnsōlātiōne gaudēre.}\vspace{-2ex}

\noindent\emph{\scriptsize and ever rejoice in his consolation.}

\noindent{Per Chrīstum Dominum nostrum. Āmēn.}\vspace{-2ex}

\noindent\emph{\scriptsize Through Christ our Lord. Amen.}

\vspace{4ex}

\includegraphics[scale=0.55]{red-dove.png}

\vspace*{\fill}
\end{center}

\newpage

% BEGIN GOSPEL OF MARK %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\clearpage
\pagenumbering{arabic}
\begin{flushleft}
""" >> $TMP_DIR/00.tex

echo """
\end{flushleft}

\begin{center}
\vfill
{\huge\color{deepred} ✠}
\vfill
\end{center}

\end{document}
""" >> $TMP_DIR/99.tex

cat $TMP_DIR/*.tex > $TMP_DIR/evangelum_marcum.tex

xelatex -halt-on-error -output-directory $TMP_DIR $TMP_DIR/evangelum_marcum.tex

cp $TMP_DIR/*.pdf $SCRIPT_DIR
