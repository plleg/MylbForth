( File Access words. )

\ bin
\ create-file
\ delete-file
\ file-position
\ file-size
\ r/w
\ read-line
\ reposition-file
\ resize-file
\ w/o
\ write-file
\ write-line

\ ----------------------------------------------------------------------

( File Access extension words. )

\ file-status
\ flush-file
\ rename-file

( Forth12 )

: included? ( a u nt -- a u 1 | 0 0 )   >name 2over compare
   if 1 else 2drop 0 0 then ;
: required   ['] included-files ['] included? traverse-wordlist
   ?dup if included then ;
: include   parse-name included ;
: require   parse-name required ;
