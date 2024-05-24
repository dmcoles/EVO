
  MODULE '*slre'

DEF static_total_tests = 0;
DEF static_failed_tests = 0;

CONST REQUEST = ' GET /index.html HTTP/1.0\r\n\r\n'

CONST STR = 'aa 1234 xy\nxyz'
CONST REGEX = 'aa ([0-9]*) *([x-z]*)\\s+xy([yz])'
CONST REGEX2 = '((https?://)[^\\s/\a\q<>]+/?[^\\s\a\q<>]*)'

CONST URLSTR = '<img src=\qHTTPS://FOO.COM/x?b#c=tab1\q/>   <a href=\qhttp://cesanta.com\q>some link</a>'


PROC fail(str,test,line)
  WriteF('Fail on test \d: (line \d) [\s]\n', test, line, str);
  static_failed_tests++
ENDPROC

#define ASSERT(expr) IF (expr)=0 THEN fail('', (static_total_tests++)+1,_SRCLINE_) ELSE static_total_tests++

/* Regex must have exactly one bracket pair */
PROC slre_replace(regex:PTR TO CHAR, buf:PTR TO CHAR, sub: PTR TO CHAR)
  DEF s=0:PTR TO CHAR
  DEF n, n1, n2, n3, s_len, len, o
  DEF cap:slre_cap

  len := StrLen(buf)

  REPEAT
    s_len := IF s = 0 THEN 0 ELSE StrLen(s)
    
    IF ((n := slre_match(regex, buf, len, cap, 1, 0)) > 0)
      n1 := cap.ptr - buf
      n2 := StrLen(sub)
      n3 := buf+n - (cap.ptr+cap.len)
    ELSE
      n1 := len
      n2 := 0
      n3 := 0
    ENDIF
    o:=s
    s:=New(s_len + n1 + n2 + n3 + 1)
    IF o
      AstrCopy(s,o,StrLen(o)+1)
      Dispose(o)
    ENDIF
 
    AstrCopy(s + s_len, buf, n1+1)
    AstrCopy(s + s_len + n1, sub, n2+1)
    AstrCopy(s + s_len + n1 + n2, cap.ptr + cap.len, n3+1)
    s[s_len + n1 + n2 + n3] := 0
    
    buf += IF n > 0 THEN n ELSE len
    len -= IF n > 0 THEN n ELSE len
  UNTIL len <= 0;
 

ENDPROC s

PROC main()
  DEF caps[10]:ARRAY OF slre_cap
  DEF s:PTR TO CHAR
  DEF i,j,str_len

  /* Metacharacters */
  ASSERT(slre_match('$', 'abcd', 4, 0, 0, 0) = 4)
  ASSERT(slre_match('^', 'abcd', 4, 0, 0, 0) = 0)
  ASSERT(slre_match('x|^', 'abcd', 4, 0, 0, 0) = 0)
  ASSERT(slre_match('x|$', 'abcd', 4, 0, 0, 0) = 4)
  ASSERT(slre_match('x', 'abcd', 4, 0, 0, 0) = SLRE_NO_MATCH)
  ASSERT(slre_match('.', 'abcd', 4, 0, 0, 0) = 1)
  ASSERT(slre_match('^.*\\\\.*$', 'c:\\Tools', 8, 0, 0, SLRE_IGNORE_CASE) = 8)
  ASSERT(slre_match('\\', 'a', 1, 0, 0, 0) = SLRE_INVALID_METACHARACTER)
  ASSERT(slre_match('\\x', 'a', 1, 0, 0, 0) = SLRE_INVALID_METACHARACTER)
  ASSERT(slre_match('\\x1', 'a', 1, 0, 0, 0) = SLRE_INVALID_METACHARACTER)
  ASSERT(slre_match('\\x20', ' ', 1, 0, 0, 0) = 1)

  ASSERT(slre_match('^.+$', '', 0, 0, 0, 0) = SLRE_NO_MATCH)
  ASSERT(slre_match('^(.+)$', '', 0, 0, 0, 0) = SLRE_NO_MATCH)
  ASSERT(slre_match('^([\\+-]?)([\\d]+)$', '+', 1,caps, 10, SLRE_IGNORE_CASE) = SLRE_NO_MATCH)
  
  ASSERT(slre_match('^([\\+-]?)([\\d]+)$', '+27', 3,caps, 10, SLRE_IGNORE_CASE) = 3)
  ASSERT(caps[0].len = 1)
  ASSERT(caps[0].ptr[0] = "+")
  ASSERT(caps[1].len = 2)
  ASSERT(StrCmp(caps[1].ptr, '27', 2))

  ASSERT(slre_match('tel:\\+(\\d+[\\d-]+\\d)','tel:+1-201-555-0123;a=b', 23, caps, 10, 0) = 19);
  ASSERT(caps[0].len = 14);
  ASSERT(StrCmp(caps[0].ptr, '1-201-555-0123', 14));

  // Character sets 
  ASSERT(slre_match('[abc]', '1c2', 3, 0, 0, 0) = 2);
  ASSERT(slre_match('[abc]', '1C2', 3, 0, 0, 0) = SLRE_NO_MATCH);
  ASSERT(slre_match('[abc]', '1C2', 3, 0, 0, SLRE_IGNORE_CASE) = 2);
  ASSERT(slre_match('[.2]', '1C2', 3, 0, 0, 0) = 1);
  ASSERT(slre_match('[\\S]+', 'ab cd', 5, 0, 0, 0) = 2);
  ASSERT(slre_match('[\\S]+\\s+[tyc]*', 'ab cd', 5, 0, 0, 0) = 4);
  ASSERT(slre_match('[\\d]', 'ab cd', 5, 0, 0, 0) = SLRE_NO_MATCH);
  ASSERT(slre_match('[^\\d]', 'ab cd', 5, 0, 0, 0) = 1);
  ASSERT(slre_match('[^\\d]+', 'abc123', 6, 0, 0, 0) = 3);
  ASSERT(slre_match('[1-5]+', '123456789', 9, 0, 0, 0) = 5);
  ASSERT(slre_match('[1-5a-c]+', '123abcdef', 9, 0, 0, 0) = 6);
  ASSERT(slre_match('[1-5a-]+', '123abcdef', 9, 0, 0, 0) = 4);
  ASSERT(slre_match('[1-5a-]+', '123a--2oo', 9, 0, 0, 0) = 7);
  ASSERT(slre_match('[htps]+://', 'https://', 8, 0, 0, 0) = 8);
  ASSERT(slre_match('[^\\s]+', 'abc def', 7, 0, 0, 0) = 3);
  ASSERT(slre_match('[^fc]+', 'abc def', 7, 0, 0, 0) = 2);
  ASSERT(slre_match('[^d\\sf]+', 'abc def', 7, 0, 0, 0) = 3);
 
  
  // Flags - case sensitivity 
  ASSERT(slre_match('FO', 'foo', 3, 0, 0, 0) = SLRE_NO_MATCH);
  ASSERT(slre_match('FO', 'foo', 3, 0, 0, SLRE_IGNORE_CASE) = 2);
  ASSERT(slre_match('(?m)FO', 'foo', 3, 0, 0, 0) = SLRE_UNEXPECTED_QUANTIFIER);
  ASSERT(slre_match('(?m)x', 'foo', 3, 0, 0, 0) = SLRE_UNEXPECTED_QUANTIFIER);

  ASSERT(slre_match('fo', 'foo', 3, 0, 0, 0) = 2);
  ASSERT(slre_match('.+', 'foo', 3, 0, 0, 0) = 3);
  ASSERT(slre_match('.+k', 'fooklmn', 7, 0, 0, 0) = 4);
  ASSERT(slre_match('.+k.', 'fooklmn', 7, 0, 0, 0) = 5);
  ASSERT(slre_match('p+', 'fooklmn', 7, 0, 0, 0) = SLRE_NO_MATCH);
  ASSERT(slre_match('ok', 'fooklmn', 7, 0, 0, 0) = 4);
  ASSERT(slre_match('lmno', 'fooklmn', 7, 0, 0, 0) = SLRE_NO_MATCH);
  ASSERT(slre_match('mn.', 'fooklmn', 7, 0, 0, 0) = SLRE_NO_MATCH);
  ASSERT(slre_match('o', 'fooklmn', 7, 0, 0, 0) = 2);
  ASSERT(slre_match('^o', 'fooklmn', 7, 0, 0, 0) = SLRE_NO_MATCH);
  ASSERT(slre_match('^', 'fooklmn', 7, 0, 0, 0) = 0);
  ASSERT(slre_match('n$', 'fooklmn', 7, 0, 0, 0) = 7);
  ASSERT(slre_match('n$k', 'fooklmn', 7, 0, 0, 0) = SLRE_NO_MATCH);
  ASSERT(slre_match('l$', 'fooklmn', 7, 0, 0, 0) = SLRE_NO_MATCH);
  ASSERT(slre_match('.$', 'fooklmn', 7, 0, 0, 0) = 7);
  ASSERT(slre_match('a?', 'fooklmn', 7, 0, 0, 0) = 0);
  ASSERT(slre_match('^a*CONTROL', 'CONTROL', 7, 0, 0, 0) = 7);
  ASSERT(slre_match('^[a]*CONTROL', 'CONTROL', 7, 0, 0, 0) = 7);
  ASSERT(slre_match('^(a*)CONTROL', 'CONTROL', 7, 0, 0, 0) = 7);
  ASSERT(slre_match('^(a*)?CONTROL', 'CONTROL', 7, 0, 0, 0) = 7);

  ASSERT(slre_match('\\_', 'abc', 3, 0, 0, 0) = SLRE_INVALID_METACHARACTER);
  ASSERT(slre_match('+', 'fooklmn', 7, 0, 0, 0) = SLRE_UNEXPECTED_QUANTIFIER);
  ASSERT(slre_match('()+', 'fooklmn', 7, 0, 0, 0) = SLRE_NO_MATCH);
  ASSERT(slre_match('\\x', '12', 2, 0, 0, 0) = SLRE_INVALID_METACHARACTER);
  ASSERT(slre_match('\\xhi', '12', 2, 0, 0, 0) = SLRE_INVALID_METACHARACTER);
  ASSERT(slre_match('\\x20', '_ J', 3, 0, 0, 0) = 2);
  ASSERT(slre_match('\\x4A', '_ J', 3, 0, 0, 0) = 3);
  ASSERT(slre_match('\\d+', 'abc123def', 9, 0, 0, 0) = 6);

  // Balancing brackets 
  ASSERT(slre_match('(x))', 'fooklmn', 7, 0, 0, 0) = SLRE_UNBALANCED_BRACKETS);
  ASSERT(slre_match('(', 'fooklmn', 7, 0, 0, 0) = SLRE_UNBALANCED_BRACKETS);

  ASSERT(slre_match('klz?mn', 'fooklmn', 7, 0, 0, 0) = 7);
  ASSERT(slre_match('fa?b', 'fooklmn', 7, 0, 0, 0) = SLRE_NO_MATCH);

  // Brackets & capturing *
  ASSERT(slre_match('^(te)', 'tenacity subdues all', 20, caps, 10, 0) = 2);
  ASSERT(slre_match('(bc)', 'abcdef', 6, caps, 10, 0) = 3);
  ASSERT(slre_match('.(d.)', 'abcdef', 6, caps, 10, 0) = 5);
  ASSERT(slre_match('.(d.)\\)?', 'abcdef', 6, caps, 10, 0) = 5);
  ASSERT(caps[0].len = 2);
  ASSERT(StrCmp(caps[0].ptr, 'de', 2));
  ASSERT(slre_match('(.+)', '123', 3, caps, 10, 0) = 3);
  ASSERT(slre_match('(2.+)', '123', 3, caps, 10, 0) = 3);
  ASSERT(caps[0].len = 2);
  ASSERT(StrCmp(caps[0].ptr, '23', 2));
  ASSERT(slre_match('(.+2)', '123', 3, caps, 10, 0) = 2);
  ASSERT(caps[0].len = 2);
  ASSERT(StrCmp(caps[0].ptr, '12', 2));
  ASSERT(slre_match('(.*(2.))', '123', 3, caps, 10, 0) = 3);
  ASSERT(slre_match('(.)(.)', '123', 3, caps, 10, 0) = 2);
  ASSERT(slre_match('(\\d+)\\s+(\\S+)', '12 hi', 5, caps, 10, 0) = 5);
  ASSERT(slre_match('ab(cd)+ef', 'abcdcdef', 8, 0, 0, 0) = 8);
  ASSERT(slre_match('ab(cd)*ef', 'abcdcdef', 8, 0, 0, 0) = 8);
  ASSERT(slre_match('ab(cd)+?ef', 'abcdcdef', 8, 0, 0, 0) = 8);
  ASSERT(slre_match('ab(cd)+?.', 'abcdcdef', 8, 0, 0, 0) = 5);
  ASSERT(slre_match('ab(cd)?', 'abcdcdef', 8, 0, 0, 0) = 4);
  ASSERT(slre_match('a(b)(cd)', 'abcdcdef', 8, caps, 1, 0) = SLRE_CAPS_ARRAY_TOO_SMALL);
  ASSERT(slre_match('(.+/\\d+\\.\\d+)\\.jpg$', '/foo/bar/12.34.jpg', 18, caps, 1, 0) = 18);
  ASSERT(slre_match('(ab|cd).*\\.(xx|yy)', 'ab.yy', 5, 0, 0, 0) = 5);
  ASSERT(slre_match('.*a', 'abcdef', 6, 0, 0, 0) = 1);
  ASSERT(slre_match('(.+)c', 'abcdef', 6, 0, 0, 0) = 3);
  ASSERT(slre_match('\\n', 'abc\ndef', 7, 0, 0, 0) = 4);

  ASSERT(slre_match('b.\\s*\\n', 'aa\b\nbb\b\ncc\b\n\b\n', 14, caps, 10, 0) = 8);

  // Greedy vs non-greedy 
  ASSERT(slre_match('.+c', 'abcabc', 6, 0, 0, 0) = 6);
  ASSERT(slre_match('.+?c', 'abcabc', 6, 0, 0, 0) = 3);
  ASSERT(slre_match('.*?c', 'abcabc', 6, 0, 0, 0) = 3);
  ASSERT(slre_match('.*c', 'abcabc', 6, 0, 0, 0) = 6);
  ASSERT(slre_match('bc.d?k?b+', 'abcabc', 6, 0, 0, 0) = 5);

  // Branching 
  ASSERT(slre_match('|', 'abc', 3, 0, 0, 0) = 0);
  ASSERT(slre_match('|.', 'abc', 3, 0, 0, 0) = 1);
  ASSERT(slre_match('x|y|b', 'abc', 3, 0, 0, 0) = 2);
  ASSERT(slre_match('k(xx|yy)|ca', 'abcabc', 6, 0, 0, 0) = 4);
  ASSERT(slre_match('k(xx|yy)|ca|bc', 'abcabc', 6, 0, 0, 0) = 3);
  ASSERT(slre_match('(|.c)', 'abc', 3, caps, 10, 0) = 3);
  ASSERT(caps[0].len = 2);
  ASSERT(StrCmp(caps[0].ptr, 'bc', 2) );
  ASSERT(slre_match('a|b|c', 'a', 1, 0, 0, 0) = 1);
  ASSERT(slre_match('a|b|c', 'b', 1, 0, 0, 0) = 1);
  ASSERT(slre_match('a|b|c', 'c', 1, 0, 0, 0) = 1);
  ASSERT(slre_match('a|b|c', 'd', 1, 0, 0, 0) = SLRE_NO_MATCH);

  // Optional match at the end of the string 
  ASSERT(slre_match('^.*c.?$', 'abc', 3, 0, 0, 0) = 3);
  ASSERT(slre_match('^.*C.?$', 'abc', 3, 0, 0, SLRE_IGNORE_CASE) = 3);
  ASSERT(slre_match('bk?', 'ab', 2, 0, 0, 0) = 2);
  ASSERT(slre_match('b(k?)', 'ab', 2, 0, 0, 0) = 2);
  ASSERT(slre_match('b[k-z]*', 'ab', 2, 0, 0, 0) = 2);
  ASSERT(slre_match('ab(k|z|y)*', 'ab', 2, 0, 0, 0) = 2);
  ASSERT(slre_match('[b-z].*', 'ab', 2, 0, 0, 0) = 2);
  ASSERT(slre_match('(b|z|u).*', 'ab', 2, 0, 0, 0) = 2);
  ASSERT(slre_match('ab(k|z|y)?', 'ab', 2, 0, 0, 0) = 2);
  ASSERT(slre_match('.*', 'ab', 2, 0, 0, 0) = 2);
  ASSERT(slre_match('.*$', 'ab', 2, 0, 0, 0) = 2);
  ASSERT(slre_match('a+$', 'aa', 2, 0, 0, 0) = 2);
  ASSERT(slre_match('a*$', 'aa', 2, 0, 0, 0) = 2);
  ASSERT(slre_match( 'a+$' ,'Xaa', 3, 0, 0, 0) = 3);
  ASSERT(slre_match( 'a*$' ,'Xaa', 3, 0, 0, 0) = 3);

  // Ignore case flag 
  ASSERT(slre_match('[a-h]+', 'abcdefghxxx', 11, 0, 0, 0) = 8);
  ASSERT(slre_match('[A-H]+', 'ABCDEFGHyyy', 11, 0, 0, 0) = 8);
  ASSERT(slre_match('[a-h]+', 'ABCDEFGHyyy', 11, 0, 0, 0) = SLRE_NO_MATCH);
  ASSERT(slre_match('[A-H]+', 'abcdefghyyy', 11, 0, 0, 0) = SLRE_NO_MATCH);
  ASSERT(slre_match('[a-h]+', 'ABCDEFGHyyy', 11, 0, 0, SLRE_IGNORE_CASE) = 8);
  ASSERT(slre_match('[A-H]+', 'abcdefghyyy', 11, 0, 0, SLRE_IGNORE_CASE) = 8);

  // Example: HTTP request 

  IF (slre_match('^\\s*(\\S+)\\s+(\\S+)\\s+HTTP/(\\d)\\.(\\d)',
                 REQUEST, StrLen(REQUEST), caps, 4, 0) > 0)
    WriteF('Method: {\d}[\s], URI: {\d}[\s]\n',
           caps[0].len, caps[0].ptr,
           caps[1].len, caps[1].ptr)
  ELSE
    WriteF('Error parsing [\s]\n', REQUEST)
  ENDIF

  ASSERT(caps[1].len = 11);
  ASSERT(StrCmp(caps[1].ptr, '/index.html', caps[1].len) );



  // Example: string replacement 
  s := slre_replace('({{.+?}})',
                         'Good morning, {{foo}}. How are you, {{bar}}?',
                         'Bob');
  WriteF('\s\n', s);
  ASSERT(StrCmp(s, 'Good morning, Bob. How are you, Bob?') );
  Dispose(s);

  // Example: find all URLs in a string 
  i :=0
  j := 0
  str_len := StrLen(URLSTR)

  WHILE ((j < str_len) AND (i := slre_match(REGEX2, URLSTR + j, str_len - j, caps, 2, SLRE_IGNORE_CASE)) > 0)
    WriteF('Found URL: {\d][\s]\n', caps[0].len, caps[0].ptr);
    j += i
  ENDWHILE

  // Example more complex regular expression 

  ASSERT(slre_match(REGEX, STR, StrLen(STR), caps, 3, 0) > 0);
  ASSERT(caps[0].len = 4);
  ASSERT(caps[1].len = 2);
  ASSERT(caps[2].len = 1);
  ASSERT(caps[2].ptr[0] = "z");

  WriteF('Unit test \s (total test: \d, failed tests: \d)\n',
         IF static_failed_tests > 0 THEN 'FAILED' ELSE 'PASSED',
         static_total_tests, static_failed_tests)

  ->return static_failed_tests == 0 ? EXIT_SUCCESS : EXIT_FAILURE;
ENDPROC
