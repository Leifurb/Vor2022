// T-501-FMAL Programming languages, Lecture 5
// Spring 2021


// Expressions, part 1:
// (based on code by Peter Sestoft)

// Variable-free expressions, interpretation,
// a stack machine,
// compilation of expressions to stack machine code


module Expressions1


// * Expressions

// 17,  42, 0042, 1 + 1, 2 * 3, 2 * 3 + 1, 2 * x + 1

// 2 * (3 - 4)

// expressions are strings in concrete syntax

// but really we want to think of them as ASTs (abstract syntax)

// as a datatype (of abstract syntax trees, ASTs)

type expr = 
  | Num of int
  | Op of string * expr * expr

(*
Making this definition, you get functions

Num : int -> expr
Op : string * expr * expr -> expr
*)

let e1 = Num 17                       // 17

let e2 = Op ("-", Num 3, Num 4)       // 3 - 4

let e3 = Op ("+", Op ("*", Num 7, Num 9), Num 10)
                                      // (7 * 9) + 10

(*
We work with expressions (expr) as an object language
and F# as a meta-language.
*)

(*
The expressions as we handle them here are abstract syntax 
(abstract syntax trees, ASTs).
A programmer works with concrete syntax.

Expressions in concrete syntax are (a subclass of all) strings.

Parsing: going from concrete syntax to abstract.

Prettyprinting: going from abstract syntract to concrete.

*)


// * Prettyprinting an expression

let rec prettyprint (e : expr) : string =
    match e with
    | Num i          -> string i
    | Op (s, e1, e2) ->
          "(" + prettyprint e1 + " " + s + " " + prettyprint e2 + ")"



// * Interpreting an expression by evaluation

// (interpreting means - execute a program "directly"
// not by first translating to a more low-level language)

// by recursion


let rec eval (e : expr) : int =
    match e with
    | Num i -> i
    | Op ("+", e1, e2) -> eval e1 + eval e2
    | Op ("*", e1, e2) -> eval e1 * eval e2
    | Op ("-", e1, e2) -> eval e1 - eval e2
    | Op _             -> failwith "unknown primitive"

let e1v = eval e1
let e2v = eval e2
let e3v = eval e3


// Interpreting with a different meaning "-"

// We can choose to give our operators different meanings
// this is fine.
// Perhaps you want to remain compositional,
// ie meanings of bigger expressions
// should be determined by their parts - only reasonable.

let rec evalm (e : expr) : int =
    match e with
    | Num i -> i
    | Op ("+", e1, e2) -> evalm e1 + evalm e2
    | Op ("*", e1, e2) -> evalm e1 * evalm e2
    | Op ("-", e1, e2) -> 
         let res = evalm e1 - evalm e2
         if res < 0 then 0 else res 
    | Op _             -> failwith "unknown primitive"


let e4v = evalm (Op ("-", Num 10, Num 27))


// * A stack machine

// 2 * (3 - 4)  - expression

// 2 3 4 - *    - stack machine code

(*

[]

[2]

[3;2]

[4;3;2]

[-1;2]

[-2]

*)



// * Instructions and code

type rinstr =
  | RNum of int
  | RAdd 
  | RSub
  | RMul
  | RPop
  | RDup
  | RSwap

type code = rinstr list




// * Stack states

type stack = int list

// * Interpreting (running) stack machine code

let rec reval (inss : code) (stk : stack) : int =
    match inss, stk with 
    | ([], i :: _) -> i
    | ([], [])     -> failwith "reval: no result on stack!"
    | (RNum i  :: inss,             stk) -> reval inss (i :: stk)
    | (RAdd    :: inss, i2 :: i1 :: stk) -> reval inss ((i1+i2) :: stk)
    | (RSub    :: inss, i2 :: i1 :: stk) -> reval inss ((i1-i2) :: stk)
    | (RMul    :: inss, i2 :: i1 :: stk) -> reval inss ((i1*i2) :: stk)
    | (RPop    :: inss,        i :: stk) -> reval inss stk
    | (RDup    :: inss,        i :: stk) -> reval inss ( i ::  i :: stk)
    | (RSwap   :: inss, i2 :: i1 :: stk) -> reval inss (i1 :: i2 :: stk)
    | _ -> failwith "reval: too few operands on stack"

let rpn1 = reval [RNum 10; RNum 17; RDup; RMul; RAdd] []



// * Compiling an expression into stack machine code

// rcomp : expr -> code 

let rec rcomp (e : expr) : code =
    match e with
    | Num i            -> [RNum i]
    | Op ("+", e1, e2) -> rcomp e1 @ rcomp e2 @ [RAdd]
    | Op ("*", e1, e2) -> rcomp e1 @ rcomp e2 @ [RMul]
    | Op ("-", e1, e2) -> rcomp e1 @ rcomp e2 @ [RSub]
    | Op _             -> failwith "unknown primitive"
            

// * Correctness of compilation: eval e = reval (rcomp e) [] 
