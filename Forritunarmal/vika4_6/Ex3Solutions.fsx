// T-501-FMAL Programming languages, Practice class 3
// Spring 2022
// Solutions

module  Ex3Solutions


// Problem 1

type 'a tree =
    | Lf
    | Br of 'a * 'a tree * 'a tree

// (i)

// rootlabel : 'a tree -> 'a

let rootLabel t =
    match t with
(*    
    | Lf           ->                         // case missing 
*)  
    | Br (n, _, _) -> n

// (ii)

// rootlabelOpt : 'a tree -> 'a option

let rootLabelOpt t =
    match t with
    | Lf           -> None 
    | Br (n, _, _) -> Some n

// (iii)

exception LfExc

// rootlabelExc : 'a tree -> 'a

let rootLabelExc t = 
    match t with
    | Lf           -> raise LfExc 
    | Br (n, _, _) -> n    

// (iv)

// handleLfExc : 'a tree -> ('a tree -> b) -> b -> b

let handleLfExc t f b =
    try f t with LfExc -> b 


// Problem 2

// truncate : int -> 'a tree -> 'a tree

let rec truncate d t = 
    match d, t with
    | 0, _     -> Lf
    | _, Lf    -> Lf
    | d, Br (x, l, r) -> let d = d - 1
                         Br (x, truncate d l, truncate d r)


// Problem 3 (i)

// sumTree : int tree -> tree

let rec sumTree t =
    match t with
    | Lf -> 0
    | Br (a, l, r) ->
        a + sumTree l + sumTree r

// (ii)

// subtreeSums : int tree -> int tree

(*
This is inefficient, recomputes the sums all the time.

let rec subtreeSums t =
    match t with
    | Lf           -> Lf
    | Br (a, l, r) as t ->
         Br (sumtree t, subtreeSums l, subtreeSums r)
*)


let rootLabelInt t = handleLfExc t rootLabelExc 0

let rec subtreeSums t =
    match t with
    | Lf          -> Lf
    | Br (a, l, r) ->
         let sl = subtreeSums l
         let sr = subtreeSums r
         Br (a + rootLabelInt sl + rootLabelInt sr, sl, sr)
         
            
// (iii)

let pathSums t =
    let rec pathSums' t acc =  
        match t with
        | Lf           -> Lf
        | Br (a, l, r) ->
             let acc' = acc + a
             Br (acc', pathSums' l acc', pathSums' r acc')
    pathSums' t 0  


// Problem 4

type pos =
    | S                  // the root ("stop") position
    | L of pos           // a position in the left subtree
    | R of pos           // a position in the right subtree

// labelAt : pos -> 'a tree -> 'a

let rec labelAt p t =
    match p, t with
    | S,   Br (a, _,  _ ) -> a
    | L p, Br (_, tl, _ ) -> labelAt p tl
    | R p, Br (_, _,  tr) -> labelAt p tr


// Problem 5

type 'a netree =
    | N of 'a * ('a netree) option * ('a netree) option


// tree2netree : 'a tree -> ('a netree) option

let rec tree2netree t =
    match t with
    | Lf           -> None
    | Br (x, l, r) -> Some (N (x, tree2netree l, tree2netree r))


// netree2tree: 'a netree -> 'a tree

let rec netree2tree t =
    match t with
    | N (x, None, None)     -> Br (x, Lf, Lf)
    | N (x, Some l, None)   -> Br (x, netree2tree l, Lf)
    | N (x, None, Some r)   -> Br (x, Lf, netree2tree r)
    | N (x, Some l, Some r) -> Br (x, netree2tree l, netree2tree r)

