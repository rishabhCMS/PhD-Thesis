% Turabian Formatting for LaTeX
%
% Based on Kate L. Turabian's "A Manual for Writers of Research Papers, Theses, 
% and Dissertations," 9th edition.
%
% ==============================
% Copyright 2013-2018 Omar Abdool
%
% This work may be distributed and/or modified under the conditions of the LaTeX
% Project Public License (LPPL), either version 1.3 of this license or (at your
% option) any later version.
%
% The latest version of this license is in:
%	http://www.latex-project.org/lppl.txt
% and version 1.3 or later is part of all distributions of LaTeX version
% 2005/12/01 or later.
%
% LPPL Maintenance Status: maintained (by Omar Abdool)
%
% This work consists of the files: turabian-formatting.sty,
% turabian-researchpaper.cls, turabian-thesis.cls, turabian-formatting-doc.tex,
% and turabian-formatting-doc.pdf (in addition to the README file).
%
% ==============================
%
%


\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{turabian-thesis}[2018/08/01 Turabian Theses and Dissertations]


% Default point size
\def\@@ptsize{12pt}


% Document class options: handling

\DeclareOption{raggedright}{%
	\PassOptionsToPackage{\CurrentOption}{turabian-formatting}}

\DeclareOption{authordate}{%
	\PassOptionsToPackage{\CurrentOption}{turabian-formatting}}

\DeclareOption{noadjustbib}{%
	\PassOptionsToPackage{\CurrentOption}{turabian-formatting}}

\DeclareOption{endnotes}{%
	\PassOptionsToPackage{\CurrentOption}{turabian-formatting}}

\DeclareOption{twocolumn}{%
	\ClassWarningNoLine{turabian-researchpaper}{The '\CurrentOption' option is not supported.}
	\OptionNotUsed}

\DeclareOption{notitlepage}{%
	\ClassWarningNoLine{turabian-researchpaper}{The '\CurrentOption' option is not supported.}
	\OptionNotUsed}

\DeclareOption{10pt}{\def\@@ptsize{10pt}}

\DeclareOption{11pt}{\def\@@ptsize{11pt}}

\DeclareOption{12pt}{\def\@@ptsize{12pt}}

\DeclareOption{emptymargins}{%
	\ClassWarningNoLine{turabian-researchpaper}{The '\CurrentOption' option is no longer available}
	\OptionNotUsed}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}

\ProcessOptions\relax


% Load "book" document class with options
\LoadClass[titlepage,oneside,onecolumn,\@@ptsize]{book}


% Load turabian-formatting package
\RequirePackage{turabian-formatting}
\RequirePackage[utf8]{inputenc}
\RequirePackage[caption=false]{subfig}
%\RequirePackage[textformat=simple]{caption}
\RequirePackage[hidelinks]{hyperref}
\RequirePackage{authoraftertitle,amsmath, booktabs,breqn,comment,csquotes,datetime,ellipsis,float,fancyhdr,graphicx,gensymb,latexsym,mathtools,multirow,nomencl,longtable,pdflscape,scrhack,siunitx,tabularx,tabulary,textcase,textcomp,times,titlecaps,verbatim}

\RequirePackage[pass, letterpaper]{geometry}


% Binding offset: 0.5in
\setlength\oddsidemargin{0.5in}
\AtEndPreamble{%
	\addtolength\textwidth{-\oddsidemargin}}


% Figures and tables: support for double numeration formatting
\newif\if@doublenumerate\@doublenumeratetrue


% Figures: number formatting
\def\tf@figuredblnumprefix{\thechapter}
\newif\if@figuredblnum\@figuredblnumfalse

\renewcommand{\thefigure}{\if@figuredblnum \tf@figuredblnumprefix.\fi \@arabic\c@figure}


% Tables: number formatting
\def\tf@tabledblnumprefix{\thechapter}
\newif\if@tabledblnum\@tabledblnumfalse

\renewcommand{\thetable}{\if@tabledblnum \tf@tabledblnumprefix.\fi \@arabic\c@table}


% Document structure: formatting
\def\frontmatter{%
	\if@openright \cleardoublepage \else \clearpage \fi
	\@mainmatterfalse
	\pagenumbering{roman}
	\pagestyle{plain}}

\def\mainmatter{%
	\if@openright \cleardoublepage \else \clearpage \fi
	\@mainmattertrue
	\pagenumbering{arabic}
	\pagestyle{headings}
	\@addcontentslineskip}

\def\backmatter{%
	\if@openright \cleardoublepage \else \clearpage \fi
	\@mainmatterfalse
	\pagestyle{plain}
	\@addcontentslineskip}


% Part: formatting
\renewcommand\part{%
	\if@openright \cleardoublepage \else \clearpage \fi
	\secdef\@part\@spart}

\def\tf@partformat{\normalfont\bfseries\normalsize\singlespacing\centering}

% Part: heading with empty page
\def\@part[#1]#2{%
	\ifnum \c@secnumdepth >-2\relax
		\if@mainmatter
			\refstepcounter{part}%
			\addcontentsline{toc}{part}%
				{\protect\numberline{\partname\space\thepart}#1}%
		\else
			\addcontentsline{toc}{part}{#1}%
		\fi
	\else
		\addcontentsline{toc}{part}{#1}%
	\fi
	\markboth{}{}%
	{	\tf@partformat
		\interlinepenalty \@M
		\thispagestyle{empty}%
		\ifnum \c@secnumdepth >-2\relax
			\if@mainmatter
				\partname\nobreakspace\thepart
				\par\nobreak
				\vspace*{1\baselineskip}%
			\fi
		\fi
		#2\par}
	\@endpart}

% Part: heading with plain page style; allows following part description
\def\@spart#1{%
	\ifnum \c@secnumdepth >-2\relax
		\if@mainmatter
			\refstepcounter{part}%
			\addcontentsline{toc}{part}%
				{\protect\numberline{\partname\space\thepart}#1}%
		\fi
	\fi
	\markboth{}{}%
	{	\tf@partformat
		\interlinepenalty \@M
		\thispagestyle{plain}%
		\ifnum \c@secnumdepth >-2\relax
			\if@mainmatter
				\partname\nobreakspace\thepart
				\par\nobreak
				\vspace*{1\baselineskip}%
			\fi
		\fi
		\ifstrempty{#1}{}{#1\par\nobreak}}%
	\vspace{\dimexpr 3\tf@singlelineskip -\baselineskip \relax}
	\@afterheading}

\def\@endpart{\if@openright \cleardoublepage \else \clearpage \fi}


% Chapter: set top section command name to "chapter"
\def\tf@topsecname{chapter}

% Chapter: adjust figure/table counters based on @doublenumerate and chapter before
\newcounter{tf@tempchapfcnt}
\newcounter{tf@tempchaptcnt}

\newif\if@tfchapterbefore\@tfchapterbeforefalse

\def\tf@chapcounter{%
	\if@doublenumerate
		\if@tfchapterbefore \else
			\setcounter{tf@tempchapfcnt}{\value{figure}}
			\setcounter{tf@tempchaptcnt}{\value{table}}
		\fi
		\refstepcounter{chapter}
		\@tfchapterbeforetrue
		\@figuredblnumtrue
		\@tabledblnumtrue
	\else
		\setcounter{tf@tempchapfcnt}{\value{figure}}
		\setcounter{tf@tempchaptcnt}{\value{table}}
		\refstepcounter{chapter}
		\setcounter{figure}{\value{tf@tempchapfcnt}}
		\setcounter{table}{\value{tf@tempchaptcnt}}
	\fi}
	
\def\tf@restoreftcounters{%
	\if@doublenumerate
		\if@tfchapterbefore
			\setcounter{figure}{\value{tf@tempchapfcnt}}
			\setcounter{table}{\value{tf@tempchaptcnt}}
		\fi
		\@tfchapterbeforefalse
	\fi}

% Chapter: formatting
\def\tf@chapformat{\normalfont\bfseries\huge\singlespacing\centering}

\newlength\tf@adjafterchapskip
\setlength\tf@adjafterchapskip{\z@}

\def\tf@setafterchapskip{%
	\setlength\tf@adjafterchapskip{%
		\dimexpr 3\tf@singlelineskip -\baselineskip \relax}}

\def\@chapter[#1]#2{%
	\@figuredblnumfalse
	\@tabledblnumfalse
	\tf@afterindent
	\ifnum \c@secnumdepth >\m@ne
		\if@mainmatter
			\tf@chapcounter
			\typeout{\@chapapp\space\thechapter.}%
			\addcontentsline{toc}{chapter}%
				{\protect\numberline{\@chapapp\space\thechapter}#1}%
		\else
			\tf@restoreftcounters
			\addcontentsline{toc}{chapter}{#1}%
		\fi
	\else
		\addcontentsline{toc}{chapter}{#1}%
	\fi
	\chaptermark{#1}%
	\@makechapterhead{#2}%
	\@afterheading}

\def\@schapter#1{%
	\@figuredblnumfalse
	\@tabledblnumfalse
	\tf@restoreftcounters
	\tf@afterindent
	\@makeschapterhead{#1}%
	\@afterheading}

\def\@makechapterhead#1{%
	\tf@setafterchapskip
	{	\tf@chapformat
		\ifnum \c@secnumdepth >\m@ne
			\if@mainmatter
				\@chapapp\space \thechapter
				\par\nobreak
				\vspace*{1\baselineskip}%
			\fi
		\fi
		\interlinepenalty\@M
		\ifstrempty{#1}{}{#1\par\nobreak \vspace{\tf@adjafterchapskip}}}}

\def\@makeschapterhead#1{%
	\tf@setafterchapskip
	{	\tf@chapformat
		\interlinepenalty\@M
		#1\par\nobreak
		\vspace{\tf@adjafterchapskip}}}


% Sections: redefine \@startsection to support adjusting space after section headings
\def\@startsection#1#2#3#4#5#6{%
	\if@noskipsec \leavevmode \fi
	\par
	\@tempskipa #4\relax
	\@afterindenttrue
	\ifdim \@tempskipa <\z@
		\@tempskipa -\@tempskipa \tf@afterindent
	\fi
	\if@nobreak
		\everypar{}%
	\else
		\addpenalty\@secpenalty\addvspace\@tempskipa
	\fi
	\@ifstar
		{\@ssect{#3}{#4}{\dimexpr #5 -\tf@adjaftersec \relax}{#6}}%
		{\@dblarg{\@sect{#1}{#2}{#3}{#4}{\dimexpr #5 -\tf@adjaftersec \relax}{#6}}}}


% Title page: commands for use with \maketitle
\newcommand{\subtitle}[1]{\gdef\tf@subtitle{#1}}
\subtitle{}

\newcommand{\tf@subtitlesep}{\ifdefempty{\tf@subtitle}{}{:}}

\newcommand{\submissioninfo}[1]{\gdef\tf@submissioninfo{#1}}
\submissioninfo{}

\newcommand{\institution}[1]{\gdef\tf@institution{#1}}
\institution{}

\newcommand{\department}[1]{\gdef\tf@department{#1}}
\department{}

\newcommand{\school}[1]{\gdef\tf@school{#1}}
\school{}

\newcommand{\location}[1]{\gdef\tf@location{#1}}
\location{}

\newcommand{\degreework}[1]{\gdef\tf@degreework{#1}}
\degreework{}

\newcommand{\authorinfo}[1]{\gdef\tf@authorinfo{#1}}
\authorinfo{}

% Title page: command for emptying/completing \maketitle
\newcommand{\tf@emptymaketitle}{%
	\global\let\thanks\relax
	\global\let\maketitle\relax

	\global\let\@thanks\@empty
	\global\let\@author\@empty
	\global\let\@date\@empty
	\global\let\@title\@empty
	\global\let\tf@subtitle\@empty
	\global\let\tf@submissioninfo\@empty
	\global\let\tf@institution\@empty
	\global\let\tf@department\@empty
	\global\let\tf@location\@empty

	\global\let\title\relax
	\global\let\author\relax
	\global\let\date\relax
	\global\let\subtitle\relax
	\global\let\submissioninfo\relax
	\global\let\institution\relax
	\global\let\department\relax
	\global\let\location\relax}

% Title page: renew \maketitle for thesis/dissertation
\submissioninfo{
\doublespacing
    \tf@institution \\
\vspace*{\baselineskip}
    \@title\\
\vspace*{\baselineskip}
    A DISSERTATION \\
\vspace*{0.5\baselineskip}
    Submitted to the Faculty of \\
    \tf@department \\
    \tf@school \\
    Of \tf@institution \\
    In Partial Fulfillment of the Requirements \\
    For the Degree \\
    \tf@degreework \\
\vspace*{\baselineskip}
    By \\
\vspace*{\baselineskip}
    \@author \\
\vspace*{\baselineskip}
    
}

\renewcommand{\maketitle}{%
	\begin{titlepage}%
		\doublespacing
		\tf@setfnpunct{}
		\renewcommand*{\thefootnote}{\fnsymbol{footnote}}
		\let\footnoterule\relax
		\normalfont\normalsize
		\begin{center}
			%\vspace*{-1.2\baselineskip}
			%\parskip=1\baselineskip
			%\tf@institution\par
			%\vspace*{\stretch{1}}
% 			{\@title\tf@subtitlesep}\par
% 			{\tf@subtitle}\par%
			%\vspace*{\stretch{1}}
			\tf@submissioninfo\par
			\vspace*{0.5\baselineskip}
% 			\tf@department\par
%             \vspace*{0.5\baselineskip}
			\tf@location\par
			\vspace*{\baselineskip}
			2021
			\parskip=0pt
		\end{center}%
		\thispagestyle{empty}
	\end{titlepage}%
	\setcounter{page}{2}
	% if not endnotes, reset footnote counter
	\if@endnotesformat \else \setcounter{footnote}{0} \fi
	\tf@emptymaketitle
	\cleardoublepage}


% Table of Contents, List of Figures, and List of Tables: section number alignment
\def\tflist@beforesecnum{}
\def\tflist@aftersecnum{\hfil}
\def\numberline#1{\hb@xt@\@tempdima{\tflist@beforesecnum #1\tflist@aftersecnum}}

\def\@tocrmarg{0.75in}
\def\@pnumwidth{3.5ex}


% Table of Contents: formatting
\setcounter{tocdepth}{0}

\renewcommand*{\l@part}[2]{%
	\ifnum \c@tocdepth >-2\relax
		\addpenalty{-\@highpenalty}%
		\addvspace{1\baselineskip}%
		\setlength\@tempdima{1.25in}%
		\vskip 1\baselineskip
		{	\parindent \z@
			\rightskip \z@
			\parfillskip -\@rightskip
			\leavevmode
			\advance\leftskip\@tempdima
			\hskip -\leftskip
			{\bfseries #1}\nobreak\hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par}
	\fi}

\renewcommand*{\l@chapter}[2]{%
	\ifnum \c@tocdepth >\m@ne
		\addpenalty{-\@highpenalty}%
		\setlength\@tempdima{1.25in}%
		\vskip 1\baselineskip
		{	\parindent \z@
			\rightskip \@tocrmarg
			\parfillskip -\rightskip
			\leavevmode
			\advance\leftskip\@tempdima
			\hskip -\leftskip
			#1\nobreak\hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par
			\penalty\@highpenalty}
	\fi}

\renewcommand*{\l@section}{%
	\ifnum \c@tocdepth >\z@ \vskip \tf@singlelineskip \fi
	\@dottedtocline{1}{1.5in}{\z@}}

\renewcommand*{\l@subsection}{%
	\ifnum \c@tocdepth >1 \vskip \tf@singlelineskip \fi
	\@dottedtocline{2}{1.75in}{\z@}}

\renewcommand*{\l@subsubsection}{%
	\ifnum \c@tocdepth >2 \vskip \tf@singlelineskip \fi
	\@dottedtocline{3}{2in}{\z@}}

% Table of Contents: added lineskip
\def\@addcontentslineskip{%
	\begingroup
		\let\tf@write\write
		\def\write{\immediate\tf@write}
		\addtocontents{toc}{\protect\addvspace{\tf@singlelineskip}}
	\endgroup}


% List of Figures: formatting
\renewcommand*\l@figure{%
	\vskip \tf@singlelineskip
	\@dottedtocline{0}{\z@}{4em}}


% List of Tables: formatting
\def\l@table{\l@figure}


% Figures and Tables: caption formatting
\def\tf@numberlinedbl#1#2{\hb@xt@0.3\@tempdima{\hfil #1}\hb@xt@0.7\@tempdima{#2 \hfil}}

\long\def\@caption#1[#2]#3{%
	\par
		\csname if@#1dblnum\endcsname
			\addcontentsline{\csname ext@#1\endcsname}{#1}{%
				\protect\tf@numberlinedbl{\csname tf@#1dblnumprefix\endcsname}%
				{.\@arabic{\csname c@#1\endcsname}}%
				{\ignorespaces #2}}%
		\else
			\addcontentsline{\csname ext@#1\endcsname}{#1}{%
				\protect\tf@numberlinedbl{\csname the#1\endcsname}%
				{\@empty}%
				{\ignorespaces #2}}%
		\fi
	\begingroup
		\@parboxrestore
		\if@minipage
			\@setminipage
		\fi
		\normalsize
		\@makecaption{\csname fnum@#1\endcsname}{\ignorespaces #3}\par
	\endgroup}


% Appendixes: formatting
% appendixes environment resets figure and tables counts with "A." prefix

\newcounter{appendix}

\newenvironment{appendixes}%
	{%
		\@mainmattertrue
		\setcounter{section}{0}%
		\def\@chapapp{\appendixname}%
		\def\thechapter{\@Alph\c@appendix}
		\def\tf@chapcounter{\refstepcounter{appendix}}
		\if@doublenumerate
			\if@tfchapterbefore \else
				\setcounter{tf@tempchapfcnt}{\value{figure}}
				\setcounter{tf@tempchaptcnt}{\value{table}}
			\fi
			\def\tf@chapcounter{%
				\refstepcounter{appendix}
				\@figuredblnumtrue
				\@tabledblnumtrue}
			\setcounter{figure}{0}
			\setcounter{table}{0}
			\def\tf@figuredblnumprefix{A}
			\def\tf@tabledblnumprefix{A}
		\fi
	}%
	{%
		\if@doublenumerate
			\setcounter{figure}{\value{tf@tempchapfcnt}}
			\setcounter{table}{\value{tf@tempchaptcnt}}
		\fi
	}

% Appendixes: remove \appendix command
\def\appendix{\@empty}


% Endnotes: layout and formatting

\if@endnotesformat

	\let\tf@chapter\chapter

	\@addtoreset{endnote}{chapter}

	% Renew Notes heading formatted as \chapter* (also added to Table of Content)
	\renewcommand{\enoteheading}{%
		\tf@chapter*{\notesname}%
		\@mkboth{\notesname}{\notesname}%
		\addcontentsline{toc}{chapter}{\notesname}%
		\vspace{\dimexpr -5\tf@singlelineskip +1\baselineskip \relax}%
		\singlespacing\mbox{}%
		\def\tf@adjaftersec{\dimexpr \tf@singlelineskip -\p@ \relax}
		\let\tf@afterindent\@afterindenttrue}%

	% Renew \chapter command to: (1) reset endnotes counter at each chapter, and (2) add subheadings for each chapter in \endnotes formatting.
	\RenewDocumentCommand{\chapter}{som}{%
		\IfBooleanTF{#1}%
			{%	if \chapter*
				\tf@chapter*{#3}%
				\setcounter{endnote}{0}%
				\addtoendnotes{%
					\noexpand\tf@enotedivider%
						{\noexpand\section*}{\unexpanded{#3}}}%
			}%
			{%	if \chapter
				\IfNoValueTF{#2}%
					{\tf@chapter{#3}}%
					{\tf@chapter[#2]{#3}}%
				\setcounter{endnote}{0}%
				\if@mainmatter
					\addtoendnotes{%
						\noexpand\tf@enotedivider%
							{\noexpand\section*}{\@chapapp\space \thechapter}}%
				\else
					\addtoendnotes{%
						\noexpand\tf@enotedivider%
							{\noexpand\section*}{\unexpanded{#3}}}%
				\fi
			}}

	% Empty subheading divider before \theendnotes for use with \tf@enotedivider
	\preto{\theendnotes}{%
		\addtoendnotes{\noexpand\tf@enotedivider{}{}}}

	% Make endnote divider if not followed by another endnote divider
	\def\tf@enotedivider#1#2{\@ifnextchar\tf@enotedivider{}{#1{#2}}}%

\fi

\newcommand{\PrintCommitteeInfoPage}[5] {
    \clearpage
\noindent This dissertation by Rishabh Uniyal fulfills the dissertation requirement for the doctoral degree in Physics approved by \text{#2}, as Director, and by \text{#3}, and \text{#4}, as Readers.
    \vspace*{\stretch{1}}
    \singlespacing
    \begin{flushright}
        \noindent\rule{0.75\linewidth}{0.4pt} \\
        \vspace{7mm}
        \text{#2}, Director\\
        \vspace{12.5mm}
        \noindent\rule{0.75\linewidth}{0.4pt} \\
        \vspace{7mm}
        \text{#3}, Reader \\
        \vspace{12.5mm}
        \noindent\rule{0.75\linewidth}{0.4pt} \\
        \vspace{7mm}
        \text{#4}, Reader \\
        
       
    \end{flushright}
    \setcounter{page}{2}

    \vspace*{\stretch{1}}
    \noindent
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%List of custom strings

\renewcommand{\@chapapp}{CHAPTER}
\renewcommand{\bibname}{REFFERENCES}
\renewcommand{\appendixname}{APPENDIX}
\renewcommand{\contentsname}{TABLE OF CONTENTS}
\renewcommand{\listfigurename}{{LIST OF FIGURES}}
\renewcommand{\listtablename}{{LIST OF TABLES}}

\makeatletter
\newcommand \Dotfill {\leavevmode \cleaders \hb@xt@ 1em{\hss .\hss }\hfill \kern \z@}
\makeatother



% \floatstyle{boxed} 
\restylefloat{figure}

\def\LT@c@ption#1[#2]#3{%
\LT@makecaption#1\fnum@table{#3}%
\def\@tempa{#2}%
\ifx\@tempa\@empty\else
{\let\\\space
\addcontentsline{lot}{table}{\protect\hspace{.75in}\numberline{\thetable}{#2}}}%
\fi
\@dottedtocline{0}{\z@}{10em}
}


\newcommand*\aap{A\&A}
\let\astap=\aap
\newcommand*\aapr{A\&A~Rev.}
\newcommand*\aaps{A\&AS}
\newcommand*\actaa{Acta Astron.}
\newcommand*\aj{AJ}
\newcommand*\ao{Appl.~Opt.}
\let\applopt\ao
\newcommand*\apj{ApJ}
\newcommand*\apjl{ApJ}
\let\apjlett\apjl
\newcommand*\apjs{ApJS}
\let\apjsupp\apjs
\newcommand*\aplett{Astrophys.~Lett.}
\newcommand*\apspr{Astrophys.~Space~Phys.~Res.}
\newcommand*\apss{Ap\&SS}
\newcommand*\araa{ARA\&A}
\newcommand*\azh{AZh}
\newcommand*\baas{BAAS}
\newcommand*\bac{Bull. astr. Inst. Czechosl.}
\newcommand*\bain{Bull.~Astron.~Inst.~Netherlands}
\newcommand*\caa{Chinese Astron. Astrophys.}
\newcommand*\cjaa{Chinese J. Astron. Astrophys.}
\newcommand*\fcp{Fund.~Cosmic~Phys.}
\newcommand*\gca{Geochim.~Cosmochim.~Acta}
\newcommand*\grl{Geophys.~Res.~Lett.}
\newcommand*\iaucirc{IAU~Circ.}
\newcommand*\icarus{Icarus}
\newcommand*\jcap{J. Cosmology Astropart. Phys.}
\newcommand*\jcp{J.~Chem.~Phys.}
\newcommand*\jgr{J.~Geophys.~Res.}
\newcommand*\jqsrt{J.~Quant.~Spectr.~Rad.~Transf.}
\newcommand*\jrasc{JRASC}
\newcommand*\memras{MmRAS}
\newcommand*\memsai{Mem.~Soc.~Astron.~Italiana}
\newcommand*\mnras{MNRAS}
\newcommand*\na{New A}
\newcommand*\nar{New A Rev.}
\newcommand*\nat{Nature}
\newcommand*\nphysa{Nucl.~Phys.~A}
\newcommand*\pasa{PASA}
\newcommand*\pasj{PASJ}
\newcommand*\pasp{PASP}
\newcommand*\physrep{Phys.~Rep.}
\newcommand*\physscr{Phys.~Scr}
\newcommand*\planss{Planet.~Space~Sci.}
\newcommand*\pra{Phys.~Rev.~A}
\newcommand*\prb{Phys.~Rev.~B}
\newcommand*\prc{Phys.~Rev.~C}
\newcommand*\prd{Phys.~Rev.~D}
\newcommand*\pre{Phys.~Rev.~E}
\newcommand*\prl{Phys.~Rev.~Lett.}
\newcommand*\procspie{Proc.~SPIE}
\newcommand*\qjras{QJRAS}
\newcommand*\rmxaa{Rev. Mexicana Astron. Astrofis.}
\newcommand*\skytel{S\&T}
\newcommand*\solphys{Sol.~Phys.}
\newcommand*\sovast{Soviet~Ast.}
\newcommand*\ssr{Space~Sci.~Rev.}
\newcommand*\zap{ZAp}