OPT MODULE
OPT EXPORT

OPT PREPROCESS

CONST DOS_STDIO_I=1,
      BUF_LINE=0,
      BUF_FULL=1,
      BUF_NONE=2,
      ENDSTREAMCH=-1

/* Wouter said he was going to fix macros so ReadChar() would be allowed... */
#define ReadChar             FgetC(Input())
#define WriteChar(c)         FputC(Output(),(c))
#define UnReadChar(c)        UnGetC(Input(),(c))
/* next one is inefficient */
#define ReadChars(buf,num)   Fread(Input(),(buf),1,(num))
#define ReadLn(buf,len)      Fgets(Input(),(buf),(len))
#define WriteStr(s)          Fputs(Output(),(s))
#define Vwritef(format,argv) VfWritef(Output(),(format),(argv))
