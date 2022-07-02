
/* FDtoM
 *
 * This nice utility converts a '.fd' file into an E binary module.
 * it understands :
---------
 * remark
 ##base _xyzBase
 ##bias wert
 ##public
 ##private
 Function(arg1,arg2,...,regx)(reg1,reg2,..,regx)
 Function(arg1,arg2,...,regx)(reg1/reg2/../regx)
 ##end
---------
 * Updated By Darren Coles
 *
 * 1.5 (2.7.22)
 *     Minor code change to allow compiling with E-VO 3.5.0
 *
 * 1.4 (3.10.94)
 *     Some Code-Cleanup : Much faster by using dos/FGets() [v36+]
 *     Added ASM-Switch and 3.Output-File: libname_lvo.i
 *
 * Written by Detlef Riekenberg
 *
 * 1.3 (3.10.94)
 *     Some Code-Cleanup : Much faster by using dos/FGets() [v36+]
 *     Added ASM-Switch and 3.Output-File: libname_lvo.i
 *
 * 1.2 (23.7.94)
 *     Added DEVICE & RESOURCE-Switch
 *     (Minimum Library-Offset in AmigaE is 30, but the LVO-File is ok)
 *
 * 1.1 (6.2.94)
 *     Added "/" as Register-Seperator
 *     Added FDtom.doc
 *
 * 1.0 (29.6.93)
 *     Initial Release
 *
 * USAGE: FDtoM <.fdfile> <.fdfile2> <.fdfilex>
 *
 */


 MODULE	'dos/dos'					/* ERROR_* - Code's*/


/* Type's in the *.m - File: */
ENUM T_DONE,T_CONST,T_OBJ,T_LIBRARY=6


/* Some Error-Code's */
ENUM ER_NONE,ER_ARGS,
	ER_FD,ER_TMP,ER_LVO,ER_OUT,				/* File's */
	ER_MEM,ER_BREAK,ER_FORM,
	ER_CMD,ER_NAME,ER_BIAS,ER_BASE


/* String's */

DEF	fdname[256]:STRING, 	/* File to Convert */
	outname[80]:STRING, 	/* Library-File.m */
	tmpname[80]:STRING, 	/* CONST-File.m (LVOUNCTIONNAME=)*/
	lvoname[80]:STRING, 	/* ASM-File.lvo (_LVOFunction EQU)*/

    fdline[256]:STRING,		/* Input_Line */
	outline[256]:STRING, 	/* Lib-Line */
	tmpline[256]:STRING, 	/* CONST-Line */
	basename[64]:STRING,	/* > xyzBase */
	libraryname[64]:STRING, /* > xyz.library */

    fdhandle=	NIL,
	outhandle=	NIL,
	lvohandle=	NIL,
	tmphandle=	NIL,

	noeof	=	TRUE,

	resource,				/* Special handling for resource-file's */
	device,					/* Special handling for device-file's */
	asmflag,				/* libname_lvo.x - Output, when asmflag <> 0 */
    linelen,
	fpart


DEF	names,thisname,
	line=0,
	dosnum=0,
	a,l


DEF	myargs:PTR TO LONG,
	rdargs

/*#################################################*/
/* Sub-Code's */

PROC outword(dummy)
  IF (Write(outhandle,dummy+2,2))<>2 THEN error(ER_OUT)
ENDPROC

PROC outlong(dummy)
  IF (Write(outhandle,dummy,4))<>4 THEN error(ER_OUT)
ENDPROC

PROC tmpword(dummy)
  IF (Write(tmphandle,dummy+2,2))<>2 THEN error(ER_TMP)
ENDPROC

PROC tmplong(dummy)
  IF (Write(tmphandle,dummy,4))<>4 THEN error(ER_TMP)
ENDPROC

/* ######################### */
/* Changed in V1.3 for Speed */

PROC getline()
  IF (KickVersion(36))
	  noeof:=(Fgets(fdhandle,fdline,254))
  ELSE
	  noeof:=(ReadStr(fdhandle,fdline)<>-1)
  ENDIF

  MOVE.L	fdline,A0			/* Get Line-Start */
  MOVEQ		#0,D1
  NOT.B		D1					/* Max-len = 255 */
getline_find0:
  TST.B	(A0)+
  DBEQ	D1,getline_find0
  CLR.B		-2(A0)				/* Remove Linefeed */

  ADDQ.L	#1,line
  IF  (dosnum:=IoErr())>0 THEN error(ER_FD)
ENDPROC


/*#################################################*/
/* Version-String */

version_txt:
CHAR	0,'$VER: FDtoM 1.5 (02.07.22) by Detlef Riekenberg & Darren Coles',0

/*#################################################*/

PROC main()
  myargs:=[0,0,0,0,0,0]

  IF wbmessage<>0 THEN error(ER_ARGS)

  WriteF('\n\e[1m\s.\e[0m\n',{version_txt}+7)

/* Use DOS to Support Multiple Filename's */
  IF (KickVersion(36))
	IF (rdargs:=ReadArgs('FILE/A/M,RESOURCE/S,DEVICE/S,ASM/S',myargs,NIL))=0 THEN error(ER_ARGS)
  ELSE
	/* Remove SPACE & TAB */
	MOVE.L	arg,A0
	MOVEQ	#32,D1
	MOVEQ	#9,D2

parse_old_loop:
	MOVE.B	(A0)+,D0
	BEQ.S	parse_old_end
	CMP.B	D0,D1
	BEQ.S	parse_old_loop
	CMP.B	D0,D2
	BEQ.S	parse_old_loop
parse_old_end:
	SUBQ.L	#1,A0
	MOVE.L	A0,a
	MOVE.L	A0,D2

    MOVE.L	myargs,A1					/* Create Fake File/A/M-Arg */
	LEA		16(A1),A2
	MOVE.L	A2,(A1)+
	CLR.L	(A1)+
	MOVE.L	A0,(A1)+
	CLR.L	(A1)+
	CLR.L	rdargs
  ENDIF

  resource:=myargs[1]
  device:=myargs[2]
  asmflag:=myargs[3]

  IF (names:=myargs[0])=0 THEN error(ER_ARGS)
  StrCopy(fdname,Long(names),ALL)
  IF (StrCmp(fdname,'?',ALL)) OR ((StrLen(fdname))=0) THEN error(ER_ARGS)

/*---------------------*/
/* Loop for every Name */
/*---------------------*/

  WHILE (thisname:=Long(names))

	libraryname[]:=0
	basename[]:=0
	CLR.L	line

	StrCopy(fdname,thisname,ALL)


/*---------------------------*/
/* fpart:=FilePart(FileName) */
/*---------------------------*/


	MOVE.L	thisname,A0
	MOVEQ	#":",D0
	MOVEQ	#":",D1
	MOVEQ	#"/",D2
partloop:
	CMP.B	D0,D1				/* Remove Drive: */
	BEQ.S	partloop1
	CMP.B	D0,D2				/* Remove Directory/ */
	BNE.S	partloop2
partloop1:
	MOVE.L	A0,A1				/* A1=Filename-Start-Address */
partloop2:
	MOVE.B	(A0)+,D0			/* Get Next Char. End of Filename ? */
	BNE.S	partloop
	MOVE.L	A1,fpart

	l:=StrLen(fpart)
	a:=EstrLen(fdname)

/*---------------------*/
/* Test File-extension */
/*---------------------*/
	linelen:=7
	IF	linelen>l THEN linelen:=l

	RightStr(tmpline,fdname,linelen)				/* "_LIB.FD" = 7 Char */
	UpperStr(tmpline)
	IF	linelen>2
		IF (StrCmp(tmpline+linelen-3,'.FD',3))
			SUBQ.L	#3,l							/* String-Len without ".fd" */
			SUBQ.L	#3,linelen
			SUBQ.L	#3,a
		ENDIF
	ENDIF

	IF	linelen>3
		IF (StrCmp(tmpline+linelen-4,'_LIB',4))
			SUBQ.L	#4,l							/* Len without "_lib.fd" */
		ENDIF
	ENDIF


/*----------------*/
/* Open .fd-File  */
/*----------------*/
	SetStr(fdname,a)

	IF (fdhandle:=Open(fdname,OLDFILE))=NIL

		IF ( (dosnum:=IoErr() )<>ERROR_OBJECT_NOT_FOUND) THEN error(ER_FD)

		StrAdd(fdname,'.fd',ALL)					/* Try with extension */
		IF (fdhandle:=Open(fdname,OLDFILE))=NIL
			SetStr(fdname,a)
			StrAdd(fdname,'_lib.fd',ALL)			/* Try with extension */
			IF (fdhandle:=Open(fdname,OLDFILE))=NIL THEN error(ER_FD)
		ENDIF
	ENDIF

/*--------------------*/
/* Make New Filenames */
/*--------------------*/
	StrCopy(tmpname,fpart,l)
	StrAdd(tmpname,'_lvo.m',ALL)

	StrCopy(lvoname,fpart,l)
	StrAdd(lvoname,'_lvo.i',ALL)

	StrCopy(outname,fpart,l)
	StrAdd(outname,'.m',ALL)

/*--------------*/
/* File valid ? */
/*--------------*/

 	IF (linelen:=FileLength(fdname))<=0 THEN error(ER_FD)
	WriteF('Now trying to convert <\s>.\n\e[0 p',fdname)

	IF (outhandle:=Open(outname,NEWFILE))=NIL THEN error(ER_OUT)
	IF (tmphandle:=Open(tmpname,NEWFILE))=NIL THEN error(ER_TMP)
	IF	asmflag
		IF (lvohandle:=Open(lvoname,NEWFILE))=NIL THEN error(ER_LVO)

		StrCopy(tmpline,fpart,l)
		UpperStr(tmpline)
		StringF(outline,'\n;* Generated by \s *\n\n\tIFND \s_LVO_I\n\s_LVO_I\tSET 1\n\n',{version_txt}+7,tmpline,tmpline)
		a:=EstrLen(outline)
		IF (Write(lvohandle,outline,a))<a THEN error(ER_LVO)

	ENDIF

/*-------------*/
/* File Ident. */
/*-------------*/

	outlong('EMOD')
	outword([T_LIBRARY])

	tmplong('EMOD')
	tmpword([T_CONST])

	makemodule()

/*---------*/
/* CleanUp */
/*---------*/

	IF fdhandle
		Close(fdhandle)
		CLR.L	fdhandle
	ENDIF
	IF tmphandle
		Close(tmphandle)
		CLR.L	tmphandle
	ENDIF
	IF lvohandle
		Close(lvohandle)
		CLR.L	lvohandle
	ENDIF
	IF outhandle
		Close(outhandle)
		CLR.L	outhandle
	ENDIF
	ADDQ.L	#4,names			/* PTR to the next Name or 0 */
  ENDWHILE
  error(ER_NONE)
ENDPROC


/* ####################### */
/* The Converting Funktion */
/* ####################### */

PROC makemodule()
DEF	fdtmp[256]:STRING,			/* Line to Ucase(varname) */
	bias=30,					/* Default's */
	newbias,
	pos:PTR TO CHAR,
	pos2,
	c

/* Added in V1.2 for correct Bias*/
  IF resource THEN bias:=6

  WriteF('\n\e[ALine:      :')		/* Changed in V1.3 for Speed */

  getline()
  WHILE	(noeof)
	IF CtrlC() THEN error(ER_BREAK)
	WriteF('\e[4D\d[4]',line)		/* Changed in V1.3 for Speed */
	StrCopy(fdtmp,fdline,ALL)

	UpperStr(fdtmp)
	c:=fdtmp[0]
	IF (c="#")
		IF fdtmp[1]<>"#" THEN error(ER_FORM)
		IF	(StrCmp(fdtmp+2,'BASE',4))
			IF basename[] THEN error(ER_BASE)
			MOVE.L	fdtmp,A0
			MOVEQ	#" ",D0
			MOVEQ	#5,D1
clrloop1:
			MOVE.B	D0,(A0)+
			DBRA	D1,clrloop1
			pos:=TrimStr(fdtmp)
			IF (StrCmp(pos,'_',1)) THEN ADDQ.L	#1,pos

			StrCopy(basename,pos,ALL)
			LowerStr(basename)
			l:=EstrLen(basename)
			StrCopy(libraryname,basename,l-4)

/* changed in V1.2 for correct Name in the Header.*/

			IF	resource
				StrAdd(libraryname,'.resource',ALL)
				ADDQ.L	#1,l
			ELSEIF	device
				StrAdd(libraryname,'.device',ALL)
				SUBQ.L	#1,l
			ELSE
				StrAdd(libraryname,'.library',ALL)
			ENDIF

/* End of V1.2-change */

			StrCopy(outline,libraryname,ALL)
			StrAdd(outline,' ',1)
			StrAdd(outline,basename,ALL)
			StrAdd(outline,' ',1)
			a:=EstrLen(outline)
			outline[l+4]:=0
			outline[a-1]:=0
			IF Write(outhandle,outline,a)<a THEN error(ER_OUT)

		ELSEIF (StrCmp(fdtmp+2,'BIAS',4))
			IF (pos:=InStr(fdtmp,'=',6))=-1 THEN pos:=6

			newbias:=Val(pos+fdtmp,{a})

/*			WriteF('\n bias: \d newbias: \d\n',bias,newbias)	/* Debug-Info */*/

			IF (newbias < bias) OR (a=0) THEN error(ER_BIAS)
			StrCopy(fdtmp,'Dum.',ALL)
			fdtmp[3]:=16
			WHILE newbias > bias
				outlong(fdtmp)
				ADDQ.L	#6,bias
			ENDWHILE
			IF newbias <> bias THEN error(ER_BIAS)
		ELSEIF	(StrCmp(fdtmp+2,'END',3)) ; CLR.L	noeof
		ELSEIF	(StrCmp(fdtmp+2,'PUBLIC',6)) ; NOP
		ELSEIF	(StrCmp(fdtmp+2,'PRIVATE',7)) ; NOP
		ELSE
			error(ER_CMD)
		ENDIF
	ELSEIF (c="*")
		NOP
	ELSE
		IF (fdtmp[0]<"A") OR (fdtmp[0]>"Z") OR (fdtmp[1]<"A") OR (fdtmp[1]>"Z")
			StringF(fdtmp,'x\s',fdline)
			StrCopy(fdline,fdtmp)
			UpperStr(fdtmp)
		ENDIF
		IF (l:=InStr(fdtmp,'(',0))=-1 THEN error(ER_NAME)
		StrCopy(outline,fdline,l)

		StrCopy(tmpline,'LVO',ALL)
		StrAdd(tmpline,fdtmp,l)

 		tmpline[l+3]:=0				/* End-Marker */
		tmpline[l+4]:=0				/* For Alingment */
		MOVE.L	l,D0
		ADDQ.W	#5,D0
		AND.B	#$FE,D0				/* Needs even Name-Length */
		MOVE.L	D0,a

		newbias:=0-bias
		tmpword([a])
		tmplong([newbias])
		IF (Write(tmphandle,tmpline,a))<a THEN error(ER_TMP)

		IF	asmflag
			StringF(tmpline,'_LVO\s\tEQU \d\n',outline,newbias)
			a:=EstrLen(tmpline)
			IF (Write(lvohandle,tmpline,a))<a THEN error(ER_LVO)
		ENDIF

		IF (outline[0]>="a") AND (outline[0]<="z") THEN outline[0]:=outline[0] AND $DF /* First Char Ucase	*/
		IF (outline[1]>="A") AND (outline[1]<="Z") THEN outline[1]:=outline[1] OR $20 /* Second : Lcase	*/

		a:=l+outline
		IF (pos2:=InStr(fdtmp,')',l))=-1 THEN error(ER_NAME)
		IF (pos2-l)>1				/* Data between the "()" */

			IF (pos:=InStr(fdtmp,'(',pos2))=-1 THEN error(ER_NAME)
			ADDQ.L	#1,pos
			IF (pos2:=InStr(fdtmp,')',pos))=-1 THEN error(ER_NAME)
			pos :=pos	+fdtmp
			pos2:=pos2	+fdtmp

			WHILE pos<pos2
				REPEAT
					c:=pos[]++
				UNTIL (c<>$20)			/* Ignore Space */

				CLR.L	l

/* Small cleanup in v1.2 */
				IF c=$41				;/* 'A'*/
					ADDQ.L	#8,l
				ELSEIF c<>$44			;/* 'D'*/
					error(ER_NAME)
				ENDIF

				c:=pos[]++
				IF (c<$30) OR (c>$37) THEN error(ER_NAME)
				l:=l+(c AND 7)
				MOVE.L	a,A0
				MOVE.L	l,D0
				MOVE.B	D0,(A0)+	/* Register-Number for Parameter */
				MOVE.L	A0,a


/* Seperator "," OR "/" here */

				c:=pos[]++
				IF (pos<pos2)
					IF (c<>$2c) AND (c<>$2f) THEN error(ER_NAME)	/* Format-Error*/
				ENDIF
			ENDWHILE
		ELSE
			MOVE.L	a,A0
			MOVE.B	#16,(A0)+	/* No Parameter */
			MOVE.L	A0,a
		ENDIF
		a:=a-outline
		IF	(bias>=30) OR (resource AND (bias>=6))							/*	Resource-Handling added in 1.2 */
			IF (Write(outhandle,outline,a))<a THEN error(ER_OUT)
		ENDIF
		ADDQ.L	#6,bias
	ENDIF
	IF	(noeof) THEN getline()
  ENDWHILE

  tmpword([0])					/* End-Code */
  IF	asmflag
    IF (Write(lvohandle,'\n\tENDC\n',7))<7 THEN error(ER_LVO)	/* Ende */
  ENDIF
  MOVE.L	outline,A0
  MOVE.B	#255,(A0)			/* End-Code */
  IF (Write(outhandle,outline,1))<=0 THEN error(ER_OUT)
  WriteF('\n')
ENDPROC

/* ############################# */

PROC error(ernum)
  IF fdhandle	THEN Close(fdhandle)
  IF lvohandle	THEN Close(lvohandle)
  IF tmphandle	THEN Close(tmphandle)
  IF outhandle	THEN Close(outhandle)
  IF (rdargs)	THEN FreeArgs(rdargs)

  WriteF('\n\e[1m')

  tmpline[]:=0
  IF (KickVersion(36)) AND (dosnum<>0) THEN Fault(dosnum,'\e[0m',tmpline,120)

  SELECT ernum
    CASE ER_NONE;   WriteF('\e[0mAll Done.\n')
    CASE ER_ARGS;   WriteF('Usage: fdtom fdname[.fd]')
    CASE ER_FD;     WriteF('Could not read "\s" \s',fdname,tmpline)

    CASE ER_TMP;    WriteF('Could not write "\s" \s',tmpname,tmpline)
    CASE ER_LVO;    WriteF('Could not write "\s" \s',lvoname,tmpline)
    CASE ER_OUT;    WriteF('Could not write "\s" \s',outname,tmpline)

    CASE ER_MEM;    WriteF('Could not allocate memory')
	CASE ER_BREAK;  WriteF('******* User Break ******')
    CASE ER_FORM;   WriteF('.fd file format error')
    CASE ER_CMD;	WriteF('Unknown Command')
    CASE ER_NAME;	WriteF('Name-Error')
    CASE ER_BIAS;	WriteF('BIAS-Fault.')
    CASE ER_BASE;	WriteF('BASE-Fault.')
  ENDSELECT

  WriteF('\e[0m\e[ p\n')
  IF wbmessage<>0 THEN WriteF('CLI-Only.\nPress "Return" to Quit.')
  IF (ernum>0) AND (line )
	WriteF('"\s"\nPress "CTRL-C" to Stop Deletion.\n',fdline)
	Delay(250)
	IF	CtrlC()=0
		DeleteFile(outname)				/* Return-Value not checked */
		DeleteFile(lvoname)				/* dito. */
		DeleteFile(tmpname)				/* dito. */
	ENDIF
  ENDIF
  CleanUp(ernum)
ENDPROC

