# minipdf

Very simple, quickly hacked GUI for GhostScript to try to shrink unoptimized PDFs (basically images).
May result in bigger PDFs on some conditions.

Made to simplify the process enough for non technical users to be able to replicate what I do with `gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -dColorImageDownsampleType=/Bicubic -dGrayImageDownsampleType=/Bicubic -dMonoImageDownsampleType=/Subsample -dSubsetFonts=true -dEmbedAllFonts=true -dColorImageResolution=150 -sOutputFile=new/"$PDF" "$PDF"`.

Made with bash and YAD. Requires postscript for the "conversion" part.

I hope it helps somebody =)

# screenshot
![Screenshot from 2021-09-07 21-37-11](https://user-images.githubusercontent.com/2091971/132427247-ea307587-6b36-42b4-828d-933eb6e64cd0.png)
