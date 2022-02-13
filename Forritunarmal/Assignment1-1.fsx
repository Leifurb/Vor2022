// T-501-FMAL, Spring 2022, Assignment 1

(*
STUDENT NAMES HERE:
  Aðalsteinn Leifs Maríuson
  Leifur Benedikt Baldursson
*)

module Assignment1

////////////////////////////////////////////////////////////////////////
// Problem 1                                                          //
////////////////////////////////////////////////////////////////////////

// nf : int -> int
let rec nf n =
  if n < 1 then 0 else
  if n = 1 then 1 else
  nf (n - 2) + n

////////////////////////////////////////////////////////////////////////
// Problem 2                                                          //
////////////////////////////////////////////////////////////////////////

// truesAndLength : bool list -> int * int

let rec truesAndLength bs = 
  let sum a b = (fst a + fst b, snd a + snd b)
  match bs with
  | [] -> (0, 0)
  | head::tail ->
    if head then sum (1, 1) (truesAndLength tail) else sum (1, 0) (truesAndLength tail)

// majority : bool list -> bool
let rec majority bs = 
  match truesAndLength bs with 
  | (x, y) -> if (y:float) / (x:float) < 0.5 then false else true


// majority2 : ('a -> bool) -> 'a list -> bool
let majority2 p xs = 
  majority (xs |> List.map (p))

// majorityLarge : int list -> bool
let majorityLarge xs =
  majority2 (fun x -> x >= 100 ) xs


////////////////////////////////////////////////////////////////////////
// Problem 3                                                          //
////////////////////////////////////////////////////////////////////////

// isGood : ('a * 'b) list -> bool when 'a: equality
let rec isGood ps = 
  match ps with
  | [] | [_] -> true
  | x::y::tail -> 
    if fst x = fst y then false else isGood (y::tail)

// makeGoodInt : ('a * int) list -> ('a * int) list when 'a: equality
let rec makeGoodInt ps = 
  match ps with
  | [] | [_] -> ps
  | x::y::tail -> 
    if fst x = fst y then makeGoodInt ((fst x, snd x + snd y) :: tail) else x :: makeGoodInt (y::tail)

// makeGoodWith : ('b -> 'b -> 'b) -> ('a * 'b) list -> ('a * 'b) list
//                                                     when 'a: equality
let rec makeGoodWith f ps =
  match ps with
  | [] | [_] -> ps
  | x::y::tail -> 
    if fst x = fst y then makeGoodWith f ((fst x, f (snd x) (snd y)) :: tail) else x :: makeGoodWith f (y::tail)


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
  Since lists in F# are Singly Linked List
  the time complexity of inserting a value at
  the end of the list is O(N) and we have to loop 
  through the list once, that makes the total time
  complexity quadratic O(N^2)
*)


// shuffle2 : 'a list -> 'a list
let shuffle2 xs =
  // shuffleAcc : 'a list -> 'a list -> 'a list
  let rec shuffleAcc acc xs =
    match xs with
    | [] -> []@acc
    | [x] -> [x]@acc
    | x::y::xs -> x :: shuffleAcc (y::acc) xs
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
let rec foo2 xs =
  let sum num1 num2 =
    match num1 with
    | None -> None
    | Some val1 ->
      match num2 with
      | None -> None
      | Some val2 -> Some(val1 + val2)

  match xs with
  | [] -> Some 0
  | head::tail -> if head < 0 then None else sum (Some head) (foo2 tail)


// foo2Default : int -> int list -> int
let foo2Default d xs =
  let foo = foo2 xs
  if foo = None then d else foo.Value



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


let testTree =
  Branch (2,
    Branch (3,
      Branch (5,
        Leaf,
        Leaf),
      Leaf),
    Branch (7,
      Mul (11, Branch (13,
        Mul (17, Mul (19, Branch (23,
          Leaf,
          Leaf))),
        Branch (29, Leaf, Leaf))),
      Branch (31,
        Leaf,
        Branch (37,
          Leaf,
          Leaf))))

// getValAt : pos -> mtree -> int
let rec getValAt p t = 
  match p, t with
  | _, Mul (mul, tree) -> (*) mul (getValAt p tree)
  | S, Branch (value,_,_)-> value
  | L p, Leaf -> failwith "Cannot continue"
  | L p, Branch (_,left,_) -> getValAt p left
  | R p, Leaf -> failwith "Cannot continue"
  | R p, Branch (_,_,right) -> getValAt p right
  | _, _ -> failwith "Cannot continue"


// toTree : mtree -> int tree
let toTree t = 
  let rec generateTree t m = 
    match t, m with
    | Leaf, _ -> Lf
    | Mul (mul, tree), _ -> generateTree tree (mul*m)
    | Branch (value, left, right), _ -> Br (value * m, generateTree left m, generateTree right m)
  generateTree t 1

