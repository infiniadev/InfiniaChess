                                                                       
                           =====================================
                           =         EnginMax v5.11c           =
                           =     by Engin Uestuen, Germany     =                  
                           =====================================

==========================================================================================                             
About
==========================================================================================

EnginMax is a chess engine and it's FREEWARE. 
runs under winboard from Dr. Tim Mann with the winboard protocol 1 and 2,
and with all UCI compatible GUI's like Arena or Fritz.  

==========================================================================================
Installation:
==========================================================================================

unzip all files to a subfolder where is winboard installed and named EnginMax.

add to Winboard.ini file:
 
firstChessprogramm
"EnginMax" /fd=c:\WinBoard\EnginMax

and 

secondChessprogram
"EnginMax" /sd=c:\WinBoard\EnginMax


change something's in the EnginMax.ini for hash, book....etc.


==========================================================================================
build your own books from any PGN games:
==========================================================================================

- start EnginMax in MS-DOS mode.
- after start type <build> and enter the name of PGN and book file.
- wait until finished, that can be takes a long time if are many games available!
- now write the BOOK_NAME in EnginMax.ini who it will be using and the USE_BOOK must be set "on"
   

========
changed:
========
18.11.2002 v5.11c     - UCI ponder time bugfixed
                      - mate score output bugfixed
                      - root search window changed

16.11.2002 v5.11      - search and eval changes, better results
                      - analyze mode and ponder under UCI was not worked correct, this fixed

14.11.2002 v5.10a     - hash and killer move bug fixed

13.11.2002 v5.10      - PGN parser bug fixed
                      - new book format and building book with temp files
                      - add null-move mate_threat information to the hash tables
                      - changes in the search and eval
                      - book learning improved
                      - move generation and select next move improvements
                   

22.10.2002 v4.92      - most of time bug fixed
                      - pawn evalution rewrited and other eval settings changed
                      - opening book function rewrited new with results learn 
                      - move gen rewrited, produce only legal moves now
                      - new piece list implemented

===========================================================================================
EnginMax play on FICS
if you want to play against the newest version on FICS, search named EnginMax(C)

if want to report any bugs please email me!

good luck !
Engin Uestuen

E-mail  :  us.engin@t-online.de

Homepage:  http://us.engin.bei.t-online.de 
          
===========================================================================================