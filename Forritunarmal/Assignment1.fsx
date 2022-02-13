// T-501-FMAL, Spring 2022, Assignment 1

(*
STUDENT NAMES HERE:
  ...
  ...
*)

module Assignment1



////////////////////////////////////////////////////////////////////////
// Problem 1                                                          //
////////////////////////////////////////////////////////////////////////

// nf : int -> int
let rec nf n = failwith "Not implemented"



////////////////////////////////////////////////////////////////////////
// Problem 2                                                          //
////////////////////////////////////////////////////////////////////////

// truesAndLength : bool list -> int * int
let rec truesAndLength bs = failwith "Not implemented"

// majority : bool list -> bool
let rec majority bs = failwith "Not implemented"

// majority2 : ('a -> bool) -> 'a list -> bool
let majority2 p xs = failwith "Not implemented"

// majorityLarge : int list -> bool
let majorityLarge xs = failwith "Not implemented"



////////////////////////////////////////////////////////////////////////
// Problem 3                                                          //
////////////////////////////////////////////////////////////////////////

// isGood : ('a * 'b) list -> bool when 'a: equality
let rec isGood ps = failwith "Not implemented"

// makeGoodInt : ('a * int) list -> ('a * int) list when 'a: equality
let rec makeGoodInt ps = failwith "Not implemented"

// makeGoodWith : ('b -> 'b -> 'b) -> ('a * 'b) list -> ('a * 'b) list
//                                                     when 'a: equality
let rec makeGoodWith f ps = failwith "Not implemented"



////////////////////////////////////////////////////////////////////////
// Problem 4                                                          //
////////////////////////////////////////////////////////////////////////

// shuffle : 'a list -> 'a list
let rec shuffle xs =
  match xs with
  | [] -> []
  | [x] -> [x]
  | x::y::xs -> x :: (shuffle xs @ [y])

(*
ANSWER 4(i) HERE:
  ...
*)


// shuffle2 : 'a list -> 'a list
let shuffle2 xs =
  // shuffleAcc : 'a list -> 'a list -> 'a list
  let rec shuffleAcc acc xs = failwith "Not implemented"
  shuffleAcc [] xs



////////////////////////////////////////////////////////////////////////
// Problem 5                                                          //
////////////////////////////////////////////////////////////////////////

exception FooException

// foo : int list -> int
let rec foo xs =
  match xs with
  | [] -> 0
  | x::xs -> if x < 0 then raise FooException else x + foo xs

// fooDefault : int -> int list -> int
let fooDefault d xs = try foo xs with FooException -> d


// foo2 : int list -> int option
let rec foo2 xs = failwith "Not implemented"

let rec tryFindMatch list =
    

// result1 is Some 100 and its type is int option.
let result1 = tryFindMatch [ 200; 100; 50; 25 ]

// foo2Default : int -> int list -> int
let foo2Default d xs = failwith "Not implemented"



////////////////////////////////////////////////////////////////////////
// Problem 6                                                          //
////////////////////////////////////////////////////////////////////////

type mtree =
  | Leaf                            // leaf
  | Branch of int * mtree * mtree   // branch (value, left, right)
  | Mul of int * mtree              // multiply values below by given int

type 'a tree =
  | Lf                              // leaf
  | Br of 'a * 'a tree * 'a tree    // branch (value, left, right)

type pos =
  | S                               // the root ("stop") position
  | L of pos                        // a position in the left subtree
  | R of pos                        // a position in the right subtree

// getValAt : pos -> mtree -> int
let rec getValAt p t = failwith "Not implemented"

// toTree : mtree -> int tree
let toTree t = failwith "Not implemented"

