  OPT MODULE
  OPT EXPORT
  OPT PREPROCESS


/*
**  $VER: reaction_macros.h 44.1 (19.10.1999)
**  Includes Release 44.1
**
**  Reaction macros
**
**  (C) Copyright 1987-1999 Amiga, Inc.
**      All Rights Reserved
*/
/****************************************************************************
 *  The following macro defines allow easy object creation.
 *
 *  You can do things such as:
 *
 *   layoutgadget = LayoutObject,
 *                      LAYOUT_BevelStyle, GroupFrame,
 *                      LAYOUT_AddChild,
 *                          ButtonObject,
 *                              GA_ID, 1L,
 *                              GA_Text, "_Hamburgers",
 *                          EndButton,
 *                      LAYOUT_AddChild,
 *                          ButtonObject,
 *                              GA_ID, 2L,
 *                              GA_Text, "Hot _Dogs",
 *                          EndButton,
 *                  EndLayout;
 *
 *   Be careful with your commas and colons; only the FIRST object gets
 *   an "End;", objects that are embedded should get a comma ("End,"), so
 *   that the TagList continues.
 */
/****************************************************************************
 * Gadget Objects Creation Macros
 */
#define End                  TAG_DONE])
#define ButtonObject         NewObjectA( NIL, 'button.gadget',[TAG_IGNORE,0
#define ToggleObject         NewObjectA( NIL, 'button.gadget', [GA_TOGGLESELECT, TRUE
#define CheckBoxObject       NewObjectA( CheckBox_GetClass(), NIL,[TAG_IGNORE,0
#define ChooserObject        NewObjectA( Chooser_GetClass(), NIL,[TAG_IGNORE,0
#define ClickTabObject       NewObjectA( ClickTab_GetClass(), NIL,[TAG_IGNORE,0
#define ClickTabsObject      ClickTabObject
#define PopUpObject          NewObjectA( Chooser_GetClass(), NIL, [CHOOSER_POPUP, TRUE
#define DropDownObject       NewObjectA( Chooser_GetClass(), NIL, [CHOOSER_DROPDOWN, TRUE
#define FuelGaugeObject      NewObjectA( FuelGauge_GetClass(), NIL,[TAG_IGNORE,0
#define FuelObject           FuelGaugeObject
#define GetFileObject        NewObjectA( GetFile_GetClass(), NIL,[TAG_IGNORE,0
#define GetFontObject        NewObjectA( GetFont_GetClass(), NIL,[TAG_IGNORE,0
#define GetScreenModeObject  NewObjectA( GetScreenMode_GetClass(), NIL,[TAG_IGNORE,0
#define IntegerObject  NewObjectA( Integer_GetClass(), NIL,[TAG_IGNORE,0
#define PaletteObject  NewObjectA( Palette_GetClass(), NIL,[TAG_IGNORE,0
#define PageObject     NewObjectA( Page_GetClass(), NIL,[TAG_IGNORE,0
#define PenMapObject   NewObjectA( PenMap_GetClass(), NIL,[TAG_IGNORE,0
#define LayoutObject   NewObjectA( Layout_GetClass(), NIL,[TAG_IGNORE,0
#define VLayoutObject  NewObjectA( Layout_GetClass(), NIL, [LAYOUT_ORIENTATION, LAYOUT_ORIENT_VERT
#define HLayoutObject  NewObjectA( Layout_GetClass(), NIL, [TAG_IGNORE,0
#define VGroupObject   VLayoutObject
#define HGroupObject   HLayoutObject
#define ListBrowserObject    NewObjectA( ListBrowser_GetClass(), NIL,[TAG_IGNORE,0
#define RadioButtonObject    NewObjectA( RadioButton_GetClass(), NIL,[TAG_IGNORE,0
#define MxObject             RadioButtonObject
#define ScrollerObject       NewObjectA( Scroller_GetClass(), NIL,[TAG_IGNORE,0
#define SpeedBarObject       NewObjectA( SpeedBar_GetClass(), NIL,[TAG_IGNORE,0
#define SliderObject         NewObjectA( Slider_GetClass(), NIL,[TAG_IGNORE,0
#define StatusObject         NewObjectA( StatusBar_GetClass(), NIL,[TAG_IGNORE,0
#define StringObject         NewObjectA( String_GetClass(), NIL,[TAG_IGNORE,0
#define SpaceObject          NewObjectA( Space_GetClass(), NIL,[TAG_IGNORE,0
#define TextFieldObject      NewObjectA( TextField_GetClass(), NIL,[TAG_IGNORE,0
/****************************************************************************
 * Image Object Creation Macros
 */
#define BevelObject          NewObjectA( Bevel_GetClass(), NIL,[TAG_IGNORE,0
#define BitMapObject         NewObjectA( Bitmap_GetClass(), NIL,[TAG_IGNORE,0
#define DrawListObject       NewObjectA( DrawList_GetClass(), NIL,[TAG_IGNORE,0
#define GlyphObject          NewObjectA( Glyph_GetClass(), NIL,[TAG_IGNORE,0
#define LabelObject          NewObjectA( Label_GetClass(), NIL,[TAG_IGNORE,0
/****************************************************************************
 * Class Object Creation Macros
 */
#define WindowObject         NewObjectA(Window_GetClass(), NIL, [TAG_IGNORE,0
#define ARexxObject          NewObjectA(Arexx_GetClass(), NIL,[TAG_IGNORE,0
/****************************************************************************
 * Window class method macros
 */
#define RA_OpenWindow(win )       doMethodA(win, [WM_OPEN, NIL])
#define RA_CloseWindow(win )      doMethodA(win, [WM_CLOSE, NIL])
#define RA_HandleInput(win,code ) doMethodA(win, [WM_HANDLEINPUT, code])
#define RA_Iconify(win )          doMethodA(win, [WM_ICONIFY, NIL])
#define RA_Uniconify(win )     RA_OpenWindow(win)
/****************************************************************************
 * ARexx class method macros
 */
#define RA_HandleRexx(obj)  doMethodA(obj, [AM_HANDLEEVENT] )
#define RA_FlushRexx(obj)   doMethodA(obj, [AM_FLUSH] )
/* Easy macro to set up a Hook for a string gadget, etc
 */
#define RA_SetUpHook(apphook,func,data)  apphook.h_Entry = func \\
 apphook.h_SubEntry = NIL        \\
 apphook.h_Data = data
/****************************************************************************
 * Additional BOOPSI Classes.
 */
#define ColorWheelObject     NewObjectA( NIL, 'colorwheel.gadget',[TAG_IGNORE,0
#define GradientObject       NewObjectA( NIL, 'gradientslider.gadget',[TAG_IGNORE,0
#define LedObject            NewObjectA( NIL, 'led.image',[TAG_IGNORE,0
/****************************************************************************
 * Reaction synomyms for End which can make layout
 * groups easier to follow.
 */
#define WindowEnd            End
#define BitMapEnd            End
#define ButtonEnd            End
#define CheckBoxEnd          End
#define ChooserEnd           End
#define ClickTabEnd          End
#define ClickTabsEnd         End
#define FuelGaugeEnd         End
#define IntegerEnd           End
#define PaletteEnd           End
#define LayoutEnd            End
#define ListBrowserEnd       End
#define PageEnd              End
#define RadioButtonEnd       End
#define ScrollerEnd          End
#define SpeedBarEnd          End
#define SliderEnd            End
#define StatusEnd            End
#define StringEnd            End
#define SpaceEnd             End
#define StatusbarEnd         End
#define TextFieldEnd         End
#define ARexxEnd             End
#define BevelEnd             End
#define DrawListEnd          End
#define GlyphEnd             End
#define LabelEnd             End
#define ColorWheelEnd        End
#define GradientSliderEnd    End
#define LedEnd               End
/****************************************************************************
 * Vector Glyph Images.
 */
#define GetPath              GLYPH_POPDRAWER
#define GetFile              GLYPH_POPFILE
#define GetScreen            GLYPH_POPSCREENMODE
#define GetTime              GLYPH_POPTIME
#define CheckMark            GLYPH_CHECKMARK
#define PopUp                GLYPH_POPUP
#define DropDown             GLYPH_DROPDOWN
#define ArrowUp              GLYPH_ARROWUP
#define ArrowDown            GLYPH_ARROWDOWN
#define ArrowLeft            GLYPH_ARROWLEFT
#define ArrowRight           GLYPH_ARROWRIGHT
/****************************************************************************
 * Bevel Frame Types.
 */
#define ThinFrame            BVS_THIN
#define ButtonFrame          BVS_BUTTON
#define StandardFrame        BVS_STANDARD
#define RidgeFrame           BVS_FIELD
#define StringFrame          BVS_FIELD
#define GroupFrame           BVS_GROUP
#define DropBoxFrame         BVS_DROPBOX
#define HBarFrame            BVS_SBAR_HORIZ
#define VBarFrame            BVS_SBAR_VERT
#define RadioFrame           BVS_RADIOBUTTON
#define MxFrame              BVS_RADIOBUTTON
/****************************************************************************
 * Often used simple gadgets
 */
#define Label(text )       CHILD_LABEL, LabelObject, LABEL_TEXT, text, End
#define Button(text,id )    ButtonObject, GA_TEXT, text, GA_ID, id, GA_RELVERIFY, TRUE, End
#define PushButton(text,id )  ButtonObject, GA_TEXT, text, GA_ID, id, GA_RELVERIFY, TRUE, BUTTON_PUSHBUTTON, TRUE, End
#define TextLine(text )   ButtonObject, GA_TEXT, text, GA_READONLY, TRUE, End
#define LabelTextLine(text,label )  TextLine(text), Label(label)
#define String(text,id,maxchars ) StringObject, STRINGA_TEXTVAL, text, STRINGA_MAXCHARS, maxchars, GA_ID, id, GA_RELVERIFY, TRUE, GA_TABCYCLE, TRUE, End
#define LabelString(text,id,maxchars,label )    String(text,id,maxchars), Label(label)
#define PopString(text,id,maxchars,image )  LAYOUT_ADDCHILD, HLayoutObject, String(text,0,maxchars), ButtonObject, BAG_AUTOBUTTON, image, GA_RELVERIFY, TRUE, GA_ID, id, End, End
/****************************************************************************
 * BGUI style Window/Layout Group Macros.
 */
#define StartMember          LAYOUT_ADDCHILD
#define StartImage           LAYOUT_ADDIMAGE
#define StartHLayout         LAYOUT_ADDCHILD, HLayoutObject
#define StartVLayout         LAYOUT_ADDCHILD, VLayoutObject
#define StartHGroup          StartHLayout
#define StartVGroup          StartVLayout
#define EndWindow            End
#define EndMember            End
#define EndImage             End
#define EndObject            End
#define EndHGroup            End
#define EndVGroup            End
#define EndGroup             End
/****************************************************************************
 * Lazy typist BGUI inspired macros (BGUI is Copyright Jan van den Baard.)
 */
#define HAlign(p)   LAYOUT_HORIZALIGNMENT, p
#define VAlign(p)   LAYOUT_VERTALIGNMENT, p
#define Spacing(p)  LAYOUT_INNERSPACING, p
#define LOffset(p)  LAYOUT_LEFTSPACING, p
#define ROffset(p)  LAYOUT_RIGHTSPACING, p
#define TOffset(p)  LAYOUT_TOPSPACING, p
#define BOffset(p)  LAYOUT_BOTTOMSPACING, p
/****************************************************************************
 * And for even lazier typists....
 */
#define VCentered   LAYOUT_VERTALIGNMENT, LALIGN_CENTER
#define TAligned    LAYOUT_VERTALIGNMENT, LALIGN_TOP
#define BAligned    LAYOUT_VERTALIGNMENT, LALIGN_BOTTOM
#define HCentered   LAYOUT_HORIZALIGNMENT, LALIGN_CENTER
#define LAligned    LAYOUT_HORIZALIGNMENT, LALIGN_LEFT
#define RAligned    LAYOUT_HORIZALIGNMENT, LALIGN_RIGHT
#define Offset(x1,y1,x2,y2 ) LAYOUT_LEFTSPACING, x1, LAYOUT_TOPSPACING, y1, LAYOUT_RIGHTSPACING, x2, LAYOUT_BOTTOMSPACING, y2
#define EvenSized   LAYOUT_EVENSIZE, TRUE
#define MemberLabel(a )  CHILD_LABEL, LabelObject, LABEL_TEXT, a, LabelEnd
/****************************************************************************
 * Easy Menu Macros.
 */
#define Title(t ) { NM_TITLE, t, NIL, 0, 0, NIL }
#define Item(t,s,i ) { NM_ITEM, t, s, 0, 0, i }
#define ItemBar { NM_ITEM, NM_BARLABEL, NIL, 0, 0, NIL }
#define SubItem(t,s,i ) { NM_SUB, t, s, 0, 0, i }
#define SubBar { NM_SUB, NM_BARLABEL, NIL, 0, 0, NIL }
#define EndMenu { NM_END, NIL, NIL, 0, 0, NIL }
