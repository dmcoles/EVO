->scanf like function
->ported to E by Darren Coles
->see end of code for example of use.

OPT MODULE

-> ported from the C scanf function provided as part of the following project
-> https://code.google.com/archive/p/c-standard-library/
-> released under MIT Licence

/*THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
 PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
 FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.*/

EXPORT CONST EOF = 0, ESFMT = 1, INT_MAX = $7FFF, BUFSIZ=4000, UCHAR_MAX=255

EXPORT ENUM SPEC_NO_MATCH,
    SPEC_CHAR,
    /* Signed integers */
    SPEC_SCHAR,
    SPEC_SHORT, 
    SPEC_INT, 
    SPEC_LONG,
    SPEC_LLONG,
    SPEC_INTMAXT,
    SPEC_PTRDIFFT,
    /* Unsigned integers */
    SPEC_UCHAR,
    SPEC_USHORT, 
    SPEC_UINT, 
    SPEC_ULONG,
    SPEC_ULLONG,
    SPEC_UINTMAXT,
    SPEC_SIZET,
    /* Pointer values */
    SPEC_POINTER,
    /* Floating-point types */
    SPEC_FLOAT, 
    SPEC_DOUBLE, 
    SPEC_LDOUBLE,
    /* Null terminated pointers to char */
    SPEC_STRING,
    /* Sequences of characters to match */
    SPEC_SCANSET,
    /* Character input counts of the stream */
    SPEC_COUNT,
    /* Escaped '%' literal characters */
    SPEC_LITERAL

EXPORT ENUM SPEC_FMT_NO_FORMAT,SPEC_FMT_DECIMAL=10,SPEC_FMT_HEX=16,SPEC_FMT_OCTAL=8

EXPORT OBJECT localespec
  thousands_sep:CHAR
  decimal_point:CHAR
  grouping:PTR TO CHAR
ENDOBJECT

OBJECT scanspec PRIVATE
    suppressed:INT  /* Conversion has been suppressed with '*' */
    field_width:INT /* The maximum number of characters to read */
    type:INT        /* Type of expected input (including length) */
    format:INT      /* Expected format of the type */
    skipws:INT      /* Used if the type discards leading whitespace */
    nomatch:INT     /* Used if the scanset specifies '^' */
    scanset:PTR TO CHAR /* Lookup table for the scanset */
ENDOBJECT

EXPORT OBJECT scanf
  estrings:INT     -> treat output strings as E STRINGS (otherwise treat as array of char)
  read_count:LONG -> Total number of characters read
  converted:LONG-> Total number of specifiers processed
  error_state:LONG   -> The most recently flagged error
  offset:LONG
  locale : localespec
ENDOBJECT

EXPORT PROC create() OF scanf  ->constructor
  self.read_count:=0
  self.converted:=0
  self.error_state:=0
  self.offset:=0
  self.estrings:=TRUE

  self.locale.thousands_sep:=","
  self.locale.decimal_point:="."
  self.locale.grouping:=[3,3,3,3]:CHAR
ENDPROC

PROC get(src:PTR TO CHAR) OF scanf
  DEF ch
  self.read_count:=self.read_count+1
  ch:=src[self.offset]
  self.offset:=self.offset+1
ENDPROC ch

PROC unget(ch,src:PTR TO CHAR) OF scanf
  self.offset:=self.offset-1
  self.read_count:=self.read_count-1
ENDPROC

PROC tolower(ch) OF scanf
  IF (ch>="A") AND (ch<="Z") THEN ch:=ch+32
ENDPROC ch

PROC octVal(s:PTR TO CHAR) OF scanf
  DEF neg,v,b,t=0
  
  neg:=s[0]="-"
  IF (s[0]="-") OR (s[0]="+") THEN s++
  b:=0
  WHILE (s[0]>="0") AND (s[0]<="7")
    v:=s[0]-"0"
    t:=t+Shl(v,b)
    b:=b+3
  ENDWHILE
  IF neg THEN t:=-t
ENDPROC t

PROC digitvalue(ch,base) OF scanf
  DEF r=-1
  IF (ch>="0") AND (ch<="9") THEN r:=ch-"0"
  IF (ch>="A") AND (ch<="F") THEN r:=ch-"A"+10
  IF (ch>="a") AND (ch<="f") THEN r:=ch-"a"+10
  IF r>=base THEN r:=-1
ENDPROC r

PROC isdigit(ch) OF scanf IS (ch>="0") AND (ch<="9")
PROC isxdigit(ch) OF scanf IS ((ch>="0") AND (ch<="9")) OR ((ch>="a") AND (ch<="f")) OR ((ch>="A") AND (ch<="F"))

PROC isspace(ch) OF scanf IS (ch=32) OR (ch=13) OR (ch=13) OR (ch=8)

PROC setIntVar(var:PTR TO LONG,value) OF scanf
  var[]:=value
ENDPROC

PROC setStrVar(var:PTR TO LONG,value:PTR TO CHAR,len) OF scanf
  IF self.estrings
    IF len>0 THEN StrCopy(var[],value,len) ELSE StrCopy(var[],'')
  ELSE
    IF len>0 THEN AstrCopy(var[],value,len) ELSE var[]:=0
  ENDIF
ENDPROC

/*
    @description:
        Extracts up to n characters into the specified buffer.
*/
PROC load_charvalue(src:PTR TO CHAR, s:PTR TO CHAR, n) OF scanf
  DEF i
  DEF ch

  FOR i:=0 TO n-1
    ch:=self.get(src)

    IF (ch = EOF) 
        self.unget(ch, src)
        RETURN i
    ENDIF

    s[i]:=ch
  ENDFOR

ENDPROC i

/*
    @description:
        Extracts up to n valid scanset characters into the specified buffer.
*/
PROC load_scanvalue(src:PTR TO CHAR,s:PTR TO CHAR, n, scanset:PTR TO CHAR, exclude) OF scanf
  DEF i
  DEF ch

  FOR i:=0 TO n-1
      ch:=self.get(src)

      IF ((ch = EOF) OR (((exclude AND scanset[ch])) OR (((exclude=FALSE) AND (scanset[ch]=FALSE)))) OR self.isspace(ch))
          self.unget(ch, src)
          s[i]:=0
          RETURN i
      ENDIF

      s[i]:=ch
  ENDFOR

  s[i]:=0
ENDPROC i


/*
    @description:
        Extracts a whitespace delimited string into the specified buffer.
*/
PROC load_strvalue(src:PTR TO CHAR, s:PTR TO CHAR,n) OF scanf
  DEF i
  DEF ch
    IF (self.trim_leading(src) = EOF)
        RETURN 0
    ELSE
      FOR i:=0 TO n-1
          ch:=self.get(src)

          IF ((ch=EOF) OR (self.isspace(ch)))
              self.unget(ch, src)
              s[i]:=0
              RETURN i
          ENDIF

          s[i]:=ch
      ENDFOR

      s[i]:=0

    ENDIF
ENDPROC i

/*
    @description:
        Extracts a valid integer string representation into the specified buffer.
*/
PROC load_intvalue(src:PTR TO CHAR, s:PTR TO CHAR, n, is_unsigned, base) OF scanf
  DEF i,iend,ch,skip=FALSE

    IF (self.trim_leading(src) = EOF)
        RETURN 0
    ELSE
        i:=0

        IF (base=0) THEN base:=10 /* Assume decimal */

        IF base=16
          s[0]:="$"
          i:=1
        ENDIF

        /* Get a count of valid locale friendly integer characters */
        iend:=self.integer_end(src, n, base)

        IF (iend=0) THEN RETURN 0 /* There are no valid groups */

        WHILE (n--)
            ch:=self.get(src)

            EXIT (ch = EOF)

            /* Further error check anything that's not a thousands separator */
            IF (ch <> self.locale.thousands_sep)
                IF ((i = 0) AND ((ch = "-") OR (ch = "+")))
                    IF (is_unsigned)
                        /* The sign isn't in an expected location */
                        self.unget(ch, src)
                        JUMP brk2
                    ENDIF
                ELSEIF (self.digitvalue(ch, base)=-1)
                    IF ((((base = 16) AND (i = 1) AND (self.tolower(ch)) = "x"))=FALSE)
                        /* Alternate format characters aren't in an expected location */
                        self.unget(ch, src)
                        JUMP brk2
                    ENDIF

                    skip:=TRUE /* Skip over alternate format characters */
                ENDIF

                IF skip=FALSE
                  s[i]:=ch
                  i++
                ENDIF
                skip:=FALSE
            ENDIF

        ENDWHILE
brk2:
        s[i]:=0

    ENDIF
ENDPROC i

/*
    @description:
        Extracts a valid floating point string representation into the specified buffer.
*/
PROC load_fpvalue(src:PTR TO CHAR, s:PTR TO CHAR,n, is_hex) OF scanf
  DEF in_exponent,seen_decimal,seen_digit,last,i,iend,ch,exponent

    IF (self.trim_leading(src) = EOF)
        RETURN 0
    ELSE
        exponent:=IF is_hex THEN "p" ELSE "e"

        in_exponent:=FALSE
        seen_decimal:=FALSE
        seen_digit:=FALSE
        last:=EOF

        -> Find the end of the integer part of the mantissa
        iend:=self.integer_end(src, n, 10)

        ->
        ->    At this point iend is either greater than zero (there was a 
        ->    valid integer part), or it's zero (no integer part) and the
        ->    next character is a decimal point. Anything else represents
        ->    a format error for the value.
        ->
        IF (iend=FALSE)
            ch:=self.get(src)

            -> ch being EOF falls into this test naturally
            IF (ch <> self.locale.decimal_point)
                self.unget(ch, src)
                RETURN 0
            ENDIF
        ENDIF

        FOR i:=0 TO n-1
            ch:=self.get(src)

            EXIT ch=EOF
            IF (IF is_hex THEN self.isxdigit(ch) ELSE self.isdigit(ch))
                seen_digit:=TRUE
            ELSE
                ->
                ->    Only ignore the thousands separator when we're in the
                ->    integer part. Otherwise all subsequent checks apply 
                ->    and a thousands separator is erroneous.
                ->
                IF ((i >= iend) OR (ch <> self.locale.thousands_sep))
                    IF ((ch = "+") OR (ch = "-"))
                        IF ((last <> EOF) AND ((in_exponent AND (self.tolower(last) = exponent))=FALSE))
                            -> The sign isn't in an expected location
                            self.unget(ch, src)
                            JUMP brk3
                        ENDIF
                    ELSEIF  ((self.tolower(ch) = "x") AND ((is_hex AND (i = 1))=FALSE))
                        -> Alternate format characters aren't in an expected location
                        self.unget(ch, src)
                        JUMP brk3
                    ELSEIF (self.tolower(ch) = exponent)
                        IF (seen_digit=FALSE)
                            -> We can't have an exponent without a value
                            self.unget(ch, src)
                            JUMP brk3
                        ENDIF

                        in_exponent:=TRUE
                    ELSEIF (ch = self.locale.decimal_point)
                        IF (in_exponent)
                            -> The decimal isn't in an expected location 
                            self.unget(ch, src)
                            
                        ENDIF

                        seen_decimal:=TRUE
                    ELSE
                        -> Invalid character 
                        self.unget(ch, src)
                        JUMP brk3
                    ENDIF
                ENDIF
            ENDIF

            -> Always add even the thousands separator
            s[i]:=ch
            last:=ch
        ENDFOR
brk3:
        s[i]:=0
    ENDIF
ENDPROC i

/*
    @description:
        Locates the end of the first valid integer string from the source.
        This function is aware of the current locale's LC_NUMERIC setting.
*/
PROC integer_end(src:PTR TO CHAR, n,  base) OF scanf

    DEF grouping:PTR TO CHAR
    DEF group_len=0, group_size
    DEF stack[BUFSIZ]:ARRAY OF CHAR
    DEF top=0, i=0,c

    grouping:=self.locale.grouping
    group_size:=grouping[]

    IF (self.locale.thousands_sep=0)
        /* Avoid potentially a lot of work if the locale doesn't support separators */
        RETURN n
    ENDIF

    /* Find the end of the possible characters */
    WHILE ((i++ < n) AND ((c:=self.get(src)) <> EOF) AND (self.isspace(c)=FALSE))
      stack[top]:=c
      top++
    ENDWHILE

    IF (i < n)
        /* We stopped on an invalid character */
        self.unget(c, src)
        top--
    ENDIF
    stack[i]:=0

    WHILE (top >= 0)
        IF ((top = 0) AND (group_size) AND (self.digitvalue(stack[i], base) <> -1))
            i:=0
        ELSEIF ((top > 0) AND (group_size) AND (group_len++ = (group_size)))
            IF ((top = 0) OR (stack[top] <> self.locale.thousands_sep))
                /* Invalid group: reset grouping, mark the end and proceed */
                grouping:=self.locale.grouping
                group_size:=grouping[]
                group_len:=0
                i:=top /* Save 1 past the last valid character */
            ELSE
                /* Valid group: move to the next grouping level */
                IF (grouping[])
                  grouping++
                  IF grouping[] THEN group_size:=grouping[]
                ENDIF

                group_len:=0

                /* Skip over the separator so we don't error on the next iteration */
                self.unget(stack[top--], src)
            ENDIF
        ELSEIF (((stack[top] = "-") OR (stack[top] = "+")) AND (top > 0))
            /* Invalid sign: reset grouping, mark the end and proceed */
            grouping:=self.locale.grouping
            group_size:=grouping[]
            group_len:=0
            i:=top /* Save 1 past the last valid character */
        ELSEIF ((((stack[top] = "-") OR (stack[top] = "+"))=FALSE) AND (self.digitvalue(stack[top], base) = -1))
            /* Invalid digit: reset grouping, mark the end and proceed */
            grouping:=self.locale.grouping
            group_size:=grouping[]
            group_len:=0
            i:=top /* Save 1 past the last valid character */
        ENDIF

        self.unget(stack[top--], src)
    ENDWHILE

ENDPROC i

/*
    @description:
        Extract and discard leading whitespace from the source.
*/
PROC trim_leading(src:PTR TO CHAR) OF scanf
  DEF ch

    REPEAT
      ch:=self.get(src)
    UNTIL (ch=EOF) OR (self.isspace(ch)=FALSE)

    /* Push back the non-whitespace character that broke the loop */
    self.unget(ch, src)

ENDPROC ch

/*
    @description:
        Extract and match a specific character value from the source.
*/
PROC match_literal(src:PTR TO CHAR, match) OF scanf
  DEF ch
    ch:=self.get(src)

    /* Match a literal character */
    IF (ch <> match)
        self.unget(ch, src)
        RETURN EOF
    ENDIF


ENDPROC ch

PROC load_scanspec(spec:PTR TO scanspec,fmt:PTR TO CHAR) OF scanf
  DEF length = 0 /* Offset from SPEC_*INT or SPEC_FLOAT for the corresponding type */
  DEF pos = 0
  DEF ch = 0

  IF (fmt[pos] <> "%") THEN RETURN 0

    /* Reset to suitable defaults */
    spec.suppressed:=0
    spec.field_width:=0
    spec.type:=SPEC_NO_MATCH
    spec.format:=SPEC_FMT_NO_FORMAT
    spec.skipws:=1 /* All specifications skip by default */
    spec.nomatch:=0

    Dispose(spec.scanset)
    spec.scanset:=0
    pos++

    /* Get the non-type flags */
    WHILE (ch:=fmt[pos])
        pos++
        IF(self.isdigit (ch))
            spec.field_width:= 10 * spec.field_width + (ch - "0")
        ELSE
            SELECT ch
            CASE "*"
              spec.suppressed:=1
            CASE "h"
                length:= -1

                IF (fmt[pos] = "h")
                    length:=length-1
                    pos:=pos+1
                ENDIF
            CASE "l"
                length:=length+1

                IF (fmt[pos] ="l") 
                    length:=length+1
                    pos:=pos+1
                ENDIF
            CASE "j"
              length:=length+3
            CASE "z"
              length:=length+4
            CASE "t"
              length:=length+4
            CASE "L"
              length:=length+2
            DEFAULT
              JUMP brk4
            ENDSELECT
        ENDIF
    ENDWHILE
brk4:

    /* A, E, F, G, and X behave the same as a, e, f, g, and x */
    ch:=self.tolower(ch)

    /* Fill in the type data */
    SELECT ch
    
      CASE "d"
        spec.type:=SPEC_INT + length
        spec.format:=SPEC_FMT_DECIMAL
      CASE "i"
        spec.type:=SPEC_INT + length
      CASE "o"
        spec.type:=SPEC_UINT + length
        spec.format:=SPEC_FMT_OCTAL
      CASE "u"
        spec.type:=SPEC_UINT + length
        spec.format:=SPEC_FMT_DECIMAL
      CASE "x"
        spec.type:=SPEC_UINT + length
        spec.format:=SPEC_FMT_HEX
      CASE "e"
       spec.type:=SPEC_FLOAT + length
      CASE "f"
        spec.type:=SPEC_FLOAT + length
      CASE "g"
        spec.type:=SPEC_FLOAT + length
      CASE "c"
        spec.type:=SPEC_CHAR
        spec.skipws:=0
        /* Default to 1 character */
        IF (spec.field_width = 0) THEN spec.field_width:=1
      CASE "s"
        spec.type:=SPEC_STRING
      CASE "["
        pos:=self.load_scanset(spec, fmt, pos-1)+1
        spec.type:=SPEC_SCANSET
        spec.skipws:=0
      CASE "p"
        spec.type:=SPEC_POINTER
        spec.format:=SPEC_FMT_HEX
      CASE "n"
        spec.type:= SPEC_COUNT
        spec.skipws:=0
      CASE "%"
        spec.type:=SPEC_LITERAL
      DEFAULT
        RETURN 0 /* Invalid specifier */
    ENDSELECT

ENDPROC pos

PROC load_scanset(spec:PTR TO scanspec, fmt:PTR TO CHAR, pos) OF scanf
  DEF start
  DEF firstchar
  DEF begin,end,i,s
  
  start:=pos

    IF (fmt[pos] <> "[") THEN RETURN 0

    pos++
    /* Create a lookup table for every character */
    IF ((spec.scanset=0) AND ((s:= New(UCHAR_MAX + 1))=FALSE)) THEN RETURN 0
    spec.scanset:=s
    ->FOR i:=0 TO UCHAR_MAX DO spec.scanset[i]:=0

    /* Fill up the lookup table */
    WHILE (fmt[pos] <> 0)
        firstchar:=(pos= (start + 1) OR ((pos = (start + 2)) AND (fmt[pos - 1] = "^")))

        /*
            A hat character can be in the scanset, but if it's the
            first character, the scanset denotes a negative lookup
            and the hat is *not* stored.
        */
        IF ((fmt[pos] = "^") AND (pos = (start + 1)))
            spec.nomatch:=1

        /*
            A closing square bracket can be in the scanset, but
            only immediately after the the opening "[" or "[^".
        */
        ELSEIF ((fmt[pos] = "]") AND (firstchar=FALSE))
            RETURN pos
        ELSEIF ((((fmt[pos] = "-") AND (firstchar=FALSE) AND (fmt[pos + 1] <> "]")))=FALSE)
            spec.scanset[fmt[pos]]:=spec.scanset[fmt[pos]]+1 /* Add a non-range character to the lookup table */
        ELSE
            /*
                It's implementation-defined how *scanf treats a '-' character 
                anywhere except the beginning of the scanset. That clause
                practically begs the implementation to employ a range, so
                this implementation does so. :)
            */
            IF ((fmt[pos] = "-") AND (firstchar=FALSE) AND (fmt[pos + 1] <> "]"))
                begin:=fmt[pos - 1]
                pos++
                end:=fmt[pos];

                IF (begin < end)
                    WHILE (begin++ < end) DO spec.scanset[begin]:=spec.scanset[begin]+1
                ELSE
                    WHILE (begin-- > end) DO spec.scanset[begin]:=spec.scanset[begin]+1
                ENDIF
            ENDIF
        ENDIF
        pos++
    ENDWHILE

ENDPROC pos

/*
    @description:
        Worker function for the scanf family.
*/

EXPORT PROC scanf(src:PTR TO CHAR, fmt:PTR TO CHAR, args:PTR TO LONG) OF scanf
    DEF spec : scanspec
    DEF count
    DEF s[BUFSIZ]:ARRAY OF CHAR
    DEF n

    self.read_count:=0
    self.converted:=0

    WHILE (fmt[])
        IF (fmt[] <> "%")
            IF (self.isspace(fmt[]))
                -> Discard all leading whitespace from both the source and format string.
                self.trim_leading(src)
                
                WHILE (self.isspace(fmt[])) DO fmt++
            ELSE
                -> Try to match a literal character in the format string
                IF(self.match_literal(src, fmt[]++) = EOF) THEN JUMP brk1
            ENDIF
        ELSE
            count:=self.load_scanspec(spec, fmt)
            n:=0

            IF (count = 0) 
                -> The specifier was invalid
                self.error_state:=ESFMT
                JUMP brk1
            ENDIF

            fmt:=fmt+count -> Jump past the encoding specifier

            IF (spec.field_width = 0)
                -> Assume no field width means the maximum possible
                spec.field_width:=INT_MAX
            ENDIF

            IF (spec.type = SPEC_LITERAL)
                -> Try to match a specifier starter character from the source
                IF (self.match_literal(src, "%") = EOF) THEN JUMP brk1
            ELSEIF (spec.type = SPEC_COUNT)
                -> No encoding, the read character count was requested
                IF (spec.suppressed=FALSE) 
                  self.setIntVar(args[self.converted],self.read_count)
                  self.converted:=self.converted+1
                ENDIF
            ELSEIF ((spec.type = SPEC_CHAR) OR (spec.type = SPEC_STRING) OR (spec.type = SPEC_SCANSET))
                -> The three specifiers are similar, select which one to run
                IF (spec.type = SPEC_CHAR)
                    n:=self.load_charvalue(src, s, spec.field_width)
                ELSEIF (spec.type = SPEC_STRING)
                    n:=self.load_strvalue(src, s, spec.field_width)
                ELSEIF (spec.type = SPEC_SCANSET)
                    n:=self.load_scanvalue(src, s, spec.field_width, spec.scanset, spec.nomatch)
                ENDIF

                IF ((n=0) AND (self.converted=0)) THEN JUMP brk1

                IF ((n > 0) AND (spec.suppressed=FALSE))
                    -> Only %s null terminates the destination
                    self.setStrVar(args[self.converted],s,n + IF spec.type = SPEC_STRING THEN 1 ELSE 0)
                    self.converted:=self.converted+1
                ENDIF
            ELSEIF ((spec.type >= SPEC_SCHAR) AND (spec.type <= SPEC_PTRDIFFT))
                -> Extract and convert signed integer values 
                n:=self.load_intvalue(src, s, spec.field_width, FALSE, spec.format)

                IF ((n=0) AND(self.converted=0)) THEN JUMP brk1

                IF ((n > 0) AND (spec.suppressed=FALSE))
                    -> Out of range values invoke undefined behavior, so we'll play DS9000 here
                    /*long long value = strtoull(s, 0, spec.format)

                    switch (spec.type) {
                    case SPEC_SCHAR:    *va_arg(args, signed char*) = (signed char)value   break
                    case SPEC_SHORT:    *va_arg(args, short*) = (short)value               break
                    case SPEC_INT:      *va_arg(args, int*) = (int)value                   break
                    case SPEC_LONG:     *va_arg(args, long*) = (long)value                 break
                    case SPEC_LLONG:    ->Fall through
                    case SPEC_INTMAXT:  *va_arg(args, long long*) = value                  break
                    case SPEC_PTRDIFFT: *va_arg(args, int*) = (int)value                   break
                    }*/
                    self.setIntVar(args[self.converted],IF spec.format=SPEC_FMT_OCTAL THEN self.octVal(s) ELSE Val(s))

                    self.converted:=self.converted+1
                ENDIF
            ELSEIF ((spec.type >= SPEC_UCHAR) AND (spec.type <= SPEC_POINTER))
                ->Extract and convert unsigned integer values
                n:=self.load_intvalue(src, s, spec.field_width, TRUE, spec.format)

                IF((n= 0) AND (self.converted =0)) THEN JUMP brk1

                IF ((n > 0) AND (spec.suppressed=FALSE))
                    /* Out of range values invoke undefined behavior, so we'll play DS9000 here */
                    /*unsigned long long value = strtoull(s, 0, spec.format)

                    switch (spec.type) {
                    case SPEC_UCHAR:    *va_arg(args, unsigned char*) = (unsigned char)value   break
                    case SPEC_USHORT:   *va_arg(args, unsigned short*) = (unsigned short)value break
                    case SPEC_UINT:     *va_arg(args, unsigned int*) = (unsigned int)value     break
                    case SPEC_ULONG:    *va_arg(args, unsigned long*) = (unsigned long)value   break
                    case SPEC_ULLONG:   -> Fall through
                    case SPEC_UINTMAXT: *va_arg(args, unsigned long long*) = value             break
                    case SPEC_SIZET:    *va_arg(args, unsigned int*) = (unsigned int)value     break
                    }*/
                    self.setIntVar(args[self.converted],IF spec.format=SPEC_FMT_OCTAL THEN self.octVal(s) ELSE Val(s))

                    self.converted:=self.converted+1
                ENDIF
            ELSEIF ((spec.type >= SPEC_FLOAT) AND (spec.type <= SPEC_LDOUBLE))
                -> Extract and convert floating point values
                n:=self.load_fpvalue(src, s, spec.field_width, FALSE)

                IF ((n = 0) AND (self.converted = 0)) THEN JUMP brk1

                IF ((n > 0) AND (spec.suppressed=FALSE))
                    -> Out of range values invoke undefined behavior, so we'll play DS9000 here 
                    /*switch (spec.type) {
                    case SPEC_FLOAT:   *va_arg(args, float*) = strtof(s, 0)        break
                    case SPEC_DOUBLE:  *va_arg(args, double*) = strtod(s, 0)       break
                    case SPEC_LDOUBLE: *va_arg(args, long double*) = strtold(s, 0) break
                    }*/
                    self.setIntVar(args[self.converted],RealVal(s))

                    self.converted:=self.converted+1
                ENDIF
            ENDIF
        ENDIF
    ENDWHILE

brk1:
    Dispose(spec.scanset)
    spec.scanset:=0

ENDPROC IF((self.converted = 0) OR (self.error_state)) THEN EOF ELSE self.converted


/*
Example of use

PROC main()

  DEF a=0,b=0,c=0
  DEF d[100]:STRING
  DEF s[100]:STRING
  DEF e,f
  DEF res
  
  DEF scanf : PTR TO scanf
  
  a:=5
  b:=11
  c:=12
  e:=0.0
  f:=0
  
  NEW scanf.create()
  res:=scanf.scanf('test abc 10,000 2a -3 a-string -5.3','test %*[abcdef] %d %x %d %s %f %n',[{a},{b},{c},{d},{e},{f}])
  END scanf
  
  WriteF('a=\d, b=\d, c=\d d=\s e=\s f=\d\n',a,b,c,d,RealF(s,e,8),f)
  WriteF('res=\d\n',res)
ENDPROC*/
