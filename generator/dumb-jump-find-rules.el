((:language "elisp" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\((defun|cl-defun|cl-defgeneric|cl-defmethod|cl-defsubst)\\s+JJJ\\j"
         :tests ("(defun test (blah)"
                 "(defun test\n"
                 "(cl-defun test (blah)"
                 "(cl-defun test\n")
         :not ("(defun test-asdf (blah)"
               "(defun test-blah\n"
               "(cl-defun test-asdf (blah)"
               "(cl-defun test-blah\n"
               "(defun tester (blah)"
               "(defun test? (blah)"
               "(defun test- (blah)"))

  (:language "elisp" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\((defmacro|cl-defmacro|cl-define-compiler-macro)\\s+JJJ\\j"
         :tests ("(defmacro test (blah)"
                 "(defmacro test\n")
         :not ("(defmacro test-asdf (blah)"
               "(defmacro test-blah\n"
               "(defmacro tester (blah)"
               "(defmacro test? (blah)"
               "(defmacro test- (blah)"))

  (:language "elisp" :type "function"
             :supports ("ag" "grep" "rg" "git-grep")
             :regex "\\(defhydra\\b\\s*JJJ\\j"
             :tests ("(defhydra test "
                     "(defhydra test\n"
                     "(defhydra test (blah\n"
                     "(defhydra test (blah)")
             :not ("(defhydra tester"
                   "(defhydra test?"
                   "(defhydra test-"
                   "(defhydra test? (blah\n"
                   "(defhydra test? (blah)"))

  (:language "elisp" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\(defvar(-local)?\\b\\s*JJJ\\j"
         :tests ("(defvar test "
                 "(defvar test\n"
                 "(defvar-local test"
                 "(defvar-local test\n")
         :not ("(defvar tester"
               "(defvar test?"
               "(defvar test-"
               "(defvar-local tester"
               "(defvar-local test?"
               "(defvar-local test-"))

  (:language "elisp" :type "variable"
         :supports ("ag" "grep" "rg" "ugrep" "git-grep")
         :regex "\\(defconst\\b\\s*JJJ\\j"
         :tests ("(defconst test "
                 "(defconst test\n")
         :not ("(defconst tester"
               "(defconst test?"
               "(defconst test-"))

  (:language "elisp" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\(defcustom\\b\\s*JJJ\\j"
         :tests ("(defcustom test "
                 "(defcustom test\n")
         :not ("(defcustom tester"
               "(defcustom test?"
               "(defcustom test-"))

  (:language "elisp" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\(setq\\b\\s*JJJ\\j"
         :tests ("(setq test 123)")
         :not ("setq test-blah 123)"
               "(setq tester"
               "(setq test?" "(setq test-"))

  (:language "elisp" :type "variable"
             :supports ("ag" "grep" "rg" "git-grep")
             :regex "\\(JJJ\\s+"
             :tests ("(let ((test 123)))"
                     "(let* ((test 123)))")
             :not ("(let ((test-2 123)))"
                   "(let* ((test-2 123)))"))

  (:language "elisp" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\((cl-defstruct|cl-deftype)\\s+JJJ\\j"
         :tests ("(cl-defstruct test "
                 "(cl-defstruct test\n"
                 "(cl-deftype test "
                 "(cl-deftype test\n")
         :not ("(cl-defstruct test-asdf (blah)"
               "(cl-defstruct test-blah\n"
               "(cl-deftype test-asdf (blah)"
               "(cl-deftype test-blah\n"))

  (:language "elisp" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\((defun|cl-defun|cl-defgeneric|cl-defmethod)\\s*.+\\(?\\s*JJJ\\j\\s*\\)?"
         :tests ("(defun blah (test)"
                 "(defun blah (test blah)"
                 "(defun (blah test)")
         :not ("(defun blah (test-1)"
               "(defun blah (test-2 blah)"
               "(defun (blah test-3)"))

  (:language "commonlisp" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\\(def(un|macro|generic|method|setf)\\s+JJJ\\j"
         :tests ("(defun test (blah)"
                 "(defun test\n"
                 "(defmacro test (blah)"
                 "(defmacro test\n"
                 "(defgeneric test (blah)"
                 "(defgeneric test\n"
                 "(defmethod test (blah)"
                 "(defmethod test\n"
                 "(defsetf test (blah)"
                 "(defsetf test\n")
         :not ("(defun test-asdf (blah)"
               "(defun test-blah\n"
               "(defun tester (blah)"
               "(defun test? (blah)"
               "(defun test- (blah)"
               "(defmacro test-asdf (blah)"
               "(defmacro test-blah\n"
               "(defmacro tester (blah)"
               "(defmacro test? (blah)"
               "(defmacro test- (blah)"
               "(defgeneric test-asdf (blah)"
               "(defgeneric test-blah\n"
               "(defgeneric tester (blah)"
               "(defgeneric test? (blah)"
               "(defun test- (blah)"
               "(defmethod test-asdf (blah)"
               "(defmethod test-blah\n"
               "(defmethod tester (blah)"
               "(defmethod test? (blah)"
               "(defun test- (blah)"
               "(defsetf test-asdf (blah)"
               "(defsetf test-blah\n"
               "(defsetf tester (blah)"
               "(defsetf test? (blah)"
               "(defun test- (blah)"))

  (:language "commonlisp" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\\(define-(modify-macro|compiler-macro|setf-expander)\\s+JJJ\\j"
         :tests ("(define-modify-macro test (blah)"
                 "(define-modify-macro test\n"
                 "(define-compiler-macro test (blah)"
                 "(define-compiler-macro test\n")
         :not ("(define-modify-macro test-asdf (blah)"
               "(define-modify-macro test-blah\n"
               "(define-modify-macro tester (blah)"
               "(define-modify-macro test? (blah)"
               "(define-modify-macro test- (blah)"
               "(define-compiler-macro test-asdf (blah)"
               "(define-compiler-macro test-blah\n"
               "(define-compiler-macro tester (blah)"
               "(define-compiler-macro test? (blah)"
               "(define-compiler-macro test- (blah)"))

  (:language "commonlisp" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\\(def(var|parameter|constant)\\b\\s*JJJ\\j"
         :tests ("(defvar test "
                 "(defvar test\n"
                 "(defparameter test "
                 "(defparameter test\n"
                 "(defconstant test "
                 "(defconstant test\n")
         :not ("(defvar tester"
               "(defvar test?"
               "(defvar test-"
               "(defparameter tester"
               "(defparameter test?"
               "(defparameter test-"
               "(defconstant tester"
               "(defconstant test?"
               "(defconstant test-"))

  (:language "commonlisp" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\\(define-symbol-macro\\b\\s*JJJ\\j"
         :tests ("(define-symbol-macro test "
                 "(define-symbol-macro test\n")
         :not ("(define-symbol-macro tester"
               "(define-symbol-macro test?"
               "(define-symbol-macro test-"))

  (:language "commonlisp" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\\(def(class|struct|type)\\b\\s*JJJ\\j"
         :tests ("(defclass test "
                 "(defclass test\n"
                 "(defstruct test "
                 "(defstruct test\n"
                 "(deftype test "
                 "(deftype test\n")
         :not ("(defclass tester"
               "(defclass test?"
               "(defclass test-"
               "(defstruct tester"
               "(defstruct test?"
               "(defstruct test-"
               "(deftype tester"
               "(deftype test?"
               "(deftype test-"))

  (:language "commonlisp" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\\(define-condition\\b\\s*JJJ\\j"
         :tests ("(define-condition test "
                 "(define-condition test\n")
         :not ("(define-condition tester"
               "(define-condition test?"
               "(define-condition test-"))

  (:language "racket" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\\(define\\s+\\(\\s*JJJ\\j"
         :tests ("(define (test blah)"
                 "(define (test\n")
         :not ("(define test blah"
               "(define (test-asdf blah)"
               "(define test (lambda (blah"))

  (:language "racket" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\\(define\\s+JJJ\\s*\\\(\\s*lambda"
         :tests ("(define test (lambda (blah"
                 "(define test (lambda\n")
         :not ("(define test blah"
               "(define test-asdf (lambda (blah)"
               "(define (test)"
               "(define (test blah) (lambda (foo"))

  (:language "racket" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\\(let\\s+JJJ\\s*(\\\(|\\\[)*"
         :tests ("(let test ((blah foo) (bar bas))"
                 "(let test\n"
                 "(let test [(foo")
         :not ("(let ((test blah"))

  (:language "racket" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\\(define\\s+JJJ\\j"
         :tests ("(define test " "(define test\n")
         :not ("(define (test"))

  (:language "racket" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "(\\\(|\\\[)\\s*JJJ\\s+"
         :tests ("(let ((test 'foo"
                 "(let [(test 'foo"
                 "(let [(test 'foo"
                 "(let [[test 'foo"
                 "(let ((blah 'foo) (test 'bar)")
         :not ("{test foo"))

  (:language "racket" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\\(lambda\\s+\\\(?[^\(\)]*\\s*JJJ\\j\\s*\\\)?"
         :tests ("(lambda (test)"
                 "(lambda (foo test)"
                 "(lambda test (foo)")
         :not ("(lambda () test"))

  (:language "racket" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\\(define\\s+\\\([^\(\)]+\\s*JJJ\\j\\s*\\\)?"
         :tests ("(define (foo test)"
                 "(define (foo test bar)")
         :not ("(define foo test"
               "(define (test foo"
               "(define (test)"))

  (:language "racket" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\(struct\\s+JJJ\\j"
         :tests ("(struct test (a b)"))

  (:language "scheme" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\\(define\\s+\\(\\s*JJJ\\j"
         :tests ("(define (test blah)"
                 "(define (test\n")
         :not ("(define test blah"
               "(define (test-asdf blah)"
               "(define test (lambda (blah"))

  (:language "scheme" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\\(define\\s+JJJ\\s*\\\(\\s*lambda"
         :tests ("(define test (lambda (blah"
                 "(define test (lambda\n")
         :not ("(define test blah"
               "(define test-asdf (lambda (blah)"
               "(define (test)"
               "(define (test blah) (lambda (foo"))

  (:language "scheme" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\\(let\\s+JJJ\\s*(\\\(|\\\[)*"
         :tests ("(let test ((blah foo) (bar bas))"
                 "(let test\n"
                 "(let test [(foo")
         :not ("(let ((test blah"))

  (:language "scheme" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\\(define\\s+JJJ\\j"
         :tests ("(define test "
                 "(define test\n")
         :not ("(define (test"))

  (:language "scheme" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "(\\\(|\\\[)\\s*JJJ\\s+"
         :tests ("(let ((test 'foo"
                 "(let [(test 'foo"
                 "(let [(test 'foo"
                 "(let [[test 'foo"
                 "(let ((blah 'foo) (test 'bar)")
         :not ("{test foo"))

  (:language "scheme" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\\(lambda\\s+\\\(?[^\(\)]*\\s*JJJ\\j\\s*\\\)?"
         :tests ("(lambda (test)"
                 "(lambda (foo test)"
                 "(lambda test (foo)")
         :not ("(lambda () test"))

  (:language "scheme" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\\(define\\s+\\\([^\(\)]+\\s*JJJ\\j\\s*\\\)?"
         :tests ("(define (foo test)"
                 "(define (foo test bar)")
         :not ("(define foo test"
               "(define (test foo"
               "(define (test)"))

  (:language "janet" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\(\(de\)?f\\s+JJJ\\j"
         :tests ("(def test (foo)"))

  (:language "janet" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\(var\\s+JJJ\\j"
         :tests ("(var test (foo)"))

  (:language "janet" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\(\(de\)fn-?\\s+JJJ\\j"
         :tests ("(defn test [foo]"
                 "(defn- test [foo]")
         :not ("(defn test? [foo]"
               "(defn- test? [foo]"))

  (:language "janet" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\(defmacro\\s+JJJ\\j"
         :tests ("(defmacro test [foo]"))

  (:language "c++" :type "function"
         :supports ("ag" "rg" "git-grep")
         :regex "\\bJJJ(\\s|\\))*\\((\\w|[,&*.<>:]|\\s)*(\\))\\s*(const|->|\\{|$)|typedef\\s+(\\w|[(*]|\\s)+JJJ(\\)|\\s)*\\("
         :tests ("int test(){"
                 "my_struct (*test)(int a, int b){"
                 "auto MyClass::test ( Builder::Builder& reference, ) -> decltype( builder.func() ) {"
                 "int test( int *random_argument) const {"
                 "test::test() {"
                 "typedef int (*test)(int);")
         :not ("return test();)"
               "int test(a, b);"
               "if( test() ) {"
               "else test();"))


  (:language "c++" :type "variable"
         :supports ("ag" "rg")
         :regex "\\b(?!(class\\b|struct\\b|return\\b|else\\b|delete\\b))(\\w+|[,>])([*&]|\\s)+JJJ\\s*(\\[(\\d|\\s)*\\])*\\s*([=,(){;]|:\\s*\\d)|#define\\s+JJJ\\b"
         :tests ("int test=2;"
                 "char *test;"
                 "int x = 1, test = 2"
                 "int test[20];"
                 "#define test"
                 "typedef int test;"
                 "unsigned int test:2")
         :not ("return test;"
               "#define NOT test"
               "else test=2;"))

  (:language "c++" :type "type"
         :supports ("ag" "rg" "git-grep")
         :regex "\\b(class|struct|enum|union)\\b\\s*JJJ\\b\\s*(final\\s*)?(:((\\s*\\w+\\s*::)*\\s*\\w*\\s*<?(\\s*\\w+\\s*::)*\\w+>?\\s*,*)+)?((\\{|$))|}\\s*JJJ\\b\\s*;"
         :tests ("typedef struct test {"
                 "enum test {"
                 "} test;"
                 "union test {"
                 "class test final: public Parent1, private Parent2{"
                 "class test : public std::vector<int> {")
         :not("union test var;"
              "struct test function() {"))

  (:language "clojure" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\(def.*\ JJJ\\j"
         :tests ("(def test (foo)"
                 "(defn test [foo]"
                 "(defn ^:some-data test [foo]"
                 "(defn- test [foo]"
                 "(defmacro test [foo]"
                 "(deftask test [foo]"
                 "(deftype test [foo]"
                 "(defmulti test fn"
                 "(defmethod test type"
                 "(definterface test (foo)"
                 "(defprotocol test (foo)"
                 "(defrecord test [foo]"
                 "(deftest test"))

  (:language "coffeescript" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "^\\s*JJJ\\s*[=:].*[-=]>"
         :tests ("test = ()  =>"
                 "test= =>"
                 "test = ->"
                 "test=()->"
                 "test : ()  =>"
                 "test: =>"
                 "test : ->"
                 "test:()->")
         :not ("# test = =>"
               "test = 1"))

  (:language "coffeescript" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "^\\s*JJJ\\s*[:=][^:=-][^>]+$"
         :tests ("test = $"
                 "test : ["
                 "test = {"
                 "test = a")
         :not ("test::a"
               "test: =>"
               "test == 1"
               "# test = 1"))

  (:language "coffeescript" :type "class"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "^\\s*\\bclass\\s+JJJ"
         :tests ("class test"
                 "class test extends")
         :not ("# class"))

  (:language "objc" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\\)\\s*JJJ(:|\\b|\\s)"
         :tests ("- (void)test"
                 "- (void)test:(UIAlertView *)alertView")
         :not ("- (void)testnot"
               "- (void)testnot:(UIAlertView *)alertView"))

  (:language "objc" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\b\\*?JJJ\\s*=[^=\\n]+"
         :tests ("NSString *test = @\"asdf\"")
         :not ("NSString *testnot = @\"asdf\""
               "NSString *nottest = @\"asdf\""))

  (:language "objc" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "(@interface|@protocol|@implementation)\\b\\s*JJJ\\b\\s*"
         :tests ("@interface test: UIWindow")
         :not ("@interface testnon: UIWindow"))


  (:language "objc" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "typedef\\b\\s+(NS_OPTIONS|NS_ENUM)\\b\\([^,]+?,\\s*JJJ\\b\\s*"
         :tests ("typedef NS_ENUM(NSUInteger, test)")
         :not ("typedef NS_ENUMD(NSUInteger, test)"))

  (:language "swift" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "(let|var)\\s*JJJ\\s*(=|:)[^=:\\n]+"
         :tests ("let test = 1234"
                 "var test = 1234"
                 "private lazy var test: UITapGestureRecognizer")
         :not ("if test == 1234:"))

  (:language "swift" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "func\\s+JJJ\\b\\s*(<[^>]*>)?\\s*\\("
         :tests ("func test(asdf)"
                 "func test()"
                 "func test<Value: Protocol>()")
         :not ("func testnot(asdf)"
               "func testnot()"))

  (:language "swift" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "(class|struct|protocol|enum)\\s+JJJ\\b\\s*?"
         :tests ("struct test"
                 "struct test: Codable"
                 "struct test<Value: Codable>"
                 "class test:"
                 "class test: UIWindow"
                 "class test<Value: Codable>")
         :not ("class testnot:"
               "class testnot(object):"
               "struct testnot(object)"))

  (:language "swift" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "(typealias)\\s+JJJ\\b\\s*?="
         :tests ("typealias test =")
         :not ("typealias testnot"))

  (:language "csharp" :type "function"
         :supports ("ag" "rg")
         :regex "^\\s*(?:[\\w\\[\\]]+\\s+){1,3}JJJ\\s*\\\("
         :tests ("int test()"
                 "int test(param)"
                 "static int test()"
                 "static int test(param)"
                 "public static MyType test()"
                 "private virtual SomeType test(param)"
                 "static int test()")
         :not ("test()"
               "testnot()"
               "blah = new test()"))

  (:language "csharp" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\s*\\bJJJ\\s*=[^=\\n)]+"
         :tests ("int test = 1234")
         :not ("if test == 1234:"
               "int nottest = 44"))

  (:language "csharp" :type "variable"
         :supports ("ag" "rg")
         :regex "\\bforeach\\s*\\(\\s*[\\w\\[\\]<>,\\.?]+\\s+JJJ\\s+in\\b"
         :tests ("foreach (int test in items)"
                 "foreach (var test in items)"
                 "foreach (string test in items)"
                 "foreach (List<int> test in items)")
         :not ("foreach (int nottest in items)"
               "test in items"))

  (:type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :language "csharp"
         :regex "(class|interface)\\s*JJJ\\b"
         :tests ("class test:"
                 "public class test : IReadableChannel, I")
         :not ("class testnot:"
               "public class testnot : IReadableChannel, I"))

  (:language "java" :type "function"
         :supports ("ag" "rg")
         :regex "^\\s*(?:[\\w\\[\\]]+\\s+){1,3}JJJ\\s*\\\("
         :tests ("int test()"
                 "int test(param)"
                 "static int test()"
                 "static int test(param)"
                 "public static MyType test()"
                 "private virtual SomeType test(param)"
                 "static int test()"
                 "private foo[] test()")
         :not ("test()"
               "testnot()"
               "blah = new test()"
               "foo bar = test()"))

  (:language "java" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\s*\\bJJJ\\s*=[^=\\n)]+"
         :tests ("int test = 1234")
         :not ("if test == 1234:"
               "int nottest = 44"))

  (:language "java" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "(class|interface)\\s*JJJ\\b"
         :tests ("class test:"
                 "public class test implements Something")
         :not ("class testnot:"
               "public class testnot implements Something"))

  (:language "vala" :type "function"
         :supports ("ag" "rg")
         :regex "^\\s*(?:[\\w\\[\\]]+\\s+){1,3}JJJ\\s*\\\("
         :tests ("int test()"
                 "int test(param)"
                 "static int test()"
                 "static int test(param)"
                 "public static MyType test()"
                 "private virtual SomeType test(param)"
                 "static int test()")
         :not ("test()"
               "testnot()"
               "blah = new test()"))

  (:language "vala" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\s*\\bJJJ\\s*=[^=\\n)]+"
         :tests ("int test = 1234")
         :not ("if test == 1234:"
               "int nottest = 44"))

  (:language "vala" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "(class|interface)\\s*JJJ\\b"
         :tests ("class test:"
                 "public class test : IReadableChannel, I")
         :not ("class testnot:"
               "public class testnot : IReadableChannel, I"))

  (:language "coq" :type "function"
         :supports ("ag" "rg" "git-grep")
         :regex "\\s*Variable\\s+JJJ\\b"
         :tests ("Variable test")
         :not ("Variable testx"))

  (:language "coq" :type "function"
         :supports ("ag" "rg" "git-grep")
         :regex "\\s*Inductive\\s+JJJ\\b"
         :tests ("Inductive test")
         :not ("Inductive testx"))

  (:language "coq" :type "function"
         :supports ("ag" "rg" "git-grep")
         :regex "\\s*Lemma\\s+JJJ\\b"
         :tests ("Lemma test")
         :not ("Lemma testx"))

  (:language "coq" :type "function"
         :supports ("ag" "rg" "git-grep")
         :regex "\\s*Definition\\s+JJJ\\b"
         :tests ("Definition test")
         :not ("Definition testx"))

  (:language "coq" :type "function"
         :supports ("ag" "rg" "git-grep")
         :regex "\\s*Hypothesis\\s+JJJ\\b"
         :tests ("Hypothesis test")
         :not ("Hypothesis testx"))

  (:language "coq" :type "function"
         :supports ("ag" "rg" "git-grep")
         :regex "\\s*Theorm\\s+JJJ\\b"
         :tests ("Theorm test")
         :not ("Theorm testx"))

  (:language "coq" :type "function"
         :supports ("ag" "rg" "git-grep")
         :regex "\\s*Fixpoint\\s+JJJ\\b"
         :tests ("Fixpoint test")
         :not ("Fixpoint testx"))

  (:language "coq" :type "function"
         :supports ("ag" "rg" "git-grep")
         :regex "\\s*Module\\s+JJJ\\b"
         :tests ("Module test")
         :not ("Module testx"))

  (:language "coq" :type "function"
         :supports ("ag" "rg" "git-grep")
         :regex "\\s*CoInductive\\s+JJJ\\b"
         :tests ("CoInductive test")
         :not ("CoInductive testx"))

  (:language "python" :type "variable"
         :supports ("ag" "rg")
         :regex "\\s*\\bJJJ\\b(\\s*:[^=\\n]+)?\\s*=[^=\\n]+"
         :tests ("test = 1234"
                 "test: int = 1234"
                 "test: int | None = 1234"
                 "test: List[Optional[int]] = [1234, None]")
         :not ("if test == 1234:"
               "_test = 1234"
               "if (test := 3):"
               "while test:"
               "test['key'] = 1234"))

      (:language "python" :type "variable"
         :supports ("grep" "git-grep")
         :regex "\\s*\\bJJJ\\b(\\s*:[^=]+)?\\s*=[^=]+"
         :tests ("test = 1234"
                 "test: int = 1234"
                 "test: int | None = 12i34"
                 "test: List[Optional[int]] = [1234, None]")
         :not ("if test == 1234:"
               "_test = 1234"
               "if (test := 3):"
               "while test:"
               "test['key'] = 1234"))

  (:language "python" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "def\\s*JJJ\\b\\s*\\\("
         :tests ("\tdef test(asdf)"
                 "def test()")
         :not ("\tdef testnot(asdf)"
               "def testnot()"))

  (:language "python" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "class\\s*JJJ\\b\\s*\\\(?"
         :tests ("class test(object):"
                 "class test:")
         :not ("class testnot:"
               "class testnot(object):"))

  (:language "matlab" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "^\\s*\\bJJJ\\s*=[^=\\n]+"
         :tests ("test = 1234")
         :not ("for test = 1:2:"
               "_test = 1234"))

  (:language "matlab" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "^\\s*function\\s*[^=]+\\s*=\\s*JJJ\\b"
         :tests ("\tfunction y = test(asdf)"
                 "function x = test()"
                 "function [x, losses] = test(A, y, lambda, method, qtile)")
         :not ("\tfunction testnot(asdf)"
               "function testnot()"))

  (:language "matlab" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "^\\s*classdef\\s*JJJ\\b\\s*"
         :tests ("classdef test")
         :not ("classdef testnot"))

  (:language "nim" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "(const|let|var)\\s*JJJ\\*?\\s*(=|:)[^=:\\n]+"
         :tests ("let test = 1234"
                 "var test = 1234"
                 "var test: Stat"
                 "const test = 1234"
                 "const test* = 1234")
         :not ("if test == 1234:"))

  (:language "nim" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "(proc|func|macro|template)\\s*`?JJJ`?\\b\\*?\\s*\\\("
         :tests ("\tproc test(asdf)"
                 "proc test()"
                 "func test()"
                 "macro test()"
                 "template test()"
                 "proc test*()")
         :not ("\tproc testnot(asdf)"
               "proc testnot()"))

  (:language "nim" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "type\\s*JJJ\\b\\*?\\s*(\\{[^}]+\\})?\\s*=\\s*\\w+"
         :tests ("type test = object"
                 "type test {.pure.} = enum"
                 "type test* = ref object")
         :not ("type testnot = object"))

  (:language "nix" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\b\\s*JJJ\\s*=[^=;]+"
         :tests ("test = 1234;"
                 "test = 123;"
                 "test=123")
         :not ("testNot = 1234;"
               "Nottest = 1234;"
               "AtestNot = 1234;"))

  (:language "org" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "^\\s*#\\+[nN][aA][mM][eE]:\\s*JJJ\\j"
         :tests ("#+name: test"
                 "#+NAME: test"
                 "#+Name: test"
                 "  #+name: test"
                 "#+name:test")
         :not ("#+name: tester"
               "#+name: test-block"
               "some #+name: test"))

  (:language "org" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "^\\s*#\\+[cC][aA][lL][lL]:\\s*JJJ\\j"
         :tests ("#+call: test"
                 "#+CALL: test"
                 "#+Call: test"
                 "  #+call: test"
                 "#+call: test()"
                 "#+call: test(x=1)")
         :not ("#+call: tester"
               "#+call: test-other"
               "some #+call: test"))

  (:language "org" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "^\\*+\\s+JJJ\\j"
         :tests ("* test"
                 "** test"
                 "*** test"
                 "**** test"
                 "* test heading"
                 "** test with more words")
         :not ("* tester"
               "** testing"
               "* test-other"
               "not a * test heading"))

  (:language "org" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "^\\s*:CUSTOM_ID:\\s*JJJ\\j"
         :tests (":CUSTOM_ID: test"
                 ":CUSTOM_ID:  test"
                 "  :CUSTOM_ID: test"
                 ":CUSTOM_ID:test")
         :not (":CUSTOM_ID: tester"
               ":CUSTOM_ID: test-other"
               "inline :CUSTOM_ID: test text"))

  (:language "ruby" :type "variable"
         :supports ("ag" "rg" "git-grep")
         :regex "^\\s*((\\w+[.])*\\w+,\\s*)*JJJ(,\\s*(\\w+[.])*\\w+)*\\s*=([^=>~]|$)"
         :tests ("test = 1234"
                 "self.foo, test, bar = args")
         :not ("if test == 1234"
               "foo_test = 1234"))

  (:language "ruby" :type "function"
         :supports ("ag" "rg" "git-grep")
         :regex "(^|[^\\w.])((private|public|protected)\\s+)?def\\s+(\\w+(::|[.]))*JJJ($|[^\\w|:])"
         :tests ("def test(foo)"
                 "def test()"
                 "def test foo"
                 "def test; end"
                 "def self.test()"
                 "def MODULE::test()"
                 "private def test")
         :not ("def test_foo"))

  (:language "ruby" :type "function"
         :supports ("ag" "rg" "git-grep")
         :regex "(^|\\W)define(_singleton|_instance)?_method(\\s|[(])\\s*:JJJ($|[^\\w|:])"
         :tests ("define_method(:test, &body)"
                 "mod.define_instance_method(:test) { body }"))

  (:language "ruby" :type "type"
         :supports ("ag" "rg" "git-grep")
         :regex "(^|[^\\w.])class\\s+(\\w*::)*JJJ($|[^\\w|:])"
         :tests ("class test"
                 "class Foo::test"))

  (:language "ruby" :type "type"
         :supports ("ag" "rg" "git-grep")
         :regex "(^|[^\\w.])module\\s+(\\w*::)*JJJ($|[^\\w|:])"
         :tests ("module test"
                 "module Foo::test"))

  (:language "ruby" :type "function"
         :supports ("ag" "rg" "git-grep")
         :regex "(^|\\W)alias(_method)?\\W+JJJ(\\W|$)"
         :tests ("alias test some_method"
                 "alias_method :test, :some_method"
                 "alias_method 'test' 'some_method'"
                 "some_class.send(:alias_method, :test, :some_method)")
         :not ("alias some_method test"
               "alias_method :some_method, :test"
               "alias test_foo test"))

  (:language "groovy" :type "variable"
         :supports ("ag" "rg" "git-grep")
         :regex "^\\s*((\\w+[.])*\\w+,\\s*)*JJJ(,\\s*(\\w+[.])*\\w+)*\\s*=([^=>~]|$)"
         :tests ("test = 1234"
                 "self.foo, test, bar = args")
         :not ("if test == 1234"
               "foo_test = 1234"))

  (:language "groovy" :type "function"
         :supports ("ag" "rg" "git-grep")
         :regex "(^|[^\\w.])((private|public)\\s+)?def\\s+(\\w+(::|[.]))*JJJ($|[^\\w|:])"
         :tests ("def test(foo)"
                 "def test()"
                 "def test foo"
                 "def test; end"
                 "def self.test()"
                 "def MODULE::test()"
                 "private def test")
         :not ("def test_foo"))

  (:language "groovy" :type "type"
         :supports ("ag" "rg" "git-grep")
         :regex "(^|[^\\w.])class\\s+(\\w*::)*JJJ($|[^\\w|:])"
         :tests ("class test"
                 "class Foo::test"))

  (:language "crystal" :type "variable"
         :supports ("ag" "rg" "git-grep")
         :regex "^\\s*((\\w+[.])*\\w+,\\s*)*JJJ(,\\s*(\\w+[.])*\\w+)*\\s*=([^=>~]|$)"
         :tests ("test = 1234"
                 "self.foo, test, bar = args")
         :not ("if test == 1234"
               "foo_test = 1234"))

  (:language "crystal" :type "function"
         :supports ("ag" "rg" "git-grep")
         :regex "(^|[^\\w.])((private|public|protected)\\s+)?def\\s+(\\w+(::|[.]))*JJJ($|[^\\w|:])"
         :tests ("def test(foo)"
                 "def test()"
                 "def test foo"
                 "def test; end"
                 "def self.test()"
                 "def MODULE::test()"
                 "private def test")
         :not ("def test_foo"))

  (:language "crystal" :type "type"
         :supports ("ag" "rg" "git-grep")
         :regex "(^|[^\\w.])class\\s+(\\w*::)*JJJ($|[^\\w|:])"
         :tests ("class test"
                 "class Foo::test"))

  (:language "crystal" :type "type"
         :supports ("ag" "rg" "git-grep")
         :regex "(^|[^\\w.])module\\s+(\\w*::)*JJJ($|[^\\w|:])"
         :tests ("module test"
                 "module Foo::test"))

  (:language "crystal" :type "type"
         :supports ("ag" "rg" "git-grep")
         :regex "(^|[^\\w.])struct\\s+(\\w*::)*JJJ($|[^\\w|:])"
         :tests ("struct test"
                 "struct Foo::test"))

  (:language "crystal" :type "type"
         :supports ("ag" "rg" "git-grep")
         :regex "(^|[^\\w.])alias\\s+(\\w*::)*JJJ($|[^\\w|:])"
         :tests ("alias test"
                 "alias Foo::test"))

  (:language "scad" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\s*\\bJJJ\\s*=[^=\\n]+"
         :tests ("test = 1234")
         :not ("if test == 1234 {"))

  (:language "scad" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "function\\s*JJJ\\s*\\\("
         :tests ("function test()"
                 "function test ()"))

  (:language "scad" :type "module"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "module\\s*JJJ\\s*\\\("
         :tests ("module test()"
                 "module test ()"))

  (:language "scala" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\bval\\s*JJJ\\s*=[^=\\n]+"
         :tests ("val test = 1234")
         :not ("case test => 1234"))

  (:language "scala" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\bvar\\s*JJJ\\s*=[^=\\n]+"
         :tests ("var test = 1234")
         :not ("case test => 1234"))

  (:language "scala" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\btype\\s*JJJ\\s*=[^=\\n]+"
         :tests ("type test = 1234")
         :not ("case test => 1234"))

  (:language "scala" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\bdef\\s*JJJ\\s*\\\("
         :tests ("def test(asdf)" "def test()"))

  (:language "scala" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "class\\s*JJJ\\s*\\\(?"
         :tests ("class test(object)"))

  (:language "scala" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "trait\\s*JJJ\\s*\\\(?"
         :tests ("trait test(object)"))

  (:language "scala" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "object\\s*JJJ\\s*\\\(?"
         :tests ("object test(object)"))

  (:language "solidity" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex  "function\\s*JJJ\\s*\\\("
         :tests ("function test() internal"
                 "function test (uint x, address y)"
                 "function test() external"))

  (:language "solidity" :type "modifier"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex  "modifier\\s*JJJ\\s*\\\("
         :tests ("modifier test()"
                 "modifier test ()"))

  (:language "solidity" :type "event"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex  "event\\s*JJJ\\s*\\\("
         :tests ("event test();"
                 "event test (uint indexed x)"
                 "event test(uint x, address y)"))

  (:language "solidity" :type "error"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex  "error\\s*JJJ\\s*\\\("
         :tests ("error test();"
                 "error test (uint x)"
                 "error test(uint x, address y)"))

  (:language "solidity" :type "contract"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex  "contract\\s*JJJ\\s*(is|\\\{)"
         :tests ("contract test{"
                 "contract test {"
                 "contract test is foo"))
  
  (:language "solidity" :type "type" 
         :supports ("ag" "grep" "rg" "git-grep") 
         :regex  "struct\\s*JJJ\\s*\\\{"
         :tests ("struct test{"
                 "struct test {"))

  (:language "r" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\bJJJ\\s*=[^=><]"
         :tests ("test = 1234")
         :not ("if (test == 1234)"))

  (:language "r" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\bJJJ\\s*<-\\s*function\\b"
         :tests ("test <- function"
                 "test <- function(")
         :not   ("test <- functionX"))

  (:language "perl" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "sub\\s*JJJ\\s*(\\{|\\()"
         :tests ("sub test{"
                 "sub test {"
                 "sub test(" "sub test ("))

  (:language "perl" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "JJJ\\s*=\\s*"
         :tests ("$test = 1234"))

  (:language "tcl" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "proc\\s+JJJ\\s*\\{"
         :tests ("proc test{" "proc test {"))

  (:language "tcl" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "set\\s+JJJ"
         :tests ("set test 1234"))

  (:language "tcl" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "(variable|global)\\s+JJJ"
         :tests ("variable test" "global test"))

  (:language "shell" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "function\\s*JJJ\\s*"
         :tests ("function test{"
                 "function test {"
                 "function test () {")
         :not   ("function nottest {"))

  (:language "shell" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "JJJ\\\(\\\)\\s*\\{"
         :tests ("test() {")
         :not ("testx() {"))

  (:language "shell" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\bJJJ\\s*=\\s*"
         :tests ("test = 1234")
         :not ("blahtest = 1234"))

  (:language "php" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "function\\s*JJJ\\s*\\\("
         :tests ("function test()"
                 "function test ()"))

  (:language "php" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\*\\s@method\\s+[^ \t]+\\s+JJJ\\("
         :tests ("/** @method string|false test($a)"
                 " * @method bool test()"))

  (:language "php" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "(\\s|->|\\$|::)JJJ\\s*=\\s*"
         :tests ("$test = 1234"
                 "$foo->test = 1234"))

  (:language "php" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\*\\s@property(-read|-write)?\\s+([^ \t]+\\s+)&?\\$JJJ(\\s+|$)"
         :tests ("/** @property string $test"
                 "/** @property string $test description for $test property"
                 " * @property-read bool|bool $test"
                 " * @property-write \\ArrayObject<string,resource[]> $test"))

  (:language "php" :type "trait"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "trait\\s*JJJ\\s*\\\{"
         :tests ("trait test{"
                 "trait test {"))

  (:language "php" :type "interface"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "interface\\s*JJJ\\s*(extends|\\\{)"
         :tests ("interface test{"
                 "interface test {")
                 "interface test extends test2")

  (:language "php" :type "class"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "class\\s*JJJ\\s*(extends|implements|\\\{)"
         :tests ("class test{"
                 "class test {"
                 "class test extends foo"
                 "class test implements foo"))

  (:language "php" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\benum\\s+JJJ\\b\\s*(:\\s*(int|string))?\\s*(implements[^{]+)?\\{"
         :tests ("enum test {"
                 "enum test: int {"
                 "enum test: string {"
                 "enum test implements Stringable {"
                 "enum test: int implements JsonSerializable {")
         :not ("// enum test" "$enum = 'test'"))

  (:language "php" :type "constant"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "^\\s*case\\s+JJJ\\s*(;|=)"
         :tests ("    case test;"
                 "case test = 1;"
                 "case test = 'value';")
         :not ("case 'test':" "case \"test\":" "default:"))

  (:language "php" :type "class"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\babstract\\s+class\\s+JJJ\\s*(extends|implements|\\\{)"
         :tests ("abstract class test {"
                 "abstract class test extends Base {"
                 "abstract class test implements Foo {")
         :not ("// abstract class test"))

  (:language "php" :type "class"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\bfinal\\s+(readonly\\s+)?class\\s+JJJ\\s*(extends|implements|\\\{)"
         :tests ("final class test {"
                 "final readonly class test {"
                 "final class test extends Base {")
         :not ("// final class test"))

  (:language "php" :type "class"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\breadonly\\s+(final\\s+)?class\\s+JJJ\\s*(extends|implements|\\\{)"
         :tests ("readonly class test {"
                 "readonly final class test {"
                 "readonly class test implements Serializable {")
         :not ("// readonly class test"))

  (:language "php" :type "constant"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "(final\\s+)?(public|protected|private)?\\s*const\\s+JJJ\\s*="
         :tests ("const test = 'value';"
                 "public const test = 100;"
                 "private const test = 'secret';"
                 "protected const test = [];"
                 "final public const test = 42;"
                 "final const test = true;")
         :not ("$const = 'test'" "// const test"))

  (:language "php" :type "constant"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "^const\\s+JJJ\\s*="
         :tests ("const test = 'app_name';"
                 "const test = 42;"
                 "const test = [];")
         :not ("    const test =" "public const test ="))

  (:language "php" :type "constant"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "^\\s*define\\s*\\(\\s*['\"]JJJ['\"]"
         :tests ("define('test', 100);"
                 "define(\"test\", 'value');"
                 "define('test',")
         :not ("// define('test'" "$define = 'test'"))

  (:language "php" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "(public|protected|private)\\s+(static\\s+)?(readonly\\s+)?\\??[A-Za-z_][A-Za-z0-9_\\\\|&]*\\s+\\$JJJ\\s*(;|=|,)"
         :tests ("public int $test;"
                 "private string $test = '';"
                 "protected ?array $test = null;"
                 "public readonly string $test;"
                 "private static int $test = 0;"
                 "public DateTime $test;")
         :not ("public function foo(int $test)" "return $test;"))

  (:language "php" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "(public|protected|private)?\\s*static\\s+\\$JJJ\\s*(;|=)"
         :tests ("static $test;"
                 "public static $test = [];"
                 "private static $test = null;")
         :not ("static function test()" "static::$test"))

  (:language "php" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\bnamespace\\s+([A-Za-z_][A-Za-z0-9_]*\\\\)*JJJ\\s*[;{]"
         :tests ("namespace test;"
                 "namespace App\\test;"
                 "namespace App\\Services\\test {")
         :not ("// namespace test" "use App\\test;"))

  (:language "php" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\buse\\s+([A-Za-z_][A-Za-z0-9_]*\\\\)*JJJ\\s*(;|,|\\s+as\\s+)"
         :tests ("use test;"
                 "use App\\test;"
                 "use App\\Models\\test as TestModel;"
                 "use App\\test, App\\Other;")
         :not ("use function test;" "use const test;"))

  (:language "dart" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\bJJJ\\s*\\([^()]*\\)\\s*[{]"
         :tests ("test(foo) {"
                 "test (foo){"
                 "test(foo){"))

  (:language "dart" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "class\\s*JJJ\\s*[\\\(\\\{]"
         :tests ("class test(object) {"
                 "class test{"))

  (:language "dlang" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "^[[:space:]]*([][[:alnum:]_!.*<>]+[[:space:]]+)+JJJ[[:space:]]*\\\([^;{}]*\\\)([[:space:]]+@?[[:alnum:]_]+)*[[:space:]]*[{]"
         :tests ("void test() {"
                 "public static int test(int value) {"
                 "auto test(T)(T value) {"
                 "void test() pure {"
                 "void test() @safe {")
         :not ("return test();"
               "auto value = test(arg);"
               "test();"))

  (:language "dlang" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\s*\\bJJJ\\s*=[^=\\n)]+"
         :tests ("int test = 1234;"
                 "immutable test = 1;"
                 "auto test = foo();")
         :not ("if (test == 1234)"
               "int nottest = 44;"))

  (:language "dlang" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "(class|interface|struct|union|enum|alias)\\s+JJJ\\b"
         :tests ("class test {"
                 "struct test {"
                 "alias test = int;")
         :not ("class testnot {"
               "alias nottest = test;"))

  (:language "faust" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\bJJJ\(\\\(.+\\\)\)*\\s*="
         :tests ("test = osc + 0.5;"
                 "test(freq) = osc(freq) + 0.5;"))

  (:language "fennel" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\((local|var)\\s+JJJ\\j"
         :tests ("(local test (foo)"
                 "(var test (foo)"))

  (:language "fennel" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\(fn\\s+JJJ\\j"
         :tests ("(fn test [foo]")
         :not ("(fn test? [foo]"))

  (:language "fennel" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\(macro\\s+JJJ\\j"
         :tests ("(macro test [foo]"))

  (:language "fortran" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\s*\\bJJJ\\s*=[^=\\n]+"
         :tests ("test = 1234")
         :not ("if (test == 1234)"))

  (:language "fortran" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\b(function|subroutine|FUNCTION|SUBROUTINE)\\s+JJJ\\b\\s*\\\("
         :tests ("function test (foo)"
                 "integer function test(foo)"
                 "subroutine test (foo, bar)"
                 "FUNCTION test (foo)"
                 "INTEGER FUNCTION test(foo)"
                 "SUBROUTINE test (foo, bar)")
         :not ("end function test"
               "end subroutine test"
               "END FUNCTION test"
               "END SUBROUTINE test"))

  (:language "fortran" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "^\\s*(interface|INTERFACE)\\s+JJJ\\b"
         :tests ("interface test"
                 "INTERFACE test")
         :not ("interface test2"
               "end interface test"
               "INTERFACE test2"
               "END INTERFACE test"))

  (:language "fortran" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "^\\s*(module|MODULE)\\s+JJJ\\s*"
         :tests ("module test"
                 "MODULE test")
         :not ("end module test"
               "END MODULE test"))

  (:language "go" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\s*\\bJJJ\\s*=[^=\\n]+"
         :tests ("test = 1234")
         :not ("if test == 1234 {"))

  (:language "go" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\s*\\bJJJ\\s*:=\\s*"
         :tests ("test := 1234"))

  (:language "go" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "func\\s+\\\([^\\\)]*\\\)\\s+JJJ\\s*\\\("
         :tests ("func (s *blah) test(filename string) string {"))

  (:language "go" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "func\\s+JJJ\\s*\\\("
         :tests ("func test(url string) (string, error)"))

  (:language "go" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "type\\s+JJJ\\s+struct\\s+\\\{"
         :tests ("type test struct {"))

  (:language "javascript" :tags ("angular") :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "(service|factory)\\\(['\"]JJJ['\"]"
         :tests ("module.factory('test', [\"$rootScope\", function($rootScope) {"))

  (:language "javascript" :tags ("es6") :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\bJJJ\\s*[=:]\\s*\\\([^\\\)]*\\\)\\s+=>"
         :tests ("const test = (foo) => " "test: (foo) => {" "  test: (foo) => {"))

  (:language "javascript" :tags ("es6") :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\bJJJ\\s*\\([^()]*\\)\\s*[{]"
         :tests ("test(foo) {" "test (foo){" "test(foo){")
         :not ("test = blah.then(function(){"))

  (:language "javascript" :tags ("es6") :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "class\\s*JJJ\\s*[\\\(\\\{]"
         :tests ("class test(object) {" "class test{"))

  (:language "javascript" :tags ("es6") :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "class\\s*JJJ\\s+extends"
         :tests ("class test extends Component{"))

  (:language "javascript" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\s*\\bJJJ\\s*=[^=\\n]+"
         :tests ("test = 1234"
                 "const test = props =>")
         :not ("if (test === 1234)"))

  (:language "javascript" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\bfunction\\b[^\\(]*\\\(\\s*[^\\)]*\\bJJJ\\b\\s*,?\\s*\\\)?"
         :tests ("function (test)"
                 "function (test, blah)"
                 "function somefunc(test, blah) {"
                 "function(blah, test)")
         :not ("function (testLen)"
               "function (test1, blah)"
               "function somefunc(testFirst, blah) {"
               "function(blah, testLast)"
               "function (Lentest)"
               "function (blahtest, blah)"
               "function somefunc(Firsttest, blah) {"
               "function(blah, Lasttest)"))

  (:language "javascript" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "function\\s*JJJ\\s*\\\("
         :tests ("function test()"
                 "function test ()"))

  (:language "javascript" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\bJJJ\\s*:\\s*function\\s*\\\("
         :tests ("test: function()"))

  (:language "javascript" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\bJJJ\\s*=\\s*function\\s*\\\("
         :tests ("test = function()"))

  (:language "hcl" :type "block"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "(variable|output|module)\\s*\"JJJ\"\\s*\\\{"
         :tests ("variable \"test\" {"
                 "output \"test\" {"
                 "module \"test\" {"))

  (:language "hcl" :type "block"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "(data|resource)\\s*\"\\w+\"\\s*\"JJJ\"\\s*\\\{"
         :tests ("data \"openstack_images_image_v2\" \"test\" {"
                 "resource \"google_compute_instance\" \"test\" {"))

  (:language "typescript" :tags ("angular") :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "(service|factory)\\\(['\"]JJJ['\"]"
         :tests ("module.factory('test', [\"$rootScope\", function($rootScope) {"))

  (:language "typescript" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\bJJJ\\s*[=:]\\s*\\\([^\\\)]*\\\)\\s+=>"
         :tests ("const test = (foo) => "
                 "test: (foo) => {"
                 "  test: (foo) => {"))

  (:language "typescript" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\bJJJ\\s*\\([^()]*\\)\\s*[{]"
         :tests ("test(foo) {"
                 "test (foo){"
                 "test(foo){")
         :not ("test = blah.then(function(){"))

  (:language "typescript" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "class\\s*JJJ(\\s*<[^>]*>)?\\s*[\\\(\\\{]"
         :tests ("class test{"
                 "class test<T>{"))

  (:language "typescript" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "class\\s*JJJ(\\s*<[^>]*>)?\\s+extends"
         :tests ("class test extends Component{"
                 "class test<T> extends Component{"))

  (:language "typescript" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "class\\s*JJJ(\\s*<[^>]*>)?\\s*[\\\(\\\{]"
         :tests ("class test{"
                 "class test<T>{"))

  (:language "typescript" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "class\\s*JJJ(\\s*<[^>]*>)?\\s+extends"
         :tests ("class test extends Component{"
                 "class test<T> extends Component{"))

  (:language "typescript" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "(export\\s+)?interface\\s+JJJ\\b"
         :tests ("interface test{"
                 "interface test extends Thing{"
                 "export interface test{")
         :not ("interface testnot{"))

  (:language "typescript" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "(export\\s+)?type\\s+JJJ\\b"
         :tests ("type test = number"
                 "type test<T> = T"
                 "export type test = number")
         :not ("type testnot = number"))

  (:language "typescript" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "(export\\s+)?enum\\s+JJJ\\b"
         :tests ("enum test{"
                 "export enum test{")
         :not ("enum testnot{"))

  (:language "typescript" :type "module"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "(declare\\s+)?namespace\\s+JJJ\\b"
         :tests ("declare namespace test"
                 "namespace test")
         :not ("declare testnot"))

  (:language "typescript" :type "module"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "(export\\s+)?module\\s+JJJ\\b"
         :tests ("export module test"
                 "module test")
         :not ("module testnot"))

  (:language "typescript" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "function\\s*JJJ\\s*\\\("
         :tests ("function test()"
                 "function test ()"))

  (:language "typescript" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\bJJJ\\s*:\\s*function\\s*\\\("
         :tests ("test: function()"))

  (:language "typescript" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\bJJJ\\s*=\\s*function\\s*\\\("
         :tests ("test = function()"))

  (:language "typescript" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\s*\\bJJJ\\s*=[^=\\n]+"
         :tests ("test = 1234" "const test = props =>")
         :not ("if (test === 1234)"))

  (:language "typescript" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\bfunction\\b[^\\(]*\\\(\\s*[^\\)]*\\bJJJ\\b\\s*,?\\s*\\\)?"
         :tests ("function (test)"
                 "function (test, blah)"
                 "function somefunc(test, blah) {"
                 "function(blah, test)")
         :not ("function (testLen)"
               "function (test1, blah)"
               "function somefunc(testFirst, blah) {"
               "function(blah, testLast)"
               "function (Lentest)"
               "function (blahtest, blah)"
               "function somefunc(Firsttest, blah) {"
               "function(blah, Lasttest)"))

  (:language "julia" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "(@noinline|@inline)?\\s*function\\s*JJJ(\\{[^\\}]*\\})?\\("
         :tests ("function test()"
                 "@inline function test()"
                 "function test{T}(h)"))

  (:language "julia" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "(@noinline|@inline)?JJJ(\\{[^\\}]*\\})?\\([^\\)]*\\)\s*="
         :tests ("test(a)=1"
                 "test(a,b)=1*8"
                 "@noinline test()=1"
                 "test{T}(x)=x"))

  (:language "julia" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "macro\\s*JJJ\\("
         :tests ("macro test(a)=1"
                 " macro test(a,b)=1*8"))

  (:language "julia" :type "variable"
         :supports ("ag" "rg")
         :regex "const\\s+JJJ\\b"
         :tests ("const test = "))

  (:language "julia" :type "type"
         :supports ("ag" "rg")
         :regex "(mutable)?\\s*struct\\s*JJJ"
         :tests ("struct test"))

  (:language "julia" :type "type"
         :supports ("ag" "rg")
         :regex "(type|immutable|abstract)\\s*JJJ"
         :tests ("type test"
                 "immutable test"
                 "abstract test <:Testable" ))

  (:language "haskell" :type "module"
         :supports ("ag")
         :regex "^module\\s+JJJ\\s+"
         :tests ("module Test (exportA, exportB) where"))

  (:language "haskell" :type "top level function"
         :supports ("ag")
         :regex "^\\bJJJ(?!(\\s+::))\\s+((.|\\s)*?)=\\s+"
         :tests ("test n = n * 2"
                 "test X{..} (Y a b c) \n bcd \n =\n x * y"
                 "test ab cd e@Datatype {..} (Another thing, inTheRow) = \n undefined"
                 "test = runRealBasedMode @ext @ctx identity identity"
                 "test unwrap wrap nr@Naoeu {..} (Action action, specSpecs) = \n    undefined")
         :not ("nottest n = n * 2"
               "let testnot x y = x * y"
               "test $ y z"
               "let test a o = mda"
               "test :: Sometype -> AnotherType aoeu kek = undefined"))

  (:language "haskell" :type "type-like"
         :supports ("ag")
         :regex "^\\s*((data(\\s+family)?)|(newtype)|(type(\\s+family)?))\\s+JJJ\\s+"
         :tests ("newtype Test a = Something { b :: Kek }"
                 "data Test a b = Somecase a | Othercase b"
                 "type family Test (x :: *) (xs :: [*]) :: Nat where"
                 "data family Test "
                 "type Test = TestAlias")
         :not ("newtype NotTest a = NotTest (Not a)"
               "data TestNot b = Aoeu"))

  (:language "haskell" :type "(data)type constructor 1"
         :supports ("ag")
         :regex "(data|newtype)\\s{1,3}(?!JJJ\\s+)([^=]{1,40})=((\\s{0,3}JJJ\\s+)|([^=]{0,500}?((?<!(-- ))\\|\\s{0,3}JJJ\\s+)))"
         :tests ("data Something a = Test { b :: Kek }"
                 "data Mem a = TrueMem { b :: Kek } | Test (Mem Int) deriving Mda"
                 "newtype SafeTest a = Test (Kek a) deriving (YonedaEmbedding)")
         :not ("data Test = Test { b :: Kek }"))


  (:language "haskell" :type "data/newtype record field"
         :supports ("ag")
         :regex "(data|newtype)([^=]*)=[^=]*?({([^=}]*?)(\\bJJJ)\\s+::[^=}]+})"
         :tests ("data Mem = Mem { \n mda :: A \n  , test :: Kek \n , \n aoeu :: E \n }"
                 "data Mem = Mem { \n test :: A \n  , mda :: Kek \n , \n aoeu :: E \n }"
                 "data Mem = Mem { \n mda :: A \n  , aoeu :: Kek \n , \n test :: E \n }"
                 "data Mem = Mem { test :: Kek } deriving Mda"
                 "data Mem = Mem { \n test :: Kek \n } deriving Mda"
                 "newtype Mem = Mem { \n test :: Kek \n } deriving (Eq)"
                 "newtype Mem = Mem { -- | Some docs \n test :: Kek -- ^ More docs } deriving Eq"
                 "newtype Mem = Mem { test :: Kek } deriving (Eq,Monad)"
                 "newtype NewMem = OldMem { test :: [Tx] }"
                 "newtype BlockHeaderList ssc = BHL\n { test :: ([Aoeu a], [Ssss])\n    } deriving (Eq)")
         :not ("data Heh = Mda { sometest :: Kek, testsome :: Mem }"))

  (:language "haskell" :type "typeclass"
         :supports ("ag")
         :regex "^class\\s+(.+=>\\s*)?JJJ\\s+"
         :tests (
                 "class (Constr1 m, Constr 2) => Test (Kek a) where"
                 "class  Test  (Veryovka a)  where ")
         :not ("class Test2 (Kek a) where"
               "class MakeTest (AoeuTest x y z) where"))

  (:language "ocaml" :type "type"
         :supports ("ag" "rg")
         :regex "^\\s*(and|type)\\s+.*\\bJJJ\\b"
         :tests ("type test ="
                 "and test ="
                 "type 'a test ="
                 "type ('a, _, 'c) test"))

  (:language "ocaml" :type "variable"
         :supports ("ag" "rg")
         :regex "let\\s+JJJ\\b"
         :tests ("let test ="
                 "let test x y ="))

  (:language "ocaml" :type "variable"
         :supports ("ag" "rg")
         :regex "let\\s+rec\\s+JJJ\\b"
         :tests ("let rec test ="
                 "let rec  test x y ="))

  (:language "ocaml" :type "variable"
         :supports ("ag" "rg")
         :regex "\\s*val\\s*\\bJJJ\\b\\s*"
         :tests ("val test"))

  (:language "ocaml" :type "module"
         :supports ("ag" "rg")
         :regex "^\\s*module\\s*\\bJJJ\\b"
         :tests ("module test ="))

   (:language "ocaml" :type "module"
          :supports ("ag" "rg")
          :regex "^\\s*module\\s*type\\s*\\bJJJ\\b"
          :tests ("module type test ="))

  (:language "purescript" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "^\\s*\\bJJJ\\b\\s+(::|[^=]*\\s=[^=])"
         :tests ("test :: Int -> String"
                 "test :: Number -> Number -> Number"
                 "  test :: Int -> String"
                 "test x y = x + y"
                 "test (Just x) = x"
                 "test { x } = x")
         :not ("nottest :: Int -> String"
               "testing x = 1"
               "test x == y"
               "test >>= bar"))

  (:language "purescript" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "^\\s*\\bJJJ\\s*=[^=]"
         :tests ("test = 42"
                 "test = \\x -> x + 1"
                 "  test = compute x")
         :not ("test == 42"
               "-- test = 42"))

  (:language "purescript" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\blet\\s+JJJ\\s*(\\::|=[^=])"
         :tests ("let test = 42"
                 "let test :: Int")
         :not ("let testing = 42"
               "let test == 42"))

  (:language "purescript" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "^\\s*(type|newtype|data)\\s+JJJ\\b"
         :tests ("type test = Int"
                 "newtype test = test Int"
                 "data test = test Int | Other String")
         :not ("type testOther = Int"
               "data testOther = testOther Int"))

  (:language "lua" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\s*\\bJJJ\\s*=[^=\\n]+"
         :tests ("test = 1234")
         :not ("if test === 1234"))

  (:language "lua" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\bfunction\\b[^\\(]*\\\(\\s*[^\\)]*\\bJJJ\\b\\s*,?\\s*\\\)?"
         :tests ("function (test)"
                 "function (test, blah)"
                 "function somefunc(test, blah)"
                 "function(blah, test)")
         :not ("function (testLen)"
               "function (test1, blah)"
               "function somefunc(testFirst, blah)"
               "function(blah, testLast)"
               "function (Lentest)"
               "function (blahtest, blah)"
               "function somefunc(Firsttest, blah)"
               "function(blah, Lasttest)"))

  (:language "lua" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "function\\s*JJJ\\s*\\\("
         :tests ("function test()" "function test ()"))

  (:language "lua" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "function\\s*.+[.:]JJJ\\s*\\\("
         :tests ("function MyClass.test()"
                 "function MyClass.test ()"
                 "function MyClass:test()"
                 "function MyClass:test ()"))

  (:language "lua" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\bJJJ\\s*=\\s*function\\s*\\\("
         :tests ("test = function()"))

  (:language "lua" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\b.+\\.JJJ\\s*=\\s*function\\s*\\\("
         :tests ("MyClass.test = function()"))

  (:language "rust" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\blet\\s+(\\\([^=\\n]*)?(mut\s+)?JJJ([^=\\n]*\\\))?(:\\s*[^=\\n]+)?\\s*=\\s*[^=\\n]+"
         :tests ("let test = 1234;"
                 "let test: u32 = 1234;"
                 "let test: Vec<u32> = Vec::new();"
                 "let mut test = 1234;"
                 "let mut test: Vec<u32> = Vec::new();"
                 "let (a, test, b) = (1, 2, 3);"
                 "let (a, mut test, mut b) = (1, 2, 3);"
                 "let (mut a, mut test): (u32, usize) = (1, 2);"))

  (:language "rust" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\bconst\\s+JJJ:\\s*[^=\\n]+\\s*=[^=\\n]+"
         :tests ("const test: u32 = 1234;"))

  (:language "rust" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\bstatic\\s+(mut\\s+)?JJJ:\\s*[^=\\n]+\\s*=[^=\\n]+"
         :tests ("static test: u32 = 1234;"
                 "static mut test: u32 = 1234;"))

  (:language "rust" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\bfn\\s+.+\\s*\\\((.+,\\s+)?JJJ:\\s*[^=\\n]+\\s*(,\\s*.+)*\\\)"
         :tests ("fn abc(test: u32) -> u32 {"
                 "fn abc(x: u32, y: u32, test: Vec<u32>, z: Vec<Foo>)"
                 "fn abc(x: u32, y: u32, test: &mut Vec<u32>, z: Vec<Foo>)"))

  (:language "rust" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "(if|while)\\s+let\\s+([^=\\n]+)?(mut\\s+)?JJJ([^=\\n\\\(]+)?\\s*=\\s*[^=\\n]+"
         :tests ("if let Some(test) = abc() {"
                 "if let Some(mut test) = abc() {"
                 "if let Ok(test) = abc() {"
                 "if let Ok(mut test) = abc() {"
                 "if let Foo(mut test) = foo {"
                 "if let test = abc() {"
                 "if let Some(test) = abc()"
                 "if let Some((a, test, b)) = abc()"
                 "while let Some(test) = abc() {"
                 "while let Some(mut test) = abc() {"
                 "while let Ok(test) = abc() {"
                 "while let Ok(mut test) = abc() {")
         :not ("while let test(foo) = abc() {"))

  (:language "rust" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "struct\\s+[^\\n{]+[{][^}]*(\\s*JJJ\\s*:\\s*[^\\n},]+)[^}]*}"
         :tests ("struct Foo { abc: u32, test: Vec<String>, b: PathBuf }"
                 "struct Foo<T>{test:Vec<T>}"
                 "struct FooBar<'a> { test: Vec<String> }")
         :not ("struct Foo { abc: u32, b: Vec<String> }"
               "/// ... construct the equivalent ...\nfn abc() {\n"))

  (:language "rust" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "enum\\s+[^\\n{]+\\s*[{][^}]*\\bJJJ\\b[^}]*}"
         :tests ("enum Foo { VariantA, test, VariantB(u32) }"
                 "enum Foo<T> { test(T) }"
                 "enum BadStyle{test}"
                 "enum Foo32 { Bar, testing, test(u8) }")
         :not ("enum Foo { testing }"))

  (:language "rust" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\bfn\\s+JJJ\\s*\\\("
         :tests ("fn test(asdf: u32)"
                 "fn test()"
                 "pub fn test()"))

  (:language "rust" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\bmacro_rules!\\s+JJJ"
         :tests ("macro_rules! test"))

  (:language "rust" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "struct\\s+JJJ\\s*[{\\\(]?"
         :tests ("struct test(u32, u32)"
                 "struct test;"
                 "struct test { abc: u32, def: Vec<String> }"))

  (:language "rust" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "trait\\s+JJJ\\s*[{]?"
         :tests ("trait test;" "trait test { fn abc() -> u32; }"))

  (:language "rust" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\btype\\s+JJJ([^=\\n]+)?\\s*=[^=\\n]+;"
         :tests ("type test<T> = Rc<RefCell<T>>;"
                 "type test = Arc<RwLock<Vec<u32>>>;"))

  (:language "rust" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "impl\\s+((\\w+::)*\\w+\\s+for\\s+)?(\\w+::)*JJJ\\s+[{]?"
         :tests ("impl test {"
                 "impl abc::test {"
                 "impl std::io::Read for test {"
                 "impl std::io::Read for abc::test {"))

  (:language "rust" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "mod\\s+JJJ\\s*[{]?"
         :tests ("mod test;" "pub mod test {"))

  (:language "rust" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\benum\\s+JJJ\\b\\s*[{]?"
         :tests ("enum test { A, B, C }"
                 "enum test {"
                 "pub enum test<T> {"
                 "pub enum test<T> { A, B }"
                 "pub enum test<T: Clone + Debug> {"
                 "enum test { Variant1, Variant2(Type) }"
                 "pub(crate) enum test { Variant }")
         :not ("enum testing { A, B }"
               "enum Foo { test, Bar }"))

  (:language "elixir" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\bdef(p)?\\s+JJJ\\s*[ ,\\\(]"
         :tests ("def test do"
                 "def test, do:"
                 "def test() do"
                 "def test(), do:"
                 "def test(foo, bar) do"
                 "def test(foo, bar), do:"
                 "defp test do"
                 "defp test(), do:"))

  (:language "elixir" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\s*JJJ\\s*=[^=\\n]+"
         :tests ("test = 1234")
         :not ("if test == 1234"))

  (:language "elixir" :type "module"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "defmodule\\s+(\\w+\\.)*JJJ\\s+"
         :tests ("defmodule test do"
                 "defmodule Foo.Bar.test do"))

  (:language "elixir" :type "module"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "defprotocol\\s+(\\w+\\.)*JJJ\\s+"
         :tests ("defprotocol test do"
                 "defprotocol Foo.Bar.test do"))

  (:language "erlang" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "^JJJ\\b\\s*\\\("
         :tests ("test() ->"
                 "test()->"
                 "test(Foo) ->"
                 "test (Foo,Bar) ->"
                 "test(Foo, Bar)->"))

  (:language "erlang" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\s*JJJ\\s*=[^:=\\n]+"
         :tests ("test = 1234")
         :not ("if test =:= 1234"
               "if test == 1234"))

  (:language "erlang" :type "module"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "^-module\\\(JJJ\\\)"
         :tests ("-module(test)."))

  (:language "scss" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "@mixin\\sJJJ\\b\\s*\\\("
         :tests ("@mixin test()"))

  (:language "scss" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "@function\\sJJJ\\b\\s*\\\("
         :tests ("@function test()"))

  (:language "scss" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "JJJ\\s*:\\s*"
         :tests ("test  :"))

  (:language "sml" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\s*(data)?type\\s+.*\\bJJJ\\b"
         :tests ("datatype test ="
                 "datatype test="
                 "datatype 'a test ="
                 "type test ="
                 "type 'a test ="
                 "type 'a test"
                 "type test")
         :not ("datatypetest ="))

  (:language "sml" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\s*val\\s+\\bJJJ\\b"
         :tests ("val test ="
                 "val test="
                 "val test : bool"))

  (:language "sml" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\s*fun\\s+\\bJJJ\\b.*\\s*="
         :tests ("fun test list ="
                 "fun test (STRING_NIL, a) ="
                 "fun test ((s1,s2): 'a queue) : 'a * 'a queue ="
                 "fun test (var : q) : int ="
                 "fun test f e xs ="))

  (:language "sml" :type "module"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\s*(structure|signature|functor)\\s+\\bJJJ\\b"
         :tests ("structure test ="
                 "structure test : MYTEST ="
                 "signature test ="
                 "functor test (T:TEST) ="
                 "functor test(T:TEST) ="))

  (:language "sql" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "(CREATE|create)\\s+(.+?\\s+)?(FUNCTION|function|PROCEDURE|procedure)\\s+JJJ\\s*\\\("
         :tests ("CREATE FUNCTION test(i INT) RETURNS INT"
                 "create or replace function test (int)"
                 "CREATE PROCEDURE test (OUT p INT)"
                 "create definer = 'test'@'localhost' procedure test()"))

  (:language "sql" :type "table"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "(CREATE|create)\\s+(.+?\\s+)?(TABLE|table)(\\s+(IF NOT EXISTS|if not exists))?\\s+JJJ\\b"
         :tests ("CREATE TABLE test ("
                 "create temporary table if not exists test"
                 "CREATE TABLE IF NOT EXISTS test ("
                 "create global temporary table test"))

  (:language "sql" :type "view"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "(CREATE|create)\\s+(.+?\\s+)?(VIEW|view)\\s+JJJ\\b"
         :tests ("CREATE VIEW test ("
                 "create sql security definer view test"
                 "CREATE OR REPLACE VIEW test AS foo"))

  (:language "sql" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "(CREATE|create)\\s+(.+?\\s+)?(TYPE|type)\\s+JJJ\\b"
         :tests ("CREATE TYPE test"
                 "CREATE OR REPLACE TYPE test AS foo ("
                 "create type test as ("))

  (:language "systemverilog" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\s*class\\s+\\bJJJ\\b"
         :tests ("virtual class test;"
                 "class test;"
                 "class test extends some_class")
         :not ("virtual class testing;"
               "class test2;"
               "class some_test"
               "class some_class extends test"))

  (:language "systemverilog" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\s*task\\s+\\bJJJ\\b"
         :tests ("task test ("
                 "task test(")
         :not ("task testing ("
               "task test2("))

  (:language "systemverilog" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\s*\\bJJJ\\b\\s*="
         :tests ("assign test ="
                 "assign test="
                 "int test ="
                 "int test=")
         :not ("assign testing ="
               "assign test2="))

  (:language "systemverilog" :type "function"
         :supports ("ag" "rg" "git-grep")
         :regex "function\\s[^\\s]+\\s*\\bJJJ\\b"
         :tests ("function Matrix test ;"
                 "function Matrix test;")
         :not ("function test blah"))

  (:language "systemverilog" :type "function"
         :supports ("ag" "rg" "git-grep")
         :regex "^\\s*[^\\s]*\\s*[^\\s]+\\s+\\bJJJ\\b"
         :tests ("some_class_name test"
                 "  another_class_name  test ;"
                 "some_class test[];"
                 "some_class #(1) test")
         :not ("test some_class_name"
               "class some_class extends test"))

  (:language "vhdl" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\s*type\\s+\\bJJJ\\b"
         :tests ("type test is"
                 "type test  is")
         :not ("type testing is"
               "type test2  is"))

  (:language "vhdl" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\s*constant\\s+\\bJJJ\\b"
         :tests ("constant test :"
                 "constant test:")
         :not ("constant testing "
               "constant test2:"))

  (:language "vhdl" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "function\\s*\"?JJJ\"?\\s*\\\("
         :tests ("function test(signal)"
                 "function test (signal)"
                 "function \"test\" (signal)")
         :not ("function testing(signal"))

  (:language "tex" :type "command"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\\\.*newcommand\\\*?\\s*\\\{\\s*(\\\\)JJJ\\s*}"
         :tests ("\\newcommand{\\test}"
                 "\\renewcommand{\\test}"
                 "\\renewcommand*{\\test}"
                 "\\newcommand*{\\test}"
                 "\\renewcommand{ \\test }")
         :not("\\test"  "test"))

  (:language "tex" :type "command"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\\\.*newcommand\\\*?\\s*(\\\\)JJJ\\j"
         :tests ("\\newcommand\\test {}"
                 "\\renewcommand\\test{}"
                 "\\newcommand \\test")
         :not("\\test"
              "test"))

  (:language "tex" :type "length"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\\\(s)etlength\\s*\\\{\\s*(\\\\)JJJ\\s*}"
         :tests ("\\setlength { \\test}"
                 "\\setlength{\\test}"
                 "\\setlength{\\test}{morecommands}" )
         :not("\\test"
              "test"))

  (:language "tex" :type "counter"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\\\newcounter\\\{\\s*JJJ\\s*}"
         :tests ("\\newcounter{test}" )
         :not("\\test"
              "test"))

  (:language "tex" :type "environment"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\\\.*newenvironment\\s*\\\{\\s*JJJ\\s*}"
         :tests ("\\newenvironment{test}"
                 "\\newenvironment {test}{morecommands}"
                 "\\lstnewenvironment{test}"
                 "\\newenvironment {test}" )
         :not("\\test"
              "test" ))

  (:language "pascal" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\bfunction\\s+JJJ\\b"
         :tests ("  function test : "))

  (:language "pascal" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\bprocedure\\s+JJJ\\b"
         :tests ("  procedure test ; "))

  (:language "fsharp" :type "variable"
         :supports ("ag" "grep" "git-grep")
         :regex "let\\s+JJJ\\b.*\\\="
         :tests ("let test = 1234"
                 "let test() = 1234"
                 "let test abc def = 1234")
         :not ("let testnot = 1234"
               "let testnot() = 1234"
               "let testnot abc def = 1234"))

  (:language "fsharp" :type "interface"
         :supports ("ag" "grep" "git-grep")
         :regex "member(\\b.+\\.|\\s+)JJJ\\b.*\\\="
         :tests ("member test = 1234"
                 "member this.test = 1234")
         :not ("member testnot = 1234"
               "member this.testnot = 1234"))

  (:language "fsharp" :type "type"
         :supports ("ag" "grep" "git-grep")
         :regex "type\\s+JJJ\\b.*\\\="
         :tests ("type test = 1234")
         :not ("type testnot = 1234"))

  (:language "kotlin" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "fun\\s*(<[^>]*>)?\\s*JJJ\\s*\\("
         :tests ("fun test()" "fun <T> test()"))

  (:language "kotlin" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "(val|var)\\s*JJJ\\b"
         :not ("val testval"
               "var testvar")
         :tests ("val test "
                 "var test"))

  (:language "kotlin" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "(class|interface)\\s*JJJ\\b"
         :tests ("class test"
                 "class test : SomeInterface"
                 "interface test"))

  (:language "zig" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "fn\\s+JJJ\\b"
         :tests ("fn test() void {"
                 "fn test(a: i32) i32 {"
                 "pub fn test(a: i32) i32 {"
                 "export fn test(a: i32) i32 {"
                 "extern \"c\" fn test(a: i32) i32 {"
                 "inline fn test(a: i32) i32 {"))

  (:language "zig" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "(var|const)\\s+JJJ\\b"
         :tests ("const test: i32 = 3;"
                 "var test: i32 = 3;"
                 "pub const test: i32 = 3;"))

  (:language "protobuf" :type "message"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "message\\s+JJJ\\s*\\\{"
         :tests ("message test{" "message test {"))

  (:language "protobuf" :type "enum"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "enum\\s+JJJ\\s*\\\{"
         :tests ("enum test{" "enum test {"))

  (:language "apex" :type "function"
         :supports ("ag" "rg")
         :regex "^\\s*(?:[\\w\\[\\]]+\\s+){1,3}JJJ\\s*\\\("
         :tests ("int test()"
                 "int test(param)"
                 "static int test()"
                 "static int test(param)"
                 "public static MyType test()"
                 "private virtual SomeType test(param)"
                 "static int test()"
                 "private foo[] test()")
         :not ("test()" "testnot()"
               "blah = new test()"
               "foo bar = test()"))

  (:language "apex" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\s*\\bJJJ\\s*=[^=\\n)]+" :tests ("int test = 1234")
         :not ("if test == 1234:" "int nottest = 44"))

  (:language "apex" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "(class|interface)\\s*JJJ\\b"
         :tests ("class test:"
                 "public class test implements Something")
         :not ("class testnot:"
               "public class testnot implements Something"))

  (:language "jai" :type "function"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\bJJJ\\s*::"
         :tests ("test ::"))
  (:language "jai" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\bJJJ\\s*(:|:\\s*=|::)"
         :tests ("test: Type" "test : Type = Val" "test :: Val"))
  (:language "jai" :type "type"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\bJJJ\\s*::"
         :tests ("test ::"))

  (:language "odin" :type "variable"
         :supports ("ag" "grep" "rg" "git-grep")
         :regex "\\s*\\bJJJ\\s*:\\s*([^=\\n]+\\s*:|:|[^=\\n]+\\s*=|=)"
         :tests ("test :: struct"
                 "test ::enum"
                 "test:: union"
                 "test: : custom_type"
                 "test :: [2]f32"
                 "test : f32 : 20"
                 "test: i32 : 10"
                 "test := 20"
                 "test : f32 = 20"
                 "test: i32 = 10"
                 "test: i32= 10"
                 "test :i32= 10"
                 "test :: proc()"
                 "test ::proc() {"
                 "test:: proc(a: i32) -> i32 {"
                 "test::proc{}"
                 "test: :proc \"contextless\" {}"))

  (:language "cobol" :type "variable"
             :supports ("ag" "grep" "rg" "git-grep")
             :regex "^(.{6}[^*/])?\\s*([frs]d|[[:digit:]]{1,2})\\s+JJJ([\\. ]|$)"
             :tests ("       01 test."
                     "000350     10 test pic x."
                     "  88 test value '10'."
                     "fd  test."
                     "       sd test.")
             :not ("      *01 test"
                   "       05 test-01"
                   "       05 testing"))

  (:language "cobol" :type "section"
             :supports ("ag" "grep" "rg" "git-grep")
             :regex "^(.{6}[^*/])?JJJ(\\s+section)?\\."
             :tests ("       test."
                     "       test section."
                     "test."
                     "test section.")
             :not ("        test."
                   "      *test section."))

  (:language "cobol" :type "submodule"
             :supports ("ag" "grep" "rg" "git-grep")
             :regex "^(.{6}[^*/])?program-id\\.\\s*[\"']?JJJ[\"']?.*\\."
             :tests ("       program-id. test."
                     "       program-id. 'test'."
                     "program-id. \"test\".")
             :not ("        test.")))
