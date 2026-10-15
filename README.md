# Lexical Analyzer using Flex

A simple **C/C++ Lexical Analyzer** built using Flex (Fast Lexical Analyzer Generator) and C. The program reads source code from an input file, identifies different types of tokens, and writes the categorized tokens along with their line numbers to an output file.

## Features

- **Keyword Detection:** Identifies keywords such as `int`, `float`, `if`, `else`, `return`, and `while`.
- **Identifier Recognition:** Detects variable names and other identifiers.
- **Function Detection:** Identifies function names and extracts their parameters.
- **Number Recognition:** Recognizes integer and floating-point literals, including hexadecimal integers and scientific notation.
- **Operator Detection:** Classifies arithmetic, relational, logical, assignment, and stream operators.
- **Symbol Recognition:** Detects punctuation marks, brackets, braces, and other symbols.
- **String and Character Recognition:** Identifies string and character literals.
- **Comment Detection:** Recognizes single-line and multiline comments.
- **Library Detection:** Extracts library names from `#include` directives.
- **STL Recognition:** Detects common C++ Standard Template Library types, including `vector`, `map`, `stack`, `queue`, and `pair`.
- **Line Number Tracking:** Reports the source line associated with each recognized token.
- **Invalid Token Reporting:** Reports unrecognized characters as errors.

## Technologies Used

- **C** — Core implementation
- **Flex** — Lexical analysis and token recognition
- **GCC** — C compiler

## Project Structure

```text
Lexical Analyzer/
├── lexer.l          # Flex source file containing lexical rules
├── lex.yy.c         # Generated C source code
├── lexer.exe        # Compiled executable
├── input.txt        # Input source code
├── output.txt       # Generated token report
└── commands.txt     # Build and execution commands
```



## Execution


Go to Windows terminal and run the commands for execution

### 1. Generate the C source file

```bash
flex lexer.l
```

This generates `lex.yy.c` from the Flex specification.

### 2. Compile the generated source

```bash
gcc lex.yy.c -o lexer
```

### 3. Run the analyzer

```cmd
lexer
```

The program reads `input.txt` from the current working directory and writes the results to `output.txt`.

**Note:** Keep `input.txt` in the directory from which you execute the program, since the filenames are hardcoded in the source.

## Example

### Input (`input.txt`)

```cpp
#include <iostream>
using namespace std;

int main() {
    int x = 10;
    float y = 3.14;

    if (x < 100) {
        cout << x;
    }

    return 0;
}
```

### Output (`output.txt`)

```text
Library File: iostream (line 1)
Keyword: using (line 2)
Keyword: namespace (line 2)
Identifier: std (line 2)
Symbol: ; (line 2)
Keyword: int (line 4)
Function: main (line 4)
Symbol: ( (line 4)
Symbol: ) (line 4)
Symbol: { (line 4)
Keyword: int (line 5)
Identifier: x (line 5)
Assignment Operator: = (line 5)
Number: 10 (line 5)
Symbol: ; (line 5)
Keyword: float (line 6)
Identifier: y (line 6)
Assignment Operator: = (line 6)
Number: 3.14 (line 6)
Symbol: ; (line 6)
Keyword: if (line 8)
Symbol: ( (line 8)
Identifier: x (line 8)
Relational Operator: < (line 8)
Number: 100 (line 8)
Symbol: ) (line 8)
Symbol: { (line 8)
Identifier: cout (line 9)
Stream Operator: << (line 9)
Identifier: x (line 9)
Symbol: ; (line 9)
Symbol: } (line 10)
Keyword: return (line 12)
Number: 0 (line 12)
Symbol: ; (line 12)
Symbol: } (line 13)
```

*The example output illustrates the expected token classifications; the actual output depends on the input source code and the lexical rules implemented in `lexer.l`.*

## How It Works

1. **Input:** The analyzer reads source code from `input.txt`.
2. **Pattern Matching:** Flex matches input text against regular-expression rules defined in `lexer.l`.
3. **Token Classification:** Recognized text is categorized into keywords, identifiers, operators, literals, symbols, functions, and other supported token types.
4. **Line Tracking:** The analyzer maintains line numbers while scanning the input.
5. **Output:** The categorized tokens are written to `output.txt`.

## Limitations

- The analyzer implements a subset of C/C++ lexical rules rather than a complete language specification.
- Its token recognition depends on the patterns and rule ordering defined in `lexer.l`.
- It does not perform syntax analysis, semantic analysis, or code execution.
- The input and output filenames are currently hardcoded as `input.txt` and `output.txt`.
- Complex language constructs and certain literal or template forms may not be handled correctly.

## Learning Objectives

This project demonstrates practical concepts in compiler design, including:

- Lexical analysis and tokenization
- Regular expressions and pattern matching
- Flex specifications and generated C code
- Token classification and line tracking
- Basic compiler front-end concepts
