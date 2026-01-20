/* 
 * Amiga E Functions Unit Test Suite
 * For EVO Compiler
 */

OPT LARGE

/* Test tracking variables */
DEF tests_run = 0
DEF tests_passed = 0
DEF tests_failed = 0
DEF stoponfail=FALSE

CONST TESTFAIL=1

/* Helper procedure to report test results */
PROC assert_equal(expected, actual, name:PTR TO CHAR,linenum)
  assert(expected=actual,name,linenum)
ENDPROC

PROC assert_false(value,name:PTR TO CHAR,linenum)
  assert(value=FALSE,name,linenum)
ENDPROC

PROC assert_float_near(expected, actual, tolerance, name:PTR TO CHAR,linenum)
  DEF diff
  DEF s[50]: STRING
  DEF result
  diff:=!expected - actual
  IF !diff < 0.0 THEN diff:=Fabs(diff)
  assert(!diff <= tolerance, name,linenum)
ENDPROC

PROC assert(condition, test_name:PTR TO CHAR,linenum)
  tests_run++
  IF condition
    tests_passed++
    WriteF('PASS: \s\n', test_name)
  ELSE
    tests_failed++
    WriteF('FAIL: \s at line \d\n', test_name,linenum)
    IF stoponfail THEN Raise(TESTFAIL)
  ENDIF
ENDPROC


/* ============ CONSTANTS ============ */

CONST
  MAGIC_NUMBER = 42,
  MAX_SIZE = 1000,
  MIN_VALUE = -500,
  PI_APPROX = 314

PROC test_constants()
  assert_equal(42, MAGIC_NUMBER, 'CONST basic value',_SRCLINE_)
  assert_equal(1000, MAX_SIZE, 'CONST larger value',_SRCLINE_)
  assert_equal(-500, MIN_VALUE, 'CONST negative value',_SRCLINE_)
  assert_equal(314, PI_APPROX, 'CONST decimal approximation',_SRCLINE_)
ENDPROC

/* ============ ENUMERATIONS ============ */

ENUM
  RED,
  GREEN,
  BLUE,
  YELLOW

ENUM
  MONDAY = 1,
  TUESDAY,
  WEDNESDAY,
  THURSDAY,
  FRIDAY,
  SATURDAY = 10,
  SUNDAY

PROC test_enums()
  assert_equal(0, RED, 'ENUM first value is 0',_SRCLINE_)
  assert_equal(1, GREEN, 'ENUM incremented value',_SRCLINE_)
  assert_equal(2, BLUE, 'ENUM continues',_SRCLINE_)
  assert_equal(3, YELLOW, 'ENUM final value',_SRCLINE_)
  
  assert_equal(1, MONDAY, 'ENUM with custom start',_SRCLINE_)
  assert_equal(2, TUESDAY, 'ENUM after custom start',_SRCLINE_)
  assert_equal(10, SATURDAY, 'ENUM reset value',_SRCLINE_)
  assert_equal(11, SUNDAY, 'ENUM after reset',_SRCLINE_)
ENDPROC

/* ============ SETS ============ */

SET
  FLAG_READ,
  FLAG_WRITE,
  FLAG_EXECUTE,
  FLAG_DELETE

PROC test_sets()
  DEF flags = 0
  
  flags:=FLAG_READ
  assert_equal(1, flags, 'SET first flag = 1',_SRCLINE_)
  
  flags:=FLAG_WRITE
  assert_equal(2, flags, 'SET second flag = 2',_SRCLINE_)
  
  flags:=FLAG_EXECUTE
  assert_equal(4, flags, 'SET third flag = 4',_SRCLINE_)
  
  flags:=FLAG_DELETE
  assert_equal(8, flags, 'SET fourth flag = 8',_SRCLINE_)
  
  flags:=FLAG_READ OR FLAG_WRITE
  assert_equal(3, flags, 'SET combined flags',_SRCLINE_)
ENDPROC

/* ============ POINTER TYPES ============ */

PROC test_ptr_to_char()
  DEF str: PTR TO CHAR
  
  str:='Hello'
  
  assert_equal(72, str[], 'PTR TO CHAR deref gets h',_SRCLINE_)
ENDPROC

PROC test_ptr_to_int()
  DEF arr[5]: ARRAY OF INT
  DEF p:PTR TO INT
  DEF i
  
  FOR i:=0 TO 4 DO arr[i]:=i*100
  p:=arr
  
  assert_equal(0, p[], 'PTR TO INT first element',_SRCLINE_)
  assert_equal(100, p[1], 'PTR TO INT next element',_SRCLINE_)
ENDPROC

PROC test_ptr_to_long()
  DEF arr[5]:  ARRAY OF LONG
  DEF p:PTR TO LONG
  DEF i
  
  FOR i:=0 TO 4 DO arr[i]:=i*1000
  p:=arr
  
  assert_equal(0, p[], 'PTR TO LONG first element',_SRCLINE_)
  assert_equal(1000, p[1], 'PTR TO LONG next element',_SRCLINE_)
ENDPROC

PROC test_ptr_to_ptr()
  DEF value=12345:LONG
  DEF p:  PTR TO LONG
  DEF pp: PTR TO PTR TO LONG
  
  p:={value}
  pp:={p}
  
  assert_equal(12345, pp[][], 'PTR TO PTR double dereference',_SRCLINE_)
ENDPROC

/* ============ ARRAY TYPES ============ */

PROC test_array_of_char()
  DEF arr[10]:ARRAY OF CHAR
  DEF i
  
  FOR i:=0 TO 9 DO arr[i]:=65+i  /* A-J */
  
  assert_equal(65, arr[0], 'ARRAY OF CHAR first',_SRCLINE_)
  assert_equal(74, arr[9], 'ARRAY OF CHAR last',_SRCLINE_)
ENDPROC

PROC test_array_of_int()
  DEF arr[5]:ARRAY OF INT
  DEF i
  
  FOR i:=0 TO 4 DO arr[i]:=i*1000
  
  assert_equal(0, arr[0], 'ARRAY OF INT first',_SRCLINE_)
  assert_equal(4000, arr[4], 'ARRAY OF INT last',_SRCLINE_)
ENDPROC

PROC test_array_of_long()
  DEF arr[5]: ARRAY OF LONG
  DEF i
  
  FOR i:=0 TO 4 DO arr[i]:=i*1000
  
  assert_equal(0, arr[0], 'ARRAY OF LONG first',_SRCLINE_)
  assert_equal(4000, arr[4], 'ARRAY OF LONG last',_SRCLINE_)
ENDPROC

PROC test_array_of_word()
  DEF arr[5]:ARRAY OF WORD
  DEF i
  
  FOR i:=0 TO 4 DO arr[i]:=i*10000
  
  assert_equal(0, arr[0], 'ARRAY OF WORD first',_SRCLINE_)
  assert_equal(40000, arr[4], 'ARRAY OF WORD last',_SRCLINE_)
ENDPROC

PROC test_array_of_byte()
  DEF arr[5]:ARRAY OF BYTE
  DEF i
  
  FOR i:=0 TO 4 DO arr[i]:=i*20-50
  
  assert_equal(-50, arr[0], 'ARRAY OF BYTE first',_SRCLINE_)
  assert_equal(30, arr[4], 'ARRAY OF BYTE last',_SRCLINE_)
ENDPROC

PROC test_array_of_ptr()
  DEF ptrs[3]: ARRAY OF PTR TO LONG
  DEF v1=10:LONG, v2=20:LONG, v3=30:LONG
  
  ptrs[0]:={v1}
  ptrs[1]:={v2}
  ptrs[2]:={v3}
  
  assert_equal(10, ptrs[0][], 'ARRAY OF PTR element 0',_SRCLINE_)
  assert_equal(20, ptrs[1][], 'ARRAY OF PTR element 1',_SRCLINE_)
  assert_equal(30, ptrs[2][], 'ARRAY OF PTR element 2',_SRCLINE_)
ENDPROC

/* ============ BASIC TYPES & VARIABLES ============ */

PROC test_basic_types()
  DEF k=1000000:LONG
  DEF p:PTR TO LONG

  p:={k}

  assert_equal(1000000, k, 'LONG type',_SRCLINE_)
  assert_equal(1000000, ^p, 'PTR dereference',_SRCLINE_)
  assert_equal(1000000, p[], 'PTR dereference 2',_SRCLINE_)
ENDPROC

/* ============ ARRAYS ============ */

PROC test_arrays()
  DEF arr[10]: ARRAY OF LONG
  DEF i
  
  FOR i:=0 TO 9 DO arr[i]:=i*i
  
  assert_equal(0, arr[0], 'Array assignment',_SRCLINE_)
  assert_equal(1, arr[1],'Array index 1',_SRCLINE_)
  assert_equal(25, arr[5],'Array index 5',_SRCLINE_)
  assert_equal(81, arr[9],'Array index 9',_SRCLINE_)
ENDPROC

PROC test_multidim_arrays()
  DEF matrix[3][3]:ARRAY OF LONG
  DEF i, j, val = 0
  
  FOR i:=0 TO 2
    FOR j:=0 TO 2
      matrix[i][j]:=val
      val:=val+1
    ENDFOR
  ENDFOR
  
  assert_equal(0, matrix[0][0],'2D Array [0][0]',_SRCLINE_)
  assert_equal(5, matrix[1][2],'2D Array [1][2]',_SRCLINE_)
  assert_equal(8, matrix[2][2],'2D Array [2][2]',_SRCLINE_)
ENDPROC

/* ============ ARITHMETIC OPERATORS ============ */

PROC test_arithmetic()
  DEF a = 10, b = 3
  
  assert_equal(13, a+b, 'Addition',_SRCLINE_)
  assert_equal(7, a-b, 'Subtraction',_SRCLINE_)
  assert_equal(30, a*b, 'Multiplication',_SRCLINE_)
  assert_equal(3, a/b, 'Division (16-bit)',_SRCLINE_)
  assert_equal(1, a-((a/b)*b), 'Modulo',_SRCLINE_)
  assert_equal(-10, -a, 'Negation',_SRCLINE_)
ENDPROC

PROC test_bitwise()
  DEF a = $0F, b = $F0
  
  assert_equal($00, a AND b, 'Bitwise AND',_SRCLINE_)
  assert_equal($FF, a OR b, 'Bitwise OR',_SRCLINE_)
  assert_equal(NOT $00, $FFFFFFFF, 'Bitwise NOT',_SRCLINE_)
  assert_equal(32, 8 << 2, 'Left shift',_SRCLINE_)
  assert_equal(2, 8 >> 2, 'Right shift',_SRCLINE_)
ENDPROC

/* ============ COMPOUND ASSIGNMENT OPERATORS ============ */

PROC test_compound_assign_plus()
  DEF x = 10
  x += 5
  assert_equal(15, x, 'Compound += operator',_SRCLINE_)
ENDPROC

PROC test_compound_assign_minus()
  DEF x = 20
  x -= 7
  assert_equal(13, x, 'Compound -= operator',_SRCLINE_)
ENDPROC

PROC test_compound_assign_multiply()
  DEF x = 6
  x *= 3
  assert_equal(18, x, 'Compound *= operator',_SRCLINE_)
ENDPROC

PROC test_compound_assign_divide()
  DEF x = 20
  x /= 4
  assert_equal(5, x, 'Compound /= operator',_SRCLINE_)
ENDPROC

PROC test_compound_assign_and()
  DEF x = $FF
  x AND= $0F
  assert_equal($0F, x, 'Compound AND= operator',_SRCLINE_)
ENDPROC

PROC test_compound_assign_or()
  DEF x = $F0
  x OR= $0F
  assert_equal($FF, x, 'Compound OR= operator',_SRCLINE_)
ENDPROC

/*PROC test_compound_assign_pipe()
  DEF x = $F0
  x ||= $0F
  assert_equal($FF, x, 'Compound |= operator (OR)',_SRCLINE_)
ENDPROC*/

PROC test_compound_assign_lshift()
  DEF x = 2
  x <<= 3
  assert_equal(16, x, 'Compound <<= operator',_SRCLINE_)
ENDPROC

PROC test_compound_assign_rshift()
  DEF x = 32
  x >>= 2
  assert_equal(8, x, 'Compound >>= operator',_SRCLINE_)
ENDPROC

PROC test_all_compound_assignments()
  DEF a = 100, b = 50, c = 10, d = 8
  DEF flags = $FF
  
  a += 25
  assert_equal(125, a, 'All tests:  += result',_SRCLINE_)
  
  b -= 10
  assert_equal(40, b, 'All tests:  -= result',_SRCLINE_)
  
  c *= 2
  assert_equal(20, c, 'All tests:  *= result',_SRCLINE_)
  
  d /= 2
  assert_equal(4, d, 'All tests:  /= result',_SRCLINE_)
  
  flags AND= 1
  flags OR= 2
  
  assert_equal(3, flags, 'All tests: bitwise compound ops',_SRCLINE_)
ENDPROC


/* ============ LOGICAL OPERATORS - ANDALSO & ORELSE ============ */

PROC test_andalso_true()
  DEF x = 5, y = 10
  DEF result = FALSE
  
  IF (x < 10) ANDALSO (y > 5) THEN result := TRUE
  assert(result, 'ANDALSO both conditions true',_SRCLINE_)
ENDPROC

PROC test_andalso_false_first()
  DEF x = 15, y = 10
  DEF result = TRUE
  
  IF (x < 10) ANDALSO (y > 5) THEN result := FALSE
  assert(result, 'ANDALSO first condition false',_SRCLINE_)
ENDPROC

PROC test_andalso_false_second()
  DEF x = 5, y = 2
  DEF result = TRUE
  
  IF (x < 10) ANDALSO (y > 5) THEN result := FALSE
  assert(result, 'ANDALSO second condition false',_SRCLINE_)
ENDPROC

PROC test_orelse_both_true()
  DEF x = 5, y = 10
  DEF result = FALSE
  
  IF (x < 10) ORELSE (y > 5) THEN result := TRUE
  assert(result, 'ORELSE both conditions true',_SRCLINE_)
ENDPROC

PROC test_orelse_first_true()
  DEF x = 5, y = 2
  DEF result = FALSE
  
  IF (x < 10) ORELSE (y > 5) THEN result := TRUE
  assert(result, 'ORELSE first condition true',_SRCLINE_)
ENDPROC

PROC test_orelse_second_true()
  DEF x = 15, y = 10
  DEF result = FALSE
  
  IF (x < 10) ORELSE (y > 5) THEN result := TRUE
  assert(result, 'ORELSE second condition true',_SRCLINE_)
ENDPROC

PROC test_orelse_both_false()
  DEF x = 15, y = 2
  DEF result = TRUE
  
  IF (x < 10) ORELSE (y > 5) THEN result := FALSE
  assert(result, 'ORELSE both conditions false',_SRCLINE_)
ENDPROC

PROC test_andalso_short_circuit()
  DEF counter = 0
  DEF x = 15
  DEF result = TRUE
  
  IF (x < 10) ANDALSO (counter := counter+1)=0
    result := FALSE
  ENDIF
  
  assert_equal(0, counter, 'ANDALSO short-circuits second condition',_SRCLINE_)
ENDPROC

PROC test_orelse_short_circuit()
  DEF counter = 0
  DEF x = 5
  DEF result = FALSE
  
  IF (x < 10) ORELSE (counter := counter+1)=0
    result := TRUE
  ENDIF
  
  assert_equal(0, counter, 'ORELSE short-circuits second condition',_SRCLINE_)
ENDPROC

PROC test_combined_andalso_orelse()
  DEF a = 5, b = 10, c = 15
  DEF result = FALSE
  
  IF ((a < 10) ANDALSO (b > 5)) ORELSE (c > 20)
    result := TRUE
  ENDIF
  
  assert(result, 'Combined ANDALSO and ORELSE',_SRCLINE_)
ENDPROC


/* ============ FLOAT FUNCTIONS - BASIC ============ */

PROC test_realval()
  DEF result, read
  
  result:=RealVal('3.14159')
  assert_float_near(3.14159, result, 0.001, 'RealVal basic',_SRCLINE_)
  
  result:=RealVal(' 2.5')
  assert_float_near(2.5, result, 0.001, 'RealVal with leading space',_SRCLINE_)
  
  result:=RealVal('10.0')
  assert_float_near(10.0, result, 0.001, 'RealVal integer as float',_SRCLINE_)
ENDPROC

PROC test_realf()
  DEF s[50]: STRING
  DEF result
  
  result:=RealF(s, 3.14159, 2)
  assert(StrLen(s) > 0, 'RealF produces string',_SRCLINE_)
ENDPROC

PROC test_fabs()
  DEF pos_result, neg_result
  
  pos_result:=!  Fabs(!  5.5)
  assert_float_near(5.5, pos_result, 0.001, 'Fabs positive value',_SRCLINE_)
  
  neg_result:=! Fabs(!  (-5.5))
  assert_float_near(5.5, neg_result, 0.001, 'Fabs negative value',_SRCLINE_)
ENDPROC

PROC test_ffloor()
  DEF result1, result2
  
  result1:=!  Ffloor(! 3.7)
  assert_float_near(3.0, result1, 0.001, 'Ffloor rounds down 3.7',_SRCLINE_)
  
  result2:=! Ffloor(! (-3.7))
  assert_float_near(-4.0, result2, 0.001, 'Ffloor rounds down -3.7',_SRCLINE_)
ENDPROC

PROC test_fceil()
  DEF result1, result2
  
  result1:=! Fceil(! 3.2)
  assert_float_near(4.0, result1, 0.001, 'Fceil rounds up 3.2',_SRCLINE_)
  
  result2:=! Fceil(! (-3.2))
  assert_float_near(-3.0, result2, 0.001, 'Fceil rounds up -3.2',_SRCLINE_)
ENDPROC

/* ============ TRIGONOMETRIC FUNCTIONS ============ */

PROC test_fsin()
  DEF result
  
  result:=!  Fsin(! 0.0)
  assert_float_near(0.0, result, 0.001, 'Fsin(0) = 0',_SRCLINE_)
  
  result:=! Fsin(! 1.5707963)  /* pi/2 */
  assert_float_near(1.0, result, 0.01, 'Fsin(pi/2) ˜ 1',_SRCLINE_)
ENDPROC

PROC test_fcos()
  DEF result
  
  result:=! Fcos(!  0.0)
  assert_float_near(1.0, result, 0.001, 'Fcos(0) = 1',_SRCLINE_)
  
  result:=! Fcos(! 3.14159265)  /* pi */
  assert_float_near(-1.0, result, 0.01, 'Fcos(pi) ˜ -1',_SRCLINE_)
ENDPROC

PROC test_ftan()
  DEF result
  
  result:=! Ftan(! 0.0)
  assert_float_near(0.0, result, 0.001, 'Ftan(0) = 0',_SRCLINE_)
ENDPROC

/* ============ INVERSE TRIGONOMETRIC FUNCTIONS ============ */

PROC test_fasin()
  DEF result
  
  result:=Fasin(0.0)
  assert_float_near(0.0, result, 0.001, 'Fasin(0) = 0',_SRCLINE_)
  
  result:=Fasin(0.5)
  assert_float_near(0.5236, result, 0.01, 'Fasin(0.5) ˜ pi/6',_SRCLINE_)
ENDPROC

PROC test_facos()
  DEF result
  
  result:=Facos(1.0)
  assert_float_near(0.0, result, 0.001, 'Facos(1) = 0',_SRCLINE_)
  
  result:=Facos(0.5)
  assert_float_near(1.0472, result, 0.01, 'Facos(0.5) ˜ pi/3',_SRCLINE_)
ENDPROC

PROC test_fatan()
  DEF result
  
  result:=Fatan(0.0)
  assert_float_near(0.0, result, 0.001, 'Fatan(0) = 0',_SRCLINE_)
ENDPROC

/* ============ HYPERBOLIC FUNCTIONS ============ */

PROC test_fsinh()
  DEF result
  
  result:=Fsinh(0.0)
  assert_float_near(0.0, result, 0.001, 'Fsinh(0) = 0',_SRCLINE_)
ENDPROC

PROC test_fcosh()
  DEF result
  
  result:=Fcosh(0.0)
  assert_float_near(1.0, result, 0.001, 'Fcosh(0) = 1',_SRCLINE_)
ENDPROC

PROC test_ftanh()
  DEF result
  
  result:=Ftanh(0.0)
  assert_float_near(0.0, result, 0.001, 'Ftanh(0) = 0',_SRCLINE_)
ENDPROC

/* ============ EXPONENTIAL & LOGARITHMIC FUNCTIONS ============ */

PROC test_fexp()
  DEF result
  
  result:=Fexp(0.0)
  assert_float_near(1.0, result, 0.001, 'Fexp(0) = 1',_SRCLINE_)
  
  result:=Fexp(1.0)
  assert_float_near(2.71828, result, 0.01, 'Fexp(1) ˜ e',_SRCLINE_)
ENDPROC

PROC test_flog()
  DEF result
  
  result:=Flog(1.0)
  assert_float_near(0.0, result, 0.001, 'Flog(1) = 0',_SRCLINE_)
  
  result:=Flog(2.71828)  /* e */
  assert_float_near(1.0, result, 0.01, 'Flog(e) ˜ 1',_SRCLINE_)
ENDPROC

PROC test_flog10()
  DEF result
  
  result:=Flog10(1.0)
  assert_float_near(0.0, result, 0.001, 'Flog10(1) = 0',_SRCLINE_)
  
  result:=Flog10(10.0)
  assert_float_near(1.0, result, 0.001, 'Flog10(10) = 1',_SRCLINE_)
ENDPROC

PROC test_fsqrt()
  DEF result
  
  result:=Fsqrt(0.0)
  assert_float_near(0.0, result, 0.001, 'Fsqrt(0) = 0',_SRCLINE_)
  
  result:=Fsqrt(4.0)
  assert_float_near(2.0, result, 0.001, 'Fsqrt(4) = 2',_SRCLINE_)
   
  result:=Fsqrt(2.0)
  assert_float_near(1.41421, result, 0.01, 'Fsqrt(2) ˜ 1.414',_SRCLINE_)
ENDPROC

PROC test_fpow()
  DEF result
  
  result:=Fpow(3.0, 2.0)
  assert_float_near(8.0, result, 0.001, 'Fpow(2,3) = 8',_SRCLINE_)
  
  result:=Fpow(2.0, 10.0)
  assert_float_near(100.0, result, 0.001, 'Fpow(10,2) = 100',_SRCLINE_)
  
  result:=Fpow((-1.0), 2.0)
  assert_float_near(0.5, result, 0.001, 'Fpow(2,-1) = 0.5',_SRCLINE_)
ENDPROC

/* ============ IEEE CONVERSION FUNCTIONS ============ */

PROC test_ftieee()
  DEF result
  
  /* Ftieee converts FFP to IEEE */
  result:=Ftieee(1.0)
  assert_float_near(1.0, result, 0.001, 'Ftieee(1.0) preserved',_SRCLINE_)
ENDPROC

PROC test_ffieee()
  DEF result
  
  /* Ffieee converts IEEE to FFP */
  result:=!Ffieee(1.0)
  assert_float_near(1.0, result, 0.001, 'Ffieee(1.0) preserved',_SRCLINE_)
ENDPROC

/* ============ SPECIAL TRIGONOMETRIC FUNCTION ============ */

PROC test_fsincos()
  DEF sin_result, cos_result
  
  sin_result:=Fsin(0.0)
  cos_result:=Fcos(0.0)
  
  assert_float_near(0.0, sin_result, 0.001, 'Fsincos sin(0)',_SRCLINE_)
  assert_float_near(1.0, cos_result, 0.001, 'Fsincos cos(0)',_SRCLINE_)
ENDPROC

/* ============ COMPARISON OPERATORS ============ */

PROC test_comparison()
  DEF a = 5, b = 10
  
  assert((a+5) = b, 'Equal TRUE',_SRCLINE_)
  assert(a <> b, 'Not equal TRUE',_SRCLINE_)
  assert(b > a, 'Greater TRUE',_SRCLINE_)
  assert(a < b, 'Less TRUE',_SRCLINE_)
  assert(b >= b, 'Greater or equal TRUE',_SRCLINE_)
  assert(a <= a, 'Less or equal TRUE',_SRCLINE_)
ENDPROC

/* ============ LOGICAL OPERATORS ============ */

PROC test_logical()
  DEF t = TRUE, f = FALSE
  
  assert((t AND t),'AND TRUE',_SRCLINE_)
  assert_false((t AND f),'AND FALSE',_SRCLINE_)
  assert((t OR f), 'OR TRUE',_SRCLINE_)
  assert_false((f OR f), 'OR FALSE',_SRCLINE_)
  assert_false(NOT t, 'NOT TRUE becomes FALSE',_SRCLINE_)
  assert( NOT f,'NOT FALSE becomes TRUE',_SRCLINE_)
ENDPROC

/* ============ CONTROL FLOW - IF/THEN/ELSE ============ */

PROC test_if_then_else()
  DEF x = 5, result = 0
  
  IF x < 10 THEN result:=1
  assert_equal(1, result, 'IF THEN',_SRCLINE_)
  
  result:=0
  IF x > 10 THEN result:=1 ELSE result:=2
  assert_equal(2, result, 'IF THEN ELSE',_SRCLINE_)
  
  result:= IF x > 3 THEN 100 ELSE 200
  assert_equal(100, result, 'IF THEN ELSE expression',_SRCLINE_)
ENDPROC

PROC test_if_elseif_else()
  DEF x = 15, result = 0
  
  IF x < 5
    result:=1
  ELSEIF x < 10
    result:=2
  ELSEIF x < 20
    result:=3
  ELSE
    result:=4
  ENDIF
  
  assert_equal(3, result, 'ELSEIF matching',_SRCLINE_)
ENDPROC

/* ============ CONTROL FLOW - IFN (INVERTED IF) ============ */

PROC test_ifn()
  DEF x = 5, result = 0
  
  IFN x > 10 THEN result := 1
  assert_equal(1, result, 'IFN inverted condition true',_SRCLINE_)
  
  result := 0
  IFN x < 3 THEN result := 1
  assert_equal(1, result, 'IFN inverted condition false',_SRCLINE_)
ENDPROC

PROC test_ifn_with_else()
  DEF x = 5, result = 0
  
  IFN x > 10 THEN result := 1 ELSE result := 2
  assert_equal(1, result, 'IFN with ELSE both branches',_SRCLINE_)
ENDPROC

/* ============ CONTROL FLOW - ELSEIFN (INVERTED ELSEIF) ============ */

PROC test_elseifn()
  DEF x = 15, result = 0
  
  IF x < 5
    result:=1
  ELSEIFN x < 10
    result:=2
  ELSEIFN x < 20
    result:=3
  ELSE
    result:=4
  ENDIF
  
  assert_equal(2, result, 'ELSEIFN inverted matching',_SRCLINE_)
ENDPROC

PROC test_elseifn_combined()
  DEF x = 7, result = 0
  
  IF x < 5
    result:=1
  ELSEIFN x > 10
    result:=2
  ELSE
    result:=3
  ENDIF
  
  assert_equal(2, result, 'ELSEIFN combined inverted logic',_SRCLINE_)
ENDPROC


/* ============ CONTROL FLOW - WHILE & WHILEN ============ */

PROC test_while_loop()
  DEF i = 0, sum = 0
  
  WHILE i < 5
    sum:=sum+i
    i:=i+1
  ENDWHILE
  
  assert_equal(10, sum, 'WHILE loop',_SRCLINE_)
ENDPROC

PROC test_whilen()
  DEF i = 0, sum = 0
  
  WHILEN (i >= 5)
    sum:=sum+i
    i:=i+1
  ENDWHILE
  
  assert_equal(10, sum, 'WHILEN inverted condition',_SRCLINE_)
ENDPROC

PROC test_whilen_with_elsewhile()
  DEF x = 10, result = 0
  
  WHILEN x > 20
    result:=1
    x++
  ELSEWHILE x < 15
    result:=2
    x++
  ENDWHILE
  
  assert_equal(1, result, 'WHILEN with ELSEWHILE',_SRCLINE_)
ENDPROC

/* ============ CONTROL FLOW - REPEAT & UNTILN ============ */

PROC test_repeat_until()
  DEF i = 0, sum = 0
  
  REPEAT
    sum:=sum+i
    i:=i+1
  UNTIL i >= 5
  
  assert_equal(10, sum, 'REPEAT UNTIL',_SRCLINE_)
ENDPROC

PROC test_untiln()
  DEF i = 0, sum = 0
  
  REPEAT
    sum:=sum+i
    i:=i+1
  UNTILN i < 5
  
  assert_equal(10, sum, 'UNTILN inverted condition',_SRCLINE_)
ENDPROC


/* ============ CONTROL FLOW - LOOPS BASIC ============ */

PROC test_for_loop()
  DEF i, sum = 0
  
  FOR i:=1 TO 5 DO sum:=sum+i
  assert_equal(15, sum, 'FOR loop sum 1-5',_SRCLINE_)
ENDPROC

PROC test_for_loop_step()
  DEF i, count = 0
  
  FOR i:=0 TO 10 STEP 2 DO count:=count+1
  assert_equal(6, count, 'FOR STEP (0,2,4,6,8,10)',_SRCLINE_)
ENDPROC

/* ============ CONTROL FLOW - ELSEWHILE & ALWAYS ============ */

PROC test_elsewhile()
  DEF x = 3, count = 0
  
  WHILE x < 10
    count:=count+1
    x++
  ELSEWHILE x < 20
    count:=count+10
    x++
  ENDWHILE
  
  assert_equal(107, count, 'ELSEWHILE alternate condition',_SRCLINE_)
ENDPROC

PROC test_elsewhilen()
  DEF x = 3, count = 0

 WHILE x < 10
    count:=count+1
    x++
  ELSEWHILEN x >= 20
    count:=count+10
    x++
  ENDWHILE
  
  assert_equal(107, count, 'ELSEWHILEN inverted condition',_SRCLINE_)
ENDPROC

PROC test_always()
  DEF x = 0, count = 0
  
  WHILE x < 3
    count:=count+1
    x:=x+1
  ALWAYS
    count:=count+100
  ENDWHILE
  
  assert_equal(303, count, 'ALWAYS executes every iteration',_SRCLINE_)
ENDPROC

PROC test_always_with_elsewhile()
  DEF x = 5, y = 0, result = 0
  
  WHILE x > 10
    result:=1
  ELSEWHILE x < 3
    result:=2
  ELSEWHILE x > 2
    result:=3
    y:=y+1
  ALWAYS
    result:=result+10
    EXIT y>1
  ENDWHILE
  
  assert_equal(13, result, 'ALWAYS with ELSEWHILE',_SRCLINE_)
ENDPROC

/* ============ CONTROL FLOW - LOOP & EXIT ============ */

PROC test_loop_exit()
  DEF i = 0, sum = 0
  
  LOOP
    IF i >= 5 THEN EXIT i
    sum:=sum+i
    i:=i+1
  ENDLOOP
  
  assert_equal(10, sum, 'LOOP with EXIT',_SRCLINE_)
ENDPROC

PROC test_loop_exitn()
  DEF i = 0, sum = 0
  
  LOOP
    EXITN i < 5
    sum:=sum+i
    i:=i+1
  ENDLOOP
  
  assert_equal(10, sum, 'LOOP with EXITN (inverted)',_SRCLINE_)
ENDPROC

/* ============ CONTROL FLOW - CONT & CONTN ============ */

PROC test_loop_cont()
  DEF i = 0, sum = 0
  
  WHILE i < 5
    i:=i+1
    CONT i=3
    sum:=sum+i
  ENDWHILE
  
  assert_equal(12, sum, 'CONT skips i=3',_SRCLINE_)  /* 1+2+4+5 */
ENDPROC

PROC test_loop_contn()
  DEF i = 0, sum = 0
  
  WHILE i < 5
    i:=i+1
    CONTN i = 3
    sum:=sum+i
  ENDWHILE
  
  assert_equal(3, sum, 'CONTN only processes i=3',_SRCLINE_)
ENDPROC

/* ============ CONTROL FLOW - JUMP & LABELS ============ */

PROC test_jump_simple()
  DEF result = 0
  
  result:=1
  JUMP end_label
  result:=2
  
  end_label:
  assert_equal(1, result, 'JUMP skips code',_SRCLINE_)
ENDPROC

PROC test_jump_forward()
  DEF i = 0, sum = 0
  
  start_loop:
  IF i >= 3 THEN JUMP loop_end
  sum:=sum+(i*i)
  i:=i+1
  JUMP start_loop
  
  loop_end:
  assert_equal(5, sum, 'JUMP forward creates loop (0+1+4)',_SRCLINE_)
ENDPROC

PROC test_jump_over_block()
  DEF x = 0, y = 0
  
  x:=10
  JUMP skip_block
  y:=20
  x:=30
  
  skip_block:
  assert_equal(10, x, 'JUMP over block x unchanged',_SRCLINE_)
  assert_equal(0, y, 'JUMP over block y unchanged',_SRCLINE_)
ENDPROC

PROC test_jump_multiple_labels()
  DEF result = 0
  
  JUMP label_b
  
  label_a:
  result:=1
  JUMP end_label2
  
  label_b:
  result:=2
  JUMP label_a
  
  end_label2:
  assert_equal(1, result, 'JUMP to multiple labels',_SRCLINE_)
ENDPROC

/* ============ SELECT/CASE ============ */

PROC test_select_case()
  DEF x = 2, result = 0
  
  SELECT x
    CASE 1
      result:=10
    CASE 2
      result:=20
    CASE 3
      result:=30
    DEFAULT
      result:=0
  ENDSELECT
  
  assert_equal(20, result,'SELECT CASE 2',_SRCLINE_)
ENDPROC

PROC test_select_case_default()
  DEF x = 99, result = 0
  
  SELECT x
    CASE 1
      result:=10
    CASE 2
      result:=20
    DEFAULT
      result:=999
  ENDSELECT
  
  assert_equal(999, result,'SELECT DEFAULT',_SRCLINE_)
ENDPROC

/* ============ OBJECTS WITH METHODS ============ */

OBJECT counter
  value: LONG
ENDOBJECT

PROC increment() OF counter IS self.value:=self.value+1

PROC decrement() OF counter IS self.value:=self.value-1

PROC get_value() OF counter IS self.value

PROC reset() OF counter IS self.value:=0

PROC test_object_methods()
  DEF c:counter
  
  c.value:=10
  c.increment()
  assert_equal(11, c.value, 'Object method increment',_SRCLINE_)
  
  c.decrement()
  assert_equal(10, c.value, 'Object method decrement',_SRCLINE_)
  
  assert_equal(10, c.get_value(), 'Object method with return',_SRCLINE_)
  
  c.reset()
  assert_equal(0, c.value, 'Object method reset',_SRCLINE_)
ENDPROC

/* ============ OBJECTS WITH INHERITANCE & METHODS ============ */

OBJECT shape
  name:PTR TO CHAR
ENDOBJECT

OBJECT circle OF shape
  radius:LONG
ENDOBJECT

PROC area() OF shape
  RETURN 0
ENDPROC

PROC area() OF circle
  RETURN self.radius*self.radius*314  /* rough pi approximation */
ENDPROC

PROC test_object_inheritance_methods()
  DEF s:shape, c:circle
  
  s.name:='square'
  assert_equal(0, s.area(), 'Shape base area',_SRCLINE_)
  
  c.name:='circle'
  c.radius:=10
  assert_equal(31400, c.area(), 'Circle area calculation',_SRCLINE_)
ENDPROC

/* ============ OBJECTS WITH UNIONS ============ */

OBJECT data_value
  data_type:INT
  UNION
    [int_val:INT]
    [char_val:CHAR]
  ENDUNION
ENDOBJECT

PROC test_object_with_union()
  DEF dv:data_value
  
  dv.data_type:=1
  dv.int_val:=12345
  assert_equal(12345, dv.int_val, 'UNION int_val',_SRCLINE_)
  
  dv.data_type:=2
  dv.char_val:=65  /* 'A' */
  assert_equal(65, dv.char_val, 'UNION char_val',_SRCLINE_)
ENDPROC

/* ============ OBJECTS WITH PRIVATE MEMBERS ============ */

OBJECT bank_account PRIVATE
  balance:  LONG
  account_number: LONG
ENDOBJECT

PROC deposit(amount: LONG) OF bank_account
  self.balance:=self.balance+amount
ENDPROC

PROC get_balance() OF bank_account IS self.balance

PROC test_object_private_members()
  DEF account:bank_account
  
  account.balance:=1000
  account.deposit(500)
  assert_equal(1500, account.get_balance(), 'Private member via method',_SRCLINE_)
ENDPROC

/* ============ PROCEDURES & FUNCTIONS ============ */

PROC add(x, y) IS x+y

PROC multiply(x, y)
  DEF result
  result:=x*y
ENDPROC result

PROC swap_values(a: PTR TO LONG, b:PTR TO LONG)
  DEF temp
  temp:=^a
  ^a:=^b
  ^b:=temp
ENDPROC

PROC test_procedures()
  assert_equal(15, add(10, 5),'PROC return value',_SRCLINE_)
  assert_equal(50, multiply(10, 5),'PROC with local var',_SRCLINE_)
ENDPROC

PROC test_proc_by_reference()
  DEF x = 5, y = 10
  swap_values({x}, {y})
  assert_equal(10, x,'Swap x becomes 10',_SRCLINE_)
  assert_equal(5, y,'Swap y becomes 5',_SRCLINE_)
ENDPROC

PROC sum_many(a, b, c, d) IS a+b+c+d

PROC test_multiple_args()
  assert_equal(50, sum_many(10, 15, 12, 13),'Multiple arguments',_SRCLINE_)
ENDPROC

/* ============ MULTIPLE RETURN VALUES ============ */

PROC divide_with_remainder(a, b)
  DEF quotient, remainder
  quotient:=a/b
  remainder:=a-((a/b)*b)
ENDPROC quotient, remainder

PROC test_multiple_returns()
  DEF q, r
  q, r:=divide_with_remainder(17, 5)
  assert_equal(3, q, 'Quotient',_SRCLINE_)
  assert_equal(2, r, 'Remainder',_SRCLINE_)
ENDPROC


/* ============ OBJECTS ============ */

OBJECT point
  x: LONG
  y:LONG
ENDOBJECT

OBJECT rectangle OF point
  width:LONG
  height: LONG
ENDOBJECT

PROC test_objects()
  DEF p:point
  
  p.x:=10
  p.y:=20
  
  assert_equal(10, p.x, 'Object member x',_SRCLINE_)
  assert_equal(20, p.y, 'Object member y',_SRCLINE_)
ENDPROC

PROC test_object_inheritance()
  DEF r:rectangle
  
  r.x:=5
  r.y:=10
  r.width:=100
  r.height:=200
  
  assert_equal(5, r.x,'Inherited member x',_SRCLINE_)
  assert_equal(10, r.y, 'Inherited member y',_SRCLINE_)
  assert_equal(100, r. width, 'Own member width',_SRCLINE_)
  assert_equal(200, r.height, 'Own member height',_SRCLINE_)
ENDPROC

/* ============ LISTS ============ */

PROC test_immediate_lists()
  DEF lst[10]:LIST
  DEF item
  
  ListCopy(lst, [1, 2, 3, 4, 5], ALL)
  
  assert_equal(1, lst[0],'List item 0',_SRCLINE_)
  assert_equal(3, lst[2],'List item 2',_SRCLINE_)
  assert_equal(5, lst[4],'List item 4',_SRCLINE_)
ENDPROC

PROC test_list_functions()
  DEF lst[20]:LIST
  
  ListCopy(lst, [10, 20, 30], ALL)
  ListAdd(lst, [40, 50], ALL)
  
  assert_equal(40, lst[3],'List after add',_SRCLINE_)
  assert_equal(5, ListLen(lst),'List length check',_SRCLINE_)
ENDPROC


/* ============ SIZEOF & OFFSETOF ============ */

PROC test_sizeof()
  DEF i:PTR TO INT
  DEF j:PTR TO BYTE
   DEF arr[10]: ARRAY OF INT
  
  DEF l: LONG
  
  assert_equal(2, SIZEOF i,'SIZEOF PTR TO INT',_SRCLINE_)
  assert_equal(1, SIZEOF j,'SIZEOF PTR TO BYTE',_SRCLINE_)
  assert_equal(4, SIZEOF l,'SIZEOF LONG',_SRCLINE_)
  assert_equal(8, SIZEOF point,'SIZEOF point object',_SRCLINE_)
  assert_equal(2, SIZEOF arr, 'SIZEOF ARRAY OF INT',_SRCLINE_)
ENDPROC


PROC test_psizeof()
  DEF i:PTR TO INT
  DEF l:PTR TO LONG
  DEF arr[10]: ARRAY OF INT
  
  assert_equal(4, PSIZEOF i, 'PSIZEOF PTR TO INT',_SRCLINE_)
  assert_equal(4, PSIZEOF l, 'PSIZEOF PTR TO LONG',_SRCLINE_)
  assert_equal(2, PSIZEOF arr, 'PSIZEOF ARRAY OF INT',_SRCLINE_)
ENDPROC

PROC test_arraysize()
  DEF arr1[10]:ARRAY OF LONG
  DEF arr2[5][8]:ARRAY OF INT
  
  assert_equal(10, ARRAYSIZE 1,arr1, 'ARRAYSIZE 1D array',_SRCLINE_)
  assert_equal(5, ARRAYSIZE 1,arr2, 'ARRAYSIZE 2D first dimension',_SRCLINE_)
  assert_equal(8, ARRAYSIZE 2,arr2, 'ARRAYSIZE 2D second dimension',_SRCLINE_)
ENDPROC


PROC test_sizeof_object()
  DEF r:rectangle
  
  assert_equal(16, SIZEOF r,'SIZEOF rectangle',_SRCLINE_)
ENDPROC

PROC test_offsetof()
  DEF offset
  
  offset:=OFFSETOF point.x
  assert_equal(0, offset,'OFFSETOF first member is 0',_SRCLINE_)

  offset:=OFFSETOF point.y
  assert(offset>0,'OFFSETOF second member is >0',_SRCLINE_)
ENDPROC

/* ============ ASSIGNMENT OPERATORS ============ */

PROC test_compound_assignments()
  DEF x = 10
  
  x:=x+5
  assert_equal(15, x,'x+5',_SRCLINE_)
  
  x:=x-3
  assert_equal(12, x,'x-3',_SRCLINE_)
  
  x:=x*2
  assert_equal(24, x,'x*2',_SRCLINE_)
ENDPROC

/* ============ INCREMENT/DECREMENT ============ */

PROC test_increment_decrement()
  DEF x = 5, y = 10
  
  x:=x+1
  assert_equal(6, x,'Increment',_SRCLINE_)
  
  y:=y-1
  assert_equal(9, y,'Decrement',_SRCLINE_)
ENDPROC

PROC test_inc_dec_statements()
  DEF x = 5
  
  INC x
  assert_equal(6, x,'INC x',_SRCLINE_)
  
  DEC x
  assert_equal(5, x,'DEC x',_SRCLINE_)

  x++
  assert_equal(6, x,'x++',_SRCLINE_)
  
  x--
  assert_equal(5, x,'x--',_SRCLINE_)

ENDPROC

/* ============ FLOAT OPERATIONS ============ */

PROC test_floats()
  DEF f = 3.14, g = 2.0
  DEF result
  
  result:=! f+g
  assert(result > 5.0,'Float addition',_SRCLINE_)
  assert(result < 5.2,'Float addition2',_SRCLINE_)
ENDPROC

/* ============ IMMEDIATE VALUES ============ */

PROC test_hex_values()
  DEF x = $FF, y = $1000
  
  assert_equal(255, x,'Hex $FF',_SRCLINE_)
  assert_equal(4096, y,'Hex $1000',_SRCLINE_)
ENDPROC

PROC test_binary_values()
  DEF x = %1111, y = %10101010
  
  assert_equal(15, x,'Binary %1111',_SRCLINE_)
  assert_equal(170, y,'Binary %10101010',_SRCLINE_)
ENDPROC

PROC test_char_values()
  DEF x = "ABC"
  
  assert_equal($00414243, x,'Char "ABC"',_SRCLINE_)
ENDPROC

/* ============ CONDITIONAL EXPRESSIONS ============ */

PROC test_conditional_expr()
  DEF x = 5, result
  
  result:= IF x > 3 THEN 100 ELSE 200
  assert_equal(100, result,'Conditional expr 100',_SRCLINE_)
  
  result:= IF x > 10 THEN 100 ELSE 200
  assert_equal(200, result,'Conditional expr 200',_SRCLINE_)
ENDPROC

PROC test_ternary_operator()
  DEF x = 5, result
  
  result:= x > 3 ? 100 :  200
  assert_equal(100, result,'Ternary operator',_SRCLINE_)
ENDPROC

/* ============ QUICK COMPARE OPERATOR ============ */

PROC test_quick_compare()
  DEF x = 5, result
  
  result:= x == [5, 10 TO 20, 100]
  assert(result,'Quick compare match',_SRCLINE_)
ENDPROC

/* ============ SWAP OPERATOR ============ */

PROC test_swap_operator()
  DEF a = 10, b = 20
  
  a:=:b
  assert_equal(20, a,'Swap a',_SRCLINE_)
  assert_equal(10, b,'Swap b',_SRCLINE_)
ENDPROC

/* ============ EXCEPTIONS ============ */

ENUM
  ERR_CUSTOM = 100

PROC inner(result:PTR TO LONG) HANDLE
  IF TRUE THEN Raise(ERR_CUSTOM)
EXCEPT
  result[]:=999
ENDPROC

PROC test_exception_basic()
  DEF result = 0
  
  inner({result})
  assert_equal(999, result,'Exception raised',_SRCLINE_)
ENDPROC

PROC test_try_catch()
  DEF result = 0
  
  TRY
    IF TRUE THEN Throw(ERR_CUSTOM, 123)
    result:=0
  CATCH
    result:=exceptioninfo
  ENDTRY
  
  assert_equal(123, result,'TRY CATCH info',_SRCLINE_)
ENDPROC

/* ============ DYNAMIC MEMORY - NEW/END ============ */

PROC test_new_single()
  DEF p:PTR TO LONG
  
  NEW p
  IF p <> NIL
    ^p:=12345
    assert_equal(12345, ^p,'NEW allocation',_SRCLINE_)
    END p
  ENDIF
ENDPROC

PROC test_new_array()
  DEF arr: PTR TO LONG
  DEF i
  
  NEW arr[5]
  IF arr <> NIL
    FOR i:=0 TO 4 DO arr[i]:=i*10
    assert_equal(0, arr[0],'NEW array [0]',_SRCLINE_)
    assert_equal(20, arr[2],'NEW array [2]',_SRCLINE_)
    END arr[5]
  ENDIF
ENDPROC

/* ============ QUOTED EXPRESSIONS ============ */

PROC test_quoted_expressions()
  DEF x = 5
  DEF f
  DEF result
  
  f := `x*x*x
  
  result:=Eval(f)
  assert_equal(125, result,'Quoted expression',_SRCLINE_)
ENDPROC

/* ============ ForAll FUNCTION ============ */

PROC test_forall_all_true()
  DEF lst[5]:   LIST
  DEF result
  DEF x
  
  ListCopy(lst, [2, 4, 6, 8, 10], ALL)
  
  result := ForAll({x}, lst, `x > 0)
  assert(result, 'ForAll all elements positive',_SRCLINE_)
ENDPROC

PROC test_forall_some_false()
  DEF lst[5]:   LIST
  DEF result
  DEF x
  
  ListCopy(lst, [2, 4, -1, 8, 10], ALL)
  
  result := ForAll({x}, lst, `x > 0)
  assert_false(result, 'ForAll fails with negative element',_SRCLINE_)
ENDPROC

PROC test_forall_empty_list()
  DEF lst[5]:   LIST
  DEF result
  DEF x
  
  ListCopy(lst, [10, 20, 30], 3)
  
  result := ForAll({x}, lst, `x > 100)
  assert_false(result, 'ForAll with high threshold',_SRCLINE_)
ENDPROC

PROC test_forall_with_equal_check()
  DEF lst[5]:   LIST
  DEF result
  DEF x
  
  ListCopy(lst, [5, 5, 5, 5], ALL)
  
  result := ForAll({x}, lst, `x = 5)
  assert(result, 'ForAll all elements equal',_SRCLINE_)
ENDPROC

PROC test_forall_conditional()
  DEF lst[5]:   LIST
  DEF result, threshold = 3
  DEF x
  
  ListCopy(lst, [4, 5, 6, 7, 8], ALL)
  
  result := ForAll({x}, lst, `x > threshold)
  assert(result, 'ForAll with variable comparison',_SRCLINE_)
ENDPROC

PROC test_forall_side_effects()
  DEF lst[5]:   LIST
  DEF counter = 0
  DEF result
  DEF x
  
  ListCopy(lst, [1, 2, 3], 3)
  
  result := ForAll({x}, lst, `(counter := counter+1) > 0)
  assert_equal(3, counter, 'ForAll evaluates all elements',_SRCLINE_)
ENDPROC

/* ============ Exists FUNCTION ============ */

PROC test_exists_one_true()
  DEF lst[5]:   LIST
  DEF result
  DEF x
  
  ListCopy(lst, [1, 2, 5, 4, 3], ALL)
  
  result := Exists({x}, lst, `x = 5)
  assert(result, 'Exists finds matching element',_SRCLINE_)
ENDPROC

PROC test_exists_none_true()
  DEF lst[5]:   LIST
  DEF result
  DEF x
  
  ListCopy(lst, [1, 2, 3, 4, 6], ALL)
  
  result := Exists({x}, lst, `x = 5)
  assert_false(result, 'Exists returns false when no match',_SRCLINE_)
ENDPROC

PROC test_exists_multiple_matches()
  DEF lst[5]:   LIST
  DEF result
  DEF x
  
  ListCopy(lst, [2, 4, 6, 8, 10], ALL)
  
  result := Exists({x}, lst, `x > 5)
  assert(result, 'Exists with multiple matches',_SRCLINE_)
ENDPROC

PROC test_exists_empty_list_condition()
  DEF lst[5]:   LIST
  DEF result
  DEF x
  
  ListCopy(lst, [1, 2, 3, 4, 5], ALL)
  
  result := Exists({x}, lst, `x > 100)
  assert_false(result, 'Exists with impossible condition',_SRCLINE_)
ENDPROC

PROC test_exists_short_circuit()
  DEF lst[5]:   LIST
  DEF counter = 0
  DEF result
  DEF x
  
  ListCopy(lst, [1, 5, 3, 4, 2], ALL)
  
  result := Exists({x}, lst, `(counter := counter+1) AND (x = 5))
  assert(result < 3, 'Exists short-circuits after finding match',_SRCLINE_)
ENDPROC

PROC test_exists_with_range_check()
  DEF lst[5]:   LIST
  DEF result
  DEF x
  
  ListCopy(lst, [1, 2, 15, 4, 5], ALL)
  
  result := Exists({x}, lst, `(x > 10) AND (x < 20))
  assert(result, 'Exists with complex condition',_SRCLINE_)
ENDPROC

/* ============ MapList FUNCTION ============ */

PROC test_maplist_square()
  DEF src[5]:   LIST
  DEF dst[5]:   LIST
  DEF result
  DEF x
  
  ListCopy(src, [1, 2, 3, 4, 5], ALL)
  
  result := MapList({x}, src, dst, `x*x)
  
  assert_equal(1, dst[0], 'MapList square 1',_SRCLINE_)
  assert_equal(4, dst[1], 'MapList square 2',_SRCLINE_)
  assert_equal(9, dst[2], 'MapList square 3',_SRCLINE_)
  assert_equal(16, dst[3], 'MapList square 4',_SRCLINE_)
  assert_equal(25, dst[4], 'MapList square 5',_SRCLINE_)
ENDPROC

PROC test_maplist_double()
  DEF src[5]:    LIST
  DEF dst[5]:   LIST
  DEF result
  DEF x
  
  ListCopy(src, [1, 2, 3, 4, 5], ALL)
  
  result := MapList({x}, src, dst, `x*2)
  
  assert_equal(2, dst[0], 'MapList double 1',_SRCLINE_)
  assert_equal(4, dst[1], 'MapList double 2',_SRCLINE_)
  assert_equal(6, dst[2], 'MapList double 3',_SRCLINE_)
  assert_equal(8, dst[3], 'MapList double 4',_SRCLINE_)
  assert_equal(10, dst[4], 'MapList double 5',_SRCLINE_)
ENDPROC

PROC test_maplist_increment()
  DEF src[5]:   LIST
  DEF dst[5]:   LIST
  DEF result
  DEF x
  
  ListCopy(src, [5, 10, 15, 20, 25], ALL)
  
  result := MapList({x}, src, dst, `x+1)
  
  assert_equal(6, dst[0], 'MapList increment 5',_SRCLINE_)
  assert_equal(11, dst[1], 'MapList increment 10',_SRCLINE_)
  assert_equal(16, dst[2], 'MapList increment 15',_SRCLINE_)
ENDPROC

PROC test_maplist_complex_expression()
  DEF src[5]:   LIST
  DEF dst[5]:   LIST
  DEF multiplier = 3
  DEF x
  
  ListCopy(src, [1, 2, 3, 4, 5], ALL)
  
  MapList({x}, src, dst, `(x*multiplier)+10)
  
  assert_equal(13, dst[0], 'MapList complex (1*3)+10',_SRCLINE_)
  assert_equal(16, dst[1], 'MapList complex (2*3)+10',_SRCLINE_)
  assert_equal(19, dst[2], 'MapList complex (3*3)+10',_SRCLINE_)
ENDPROC

PROC test_maplist_conditional()
  DEF src[5]:   LIST
  DEF dst[5]:   LIST
  DEF x
  
  ListCopy(src, [1, 2, 3, 4, 5], ALL)
  
  MapList({x}, src, dst, `IF x > 2 THEN x*10 ELSE x)
  
  assert_equal(1, dst[0], 'MapList conditional 1',_SRCLINE_)
  assert_equal(2, dst[1], 'MapList conditional 2',_SRCLINE_)
  assert_equal(30, dst[2], 'MapList conditional 3*10',_SRCLINE_)
  assert_equal(40, dst[3], 'MapList conditional 4*10',_SRCLINE_)
  assert_equal(50, dst[4], 'MapList conditional 5*10',_SRCLINE_)
ENDPROC

PROC test_maplist_negative_values()
  DEF src[5]:   LIST
  DEF dst[5]:   LIST
  DEF x
  
  ListCopy(src, [-5, -2, 0, 3, -1], ALL)
  
  MapList({x}, src, dst, `Abs(x))
  
  assert_equal(5, dst[0], 'MapList Abs(-5)',_SRCLINE_)
  assert_equal(2, dst[1], 'MapList Abs(-2)',_SRCLINE_)
  assert_equal(0, dst[2], 'MapList Abs(0)',_SRCLINE_)
  assert_equal(3, dst[3], 'MapList Abs(3)',_SRCLINE_)
  assert_equal(1, dst[4], 'MapList Abs(-1)',_SRCLINE_)
ENDPROC

PROC test_maplist_returns_list()
  DEF src[5]:   LIST
  DEF dst[5]:   LIST
  DEF result
  DEF x
  
  ListCopy(src, [1, 2, 3, 4, 5], ALL)
  
  result := MapList({x}, src, dst, `x*2)
  
  assert(result <> NIL, 'MapList returns list',_SRCLINE_)
ENDPROC

PROC test_maplist_large_values()
  DEF src[5]:   LIST
  DEF dst[5]:   LIST
  DEF x
 
  ListCopy(src, [100, 200, 300, 400, 500], ALL)
  
  MapList({x}, src, dst, `x/10)
  
  assert_equal(10, dst[0], 'MapList large 100/10',_SRCLINE_)
  assert_equal(20, dst[1], 'MapList large 200/10',_SRCLINE_)
  assert_equal(50, dst[4], 'MapList large 500/10',_SRCLINE_)
ENDPROC

/* ============ COMBINATION TESTS ============ */

PROC test_forall_and_maplist()
  DEF src[5]:   LIST
  DEF dst[5]:   LIST
  DEF all_positive
  DEF x,y
  
  ListCopy(src, [2, 4, 6, 8, 10], ALL)
  
  MapList({x}, src, dst, `x*x)
  all_positive := ForAll({y}, dst, `y > 0)
  
  assert(all_positive, 'Combination:  MapList then ForAll',_SRCLINE_)
ENDPROC

PROC test_exists_on_maplist_result()
  DEF src[5]:   LIST
  DEF dst[5]:   LIST
  DEF has_large
  DEF x,y
  
  ListCopy(src, [1, 2, 3, 4, 5], ALL)
  
  MapList({x}, src, dst, `x*10)
  has_large := Exists({y}, dst, `y > 30)
  
  assert(has_large, 'Combination: MapList then Exists',_SRCLINE_)
ENDPROC

PROC test_forall_exists_consistency()
  DEF lst[5]:   LIST
  DEF all_match, any_match
  DEF x
  
  ListCopy(lst, [5, 5, 5, 5, 5], ALL)
  
  all_match := ForAll({x}, lst, `x = 5)
  any_match := Exists({x}, lst, `x = 5)
  
  assert(all_match, 'ForAll all same values',_SRCLINE_)
  assert(any_match, 'Exists finds same values',_SRCLINE_)
ENDPROC

PROC test_maplist_with_counter()
  DEF src[5]:   LIST
  DEF dst[5]:   LIST
  DEF counter = 0
  DEF x
  
  ListCopy(src, [10, 20, 30, 40, 50], ALL)
  
  MapList({x}, src, dst, `(counter := counter+1) * x)
  
  assert_equal(5, counter, 'MapList processes all elements',_SRCLINE_)
ENDPROC


/* ============ ANONYMOUS LISTS ============ */

PROC test_anonymous_lists()
  DEF result
  
  result:=ListItem([10, 20, 30, 40, 50], 2)
  assert_equal(30, result,'ListItem at index 2',_SRCLINE_)
ENDPROC

/* ============ UNIFICATION ============ */

PROC test_unification()
  DEF a, b, c
  DEF lst: PTR TO LONG
  
  NEW lst[3]
  lst[0]:=10
  lst[1]:=20
  lst[2]:=30
  
  IF (lst <=> [10, b, 30])
    assert_equal(20, b,'Unification b',_SRCLINE_)
  ENDIF
  
  END lst[3]
ENDPROC


/* Test StrCmp() - String comparison (case-sensitive) */
PROC test_strcmp()
  DEF str1[50]:STRING
  DEF str2[50]:STRING
 
  WriteF('\n=== Testing StrCmp() ===\n')
  
  StrCopy(str1, 'Hello')
  StrCopy(str2, 'Hello')
  assert(StrCmp(str1, str2) = TRUE, 'StrCmp: Equal strings',_SRCLINE_)
  
  StrCopy(str1, 'Hello')
  StrCopy(str2, 'World')
  assert(StrCmp(str1, str2) = FALSE, 'StrCmp: Different strings',_SRCLINE_)

  StrCopy(str1, 'Hi')
  StrCopy(str2, 'World')
  assert(StrCmp(str1, str2) = FALSE, 'StrCmp: Different string lengths',_SRCLINE_)
  
  StrCopy(str1, 'Test')
  StrCopy(str2, 'test')
  assert(StrCmp(str1, str2) = FALSE, 'StrCmp: Case sensitive',_SRCLINE_)
  
  StrCopy(str1, '')
  StrCopy(str2, '')
  assert(StrCmp(str1, str2) = TRUE, 'StrCmp: Empty strings',_SRCLINE_)
  
  ->-> Test with ALL parameter
  StrCopy(str1, 'Hello')
  StrCopy(str2, 'Hello')
  assert(StrCmp(str1, str2, ALL) = TRUE, 'StrCmp: ALL parameter',_SRCLINE_)

  -> Test with ALL parameter
  StrCopy(str1, 'Hello1')
  StrCopy(str2, 'Hello2')
  assert(StrCmp(str1, str2, ALL) = FALSE, 'StrCmp: ALL parameter - not matching',_SRCLINE_)
  
  -> Test with length parameter
  StrCopy(str1, 'Hello')
  StrCopy(str2, 'Help')
  assert(StrCmp(str1, str2, 3) = TRUE, 'StrCmp: First 3 chars match',_SRCLINE_)

  -> Test with length parameter
  StrCopy(str1, 'Hello')
  StrCopy(str2, 'Help')
  assert(StrCmp(str1, str2, 4) = FALSE, 'StrCmp: First 4 chars no match',_SRCLINE_)
ENDPROC

/* Test StriCmp() - String comparison (case-insensitive) */
PROC test_stricmp()
  DEF str1[50]:STRING
  DEF str2[50]:STRING
  
  WriteF('\n=== Testing StriCmp() ===\n')
  
  StrCopy(str1, 'Hello')
  StrCopy(str2, 'hello')
  assert(StriCmp(str1, str2) = TRUE, 'StriCmp: Case-insensitive equal',_SRCLINE_)
  
  StrCopy(str1, 'WORLD')
  StrCopy(str2, 'world')
  assert(StriCmp(str1, str2) = TRUE, 'StriCmp: Upper/lower case equal',_SRCLINE_)

  StrCopy(str1, 'Hi')
  StrCopy(str2, 'World')
  assert(StriCmp(str1, str2) = FALSE, 'StriCmp: Different string lengths',_SRCLINE_)

  
  StrCopy(str1, 'Test')
  StrCopy(str2, 'Different')
  assert(StriCmp(str1, str2) = FALSE, 'StriCmp: Different strings',_SRCLINE_)
  
  StrCopy(str1, 'MiXeD')
  StrCopy(str2, 'mIxEd')
  assert(StriCmp(str1, str2) = TRUE, 'StriCmp: Mixed case equal',_SRCLINE_)

  StrCopy(str1, '')
  StrCopy(str2, '')
  assert(StriCmp(str1, str2) = TRUE, 'StriCmp: Empty strings',_SRCLINE_)
  
  -> Test with ALL parameter
  StrCopy(str1, 'Hello')
  StrCopy(str2, 'Hello')
  assert(StriCmp(str1, str2, ALL) = TRUE, 'StriCmp: ALL parameter',_SRCLINE_)

  -> Test with ALL parameter
  StrCopy(str1, 'Hello1')
  StrCopy(str2, 'Hello2')
  assert(StriCmp(str1, str2, ALL) = FALSE, 'StriCmp: ALL parameter - not matching',_SRCLINE_)
  
  -> Test with length parameter
  StrCopy(str1, 'Hello')
  StrCopy(str2, 'help')
  assert(StriCmp(str1, str2, 3) = TRUE, 'StriCmp: First 3 chars match',_SRCLINE_)

  -> Test with length parameter
  StrCopy(str1, 'Hello')
  StrCopy(str2, 'help')
  assert(StriCmp(str1, str2, 4) = FALSE, 'StriCmp: First 4 chars no match',_SRCLINE_)

ENDPROC

/* Test StrCopy() - String copy function */
PROC test_strcopy()
  DEF dest[50]:STRING
  DEF source[50]:STRING
  
  WriteF('\n=== Testing StrCopy() ===\n')
  
  StrCopy(source, 'Test String')
  StrCopy(dest, source)
  assert(StrCmp(dest, 'Test String') = TRUE, 'StrCopy: Basic copy',_SRCLINE_)
  assert(EstrLen(dest) = 11, 'StrCopy: Basic copy - estrlen',_SRCLINE_)

  StrCopy(dest, '123456789012345678901234567890123456789012345678901234567890')
  assert(StrCmp(dest, '12345678901234567890123456789012345678901234567890') = TRUE, 'StrCopy: overflow',_SRCLINE_)
  assert(EstrLen(dest) = 50, 'StrCopy: overflow - estrlen',_SRCLINE_)
  
  StrCopy(dest, '')
  assert(StrLen(dest) = 0, 'StrCopy: Empty string copy - strlen',_SRCLINE_)
  assert(EstrLen(dest) = 0, 'StrCopy: Empty string copy - estrlen',_SRCLINE_)
  
  StrCopy(dest, '1234567890')
  assert(StrCmp(dest, '1234567890') = TRUE, 'StrCopy: Numeric string',_SRCLINE_)
  
  -> Test with length parameter
  StrCopy(source, 'Hello World')
  StrCopy(dest, source, 5)
  assert(StrCmp(dest, 'Hello') = TRUE, 'StrCopy: Copy first 5 chars',_SRCLINE_)
  assert(EstrLen(dest) = 5, 'StrCopy: Copy first 5 chars - estrlen',_SRCLINE_)
  
  -> Test with ALL parameter
  StrCopy(dest, source, ALL)
  assert(StrCmp(dest, 'Hello World') = TRUE, 'StrCopy: Copy with ALL',_SRCLINE_)
  
  StrCopy(dest, '\b\n')
  assert(dest[0]=13, 'StrCopy: CR',_SRCLINE_)
  assert(dest[1]=10, 'StrCopy: LF',_SRCLINE_)

  StrCopy(dest, '\q')
  assert(dest[0]=34, 'StrCopy: double quote',_SRCLINE_)

  StrCopy(dest, '\a')
  assert(dest[0]=39, 'StrCopy: single quote',_SRCLINE_)

  StrCopy(dest, '\e')
  assert(dest[0]=27, 'StrCopy: escape',_SRCLINE_)

  StrCopy(dest, '\t')
  assert(dest[0]=9, 'StrCopy: tab',_SRCLINE_)

  StrCopy(dest, '\!')
  assert(dest[0]=7, 'StrCopy: bell',_SRCLINE_)

  StrCopy(dest, '\0')
  assert(dest[0]=0, 'StrCopy: nul',_SRCLINE_)

  StrCopy(dest, '\x41')
  assert(dest[0]=65, 'StrCopy: ascii char',_SRCLINE_)

  StrCopy(dest, '\\')
  assert(dest[0]=92, 'StrCopy: backslash',_SRCLINE_) 
ENDPROC

/* Test StrAdd() - String concatenation */
PROC test_stradd()
  DEF str[100]:STRING
  
  WriteF('\n=== Testing StrAdd() ===\n')
  
  StrCopy(str, 'Hello')
  StrAdd(str, ' World')
  assert(StrCmp(str, 'Hello World') = TRUE, 'StrAdd: Concatenate strings',_SRCLINE_)
  assert(EstrLen(str) = 11, 'StrAdd: Concatenate strings - estrlen',_SRCLINE_)
  
  StrCopy(str, 'Test')
  StrAdd(str, '')
  assert(StrCmp(str, 'Test') = TRUE, 'StrAdd: Add empty string',_SRCLINE_)
  assert(EstrLen(str) = 4, 'StrAdd: Add empty string - estrlen',_SRCLINE_)
  
  StrCopy(str, '')
  StrAdd(str, 'Start')
  assert(StrCmp(str, 'Start') = TRUE, 'StrAdd: Add to empty string',_SRCLINE_)
  assert(EstrLen(str) = 5, 'StrAdd: Add to empty string - estrlen',_SRCLINE_)
  
  StrCopy(str, 'One')
  StrAdd(str, 'Two')
  StrAdd(str, 'Three')
  assert(StrCmp(str, 'OneTwoThree') = TRUE, 'StrAdd: Multiple adds',_SRCLINE_)
  assert(EstrLen(str) = 11, 'StrAdd: Multiple adds - estrlen',_SRCLINE_)

  StrCopy(str, '12345678901234567890123456789012345678901234567890123456789012345678901234567890')
  StrAdd(str, '9876543210987654321098765432109876543210')
  assert(StrCmp(str, '1234567890123456789012345678901234567890123456789012345678901234567890123456789098765432109876543210') = TRUE, 'StrAdd: overflow',_SRCLINE_)
  assert(EstrLen(str) = 100, 'StrAdd: overflow - estrlen',_SRCLINE_)
    
  
  -> Test with length parameter
  StrCopy(str, 'Hello')
  StrAdd(str, ' World', 3)
  assert(StrCmp(str, 'Hello Wo') = TRUE, 'StrAdd: Add with length limit',_SRCLINE_)
  assert(EstrLen(str) = 8, 'StrAdd: Add with length limit - estrlen',_SRCLINE_)
ENDPROC

/* Test StrAddChar() - Add single character to string */
PROC test_straddchar()
  DEF str[50]:STRING
  DEF shortstr[5]:STRING
  
  WriteF('\n=== Testing StrAddChar() ===\n')
  
  StrCopy(str, 'Hello')
  StrAddChar(str, "!")
  assert(StrCmp(str, 'Hello!') = TRUE, 'StrAddChar: Add char to string',_SRCLINE_)
  assert(EstrLen(str) = 6, 'StrAddChar: Add char to string - estrlen',_SRCLINE_)
  
  StrCopy(str, '')
  StrAddChar(str, "A")
  assert(StrCmp(str, 'A') = TRUE, 'StrAddChar: Add to empty string',_SRCLINE_)
  assert(EstrLen(str) = 1, 'StrAddChar: Add to empty string - estrlen',_SRCLINE_)
  
  StrCopy(str, 'Test')
  StrAddChar(str, "1")
  StrAddChar(str, "2")
  assert(StrCmp(str, 'Test12') = TRUE, 'StrAddChar: Add multiple chars',_SRCLINE_)
  assert(EstrLen(str) = 6, 'StrAddChar: Add multiple chars - estrlen',_SRCLINE_)
  
  StrCopy(shortstr, 'Test1')
  StrAddChar(shortstr, "1")
  assert(StrCmp(shortstr, 'Test1') = TRUE, 'StrAddChar: Overflow',_SRCLINE_)
  assert(EstrLen(shortstr) = 5, 'StrAddChar: Overflow - estrlen',_SRCLINE_)
  
ENDPROC

/* Test StrLen() - String length function */
PROC test_strlen()
  DEF str1[20]:STRING
  DEF str2[20]:STRING
  DEF str3[20]:STRING
  DEF astr1[20]:ARRAY OF CHAR
  
  WriteF('\n=== Testing StrLen() ===\n')
  
  StrCopy(str1, 'Hello')
  assert(StrLen(str1) = 5, 'StrLen: Normal string',_SRCLINE_)
  
  StrCopy(str2, '')
  assert(StrLen(str2) = 0, 'StrLen: Empty string',_SRCLINE_)
  
  StrCopy(str3, 'A')
  assert(StrLen(str3) = 1, 'StrLen: Single character',_SRCLINE_)
  
  StrCopy(str1, 'Hello World!')
  assert(StrLen(str1) = 12, 'StrLen: String with punctuation',_SRCLINE_)
  
  AstrCopy(astr1, 'Hello')
  assert(StrLen(astr1) = 5, 'StrLen: array of char string',_SRCLINE_)
  
  AstrCopy(astr1, '')
  assert(StrLen(astr1) = 0, 'StrLen: array of char - Empty string',_SRCLINE_)
  
  AstrCopy(astr1, 'A')
  assert(StrLen(astr1) = 1, 'StrLen: array of char - Single character',_SRCLINE_)
  
  AstrCopy(astr1, 'Hello World!')
  assert(StrLen(astr1) = 12, 'StrLen: array of char String with punctuation',_SRCLINE_)  
ENDPROC

/* Test EstrLen() - Extended string length (handles NULL) */
PROC test_estrlen()
  DEF str[20]:STRING
  DEF result
  
  WriteF('\n=== Testing EstrLen() ===\n')
  
  StrCopy(str, 'Hello')
  result := EstrLen(str)
  assert(result = 5, 'EstrLen: Normal string',_SRCLINE_)
  
  StrCopy(str, '')
  result := EstrLen(str)
  assert(result = 0, 'EstrLen: Empty string',_SRCLINE_)  
ENDPROC

/* Test StrMax() - Get string buffer size */
PROC test_strmax()
  DEF str[50]:STRING
  DEF small[10]:STRING
  DEF s
  
  WriteF('\n=== Testing StrMax() ===\n')
  
  assert(StrMax(str) = 50, 'StrMax: Buffer size 50',_SRCLINE_)
  assert(StrMax(small) = 10, 'StrMax: Buffer size 10',_SRCLINE_)
  
  s:=String(25)
  assert(StrMax(s) = 25, 'StrMax: Allocated string - Buffer size 25',_SRCLINE_)
  DisposeLink(s)
ENDPROC

/* Test StringF() - Formatted string creation */
PROC test_stringf()
  DEF str[100]:STRING
  
  WriteF('\n=== Testing StringF() ===\n')

  StringF(str, 'testing')
  assert(StrCmp(str, 'testing') = TRUE, 'StringF: Plain text string no formatting',_SRCLINE_)

  StringF(str, '\b\n')
  assert(str[0]=13, 'StringF: CR',_SRCLINE_)
  assert(str[1]=10, 'StringF: LF',_SRCLINE_)

  StringF(str, '\q')
  assert(str[0]=34, 'StringF: double quote',_SRCLINE_)

  StringF(str, '\a')
  assert(str[0]=39, 'StringF: single quote',_SRCLINE_)

  StringF(str, '\e')
  assert(str[0]=27, 'StringF: escape',_SRCLINE_)

  StringF(str, '\t')
  assert(str[0]=9, 'StringF: tab',_SRCLINE_)

  StringF(str, '\!')
  assert(str[0]=7, 'StringF: bell',_SRCLINE_)

  StringF(str, '\0')
  assert(str[0]=0, 'StringF: nul',_SRCLINE_)

  StringF(str, '\x41')
  assert(str[0]=65, 'StringF: ascii char',_SRCLINE_)

  StringF(str, '\\')
  assert(str[0]=92, 'StringF: backslash',_SRCLINE_)

  StringF(str, '\s \d', 'Number:', 42)
  assert(StrCmp(str, 'Number: 42') = TRUE, 'StringF: String and integer',_SRCLINE_)

  StringF(str, '\s \d', 'Number:', $ffffffff)
  assert(StrCmp(str, 'Number: -1') = TRUE, 'StringF: signed',_SRCLINE_)

  StringF(str, '\s \u', 'Number:', $ffffffff)
  assert(StrCmp(str, 'Number: 4294967295') = TRUE, 'StringF: unsigned',_SRCLINE_)
  
  StringF(str, '\d + \d = \d', 2, 3, 5)
  assert(StrCmp(str, '2 + 3 = 5') = TRUE, 'StringF: Multiple integers',_SRCLINE_)
  
  StringF(str, '\s', 'Test')
  assert(StrCmp(str, 'Test') = TRUE, 'StringF: Single string',_SRCLINE_)
  
  StringF(str, '\h[8]', $ABCD)
  assert(InStr(str, 'ABCD') >= 0, 'StringF: Hex format',_SRCLINE_)

  StringF(str, '\r\h[8]', $ABCD)
  assert(InStr(str, '    ABCD') >= 0, 'StringF: Hex format right align',_SRCLINE_)

  StringF(str, '\r\z\h[8]', $ABCD)
  assert(InStr(str, '0000ABCD') >= 0, 'StringF: Hex format right align 0 pad',_SRCLINE_)

  StringF(str, '\l\h[8]', $ABCD)
  assert(InStr(str, 'ABCD    ') >= 0, 'StringF: Hex format left align',_SRCLINE_)

  StringF(str, '\r\d[8]', 1000)
  assert(InStr(str, '    1000') >= 0, 'StringF: decimal format right align',_SRCLINE_)

  StringF(str, '\r\z\d[8]', 1000)
  assert(InStr(str, '00001000') >= 0, 'StringF: decimal format right align 0 pad',_SRCLINE_)

  StringF(str, '\l\d[8]', 1234)
  assert(InStr(str, '1234    ') >= 0, 'StringF: decimal format left align',_SRCLINE_)

  StringF(str, '\c', 97)
  assert(InStr(str, 'a') >= 0, 'StringF: character',_SRCLINE_)
  
ENDPROC

/* Test AstringF() - Allocate formatted string */
PROC test_astringf()
  DEF str[50]:ARRAY OF CHAR
  
  WriteF('\n=== Testing AstringF() ===\n')
  
  AstringF(str,'\s \d', 'Value:', 123)
  assert(StrCmp(str, 'Value: 123') = TRUE, 'AstringF: Allocated formatted string',_SRCLINE_)
  
  AstringF(str,'\d', 999)
  assert(StrCmp(str, '999') = TRUE, 'AstringF: Integer only',_SRCLINE_)

  AstringF(str, 'testing')
  assert(StrCmp(str, 'testing') = TRUE, 'AstringF: Plain text string no formatting',_SRCLINE_)

  AstringF(str, '\b\n')
  assert(str[0]=13, 'AstringF: CR',_SRCLINE_)
  assert(str[1]=10, 'AstringF: LF',_SRCLINE_)

  AstringF(str, '\q')
  assert(str[0]=34, 'AstringF: double quote',_SRCLINE_)

  AstringF(str, '\a')
  assert(str[0]=39, 'AstringF: single quote',_SRCLINE_)

  AstringF(str, '\e')
  assert(str[0]=27, 'AstringF: escape',_SRCLINE_)

  AstringF(str, '\t')
  assert(str[0]=9, 'AstringF: tab',_SRCLINE_)

  AstringF(str, '\!')
  assert(str[0]=7, 'AstringF: bell',_SRCLINE_)

  AstringF(str, '\0')
  assert(str[0]=0, 'AstringF: nul',_SRCLINE_)

  AstringF(str, '\x41')
  assert(str[0]=65, 'AstringF: ascii char',_SRCLINE_)

  AstringF(str, '\\')
  assert(str[0]=92, 'AstringF: backslash',_SRCLINE_)

  AstringF(str, '\s \d', 'Number:', 42)
  assert(StrCmp(str, 'Number: 42') = TRUE, 'AstringF: String and integer',_SRCLINE_)

  AstringF(str, '\s \d', 'Number:', $ffffffff)
  assert(StrCmp(str, 'Number: -1') = TRUE, 'AstringF: signed',_SRCLINE_)

  AstringF(str, '\s \u', 'Number:', $ffffffff)
  assert(StrCmp(str, 'Number: 4294967295') = TRUE, 'AstringF: unsigned',_SRCLINE_)
  
  AstringF(str, '\d + \d = \d', 2, 3, 5)
  assert(StrCmp(str, '2 + 3 = 5') = TRUE, 'AstringF: Multiple integers',_SRCLINE_)
  
  AstringF(str, '\s', 'Test')
  assert(StrCmp(str, 'Test') = TRUE, 'AstringF: Single string',_SRCLINE_)
  
  AstringF(str, '\h[8]', $ABCD)
  assert(InStr(str, 'ABCD') >= 0, 'AstringF: Hex format',_SRCLINE_)

  AstringF(str, '\r\h[8]', $ABCD)
  assert(InStr(str, '    ABCD') >= 0, 'AstringF: Hex format right align',_SRCLINE_)

  AstringF(str, '\r\z\h[8]', $ABCD)
  assert(InStr(str, '0000ABCD') >= 0, 'AstringF: Hex format right align 0 pad',_SRCLINE_)

  AstringF(str, '\l\h[8]', $ABCD)
  assert(InStr(str, 'ABCD    ') >= 0, 'AstringF: Hex format left align',_SRCLINE_)

  AstringF(str, '\r\d[8]', 1000)
  assert(InStr(str, '    1000') >= 0, 'AstringF: decimal format right align',_SRCLINE_)

  AstringF(str, '\r\z\d[8]', 1000)
  assert(InStr(str, '00001000') >= 0, 'AstringF: decimal format right align 0 pad',_SRCLINE_)

  AstringF(str, '\l\d[8]', 1234)
  assert(InStr(str, '1234    ') >= 0, 'AstringF: decimal format left align',_SRCLINE_)

  AstringF(str, '\c', 97)
  assert(InStr(str, 'a') >= 0, 'AstringF: character',_SRCLINE_)
ENDPROC

/* Test RightStr() - Get rightmost characters */
PROC test_rightstr()
  DEF str[50]:STRING
  DEF result[50]:STRING
  
  WriteF('\n=== Testing RightStr() ===\n')
  
  StrCopy(str, 'Hello World')
  RightStr(result, str, 5)
  assert(StrCmp(result, 'World') = TRUE, 'RightStr: Last 5 chars',_SRCLINE_)
  
  StrCopy(str, 'Test')
  RightStr(result, str, 2)
  assert(StrCmp(result, 'st') = TRUE, 'RightStr: Last 2 chars',_SRCLINE_)
  assert(EstrLen(result) = 2, 'RightStr: Last 2 chars - estrlen',_SRCLINE_)
  
  StrCopy(str, 'Single')
  RightStr(result, str, 1)
  assert(StrCmp(result, 'e') = TRUE, 'RightStr: Last char',_SRCLINE_)
  assert(EstrLen(result) = 1, 'RightStr: Last char - estrlen',_SRCLINE_)

  StrCopy(str, 'Single')
  RightStr(result, str, 0)
  assert(StrCmp(result, '') = TRUE, 'RightStr: 0 chars',_SRCLINE_)
  assert(EstrLen(result) = 0, 'RightStr: 0 chars - estrlen',_SRCLINE_)
  
  StrCopy(str, 'Single')
  RightStr(result, str, 10)
  assert(StrCmp(result, 'Single') = TRUE, 'RightStr: out of range',_SRCLINE_)
  assert(EstrLen(result) = 6, 'RightStr: out of range - estrlen',_SRCLINE_)
  
ENDPROC

/* Test MidStr() - Get substring */
PROC test_midstr()
  DEF str[50]:STRING
  DEF result[50]:STRING
  
  WriteF('\n=== Testing MidStr() ===\n')
  
  StrCopy(str, 'Hello World')
  MidStr(result, str, 6, 5)
  assert(StrCmp(result, 'World') = TRUE, 'MidStr: Extract middle',_SRCLINE_)
  assert(EstrLen(result) = 5, 'MidStr: Extract middle - estrlen',_SRCLINE_)
  
  StrCopy(str, 'Testing')
  MidStr(result, str, 0, 4)
  assert(StrCmp(result, 'Test') = TRUE, 'MidStr: Extract from start',_SRCLINE_)
  assert(EstrLen(result) = 4, 'MidStr: Extract from start - estrlen',_SRCLINE_)
  
  StrCopy(str, 'Extract')
  MidStr(result, str, 2, 3)
  assert(StrCmp(result, 'tra') = TRUE, 'MidStr: Middle portion',_SRCLINE_)
  assert(EstrLen(result) = 3, 'MidStr: Middle portion - estrlen',_SRCLINE_)
  
  -> Test with ALL parameter
  StrCopy(str, 'Testing')
  MidStr(result, str, 4, ALL)
  assert(StrCmp(result, 'ing') = TRUE, 'MidStr: Extract with ALL',_SRCLINE_)
  assert(EstrLen(result) = 3, 'MidStr: Extract with ALL - estrlen',_SRCLINE_)
  
  StrCopy(str, 'Testing')
  MidStr(result, str, 4, 0)
  assert(StrCmp(result, '') = TRUE, 'MidStr: 0 length',_SRCLINE_)
  assert(EstrLen(result) = 0, 'MidStr: 0 length - estrlen',_SRCLINE_)
  
ENDPROC

/* Test Val() - String to integer conversion */
PROC test_val()
  DEF str[50]:STRING
  DEF result,read
  
  WriteF('\n=== Testing Val() ===\n')
  
  StrCopy(str, '123')
  result := Val(str)
  assert(result = 123, 'Val: Positive integer',_SRCLINE_)
  
  StrCopy(str, '-456')
  result := Val(str)
  assert(result = -456, 'Val: Negative integer',_SRCLINE_)
  
  StrCopy(str, '0')
  result := Val(str)
  assert(result = 0, 'Val: Zero',_SRCLINE_)
  
  StrCopy(str, '  789  ')
  result := Val(str)
  assert(result = 789, 'Val: String with spaces',_SRCLINE_)
  
  StrCopy(str, '$FF')
  result := Val(str)
  assert(result = 255, 'Val: Hexadecimal value',_SRCLINE_)
  
  StrCopy(str, '%1010')
  result := Val(str)
  assert(result = 10, 'Val: Binary value',_SRCLINE_)

  StrCopy(str, 'one')
  result := Val(str)
  assert(result = 0, 'Val: Non-numberic',_SRCLINE_)

  StrCopy(str, '123__')
  result,read := Val(str)
  assert(result = 123, 'Val: partial read',_SRCLINE_)
  assert(read = 3, 'Val: partial read - count',_SRCLINE_)

  StrCopy(str, '  222__')
  result,read := Val(str)
  assert(result = 222, 'Val: partial read leading spaces',_SRCLINE_)
  assert(read = 5, 'Val: partial read leading spaces - count',_SRCLINE_)
  
ENDPROC

/* Test InStr() - Find substring position (case-sensitive) */
PROC test_instr()
  DEF str[50]:STRING
  DEF pos
  
  WriteF('\n=== Testing InStr() ===\n')
  
  StrCopy(str, 'Hello World')
  pos := InStr(str, 'World')
  assert(pos = 6, 'InStr: Find substring',_SRCLINE_)
  
  StrCopy(str, 'Test String')
  pos := InStr(str, 'Not')
  assert(pos = -1, 'InStr: Substring not found',_SRCLINE_)
  
  StrCopy(str, 'Hello')
  pos := InStr(str, 'H')
  assert(pos = 0, 'InStr: Find at start',_SRCLINE_)
  
  StrCopy(str, 'Hello World')
  pos := InStr(str, 'world')
  assert(pos = -1, 'InStr: Case sensitive',_SRCLINE_)
  
  -> Test with startpos parameter
  StrCopy(str, 'Hello Hello')
  pos := InStr(str, 'Hello', 1)
  assert(pos = 6, 'InStr: Find with startpos',_SRCLINE_)
ENDPROC

/* Test InStri() - Find substring position (case-insensitive) */
PROC test_instri()
  DEF str[50]:STRING
  DEF pos
  
  WriteF('\n=== Testing InStri() ===\n')
  
  StrCopy(str, 'Hello World')
  pos := InStri(str, 'world')
  assert(pos = 6, 'InStri: Case-insensitive find',_SRCLINE_)
  
  StrCopy(str, 'Test String')
  pos := InStri(str, 'STRING')
  assert(pos = 5, 'InStri: Uppercase search',_SRCLINE_)
  
  StrCopy(str, 'HELLO')
  pos := InStri(str, 'hello')
  assert(pos = 0, 'InStri: Case-insensitive at start',_SRCLINE_)
  
  -> Test with startpos parameter
  StrCopy(str, 'Hello HELLO')
  pos := InStri(str, 'hello', 1)
  assert(pos = 6, 'InStri: Find with startpos',_SRCLINE_)
ENDPROC

/* Test TrimStr() - Remove leading/trailing spaces */
PROC test_trimstr()
  DEF str[50]:STRING
  DEF newstr:PTR TO CHAR
  
  WriteF('\n=== Testing TrimStr() ===\n')
  
  StrCopy(str, '  Hello  ')
  newstr:=TrimStr(str)
  assert(StrCmp(newstr, 'Hello  ') = TRUE, 'TrimStr: Left Side',_SRCLINE_)
  
  StrCopy(str, 'NoSpaces')
  newstr:=TrimStr(str)
  assert(StrCmp(newstr, 'NoSpaces') = TRUE, 'TrimStr: No spaces',_SRCLINE_)
  
  StrCopy(str, '   Leading')
  newstr:=TrimStr(str)
  assert(StrCmp(newstr, 'Leading') = TRUE, 'TrimStr: Leading only',_SRCLINE_)
  
  StrCopy(str, 'Trailing   ')
  newstr:=TrimStr(str)
  assert(StrCmp(newstr, 'Trailing   ') = TRUE, 'TrimStr: Trailing only',_SRCLINE_)
ENDPROC

/* Test UpperStr() - Convert to uppercase */
PROC test_upperstr()
  DEF str[50]:STRING
  
  WriteF('\n=== Testing UpperStr() ===\n')
  
  StrCopy(str, 'hello world')
  UpperStr(str)
  assert(StrCmp(str, 'HELLO WORLD') = TRUE, 'UpperStr: To uppercase',_SRCLINE_)
  
  StrCopy(str, 'ALREADY')
  UpperStr(str)
  assert(StrCmp(str, 'ALREADY') = TRUE, 'UpperStr: Already upper',_SRCLINE_)
  
  StrCopy(str, 'MiXeD')
  UpperStr(str)
  assert(StrCmp(str, 'MIXED') = TRUE, 'UpperStr: Mixed case',_SRCLINE_)
  
  StrCopy(str, 'abc123')
  UpperStr(str)
  assert(StrCmp(str, 'ABC123') = TRUE, 'UpperStr: Letters and numbers',_SRCLINE_)
ENDPROC

/* Test LowerStr() - Convert to lowercase */
PROC test_lowerstr()
  DEF str[50]:STRING
  
  WriteF('\n=== Testing LowerStr() ===\n')
  
  StrCopy(str, 'HELLO WORLD')
  LowerStr(str)
  assert(StrCmp(str, 'hello world') = TRUE, 'LowerStr: To lowercase',_SRCLINE_)
  
  StrCopy(str, 'already')
  LowerStr(str)
  assert(StrCmp(str, 'already') = TRUE, 'LowerStr: Already lower',_SRCLINE_)
  
  StrCopy(str, 'MiXeD')
  LowerStr(str)
  assert(StrCmp(str, 'mixed') = TRUE, 'LowerStr: Mixed case',_SRCLINE_)
  
  StrCopy(str, 'ABC123')
  LowerStr(str)
  assert(StrCmp(str, 'abc123') = TRUE, 'LowerStr: Letters and numbers',_SRCLINE_)
ENDPROC

/* Test UpperChar() - Convert character to uppercase */
PROC test_upperchar()
  DEF c
  
  WriteF('\n=== Testing UpperChar() ===\n')
  
  c := UpperChar("a")
  assert(c = "A", 'UpperChar: Lowercase to upper',_SRCLINE_)
  
  c := UpperChar("Z")
  assert(c = "Z", 'UpperChar: Already uppercase',_SRCLINE_)
  
  c := UpperChar("1")
  assert(c = "1", 'UpperChar: Digit unchanged',_SRCLINE_)
  
  c := UpperChar("z")
  assert(c = "Z", 'UpperChar: z to Z',_SRCLINE_)
ENDPROC

/* Test LowerChar() - Convert character to lowercase */
PROC test_lowerchar()
  DEF c
  
  WriteF('\n=== Testing LowerChar() ===\n')
  
  c := LowerChar("A")
  assert(c = "a", 'LowerChar: Uppercase to lower',_SRCLINE_)
  
  c := LowerChar("z")
  assert(c = "z", 'LowerChar: Already lowercase',_SRCLINE_)
  
  c := LowerChar("1")
  assert(c = "1", 'LowerChar: Digit unchanged',_SRCLINE_)
  
  c := LowerChar("Z")
  assert(c = "z", 'LowerChar: Z to z',_SRCLINE_)
ENDPROC

/* Test SetStr() - Set string to specific length with fill char */
PROC test_setstr()
  DEF str[50]:STRING
  
  WriteF('\n=== Testing SetStr() ===\n')
  
  StrCopy(str,'**********')
  SetStr(str, 5)
  assert(EstrLen(str) = 5, 'SetStr: Fill with asterisks',_SRCLINE_)
  
  StrCopy(str,'AAAAAAAAAA')
  SetStr(str, 3)
  assert(EstrLen(str) = 3, 'SetStr: Fill with letter',_SRCLINE_)
  
  StrCopy(str,'XXXXXXXXXX')
  SetStr(str, 0)
  assert(EstrLen(str) = 0, 'SetStr: Zero length',_SRCLINE_)
  
  -> Test automatic length calculation
  StrCopy(str, 'Hello')
  SetStr(str)
  assert(EstrLen(str) = 5, 'SetStr: Auto calculate length',_SRCLINE_)


  -> Test automatic length calculation 2
  StrCopy(str, 'Hello\0world')
  SetStr(str)
  assert(EstrLen(str) = 5, 'SetStr: Auto calculate length2',_SRCLINE_)

ENDPROC

/* Test StrClone() - Clone string in existing buffer */
PROC test_strclone()
  DEF src[50]:STRING
  DEF dest
  
  WriteF('\n=== Testing StrClone() ===\n')
  
  StrCopy(src, 'Clone Me')
  dest:=StrClone(src)
  IF dest
    assert(StrCmp(dest, 'Clone Me') = TRUE, 'StrClone: Clone string',_SRCLINE_)
    assert(EstrLen(dest) = 8, 'StrClone: Clone string - estrlen',_SRCLINE_)
    DisposeLink(dest)
  ELSE
    assert(FALSE, 'StrClone: Clone string - Failed to allocate',_SRCLINE_)
  ENDIF

  StrCopy(src, '')
  dest:=StrClone(src)
  IF dest
    assert(StrLen(dest) = 0, 'StrClone: Clone empty string',_SRCLINE_)
    DisposeLink(dest)
  ELSE
    assert(FALSE, 'StrClone: Clone empty string - Failed to allocate',_SRCLINE_)
  ENDIF
ENDPROC

/* Test AstrClone() - Allocate and clone string */
PROC test_astrclone()
  DEF src[50]:STRING
  DEF dest:PTR TO CHAR
  
  WriteF('\n=== Testing AstrClone() ===\n')
  
  StrCopy(src, 'Allocate Me')
  dest := AstrClone(src)
  IF dest
    assert(StrCmp(dest, 'Allocate Me') = TRUE, 'AstrClone: Allocated clone',_SRCLINE_)
    DisposeLink(dest)
  ELSE
    assert(FALSE, 'AstrClone: Failed to allocate',_SRCLINE_)
  ENDIF
  
  -> Test with length parameter
  StrCopy(src, 'Hello World')
  dest := AstrClone(src, 5)
  IF dest
    assert(StrCmp(dest, 'Hello') = TRUE, 'AstrClone: Partial clone',_SRCLINE_)
    DisposeLink(dest)
  ELSE
    assert(FALSE, 'AstrClone: Failed partial allocation',_SRCLINE_)
  ENDIF
ENDPROC

/* Test AstrCopy() - Copy to allocated string */
PROC test_astrcopy()
  DEF src[50]:STRING
  DEF dest[50]:ARRAY OF CHAR
  
  WriteF('\n=== Testing AstrCopy() ===\n')
  
  StrCopy(src, 'Copy To Allocated')
  AstrCopy(dest,src)
  assert(StrCmp(dest, 'Copy To Allocated') = TRUE, 'AstrCopy: Allocated copy',_SRCLINE_)

  StrCopy(src, 'Copy To Allocated')
  AstrCopy(dest,src,5)
  assert(StrCmp(dest, 'Copy') = TRUE, 'AstrCopy: Allocated partial copy',_SRCLINE_)

  StrCopy(src, 'Copy To Allocated')
  AstrCopy(dest,src,ALL)
  assert(StrCmp(dest, 'Copy To Allocated') = TRUE, 'AstrCopy: Allocated copy - ALL',_SRCLINE_)
ENDPROC

/* Test AstpCopy() - Partial copy to allocated string */
PROC test_astpcopy()
  DEF src[50]:STRING
  DEF dest[50]:ARRAY OF CHAR
  DEF d
  
  WriteF('\n=== Testing AstpCopy() ===\n')
  
  StrCopy(src, 'Hello World')
  d:=AstpCopy(dest, src, 6)
  assert(StrCmp(dest, 'Hello') = TRUE, 'AstpCopy: Partial copy',_SRCLINE_)
  assert(d = (dest + 5), 'AstpCopy: Partial copy - return value',_SRCLINE_)

  d:=AstpCopy(dest, src)
  assert(StrCmp(dest, 'Hello World') = TRUE, 'AstpCopy: full copy',_SRCLINE_)
  assert(d = (dest + 11), 'AstpCopy: Partial fully copy - return value',_SRCLINE_)

  d:=AstpCopy(dest, src, ALL)
  assert(StrCmp(dest, 'Hello World') = TRUE, 'AstpCopy: full copy - ALL',_SRCLINE_)
  assert(d = (dest + 11), 'AstpCopy: Partial fully copy - ALL - return value',_SRCLINE_)

  d:=AstpCopy(dest, src)
  d:=AstpCopy(d, src,8)
  assert(StrCmp(dest, 'Hello WorldHello W') = TRUE, 'AstpCopy: run twice',_SRCLINE_)
  assert(d = (dest + 18), 'AstpCopy: run twice - return value',_SRCLINE_)

ENDPROC

/* Test OstrCmp() - Ordered string compare */
PROC test_ostrcmp()
  DEF str1[50]:STRING
  DEF str2[50]:STRING
  
  WriteF('\n=== Testing OstrCmp() ===\n')
  
  StrCopy(str1, 'Hello')
  StrCopy(str2, 'Hello')
  assert(OstrCmp(str1, str2) = 0, 'OstrCmp: Equal strings',_SRCLINE_)
  
  StrCopy(str1, 'Apple')
  StrCopy(str2, 'Banana')
  assert(OstrCmp(str1, str2) = 1, 'OstrCmp: First less than second',_SRCLINE_)
  
  StrCopy(str1, 'Zebra')
  StrCopy(str2, 'Apple')
  assert(OstrCmp(str1, str2) = -1, 'OstrCmp: First greater than second',_SRCLINE_)

  StrCopy(str1, 'Hello')
  StrCopy(str2, 'Hello')
  assert(OstrCmp(str1, str2,ALL) = 0, 'OstrCmp: Equal strings with ALL ',_SRCLINE_)
  
  -> Test with max parameter
  StrCopy(str1, 'Hello')
  StrCopy(str2, 'Help')
  assert(OstrCmp(str1, str2, 3) = 0, 'OstrCmp: First 3 chars equal',_SRCLINE_)
ENDPROC

/* Test StrIns() - Insert string into another */
PROC test_strins()
  DEF str[100]:STRING
  DEF str2[20]:STRING
  
  WriteF('\n=== Testing StrIns() ===\n')
  
  StrCopy(str, 'Hello World')
  StrCopy(str2, 'Big ')
  StrIns(str, str2, 6)
  assert(StrCmp(str, 'Hello Big World') = TRUE, 'StrIns: Insert in middle',_SRCLINE_)
  assert(EstrLen(str) = 15, 'StrIns: Insert in middle - estrlen',_SRCLINE_)
  
  StrCopy(str, 'World')
  StrCopy(str2, 'Hello ')
  StrIns(str,str2, 0)
  assert(StrCmp(str, 'Hello World') = TRUE, 'StrIns: Insert at start',_SRCLINE_)
  assert(EstrLen(str) = 11, 'StrIns: Insert in middle - estrlen',_SRCLINE_)

  StrCopy(str,'This is a long string ')
  StrCopy(str2, 'Hello World')
  StrIns(str2,str, 6)
  assert(StrCmp(str2, 'Hello This is a long') = TRUE, 'StrIns: Insert - overflow',_SRCLINE_)
  assert(EstrLen(str2) = 20, 'StrIns: Insert - overflow - estrlen',_SRCLINE_)
ENDPROC

/* Test StrRem() - Remove characters from string */
PROC test_strrem()
  DEF str[100]:STRING
  
  WriteF('\n=== Testing StrRem() ===\n')
  
  StrCopy(str, 'Hello World')
  StrRem(str, 5, 6)
  assert(StrCmp(str, 'Hello') = TRUE, 'StrRem: Remove from position',_SRCLINE_)
  assert(EstrLen(str) = 5, 'StrRem: Remove from position - estrlen',_SRCLINE_)

  StrCopy(str, 'Hello World')
  StrRem(str, 6, 3)
  assert(StrCmp(str, 'Hello ld') = TRUE, 'StrRem: Partial remove from position',_SRCLINE_)
  assert(EstrLen(str) = 8, 'StrRem: Partial remove from position - estrlen',_SRCLINE_)
  
  StrCopy(str, 'Testing')
  StrRem(str, 0, 4)
  assert(StrCmp(str, 'ing') = TRUE, 'StrRem: Remove from start',_SRCLINE_)
  assert(EstrLen(str) = 3, 'StrRem: Remove from start - estrlen',_SRCLINE_)
  
  -> Test with ALL parameter
  StrCopy(str, 'Hello World')
  StrRem(str, 5, ALL)
  assert(StrCmp(str, 'Hello') = TRUE, 'StrRem: Remove with ALL',_SRCLINE_)
  assert(EstrLen(str) = 5, 'StrRem: Remove with ALL - estrlen',_SRCLINE_)
ENDPROC

/* Test StrCompare() - Lexicographic comparison */
PROC test_strcompare()
  DEF str1[50]:STRING
  DEF str2[50]:STRING
  
  WriteF('\n=== Testing StrCompare() ===\n')
  
  StrCopy(str1, 'Hello')
  StrCopy(str2, 'Hello')
  assert(StrCompare(str1, str2) = 0, 'StrCompare: Equal strings',_SRCLINE_)
  
  StrCopy(str1, 'Apple')
  StrCopy(str2, 'Banana')
  assert(StrCompare(str1, str2) = -1, 'StrCompare: First < second',_SRCLINE_)
  
  StrCopy(str1, 'Zebra')
  StrCopy(str2, 'Apple')
  assert(StrCompare(str1, str2) = 1, 'StrCompare: First > second',_SRCLINE_)

  StrCopy(str1, 'Hello')
  StrCopy(str2, 'Hello')
  assert(StrCompare(str1, str2, ALL) = 0, 'StrCompare: Equal strings with aLL',_SRCLINE_)
  
  -> Test with length parameter
  StrCopy(str1, 'Hello')
  StrCopy(str2, 'Help')
  assert(StrCompare(str1, str2, 3) = 0, 'StrCompare: First 3 chars equal',_SRCLINE_)
ENDPROC

/* Test Mul() - 32-bit multiplication */
PROC test_mul()
  WriteF('\n=== Testing Mul() ===\n')
  
  assert(Mul(10, 20) = 200, 'Mul: Basic multiplication',_SRCLINE_)
  assert(Mul(0, 100) = 0, 'Mul: Multiply by zero',_SRCLINE_)
  assert(Mul(-5, 10) = -50, 'Mul: Negative multiplication',_SRCLINE_)
  assert(Mul(1000, 1000) = 1000000, 'Mul: Large numbers',_SRCLINE_)
  assert(Mul(1000, -1000) = -1000000, 'Mul: Large numbers negative',_SRCLINE_)
  assert(Mul(100000, 2) = 200000, 'Mul: Large source numbers',_SRCLINE_)
  assert(Mul(2, 100000) = 200000, 'Mul: Large source numbers 2',_SRCLINE_)
ENDPROC

/* Test Div() - 32-bit division */
PROC test_div()
  WriteF('\n=== Testing Div() ===\n')
  
  assert(Div(100, 10) = 10, 'Div: Basic division',_SRCLINE_)
  assert(Div(50, 5) = 10, 'Div: Even division',_SRCLINE_)
  assert(Div(-100, 10) = -10, 'Div: Negative division',_SRCLINE_)
  assert(Div(7, 2) = 3, 'Div: Division with remainder',_SRCLINE_)
  assert(Div(100000, 2) = 50000, 'Div: Large source numbers',_SRCLINE_)
  assert(Div(140000, 70000) = 2, 'Div: Large source numbers 2',_SRCLINE_)
  assert(Div(140000, 2) = 70000, 'Div: Large source numbers ',_SRCLINE_)
ENDPROC

/* Test Long(), Int(), Char(), Byte(), Word() - Memory peek functions */
PROC test_memory_peek()
  DEF buffer[20]:ARRAY OF CHAR
  
  WriteF('\n=== Testing Memory Peek Functions ===\n')
  
  -> Set up test data
  PutLong(buffer, $12345678)
  PutInt(buffer+4, $ABCD)
  PutChar(buffer+6, "X")
  PutByte(buffer+7, 42)
  PutWord(buffer+8, $FADE)
  
  assert(Long(buffer) = $12345678, 'Long: Read 32-bit value',_SRCLINE_)
  assert(Int(buffer+4) = $FFFFABCD, 'Int: Read 16-bit signed value',_SRCLINE_)
  assert(Char(buffer+6) = "X", 'Char: Read 8-bit value',_SRCLINE_)
  assert(Byte(buffer+7) = 42, 'Byte: Read 8-bit signed value',_SRCLINE_)
  assert(Word(buffer+8) = $FADE, 'Word: Read 16-bit unsigned value',_SRCLINE_)
ENDPROC

/* Test PutLong(), PutInt(), PutChar(), PutByte(), PutWord() */
PROC test_memory_poke()
  DEF buffer[20]:ARRAY
  
  WriteF('\n=== Testing Memory Poke Functions ===\n')
  
  PutLong(buffer, $DEADBEEF)
  assert(Long(buffer) = $DEADBEEF, 'PutLong: Write 32-bit value',_SRCLINE_)
  
  PutInt(buffer, $1234)
  assert(Int(buffer) = $1234, 'PutInt: Write 16-bit value',_SRCLINE_)
  
  PutChar(buffer, "A")
  assert(Char(buffer) = "A", 'PutChar: Write 8-bit value',_SRCLINE_)
  
  PutByte(buffer, 127)
  assert(Byte(buffer) = 127, 'PutByte: Write signed byte',_SRCLINE_)
  
  PutWord(buffer, $FFFF)
  assert(Word(buffer) = $FFFF, 'PutWord: Write 16-bit unsigned',_SRCLINE_)
ENDPROC

/* Test And(), Or(), Not(), Eor() - Logical/Bitwise operations */
PROC test_logical_ops()
  WriteF('\n=== Testing Logical Operations ===\n')
  
  assert(And($FF, $0F) = $0F, 'And: Bitwise AND',_SRCLINE_)
  assert(And(TRUE, FALSE) = FALSE, 'And: Logical AND',_SRCLINE_)
  
  assert(Or($F0, $0F) = $FF, 'Or: Bitwise OR',_SRCLINE_)
  assert(Or(TRUE, FALSE) = TRUE, 'Or: Logical OR',_SRCLINE_)
  
  assert(Not(0) = -1, 'Not: Bitwise NOT of 0',_SRCLINE_)
  assert(Not(-1) = 0, 'Not: Bitwise NOT of -1',_SRCLINE_)
  
  assert(Eor($FF, $0F) = $F0, 'Eor: Exclusive OR',_SRCLINE_)
  assert(Eor(TRUE, FALSE) = TRUE, 'Eor: Logical XOR',_SRCLINE_)
ENDPROC

/* Test String() - Dynamic string allocation */
PROC test_string()
  DEF s
  
  WriteF('\n=== Testing String() ===\n')
  
  s := String(50)
  IF s
    assert(StrMax(s) = 50, 'String: Allocate 50 byte string',_SRCLINE_)
    assert(EstrLen(s) = 0, 'String: Allocate 50 byte string - default strlen',_SRCLINE_)
    StrCopy(s, 'Test')
    assert(StrCmp(s, 'Test') = TRUE, 'String: Use allocated string',_SRCLINE_)
    Dispose(s)
  ELSE
    assert(FALSE, 'String: Allocation failed',_SRCLINE_)
  ENDIF
  
  s := String(0)
  IF s
    assert(StrMax(s) = 0, 'String: Allocate zero-length string',_SRCLINE_)
    assert(EstrLen(s) = 0, 'String: Allocate zero-length string - default strlen',_SRCLINE_)
    Dispose(s)
  ENDIF
ENDPROC

/* Test List() - Dynamic list allocation */
PROC test_list()
  DEF l
  
  WriteF('\n=== Testing List() ===\n')
  
  l := List(10)
  IF l
    assert(ListMax(l) = 10, 'List: Allocate 10 element list',_SRCLINE_)
    assert(ListLen(l) = 0, 'List: Allocate 10 element list - default len',_SRCLINE_)
    l[0] := 42
    assert(l[0] = 42, 'List: Use allocated list',_SRCLINE_)
    Dispose(l)
  ELSE
    assert(FALSE, 'List: Allocation failed',_SRCLINE_)
  ENDIF
  
  l := List(0)
  IF l
    assert(ListMax(l) = 0, 'List: Allocate zero-length list',_SRCLINE_)
    assert(ListLen(l) = 0, 'List: Allocate zero-length list - default len',_SRCLINE_)
    Dispose(l)
  ENDIF
ENDPROC

/* Test ListCopy() - Copy list elements */
PROC test_listcopy()
  DEF src[10]:LIST
  DEF dest[10]:LIST
  
  WriteF('\n=== Testing ListCopy() ===\n')
  
  src[0] := 1
  src[1] := 2
  src[2] := 3
  SetList(src, 3)

  ListCopy(dest, src)
  assert(dest[0] = 1, 'ListCopy: First element',_SRCLINE_)
  assert(dest[1] = 2, 'ListCopy: Second element',_SRCLINE_)
  assert(dest[2] = 3, 'ListCopy: Third element',_SRCLINE_)
  assert(ListLen(dest) = 3, 'ListCopy: List length',_SRCLINE_)
  
  SetList(dest,0)
  dest[0]:=0; dest[1]:=0; dest[2]:=0
  ListCopy(dest, src, ALL)
  assert(dest[0] = 1, 'ListCopy: ALL - First element',_SRCLINE_)
  assert(dest[1] = 2, 'ListCopy: ALL - Second element',_SRCLINE_)
  assert(dest[2] = 3, 'ListCopy: ALL - Third element',_SRCLINE_)
  assert(ListLen(dest) = 3, 'ListCopy: ALL - List length',_SRCLINE_)

  SetList(dest,0)
  dest[0]:=0; dest[1]:=0; dest[2]:=0 
  ListCopy(dest, src, 2)
  assert(dest[0] = 1, 'ListCopy: Partial copy - First element',_SRCLINE_)
  assert(dest[1] = 2, 'ListCopy: Partial copy - Second element',_SRCLINE_)
  assert(ListLen(dest) = 2, 'ListCopy: Copy with length limit',_SRCLINE_)
ENDPROC

/* Test ListAdd() - Add elements to list */
PROC test_listadd()
  DEF list1[10]:LIST
  DEF list2[5]:LIST
  
  WriteF('\n=== Testing ListAdd() ===\n')

  list1[0] := 1
  list1[1] := 2
  SetList(list1, 2)
  
  list2[0] := 3
  list2[1] := 4
  SetList(list2, 2)
  
  ListAdd(list1, list2)
  assert(list1[2] = 3, 'ListAdd: Third element added',_SRCLINE_)
  assert(list1[3] = 4, 'ListAdd: Fourth element added',_SRCLINE_)
  assert(ListLen(list1) = 4, 'ListAdd: Length updated',_SRCLINE_)
  
  list1[0] := 1
  list1[1] := 2
  SetList(list1, 2)
  
  list2[0] := 3
  list2[1] := 4
  SetList(list2, 2)
  
  ListAdd(list1, list2, ALL)
  assert(list1[2] = 3, 'ListAdd: ALL - Third element added',_SRCLINE_)
  assert(list1[3] = 4, 'ListAdd: ALL - Fourth element added',_SRCLINE_)
  assert(ListLen(list1) = 4, 'ListAdd: ALL - Length updated',_SRCLINE_)

  list1[0] := 1
  list1[1] := 2
  SetList(list1, 2)
  
  list2[0] := 3
  list2[1] := 4
  SetList(list2, 2)
  
  ListAdd(list1, list2, 1)
  assert(list1[2] = 3, 'ListAdd: Partial - Third element added',_SRCLINE_)
  assert(ListLen(list1) = 3, 'ListAdd: Partial - Length updated',_SRCLINE_)
  
  list1[0] := 1
  list1[1] := 2
  list1[2] := 3
  list1[3] := 4
  list1[4] := 5
  SetList(list1, 5)

  list2[0] := 3
  list2[1] := 4
  SetList(list2, 2)

  ListAdd(list2, list1)
  assert(list2[2] = 1, 'ListAdd: Overflow - Third element added',_SRCLINE_)
  assert(list2[3] = 2, 'ListAdd: Overflow - Fourth element added',_SRCLINE_)  
  assert(list2[4] = 3, 'ListAdd: Overflow - Fifth element added',_SRCLINE_)  
  assert(ListLen(list2) = 5, 'ListAdd: Overflow - Length updated',_SRCLINE_)
  
ENDPROC

/* Test ListAddItem() - Add single item to list */
PROC test_listadditem()
  DEF list[10]:LIST
  DEF list2[3]:LIST
  
  WriteF('\n=== Testing ListAddItem() ===\n')
  
  SetList(list, 0)
  ListAddItem(list, 42)
  assert(list[0] = 42, 'ListAddItem: First item',_SRCLINE_)
  assert(ListLen(list) = 1, 'ListAddItem: Length is 1',_SRCLINE_)
  
  ListAddItem(list, 99)
  assert(list[1] = 99, 'ListAddItem: Second item',_SRCLINE_)
  assert(ListLen(list) = 2, 'ListAddItem: Length is 2',_SRCLINE_)

  SetList(list2, 0)
  ListAddItem(list2, 42)
  ListAddItem(list2, 15)
  ListAddItem(list2, 10)
  ListAddItem(list2, 1)
  assert(list2[0] = 42, 'ListAddItem: First item',_SRCLINE_)
  assert(list2[1] = 15, 'ListAddItem: Second item',_SRCLINE_)
  assert(list2[2] = 10, 'ListAddItem: Third item',_SRCLINE_)
  assert(ListLen(list2) = 3, 'ListAddItem: Length is 3',_SRCLINE_)

ENDPROC

/* Test ListInsItem() - Insert item at position */
PROC test_listinsitem()
  DEF list[10]:LIST
  DEF list2[3]:LIST
  
  WriteF('\n=== Testing ListInsItem() ===\n')
  
  list[0] := 1
  list[1] := 3
  SetList(list, 2)
  
  ListInsItem(list, 2, 1)
  assert(list[0] = 1, 'ListInsItem: First unchanged',_SRCLINE_)
  assert(list[1] = 2, 'ListInsItem: Inserted at position 1',_SRCLINE_)
  assert(list[2] = 3, 'ListInsItem: Third shifted',_SRCLINE_)
  assert(ListLen(list) = 3, 'ListInsItem: Length increased',_SRCLINE_)

  list[0] := 1
  list[1] := 3
  SetList(list, 2)
  
  ListInsItem(list, 2, 0)
  assert(list[0] = 2, 'ListInsItem: Inserted at position 0',_SRCLINE_)
  assert(list[1] = 1, 'ListInsItem: First Shifted',_SRCLINE_)
  assert(list[2] = 3, 'ListInsItem: Third shifted',_SRCLINE_)
  assert(ListLen(list) = 3, 'ListInsItem: Length increased',_SRCLINE_)
  
  list[0] := 1
  list[1] := 3
  SetList(list, 2)
  
  ListInsItem(list, 2, 2)
  assert(list[0] = 1, 'ListInsItem: First unchanged',_SRCLINE_)
  assert(list[1] = 3, 'ListInsItem: Second unchanged',_SRCLINE_)
  assert(list[2] = 2, 'ListInsItem: Inserted at position 2',_SRCLINE_)
  assert(ListLen(list) = 3, 'ListInsItem: Length increased',_SRCLINE_)

  list2[0] := 1
  list2[1] := 2
  list2[2] := 3
  SetList(list2, 3)
  
  ListInsItem(list2, 4, 1)
  
  assert(list2[0] = 1, 'ListInsItem: overflow -First unchanged',_SRCLINE_)
  assert(list2[1] = 2, 'ListInsItem: overflow -Second unchanged',_SRCLINE_)
  assert(list2[2] = 3, 'ListInsItem: overflow -Third unchanged',_SRCLINE_)
  assert(ListLen(list2) = 3, 'ListInsItem: Length not increased',_SRCLINE_)
  
ENDPROC

/* Test ListRemItem() - Remove item at position */
PROC test_listremitem()
  DEF list[10]:LIST
  
  WriteF('\n=== Testing ListRemItem() ===\n')
  
  list[0] := 1
  list[1] := 2
  list[2] := 3
  SetList(list, 3)
  
  ListRemItem(list, 1)
  assert(list[0] = 1, 'ListRemItem: First unchanged',_SRCLINE_)
  assert(list[1] = 3, 'ListRemItem: Third moved to second',_SRCLINE_)
  assert(ListLen(list) = 2, 'ListRemItem: Length decreased',_SRCLINE_)

  list[0] := 1
  list[1] := 2
  list[2] := 3
  SetList(list, 3)
  
  ListRemItem(list, 0)
  assert(list[0] = 2, 'ListRemItem: Second moved to first',_SRCLINE_)
  assert(list[1] = 3, 'ListRemItem: Third moved to second',_SRCLINE_)
  assert(ListLen(list) = 2, 'ListRemItem: Length decreased',_SRCLINE_)

  list[0] := 1
  list[1] := 2
  list[2] := 3
  SetList(list, 3)
  
  ListRemItem(list, 2)
  assert(list[0] = 1, 'ListRemItem: First unchanged',_SRCLINE_)
  assert(list[1] = 2, 'ListRemItem: Second unchanged',_SRCLINE_)
  assert(ListLen(list) = 2, 'ListRemItem: Length decreased',_SRCLINE_)
ENDPROC

/* Test ListSwapItem() - Swap two items */
PROC test_listswapitem()
  DEF list[10]:LIST
  
  WriteF('\n=== Testing ListSwapItem() ===\n')
  
  list[0] := 1
  list[1] := 2
  list[2] := 3
  SetList(list, 3)
  
  ListSwapItem(list, 0, 2)
  assert(list[0] = 3, 'ListSwapItem: First now has third',_SRCLINE_)
  assert(list[2] = 1, 'ListSwapItem: Third now has first',_SRCLINE_)
  assert(list[1] = 2, 'ListSwapItem: Second unchanged',_SRCLINE_)
  assert(ListLen(list) = 3, 'ListRemItem: Length unchanged',_SRCLINE_)
ENDPROC

/* Test ListCmp() - Compare lists */
PROC test_listcmp()
  DEF list1[5]:LIST
  DEF list2[5]:LIST
  
  WriteF('\n=== Testing ListCmp() ===\n')
  
  list1[0] := 1
  list1[1] := 2
  list1[2] := 3
  SetList(list1, 3)
  
  list2[0] := 1
  list2[1] := 2
  list2[2] := 3
  SetList(list2, 3)

  assert(ListCmp(list1, list2) = TRUE, 'ListCmp: Equal lists',_SRCLINE_)
  
  assert(ListCmp(list1, list2, ALL) = TRUE, 'ListCmp: ALL - Equal lists',_SRCLINE_)
  
  list2[1] := 99
  assert(ListCmp(list1, list2) = FALSE, 'ListCmp: Different lists',_SRCLINE_)

  assert(ListCmp(list1, list2, ALL) = FALSE, 'ListCmp: ALL - Different lists',_SRCLINE_)
  
  assert(ListCmp(list1, list2, 1) = TRUE, 'ListCmp: First element matches',_SRCLINE_)
  
  SetList(list2,0)
  assert(ListCmp(list1, list2, 1) = FALSE, 'ListCmp: List 2 not enough elements',_SRCLINE_)

  SetList(list1,0)
  SetList(list2,1)
  assert(ListCmp(list1, list2, 1) = FALSE, 'ListCmp: List 1 not enough elements',_SRCLINE_)
ENDPROC

/* Test ListLen() - Get list length */
PROC test_listlen()
  DEF list[10]:LIST
  
  WriteF('\n=== Testing ListLen() ===\n')
  
  SetList(list, 0)
  assert(ListLen(list) = 0, 'ListLen: Empty list',_SRCLINE_)
  
  list[0] := 1
  list[1] := 2
  SetList(list, 2)
  assert(ListLen(list) = 2, 'ListLen: Two elements',_SRCLINE_)
ENDPROC

/* Test ListMax() - Get list capacity */
PROC test_listmax()
  DEF list[20]:LIST
  DEF small[5]:LIST
  
  WriteF('\n=== Testing ListMax() ===\n')
  
  assert(ListMax(list) = 20, 'ListMax: Capacity 20',_SRCLINE_)
  assert(ListMax(small) = 5, 'ListMax: Capacity 5',_SRCLINE_)
ENDPROC

/* Test ListItem() - Get item from list */
PROC test_listitem()
  DEF list[5]:LIST
  
  WriteF('\n=== Testing ListItem() ===\n')
  
  list[0] := 10
  list[1] := 20
  list[2] := 30
  SetList(list, 3)
  
  assert(ListItem(list, 0) = 10, 'ListItem: First element',_SRCLINE_)
  assert(ListItem(list, 1) = 20, 'ListItem: Second element',_SRCLINE_)
  assert(ListItem(list, 2) = 30, 'ListItem: Third element',_SRCLINE_)
ENDPROC

/* Test ListClone() - Clone a list */
PROC test_listclone()
  DEF src[10]:LIST
  DEF dest:PTR TO LONG
  
  WriteF('\n=== Testing ListClone() ===\n')
  
  src[0] := 1
  src[1] := 2
  src[2] := 3
  SetList(src, 3)
  
  dest := ListClone(src)
  IF dest
    assert(dest[0] = 1, 'ListClone: First element',_SRCLINE_)
    assert(dest[1] = 2, 'ListClone: Second element',_SRCLINE_)
    assert(dest[2] = 3, 'ListClone: Third element',_SRCLINE_)
    assert(ListLen(dest) = 3, 'ListClone: Length matches',_SRCLINE_)
    Dispose(dest)
  ELSE
    assert(FALSE, 'ListClone: Failed to allocate',_SRCLINE_)
  ENDIF

  SetList(src, 0)
  dest := ListClone(src)
  IF dest
    assert(ListLen(dest) = 0, 'ListClone: Length matches',_SRCLINE_)
    Dispose(dest)
  ELSE
    assert(FALSE, 'ListClone: Failed to allocate',_SRCLINE_)
  ENDIF  
ENDPROC

/* Test SetList() - Set list length */
PROC test_setlist()
  DEF list[10]:LIST
  
  WriteF('\n=== Testing SetList() ===\n')
  
  list[0] := 1
  list[1] := 2
  list[2] := 3
  SetList(list, 3)
  assert(ListLen(list) = 3, 'SetList: Length set to 3',_SRCLINE_)
  
  SetList(list, 0)
  assert(ListLen(list) = 0, 'SetList: Length set to 0',_SRCLINE_)
ENDPROC

/* Test Even() and Odd() */
PROC test_even_odd()
  WriteF('\n=== Testing Even() and Odd() ===\n')
  
  assert(Even(2) = TRUE, 'Even: 2 is even',_SRCLINE_)
  assert(Even(3) = FALSE, 'Even: 3 is not even',_SRCLINE_)
  assert(Even(0) = TRUE, 'Even: 0 is even',_SRCLINE_)
  
  assert(Odd(3) = TRUE, 'Odd: 3 is odd',_SRCLINE_)
  assert(Odd(2) = FALSE, 'Odd: 2 is not odd',_SRCLINE_)
  assert(Odd(1) = TRUE, 'Odd: 1 is odd',_SRCLINE_)
ENDPROC

/* Test Abs() - Absolute value */
PROC test_abs()
  WriteF('\n=== Testing Abs() ===\n')
  
  assert(Abs(5) = 5, 'Abs: Positive number',_SRCLINE_)
  assert(Abs(-5) = 5, 'Abs: Negative number',_SRCLINE_)
  assert(Abs(0) = 0, 'Abs: Zero',_SRCLINE_)
  assert(Abs(-100) = 100, 'Abs: Large negative',_SRCLINE_)
ENDPROC

/* Test Sign() - Get sign of value */
PROC test_sign()
  WriteF('\n=== Testing Sign() ===\n')
  
  assert(Sign(5) = 1, 'Sign: Positive returns 1',_SRCLINE_)
  assert(Sign(-5) = -1, 'Sign: Negative returns -1',_SRCLINE_)
  assert(Sign(0) = 0, 'Sign: Zero returns 0',_SRCLINE_)
ENDPROC

/* Test Shl() and Shr() - Arithmetic shifts */
PROC test_shl_shr()
  WriteF('\n=== Testing Shl() and Shr() ===\n')
  
  assert(Shl(1, 3) = 8, 'Shl: Shift left by 3',_SRCLINE_)
  assert(Shl(2, 4) = 32, 'Shl: Shift left by 4',_SRCLINE_)

  assert(Shl(-1, 3) = -8, 'Shl: Shift left by 3',_SRCLINE_)
  assert(Shl(-2, 4) = -32, 'Shl: Shift left by 4',_SRCLINE_)
  
  assert(Shr(8, 3) = 1, 'Shr: Shift right by 3',_SRCLINE_)
  assert(Shr(32, 4) = 2, 'Shr: Shift right by 4',_SRCLINE_)

  assert(Shr(-8, 3) = -1, 'Shr: Shift right by 3',_SRCLINE_)
  assert(Shr(-32, 4) = -2, 'Shr: Shift right by 4',_SRCLINE_)
ENDPROC

/* Test Lsl() and Lsr() - Logical shifts */
PROC test_lsl_lsr()
  WriteF('\n=== Testing Lsl() and Lsr() ===\n')
  
  assert(Lsl(1, 3) = 8, 'Lsl: Logical shift left by 3',_SRCLINE_)
  assert(Lsl(2, 4) = 32, 'Lsl: Logical shift left by 4',_SRCLINE_)
  assert(Lsl($80000008, 2) = $20, 'Lsl: Logical shift left by 2',_SRCLINE_)
  
  assert(Lsr(8, 3) = 1, 'Lsr: Logical shift right by 3',_SRCLINE_)
  assert(Lsr(32, 4) = 2, 'Lsr: Logical shift right by 4',_SRCLINE_)
  assert(Lsr($8000008, 2) = $2000002, 'Lsr: Logical shift right by 2',_SRCLINE_)
ENDPROC

/* Test Rol() and Ror() - Rotate operations */
PROC test_rol_ror()
  WriteF('\n=== Testing Rol() and Ror() ===\n')
  
  assert(Rol($80000000, 1) = 1, 'Rol: Rotate left by 1',_SRCLINE_)
  assert(Rol(1, 1) = 2, 'Rol: Rotate left simple',_SRCLINE_)
  
  assert(Ror(1, 1) = $80000000, 'Ror: Rotate right by 1',_SRCLINE_)
  assert(Ror(2, 1) = 1, 'Ror: Rotate right simple',_SRCLINE_)
ENDPROC

/* Test Mod() - Modulo operation */
PROC test_mod()
  DEF result, quotient
  
  WriteF('\n=== Testing Mod() ===\n')
  
  result, quotient := Mod(10, 3)
  assert(result = 1, 'Mod: 10 mod 3 = 1',_SRCLINE_)
  assert(quotient = 3, 'Mod: 10 div 3 = 3',_SRCLINE_)
  
  result := Mod(20, 7)
  assert(result = 6, 'Mod: 20 mod 7 = 6',_SRCLINE_)
ENDPROC

/* Test Min() and Max() */
PROC test_min_max()
  WriteF('\n=== Testing Min() and Max() ===\n')
  
  assert(Min(5, 10) = 5, 'Min: 5 is minimum',_SRCLINE_)
  assert(Min(10, 5) = 5, 'Min: Order independent',_SRCLINE_)
  assert(Min(-5, 5) = -5, 'Min: With negative',_SRCLINE_)
  
  assert(Max(5, 10) = 10, 'Max: 10 is maximum',_SRCLINE_)
  assert(Max(10, 5) = 10, 'Max: Order independent',_SRCLINE_)
  assert(Max(-5, 5) = 5, 'Max: With negative',_SRCLINE_)
ENDPROC

/* Test Bounds() - Boundary checking */
PROC test_bounds()
  WriteF('\n=== Testing Bounds() ===\n')
  
  assert(Bounds(5, 0, 10) = 5, 'Bounds: Within bounds',_SRCLINE_)
  assert(Bounds(-5, 0, 10) = 0, 'Bounds: Below minimum',_SRCLINE_)
  assert(Bounds(15, 0, 10) = 10, 'Bounds: Above maximum',_SRCLINE_)
  assert(Bounds(0, 0, 10) = 0, 'Bounds: At minimum',_SRCLINE_)
  assert(Bounds(10, 0, 10) = 10, 'Bounds: At maximum',_SRCLINE_)
ENDPROC

/* Test Rnd() and RndQ() - Random numbers */
PROC test_rnd()
  DEF r1, r2, seed
  
  WriteF('\n=== Testing Rnd() and RndQ() ===\n')
  
  Rnd(-12345)  -> Initialize seed
  r1 := Rnd(100)
  assert((r1 >= 0) AND (r1 < 100), 'Rnd: In range 0-99',_SRCLINE_)
  
  r2 := Rnd(100)
  assert((r2 >= 0) AND (r2 < 100), 'Rnd: Second call in range',_SRCLINE_)
  
  seed := $A6F87EC1
  seed := RndQ(seed)
  assert(seed <> $A6F87EC1, 'RndQ: Generates different value',_SRCLINE_)
ENDPROC

/* Test Compare(), Ucompare(), Fcompare() */
PROC test_compare_functions()
  WriteF('\n=== Testing Compare Functions ===\n')
  
  assert(Compare(5, 10) < 0, 'Compare: 5 < 10',_SRCLINE_)
  assert(Compare(10, 5) > 0, 'Compare: 10 > 5',_SRCLINE_)
  assert(Compare(5, 5) = 0, 'Compare: 5 = 5',_SRCLINE_)
  
  assert(Ucompare($FFFFFFFF, 1) > 0, 'Ucompare: Unsigned comparison',_SRCLINE_)
  assert(Ucompare(1, 1) = 0, 'Ucompare: Equal values',_SRCLINE_)
ENDPROC

/* Test EndsWith() - Check string ending */
PROC test_endswith()
  DEF str[50]:STRING
  
  WriteF('\n=== Testing EndsWith() ===\n')
  
  StrCopy(str, 'Hello World')
  assert(EndsWith(str, 'World') = TRUE, 'EndsWith: Ends with World',_SRCLINE_)
  assert(EndsWith(str, 'Hello') = FALSE, 'EndsWith: Does not end with Hello',_SRCLINE_)
  assert(EndsWith(str, 'd') = TRUE, 'EndsWith: Ends with d',_SRCLINE_)
  assert(EndsWith(str, '') = TRUE, 'EndsWith: Empty string always matches',_SRCLINE_)
ENDPROC
/* Test CharInStr() and CharInStri() */
PROC test_charinstr()
  DEF str[50]:STRING
  DEF pos
  
  WriteF('\n=== Testing CharInStr() and CharInStri() ===\n')
  
  StrCopy(str, 'Hello World')
  pos := CharInStr(str, "o")
  assert(pos = 4, 'CharInStr: Find first o',_SRCLINE_)
  
  pos := CharInStr(str, "X")
  assert(pos = -1, 'CharInStr: Character not found',_SRCLINE_)
  
  pos := CharInStr(str, "o", 5)
  assert(pos = 7, 'CharInStr: Find second o with startpos',_SRCLINE_)
  
  StrCopy(str, 'Hello World')
  pos := CharInStri(str, "W")
  assert(pos = 6, 'CharInStri: Case-insensitive find',_SRCLINE_)
  
  pos := CharInStri(str, "w")
  assert(pos = 6, 'CharInStri: Lowercase find',_SRCLINE_)
ENDPROC

/* Test MemFill() - Fill memory with value */
PROC test_memfill()
  DEF buffer[20]:ARRAY
  
  WriteF('\n=== Testing MemFill() ===\n')
  
  MemFill(buffer, 10, "A")
  assert(Char(buffer) = "A", 'MemFill: First byte is A',_SRCLINE_)
  assert(Char(buffer+9) = "A", 'MemFill: Last byte is A',_SRCLINE_)
  
  MemFill(buffer, 5, 0)
  assert(Char(buffer) = 0, 'MemFill: Fill with zero',_SRCLINE_)
ENDPROC

/* Test MemCompare() - Compare memory areas */
PROC test_memcompare()
  DEF buf1[20]:ARRAY
  DEF buf2[20]:ARRAY
  
  WriteF('\n=== Testing MemCompare() ===\n')
  
  MemFill(buf1, 10, "A")
  MemFill(buf2, 10, "A")
  assert(MemCompare(buf1, buf2, 10) = 0, 'MemCompare: Equal buffers',_SRCLINE_)
  
  PutChar(buf2, "B")
  assert(MemCompare(buf1, buf2, 10) = -1, 'MemCompare: First less than second',_SRCLINE_)
  
  PutChar(buf1, "C")
  assert(MemCompare(buf1, buf2, 10) = 1, 'MemCompare: First greater than second',_SRCLINE_)
ENDPROC

/* Test SelectFirst() - Find first matching item */
PROC test_selectfirst()
  DEF list[10]:LIST
  DEF x, result
  
  WriteF('\n=== Testing SelectFirst() ===\n')
  
  list[0] := 1
  list[1] := 2
  list[2] := 3
  list[3] := 4
  list[4] := 5
  SetList(list, 5)
  
  result := SelectFirst({x}, list, `x > 3)
  assert(result = 4, 'SelectFirst: First item > 3 is 4',_SRCLINE_)
  
  result := SelectFirst({x}, list, `x = 2)
  assert(result = 2, 'SelectFirst: Find exact match',_SRCLINE_)
  
  result := SelectFirst({x}, list, `x > 10)
  assert(result = NIL, 'SelectFirst: No match returns NIL',_SRCLINE_)
ENDPROC

/* Main test runner */
PROC main() HANDLE
  WriteF('*************************************************\n')
  WriteF('* Amiga E Complete Functions Test Suite (EVO)   *\n')
  WriteF('*************************************************\n')
  WriteF('* Testing all EVO built-in functions             *\n')
  WriteF('*************************************************\n')
  
    /* Constants and Enumerations */
  WriteF('--- Constants ---\n')
  test_constants()
  
  WriteF('\n--- Enumerations ---\n')
  test_enums()
  
  WriteF('\n--- Sets ---\n')
  test_sets()
  
  /* Pointer Types */
  WriteF('\n--- Pointer Types ---\n')
  test_ptr_to_char()
  test_ptr_to_int()
  test_ptr_to_long()
  test_ptr_to_ptr()
  
  /* Array Types */
  WriteF('\n--- Array Types ---\n')
  test_array_of_char()
  test_array_of_int()
  test_array_of_long()
  test_array_of_word()
  test_array_of_byte()
  test_array_of_ptr()
  
  /* Sizeof and Friends */
  WriteF('\n--- Sizeof/Psizeof/Arraysize ---\n')
  test_sizeof()
  test_psizeof()
  test_arraysize()
  test_sizeof_object()
  test_offsetof()
  
  /* Basic Types */
  WriteF('--- Basic Types & Variables ---\n')
  test_basic_types()
  
  /* Arrays */
  WriteF('\n--- Arrays ---\n')
  test_arrays()
  test_multidim_arrays()
  
  /* Operators */
  WriteF('\n--- Arithmetic Operators ---\n')
  test_arithmetic()
  
  WriteF('\n--- Compound Assignment Operators ---\n')
  test_compound_assign_plus()
  test_compound_assign_minus()
  test_compound_assign_multiply()
  test_compound_assign_divide()
  test_compound_assign_and()
  test_compound_assign_or()
  test_compound_assign_lshift()
  test_compound_assign_rshift()
  test_all_compound_assignments()
  
  
  WriteF('\n--- Bitwise Operators ---\n')
  test_bitwise()
  
  WriteF('\n--- ANDALSO & ORELSE Operators ---\n')
  test_andalso_true()
  test_andalso_false_first()
  test_andalso_false_second()
  test_orelse_both_true()
  test_orelse_first_true()
  test_orelse_second_true()
  test_orelse_both_false()
  test_andalso_short_circuit()
  test_orelse_short_circuit()
  test_combined_andalso_orelse()  
  
  WriteF('\n--- Comparison Operators ---\n')
  test_comparison()
  
  WriteF('\n--- Logical Operators ---\n')
  test_logical()
  
  /* Float Functions */
  WriteF('\n--- Float Functions:  Basic ---\n')
  test_realval()
  test_realf()
  test_fabs()
  test_ffloor()
  test_fceil()
  
  WriteF('\n--- Float Functions:  Trigonometric ---\n')
  test_fsin()
  test_fcos()
  test_ftan()
  
  WriteF('\n--- Float Functions: Inverse Trigonometric ---\n')
  test_fasin()
  test_facos()
  test_fatan()
  
  WriteF('\n--- Float Functions: Hyperbolic ---\n')
  test_fsinh()
  test_fcosh()
  test_ftanh()
  
  WriteF('\n--- Float Functions:  Exponential & Logarithmic ---\n')
  test_fexp()
  test_flog()
  test_flog10()
  test_fsqrt()
  test_fpow()
  
  WriteF('\n--- Float Functions: IEEE Conversion ---\n')
  test_ftieee()
  test_ffieee()
  
  WriteF('\n--- Float Functions: Special ---\n')
  test_fsincos()
  
  /* Control Flow */
  WriteF('\n--- If/Then/Else & IFN/ELSEIFN ---\n')
  test_if_then_else()
  test_if_elseif_else()
  test_ifn()
  test_ifn_with_else()
  test_elseifn()
  test_elseifn_combined()
  
  WriteF('\n--- Loops:  FOR ---\n')
  test_for_loop()
  test_for_loop_step()
  
  WriteF('\n--- Loops: WHILE & WHILEN ---\n')
  test_while_loop()
  test_whilen()
  test_whilen_with_elsewhile()
  
  WriteF('\n--- Loops:   REPEAT & UNTILN ---\n')
  test_repeat_until()
  test_untiln()
  
  WriteF('\n--- Loops: ELSEWHILE, ELSEWHILEN & ALWAYS ---\n')
  test_elsewhile()
  test_elsewhilen()
  test_always()
  test_always_with_elsewhile()
  
  WriteF('\n--- Loops: LOOP, EXIT & EXITN ---\n')
  test_loop_exit()
  test_loop_exitn()
  
  WriteF('\n--- Loops: CONT & CONTN ---\n')
  test_loop_cont()
  test_loop_contn()
  
  WriteF('\n--- Control Flow: JUMP & Labels ---\n')
  test_jump_simple()
  test_jump_forward()
  test_jump_over_block()
  test_jump_multiple_labels()
  
  WriteF('\n--- Select/Case ---\n')
  test_select_case()
  test_select_case_default()
  
  /* Objects */
  WriteF('\n--- Objects with Methods ---\n')
  test_object_methods()
  
  WriteF('\n--- Objects with Inheritance & Methods ---\n')
  test_object_inheritance_methods()
  
  WriteF('\n--- Objects with Unions ---\n')
  test_object_with_union()
  
  WriteF('\n--- Objects with Private Members ---\n')
  test_object_private_members()
  
  WriteF('\n--- Objects Basic ---\n')
  test_objects()
  test_object_inheritance()

  /* Functions */
  WriteF('\n--- Procedures & Functions ---\n')
  test_procedures()
  test_proc_by_reference()
  test_multiple_args()
  test_multiple_returns()
  
  /* Objects */
  WriteF('\n--- Objects ---\n')
  test_objects()
  test_object_inheritance()
   
  /* Lists */
  WriteF('\n--- Lists ---\n')
  test_immediate_lists()
  test_list_functions()
   
  /* Assignment */
  WriteF('\n--- Assignment Operators ---\n')
  test_compound_assignments()
  test_increment_decrement()
  test_inc_dec_statements()
  
  /* Floats */
  WriteF('\n--- Float Operations ---\n')
  test_floats()
  
  /* Immediate Values */
  WriteF('\n--- Immediate Values ---\n')
  test_hex_values()
  test_binary_values()
  test_char_values()
  
  /* Expressions */
  WriteF('\n--- Conditional Expressions ---\n')
  test_conditional_expr()
  test_ternary_operator()
  test_quick_compare()
  
  /* Advanced */
  WriteF('\n--- Swap Operator ---\n')
  test_swap_operator()
  
  WriteF('\n--- Exceptions ---\n')
  test_exception_basic()
  test_try_catch()
  
  WriteF('\n--- Dynamic Memory ---\n')
  test_new_single()
  test_new_array()
  
  WriteF('\n--- Quoted Expressions ---\n')
  test_quoted_expressions()
  
/* List Processing Functions */
  WriteF('\n--- ForAll Function ---\n')
  test_forall_all_true()
  test_forall_some_false()
  test_forall_empty_list()
  test_forall_with_equal_check()
  test_forall_conditional()
  test_forall_side_effects()
  
  WriteF('\n--- Exists Function ---\n')
  test_exists_one_true()
  test_exists_none_true()
  test_exists_multiple_matches()
  test_exists_empty_list_condition()
  test_exists_short_circuit()
  test_exists_with_range_check()
  
  WriteF('\n--- MapList Function ---\n')
  test_maplist_square()
  test_maplist_double()
  test_maplist_increment()
  test_maplist_complex_expression()
  test_maplist_conditional()
  test_maplist_negative_values()
  test_maplist_returns_list()
  test_maplist_large_values()
  
  WriteF('\n--- Combination Tests ---\n')
  test_forall_and_maplist()
  test_exists_on_maplist_result()
  test_forall_exists_consistency()
  test_maplist_with_counter()  
  
  WriteF('\n--- Lists & Functions ---\n')
  test_anonymous_lists()
  
  WriteF('\n--- Unification ---\n')
  test_unification()

  
  /* Run string function tests */
  test_strcmp()
  test_stricmp()
  test_strcopy()
  test_stradd()
  test_straddchar()
  test_strlen()
  test_estrlen()
  test_strmax()
  test_stringf()
  test_astringf()
  test_rightstr()
  test_midstr()
  test_val()
  test_instr()
  test_instri()
  test_trimstr()
  test_upperstr()
  test_lowerstr()
  test_upperchar()
  test_lowerchar()
  test_setstr()
  test_strclone()
  test_astrclone()
  test_astrcopy()
  test_astpcopy()
  test_ostrcmp()
  test_strins()
  test_strrem()
  test_strcompare()
  test_endswith()
  test_charinstr()
  
  /* Run math function tests */
  test_mul()
  test_div()
  test_abs()
  test_sign()
  test_shl_shr()
  test_lsl_lsr()
  test_rol_ror()
  test_mod()
  test_min_max()
  test_bounds()
  test_rnd()
  test_even_odd()
  test_compare_functions()
  
  /* Run memory function tests */
  test_memory_peek()
  test_memory_poke()
  test_memfill()
  test_memcompare()
  
  /* Run logical operation tests */
  test_logical_ops()
  
  /* Run list function tests */
  test_string()
  test_list()
  test_listcopy()
  test_listadd()
  test_listadditem()
  test_listinsitem()
  test_listremitem()
  test_listswapitem()
  test_listcmp()
  test_listlen()
  test_listmax()
  test_listitem()
  test_listclone()
  test_setlist()
  test_selectfirst()
  
  EXCEPT DO
  /* Print summary */
  WriteF('\n=================================================\n')
  WriteF('TEST SUMMARY\n')
  WriteF('=================================================\n')
  WriteF('Total Tests Run: \d\n', tests_run)
  WriteF('Tests Passed: \d\n', tests_passed)
  WriteF('Tests Failed: \d\n', tests_failed)
  
  IF tests_failed = 0
    WriteF('\n*** ALL TESTS PASSED! ***\n')
  ELSE
    WriteF('\n*** SOME TESTS FAILED! ***\n')
  ENDIF
  
  WriteF('=================================================\n')
ENDPROC IF (tests_failed = 0) THEN 0 ELSE 100