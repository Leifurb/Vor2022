// T-501-FMAL, Spring 2022, Assignment 4

(*
STUDENT NAMES HERE: ...


*)

//module Assignment4

// (You can ignore this line, it stops F# from printing some messages
// about references in some cases.)
#nowarn "3370";;

////////////////////////////////////////////////////////////////////////
// Problem 1                                                          //
////////////////////////////////////////////////////////////////////////

(* ANSWER 1 HERE:
     (i)   (\f. (\x. f (f x))) (\y. y) z
           ...

    (ii)   (\g. g z) (\z. z) z
           ...

   (iii)   (\h. h (\k. k z)) (\y. y y) z
           ...
*)



////////////////////////////////////////////////////////////////////////
// Problem 2                                                          //
////////////////////////////////////////////////////////////////////////

(* ANSWER 2 HERE:
    (i) t1 = ...
        t2 = ...
        t3 = ...
        t4 = ...
        t5 = ...

   (ii) t6 = ...
*)



////////////////////////////////////////////////////////////////////////
// Problem 3                                                          //
////////////////////////////////////////////////////////////////////////

// The standard node-labelled tree datatype
type 'a tree = Lf | Br of 'a * 'a tree * 'a tree

// A mutable node-labelled tree datatype
type 'a refTree = RLf | RBr of 'a * 'a refTree ref * 'a refTree ref

// Convert a standard tree into a mutable tree
// makeRefTree : 'a tree -> 'a refTree ref
let rec makeRefTree t =
  match t with
  | Lf -> ref RLf
  | Br (x, l, r) -> ref (RBr (x, makeRefTree l, makeRefTree r))

// Convert a mutable tree into a standard tree
// freeze : 'a refTree ref -> 'a tree
let rec freeze tref =
  match !tref with
  | RLf -> Lf
  | RBr (x, lref, rref) -> Br (x, freeze lref, freeze rref)

// Swap the contents of two references
// swap : 'a ref -> 'a ref -> unit
let swap r1 r2 =
  let x = !r1
  r1 := !r2;
  r2 := x

// Swap the left and right branches of each node, recursively
// mirror : 'a refTree ref -> unit
let rec mirror tref =
  match !tref with
  | RBr (x, lref, rref) ->
      match !lref with
        | RLf -> ()
        | RBr (y, llref, lrref) ->
            failwith "Not implemented"

  | RLf -> ()

// Do a single rotation (if possible)
// rotate : 'a refTree ref -> unit
let rotate tref =
    match !tref with
    | RLf -> ()
    | RBr (x, lref, rref) ->
        match !lref with
        | RLf -> ()
        | RBr (y, llref, lrref) ->
            failwith "Not implemented"



////////////////////////////////////////////////////////////////////////
// Problem 4                                                          //
////////////////////////////////////////////////////////////////////////

type expr =
    | Num of int
    | Var of string
    | Plus of expr * expr
type stmt =
    | Assign of string * expr
    | Block of string * stmt list // Block (x, stmts) is a block that
                                  // declares the variable x
    | If of expr * stmt * stmt
    | While of expr * stmt
    | Print of expr

type naivestore = Map<string,int>
let emptystore : Map<string,int> = Map.empty

// (getSto store x) gets the value of the variable x from the store.
// If x is not in the store (for example, because it has not been
// declared yet), then getSto returns 0.
let getSto (store : naivestore) x = if store.ContainsKey x then store.Item x else 0

// (setSto store (k, v)) returns a new store, in which the value of the
// variable k is set to v
let setSto (store : naivestore) (k, v) = store.Add(k, v)

let rec eval e (store : naivestore) : int =
    match e with
    | Num i -> i
    | Var x -> getSto store x
    | Plus(e1, e2) -> eval e1 store + eval e2 store

let rec exec stmt (store : naivestore) : naivestore =
    match stmt with
    | Assign (x, e) -> setSto store (x, eval e store)
    | If (e1, stmt1, stmt2) ->
        if eval e1 store <> 0 then exec stmt1 store else exec stmt2 store
    | Block (x, stmts) ->
        let rec loop ss sto =
            match ss with
            | []     -> sto
            | s1::sr -> loop sr (exec s1 sto)
        loop stmts store
    | While (e, stmt) ->
        let rec loop sto =
            if eval e sto = 0 then sto
                              else loop (exec stmt sto)
        loop store
    | Print e -> printf "%d\n" (eval e store); store

let run stmt = exec stmt emptystore |> ignore

// The example program, can be executed with (run test)
let test =
  Block("x",
    [ Assign ("x", Num 1)
    ; Print (Var "x")
    ; Block ("x",
      [ Print (Var "x")
      ; Assign ("x", Num 2)
      ; Print (Var "x")
      ])
    ; Print (Var "x")
    ])
run test


////////////////////////////////////////////////////////////////////////
// Problem 5                                                          //
////////////////////////////////////////////////////////////////////////

(* ANSWER 5 HERE:
    (i) h(1) prints: ...
   (ii) h(0) prints: ...
*)

