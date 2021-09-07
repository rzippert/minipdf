#!/bin/bash
#set -x


#TODO detectar trilhas de audio do arquivo pela janela
#TODO empactar rnnoise junto de alguma forma
#TODO arquivo .desktop para atalho

WINDOWTITLE="Minipdf"

DPI=150
INPUTFILE=""
FINALFILE=""

function usage {
	echo "$0 [-h] INPUTFILE1 [INPUTFILE2...] [-o OUTPUTFILE] [-r DPI]"
}

script_args=()
while [ $OPTIND -le "$#" ]
do
    if getopts ho:r: option
    then
        case $option
        in
            h) usage; exit 0;;
            o) wait_time="$OPTARG";;
            r) script="$OPTARG";;
        esac
    else
        script_args+=("${!OPTIND}")
        ((OPTIND++))
    fi
done

TMPDIR="./tmp$$"

function mktemp {
	if [[ ! -d $TMPDIR ]]
	then
		mkdir $TMPDIR 
	fi
}

function copyinput () {
	NEWNAME="$(echo ${INPUTFILE##*/} | tr -d ' ()#@!$%&*[]`^~+-')"
	cp "$INPUTFILE" "$TMPDIR/$NEWNAME"
	echo "$TMPDIR/$NEWNAME"
}

function tryshrink {
	COPYFILE=$(copyinput $INPUTFILE)
	OUTFILE=${COPYFILE%.pdf}.mini.pdf
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -dColorImageDownsampleType=/Bicubic -dGrayImageDownsampleType=/Bicubic -dMonoImageDownsampleType=/Subsample -dSubsetFonts=true -dEmbedAllFonts=true -dColorImageResolution=$DPI -sOutputFile="$OUTFILE" "$COPYFILE"
	if [[ "$?" -ne 0 ]]
	then
		displayerror "Error shrinking $INPUTFILE. Sorry."
	fi
	mv "$OUTFILE" "$FINALFILE"
}

function cleanup {
	if [[ -d $TMPDIR ]]
	then
		rm -rf $TMPDIR 
	fi
}

function displaywindow {
	SELECTIONS=$(yad --border=15 --form --width="300" --height="50" --center --title "$WINDOWTITLE" --text="Selecione um PDF para encolher. Para encolher muitos PDFs é possível utilizar a linha de comando. O arquivo encolhido terá no nome a extensão \".mini.pdf\"" --field="DPI (qualidade):NUM" --field="PDF original:FL" --button="Iniciar!gtk-ok" --button="Cancelar!gtk-close" 150\!72..600)
	if [[ $? -ne 0 ]]
	then
		exit 0
	fi
	DPI=$(echo $SELECTIONS | cut -d '|' -f1)
	INPUTFILE=$(echo $SELECTIONS | cut -d '|' -f2)


	if [[ -z "$INPUTFILE" ]]
	then
		yad --title="$WINDOWTITLE" --borders=15 --image=error --text="Você não selecionou nenhum PDF para encolher.\nTente novamente." --text-align=center --button=gtk-ok
		exit 1
	fi
}

function displayerror {
		yad --title="$WINDOWTITLE" --borders=15 --image=error --text="$1" --text-align=center --button=gtk-ok
		cleanup
		exit 1
}

function displaydone {
		# for some reason it fails to open the pdf directly
		#yad --title="$WINDOWTITLE" --borders=15 --center --text="Concluído." --text-align=center --button="Abrir pasta!inode-directory:1" --button="Abrir PDF!gnome-mime-application-pdf:2" --button='Fechar!gtk-ok'
		yad --title="$WINDOWTITLE" --borders=15 --center --text="Concluído." --text-align=center --button="Abrir pasta!inode-directory:1" --button='Fechar!gtk-ok'
		if [[ $? -eq 1 ]]
		then
			xdg-open "$(echo ${FINALFILE%/*})"
		fi
		exit 0
}

function askoverwrite {
		if [[ -f "${INPUTFILE%.pdf}.mini.pdf" ]]
		then
			yad --title="$WINDOWTITLE" --borders=15 --image=error --center --text="Já existe um arquivo ${INPUTFILE%.pdf}.mini.pdf.\nSobrescrever?" --text-align=center --button='Sim!gtk-yes:0' --button='Não!gtk-no:1'	
			if [[ $? -eq 0 ]]
			then
				OVERWRITE="TRUE"
			else
				exit 1
			fi
		fi
}

displaywindow
FINALFILE="${INPUTFILE%.pdf}.mini.pdf"
askoverwrite
mktemp
tryshrink | yad --title="$WINDOWTITLE" --borders=15 --center --progress --pulsate --auto-close --progress-text="Encolhendo arquivo..." --no-buttons
cleanup 
displaydone

exit 0
