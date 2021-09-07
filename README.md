# minipdf

Very simple, quickly hacked GUI for GhostScript to try to shrink unoptimized PDFs (basically images).
May result in bigger PDFs on some conditions.

Made to simplify the process enough for non technical users to be able to replicate what I do with `gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -dColorImageDownsampleType=/Bicubic -dGrayImageDownsampleType=/Bicubic -dMonoImageDownsampleType=/Subsample -dSubsetFonts=true -dEmbedAllFonts=true -dColorImageResolution=150 -sOutputFile=new/"$PDF" "$PDF"`.

Made with bash and YAD. Requires postscript for the "conversion" part.

I hope it helps somebody =)
