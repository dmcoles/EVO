OPT MODULE,EXPORT

/*
 * Copyright (c) 2004-2013 Sergey Lyubka <valenok@gmail.com>
 * Copyright (c) 2013 Cesanta Software Limited
 * All rights reserved
 *
 * This library is dual-licensed: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation. For the terms of this
 * license, see <http://www.gnu.org/licenses/>.
 *
 * You are free to use this library under the terms of the GNU General
 * Public License, but WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 *
 * Alternatively, you can license this library under a commercial
 * license, as set out in <http://cesanta.com/products.html>.
 */
 
 ->Amiga E conversion by Darren Coles 15.Mar.2024

EXPORT ENUM SLRE_IGNORE_CASE = 1

#define MAX_BRANCHES 100
#define MAX_BRACKETS 100
#define FAIL_IF(condition, error_code) IF (condition) THEN RETURN (error_code)

#define SLRE_NO_MATCH               -1
#define SLRE_UNEXPECTED_QUANTIFIER  -2
#define SLRE_UNBALANCED_BRACKETS    -3
#define SLRE_INTERNAL_ERROR         -4
#define SLRE_INVALID_CHARACTER_SET  -5
#define SLRE_INVALID_METACHARACTER  -6
#define SLRE_CAPS_ARRAY_TOO_SMALL   -7
#define SLRE_TOO_MANY_BRANCHES      -8
#define SLRE_TOO_MANY_BRACKETS      -9

OBJECT slre_cap
  ptr: PTR TO CHAR
  len
ENDOBJECT

OBJECT bracket_pair
  ptr: PTR TO CHAR  /* Points to the first char after '(' in regex  */
  len:INT           /* Length of the text between '(' and ')'       */
  branches:INT      /* Index in the branches array for this pair    */
  num_branches:INT; /* Number of '|' in this bracket pair           */
ENDOBJECT

OBJECT branch 
  bracket_index:INT;    /* index for 'struct bracket_pair brackets' */
                        /* array defined below                      */
  schlong:PTR TO CHAR;  /* points to the '|' character in the regex */
ENDOBJECT

OBJECT regex_info
  /*
   * Describes all bracket pairs in the regular expression.
   * First entry is always present, and grabs the whole regex.
   */
  brackets[MAX_BRACKETS]:ARRAY OF bracket_pair
  num_brackets:INT

  /*
   * Describes alternations ('|' operators) in the regular expression.
   * Each branch falls into a specific branch pair.
   */
  branches[MAX_BRANCHES]:ARRAY OF LONG
  num_branches:INT

  /* Array of captures provided by the user */
  caps:PTR TO slre_cap
  num_caps:INT

  /* E.g. SLRE_IGNORE_CASE. See enum below */
  flags:INT
ENDOBJECT

PROC isdigit(s) IS s == ["0" TO "9"]

PROC isxdigit(s) IS s == ["0" TO "9", "a" TO "f", "A" TO "F"]

PROC isspace(s) IS (s==[" ","\n","\t","\x0B","\x0C","\b"])

PROC is_metacharacter(s:PTR TO CHAR) IS (s[]==["^","$","(",")",".","[","]","*","+","?","|","\\","S","s","d","b","f","n","r","t","v"])

PROC op_len(re:PTR TO CHAR) IS IF (re[0] = "\\") AND (re[1] = "x") THEN 4 ELSE IF re[0] = "\\" THEN 2 ELSE 1

PROC set_len(re:PTR TO CHAR, re_len)
  DEF len = 0

  WHILE ((len < re_len) AND (re[len] <> "]"))
    len += op_len(re + len)
  ENDWHILE
ENDPROC IF len <= re_len THEN len + 1 ELSE -1

PROC get_op_len(re:PTR TO CHAR, re_len) IS IF re[0] = "[" THEN set_len(re + 1, re_len - 1) + 1 ELSE op_len(re)

PROC is_quantifier(re:PTR TO CHAR) IS (re[0] = "*") OR (re[0] = "+") OR (re[0] = "?")

PROC toi(x) IS IF isdigit(x) THEN x - "0" ELSE  x - "W"

PROC hextoi(s:PTR TO CHAR) IS (toi(LowerChar(s[0])) << 4) OR toi(LowerChar(s[1]))

PROC match_op(re:PTR TO CHAR, s:PTR TO CHAR, info: PTR TO regex_info)
  DEF result = 0
  SELECT (re[])
    CASE "\\"
      /* Metacharacters */
      SELECT (re[1])
        CASE "S"
          FAIL_IF(isspace(s[]), SLRE_NO_MATCH)
          result++
        CASE "s"
          FAIL_IF(isspace(s[])=0, SLRE_NO_MATCH)
          result++
        CASE "d"
          FAIL_IF(isdigit(s[])=0, SLRE_NO_MATCH)
          result++
        CASE "b"
          FAIL_IF(s[] <> "\x08", SLRE_NO_MATCH)
          result++
        CASE "f"
          FAIL_IF(s[] <> "\x0C", SLRE_NO_MATCH)
          result++
        CASE "n"
          FAIL_IF(s[] <> "\n", SLRE_NO_MATCH)
          result++
        CASE "r"
          FAIL_IF(s[] <> "\b", SLRE_NO_MATCH)
          result++
        CASE "t"
          FAIL_IF(s[] <> "\t", SLRE_NO_MATCH)
          result++
        CASE "v"
          FAIL_IF(s[] <> "\x0B", SLRE_NO_MATCH)
          result++
        CASE "x"
          /* Match byte, \xHH where HH is hexadecimal byte representaion */
          FAIL_IF(hextoi(re + 2) <> s[], SLRE_NO_MATCH)
          result++
        DEFAULT
          /* Valid metacharacter check is done in bar() */
          FAIL_IF(re[1] <> s[0], SLRE_NO_MATCH)
          result++
      ENDSELECT
    CASE "|"
      FAIL_IF(1, SLRE_INTERNAL_ERROR)
    CASE "$"
      FAIL_IF(1, SLRE_NO_MATCH)
    CASE "."
      result++
    DEFAULT
      IF (info.flags AND SLRE_IGNORE_CASE) 
        FAIL_IF(LowerChar(re[]) <> LowerChar(s[]), SLRE_NO_MATCH)
      ELSE
        FAIL_IF(re[] <> s[], SLRE_NO_MATCH)
      ENDIF
      result++
  ENDSELECT

ENDPROC result

PROC match_set(re:PTR TO CHAR, re_len, s:PTR TO CHAR, info:PTR TO regex_info)
  DEF len = 0, result = -1, invert 

  invert := re[0]= "^"
  IF (invert)
    re++
    re_len--
  ENDIF

  WHILE ((len <= re_len) AND (re[len] <> "]") AND (result <= 0))
    /* Support character range */
    IF ((re[len] <> "-") AND (re[len + 1] = "-") AND (re[len + 2] <> "]") AND
        (re[len + 2] <> 0))
      IF info.flags AND SLRE_IGNORE_CASE
        result:=IF (LowerChar(s[]) >= LowerChar(re[len])) AND (LowerChar(s[]) <= LowerChar(re[len + 2])) THEN 1 ELSE 0
      ELSE
        result:=IF (s[] >= re[len]) AND (s[] <= re[len + 2]) THEN 1 ELSE 0
      ENDIF
      len += 3
    ELSE
      result := match_op(re + len, s, info)
      len += op_len(re + len)
    ENDIF
  ENDWHILE
ENDPROC IF ((invert=0) AND (result > 0)) OR ((invert) AND (result <= 0)) THEN 1 ELSE -1


PROC bar(re:PTR TO CHAR, re_len, s:PTR TO CHAR, s_len, info: PTR TO regex_info, bi)
  /* i is offset in re, j is offset in s, bi is brackets index */
  DEF i, j, n, step, j2, result
  DEF nj, n1, n2, ni, non_greedy, flg

  j:=0
  i:=0
  WHILE ((i < re_len) AND (j <= s_len))

    /* Handle quantifiers. Get the length of the chunk. */
    step := IF re[i] = "(" THEN info.brackets[bi + 1].len + 2  ELSE get_op_len(re + i, re_len - i)

    /*WriteF('\s {\d}[\s] {\d}[\s] re_len=\d step=\d i=\d j=\d\n', 'bar',
         re_len - i, re + i, s_len - j, s + j, re_len, step, i, j);*/

    FAIL_IF(is_quantifier(re+i), SLRE_UNEXPECTED_QUANTIFIER)
    FAIL_IF(step <= 0, SLRE_INVALID_CHARACTER_SET)

    IF (((i + step) < re_len) AND is_quantifier(re + i + step))
      ->WriteF('QUANTIFIER: {\d}[\s]\c {\d}[\s]\n', step, re + i,re[i + step], s_len - j, s + j)
      IF (re[i + step] = "?")
        result := bar(re + i, step, s + j, s_len - j, info, bi)
        j += IF (result > 0) THEN result ELSE 0
        i++
      ELSEIF ((re[i + step] = "+") OR (re[i + step] = "*"))
        j2 := j
        nj := j 
        n2 := -1
        non_greedy := 0

        /* Points to the regexp code after the quantifier */
        ni := i + step + 1
        IF ((ni < re_len) AND (re[ni] = "?"))
          non_greedy := 1
          ni++
        ENDIF

        REPEAT
          IF ((n1 := bar(re + i, step, s + j2, s_len - j2, info, bi)) > 0)
            j2 += n1
          ENDIF
          EXIT ((re[i + step] = "+") AND (n1 < 0))

          IF (ni >= re_len)
            /* After quantifier, there is nothing */
            nj := j2
          ELSEIF ((n2 := bar(re + ni, re_len - ni, s + j2,
                               s_len - j2, info, bi)) >= 0) 
            /* Regex after quantifier matched */
            nj := j2 + n2
          ENDIF
          EXIT ((nj > j) AND non_greedy)
        UNTIL n1 <= 0
        

        /*
         * Even if we found one or more pattern, this branch will be executed,
         * changing the next captures.
         */
        IF (n1 < 0) AND (n2 < 0) AND (re[i + step] = "*")
          IF ((n2 := bar(re + ni, re_len - ni, s + j, s_len - j, info, bi)) > 0)
            nj := j + n2
          ENDIF
        ENDIF

        ->WriteF('STAR/PLUS END: \d \d \d \d \d\n', j, nj, re_len - ni, n1, n2)
        FAIL_IF((re[i + step] = "+") AND (nj = j), SLRE_NO_MATCH)

        /* If while loop body above was not executed for the * quantifier,  */
        /* make sure the rest of the regex matches                          */
        FAIL_IF((nj = j) AND (ni < re_len) AND (n2 < 0), SLRE_NO_MATCH)

        /* Returning here cause we've matched the rest of RE already */
        RETURN nj
      ENDIF
      i += step
      CONT TRUE
    ENDIF

    IF (re[i] = "[")
      n := match_set(re + i + 1, re_len - (i + 2), s + j, info)
      ->WriteF('SET {\d}\s {\d}[\s] -> \d\n', step, re + i, s_len - j, s + j, n)
      FAIL_IF(n <= 0, SLRE_NO_MATCH)
      j += n
    ELSEIF (re[i] = "(")
      n := SLRE_NO_MATCH
      bi++
      FAIL_IF(bi >= info.num_brackets, SLRE_INTERNAL_ERROR)
      /*WriteF('CAPTURING {\d}[\s] {\d}[\s] [\s]\n',
           step, re + i, s_len - j, s + j, re + i + step)*/

      IF (re_len - (i + step) <= 0)
        /* Nothing follows brackets */
        n := doh(s + j, s_len - j, info, bi);
      ELSE
        FOR j2 := 0 TO s_len - j
          flg:=0
          IF ((n := doh(s + j, s_len - (j + j2), info, bi)) >= 0)
            IF (bar(re + i + step, re_len - (i + step),
                  s + j + n, s_len - (j + n), info, bi) >= 0) THEN flg:=1
          ENDIF
                 
          EXIT flg
        ENDFOR
      ENDIF

      ->WriteF('CAPTURED {\d}[\s] {\d}[\s]:\d\n', step, re + i, s_len - j, s + j, n)
      FAIL_IF(n < 0, n)
      IF ((info.caps) AND (n > 0))
        info.caps[bi - 1].ptr := s + j
        info.caps[bi - 1].len := n
      ENDIF
      j += n
    ELSEIF (re[i] = "^")
      FAIL_IF(j <> 0, SLRE_NO_MATCH)
    ELSEIF (re[i] = "$")
      FAIL_IF(j <> s_len, SLRE_NO_MATCH)
    ELSE
      FAIL_IF(j >= s_len, SLRE_NO_MATCH)
      n := match_op((re + i), (s + j), info)
      FAIL_IF(n <= 0, n)
      j += n
    ENDIF
    i += step
  ENDWHILE

ENDPROC j

/* Process branch points */
PROC doh(s:PTR TO CHAR, s_len, info:PTR TO regex_info, bi)
  DEF b:PTR TO bracket_pair
  DEF i = 0, len, result, p:PTR TO CHAR
  DEF branch:PTR TO branch

  b := info.brackets[bi]

  REPEAT
    IF (i = 0)
      p:= b.ptr
    ELSE 
      branch:=info.branches[b.branches + i - 1]
      p:=branch.schlong + 1
    ENDIF
    
    IF b.num_branches = 0 
      len := b.len
    ELSE 
      IF i = b.num_branches 
        len := (b.ptr + b.len - p)
      ELSE  
        branch := info.branches[b.branches + i]
        len := branch.schlong - p
      ENDIF
    ENDIF
    ->WriteF('\s \d \d {\d}[\s] {\d}[\s]\n', 'doh', bi, i, len, p, s_len, s)
    result := bar(p, len, s, s_len, info, bi)
    ->WriteF('\s <- \d\n', 'doh', result)
  UNTIL  Not((result <= 0) AND (i++ < b.num_branches))  /* At least 1 iteration */

ENDPROC result

PROC baz(s:PTR TO CHAR, s_len, info:PTR TO regex_info)
  DEF i, result = -1, is_anchored
  
  is_anchored := info.brackets[0].ptr[0] = "^";

  FOR i := 0 TO s_len
    result := doh(s + i, s_len - i, info, 0)
    IF (result >= 0)
      result += i
      EXIT TRUE
    ENDIF
    EXIT is_anchored
  ENDFOR

ENDPROC result

PROC setup_branch_points(info:PTR TO regex_info)
  DEF i, j
  DEF tmp: PTR TO branch
  DEF branch:PTR TO branch
  DEF branch2:PTR TO branch

  /* First, sort branches. Must be stable, no qsort. Use bubble algo. */
  FOR i:=0 TO  info.num_branches-1
    FOR j:= i + 1 TO info.num_branches-1
      branch:=info.branches[i]
      branch2:=info.branches[j]
      IF (branch.bracket_index > branch2.bracket_index)
        tmp := info.branches[i]
        info.branches[i] := info.branches[j]
        info.branches[j] := tmp
      ENDIF
    ENDFOR
  ENDFOR

  /*
   * For each bracket, set their branch points. This way, for every bracket
   * (i.e. every chunk of regex) we know all branch points before matching.
   */
  j:=0
  FOR i :=0 TO info.num_brackets-1
    info.brackets[i].num_branches := 0
    info.brackets[i].branches := j
    
    branch2:=info.branches[j]
    WHILE ((j < info.num_branches) ANDALSO (branch2.bracket_index = i))
      info.brackets[i].num_branches := info.brackets[i].num_branches + 1
      j++
      branch2:=info.branches[j]
    ENDWHILE
  ENDFOR
ENDPROC

PROC foo(re:PTR TO CHAR, re_len, s:PTR TO CHAR, s_len, info: PTR TO regex_info)
  DEF i, step, depth = 0, ind
  DEF branch:PTR TO branch

  /* First bracket captures everything */
  info.brackets[0].ptr := re
  info.brackets[0].len := re_len
  info.num_brackets := 1

  /* Make a single pass over regex string, memorize brackets and branches */
  i:=0
  WHILE (i < re_len)
    step := get_op_len(re + i, re_len - i)

    IF (re[i] = "|")
      FAIL_IF(info.num_branches >= MAX_BRANCHES, SLRE_TOO_MANY_BRANCHES)
      branch:=info.branches[info.num_branches]
      branch.bracket_index := IF info.brackets[info.num_brackets - 1].len = -1 THEN info.num_brackets - 1 ELSE depth
      branch.schlong := re+i
      info.num_branches := info.num_branches + 1
    ELSEIF (re[i] = "\\")
      FAIL_IF(i >= (re_len - 1), SLRE_INVALID_METACHARACTER)
      IF (re[i + 1] = "x")
        /* Hex digit specification must follow */
        FAIL_IF((re[i + 1] = "x") AND (i >= (re_len - 3)),SLRE_INVALID_METACHARACTER)
        FAIL_IF((re[i + 1] =  "x") AND (((isxdigit(re[i + 2])) AND (isxdigit(re[i + 3])))=0), SLRE_INVALID_METACHARACTER)
      ELSE
        FAIL_IF(is_metacharacter(re + i + 1)=0,SLRE_INVALID_METACHARACTER)
      ENDIF
    ELSEIF (re[i] = "(")
      FAIL_IF(info.num_brackets >= MAX_BRACKETS,SLRE_TOO_MANY_BRACKETS)
      depth++  /* Order is important here. Depth increments first. */
      info.brackets[info.num_brackets].ptr := re + i + 1
      info.brackets[info.num_brackets].len := -1
      info.num_brackets := info.num_brackets + 1
      FAIL_IF((info.num_caps > 0) AND ((info.num_brackets - 1) > info.num_caps),SLRE_CAPS_ARRAY_TOO_SMALL)
    ELSEIF (re[i] = ")")
      ind := IF info.brackets[info.num_brackets - 1].len = -1 THEN info.num_brackets - 1 ELSE depth
      info.brackets[ind].len := (re+i - info.brackets[ind].ptr)
      /*WriteF('SETTING BRACKET \d {\d}[\s]\n',
           ind, info.brackets[ind].len, info.brackets[ind].ptr)*/
      depth--
      FAIL_IF(depth < 0, SLRE_UNBALANCED_BRACKETS)
      FAIL_IF((i > 0) AND (re[i - 1] = "("), SLRE_NO_MATCH)
    ENDIF
    i += step
  ENDWHILE

  FAIL_IF(depth <> 0, SLRE_UNBALANCED_BRACKETS)
  setup_branch_points(info)

ENDPROC baz(s, s_len, info)

PROC slre_match(regexp:PTR TO CHAR, s:PTR TO CHAR, s_len, caps:PTR TO slre_cap, num_caps, flags)
  DEF info:regex_info
  DEF res,i
  DEF branch:PTR TO branch

  /* Initialize info structure */
  info.flags := flags
  info.num_brackets := 0
  info.num_branches := 0
  info.num_caps := num_caps
  info.caps := caps
  
  FOR i:=0 TO MAX_BRANCHES-1 
    NEW branch
    info.branches[i]:=branch
  ENDFOR

  ->WriteF('========================> [\s] [\s]\n', regexp, s);
  res:= foo(regexp, StrLen(regexp), s, s_len, info)
  
  FOR i:=0 TO MAX_BRANCHES-1 
    branch:=info.branches[i]
    END branch
  ENDFOR
ENDPROC res
