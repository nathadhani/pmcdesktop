/* For HP 500 / 560C */

/* Setelah membuat suatu definisi agar mengikut sertakan ResetHP agar kembali
   normal */

* Reset Printer *

#define ResetHp       CHR(027)+CHR(069)                               && Reset Printer

* Underline *
#define SingLineF     CHR(027)+CHR(038)+CHR(100)+CHR(049)+CHR(068)    && Single Und-Line
#define DoubLineF     CHR(027)+CHR(038)+CHR(100)+CHR(050)+CHR(068)    && Double Und-Line
#define SingLineFl    CHR(027)+CHR(038)+CHR(100)+CHR(051)+CHR(068)    && Single Und-Line Floating
#define DoubLineFl    CHR(027)+CHR(038)+CHR(100)+CHR(052)+CHR(068)    && Double Und-Line Floating
#define UnderOff      CHR(027)+CHR(038)+CHR(100)+CHR(064)             && Underline Off

****** Page Orientation *
#define LandOr        CHR(027)+CHR(038)+CHR(108)+CHR(049)+CHR(079)    && Landscape
#define PortOr        CHR(027)+CHR(038)+CHR(108)+CHR(048)+CHR(079)    && Portrait

***** Page Size *

#define DefSize       CHR(027)+CHR(038)+CHR(108)+CHR(048)+CHR(065)    && Default Size
#define USLtSize      CHR(027)+CHR(038)+CHR(108)+CHR(050)+CHR(065)    && US Letter Size
#define USLgSize      CHR(027)+CHR(038)+CHR(108)+CHR(051)+CHR(065)    && US Legal Size
#define A4Size        CHR(027)+CHR(038)+CHR(108)+CHR(050)+CHR(054)+;
                      CHR(065)                                        && A4 Size
#define Env10Land     CHR(027)+CHR(038)+CHR(108)+CHR(045)+CHR(056)+;
                      CHR(049)+CHR(065)                               && Envelope No. 10
#define EnvDLLand     CHR(027)+CHR(038)+CHR(108)+CHR(045)+CHR(057)+;
                      CHR(048)+CHR(065)                               && Envelope DL

***** Page Length *  (Usage : HeadLength+<cNumber>+BottLength)
#define HeadLength    CHR(027)+CHR(038)+CHR(108)                      && Desc. P-Length Head
#define BottLength    CHR(080)                                        && Desc. P-Length Bott

***** Margins *      (Usage : MargTopH+<cNumber>+MargTopB)
#define MargTopH      CHR(027)+CHR(038)+CHR(108)                      && Margin Top Head
#define MargTopB      CHR(069)                                        && Margin Top Bott
#define MargLeftH     CHR(027)+CHR(038)+CHR(097)                      && Margin Left Head
#define MargLeftB     CHR(076)                                        && Margin Left Bott
#define MargRigtH     CHR(027)+CHR(038)+CHR(097)                      && Margin Right Head
#define MargRigtB     CHR(077)                                        && Margin Right Bott

***** Condense *
#define CondOn        CHR(027)+CHR(040)+CHR(115)+'15'+'H'              && Condense On 'H'

***** High Char ***
#define HiOn          CHR(027)+CHR(040)+CHR(115)+'36'+CHR(086)        && High Char. On
#define HiOff         CHR(027)+CHR(040)+CHR(115)+'18'+CHR(086)        && High Char. On

***** Italic Char ***
#define ItalicOn      CHR(027)+CHR(040)+CHR(115)+CHR(049)+CHR(083)    && Italic On

***** Pitch Type ***
#define Bold          CHR(027)+CHR(040)+CHR(115)+CHR(051)+CHR(066)    && Bold Type
#define Normal        CHR(027)+CHR(040)+CHR(115)+CHR(048)+CHR(066)    && Normal Type
#define ExtBold       CHR(027)+CHR(040)+CHR(115)+CHR(055)+CHR(066)    && Extra Bold

***** Resolution ***
#define Dpi_75         CHR(027)+CHR(042)+CHR(116)+'75'+CHR(082)        && 75 Dpi
#define Dpi_100        CHR(027)+CHR(042)+CHR(116)+'100'+CHR(082)       && 100 Dpi
#define Dpi_150        CHR(027)+CHR(042)+CHR(116)+'150'+CHR(082)       && 150 Dpi
#define Dpi_300        CHR(027)+CHR(042)+CHR(116)+'300'+CHR(082)       && 300 Dpi

