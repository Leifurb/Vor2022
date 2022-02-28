// T-501-FMAL Programming languages, Practice class 2
// Spring 2022
// Solutions

module  Ex2Solutions


// Problem 1 (i)


// countOcc by direct recursion

(*
let rec countOcc y xs =
    match xs with
    | []    -> 0
    | x::xs -> if y = x then 1 + countOcc y xs else countOcc y xs
*)

(*
let countOcc y xs = List.foldBack (fun x n -> if y = x then 1 + n else n) xs 0
*)

// countOcc with an accumulator

(*
let countOcc y xs =
    let rec countOcc' xs acc =
        match xs with 
        | []    -> acc
        | x::xs -> if y = x then countOcc' xs (acc + 1) else countOcc' xs acc
    countOcc' xs 0      
*)

(*
let countOcc y xs = List.fold (fun acc x -> if y = x then acc + 1 else acc) 0 xs
*)


// using List.filter and List.length

(*
let countOcc y xs = List.length (List.filter ((=) y) xs)
*)


// the same as a "pipe"

(*
let countOcc y xs = xs |> List.filter ((=) y) |> List.length
*)

// or differently as a pipe

(*
let countOcc y xs = xs |> (List.filter ((=) y) >> List.length)
*)



// (ii)

// occurs using countOcc

let occurs y xs = countOcc y xs > 0


// using List.filter

(*
let occurs y xs = not (List.isEmpty (List.filter ((=) y) xs))
*)

// by direct recursion

(*
let rec occurs y xs =
    match xs with
    | []    -> false
    | x::xs -> y = x || occurs y xs
*)

(*
let occurs y xs = List.foldBack (fun x b -> y = x || b) xs false
*)

// using List.exists

(*
let occurs y xs = List.exists ((=) y) xs
*)

// using an accumulator
// (this definition is quite unnatural
// but corresponds to what the def with List.fold below does)

(*
let occurs y xs =
    let rec occurs' xs acc =
        match xs with
        | []    -> acc
        | x::xs -> occurs' xs (acc || y = x)
    occurs' xs false    
*)

(*
let occurs y xs = List.fold (fun acc x -> acc || y = x) false xs
*)

// occurs written with the help of countOcc always traverses the whole list,
// be countOcc coded directly by recursion or using List.fold,
// since countOcc must necessarily traverse the whole list to
// compute the count.

// occurs written by directly by recursion or using List.exists only
// traverses the list up to the position where y is found.

// [Annoyingly though, if the direct recursive definition of
// occurs is reformulated in terms of List.foldBack, then the
// whole list is traversed. This is because function application
// is strict in F#, so evaluation of (fun x b -> y = x || b) x' b'
// requires evaluation of b' even when y = x' is true. 
// In a nonstrict language like Haskell, the definition of occurs with
// foldBack (called foldr in Haskell) only traverses the list up to
// the position where y is found.]

// occurs coded with List.fold traverses the whole list
// since the only base case for fold is []. 


// Problem 2

// sorted by direct recursion

let rec sorted xs =
    match xs with
    | [] | [_]         -> true
    | x::(x'::_ as xs) -> x <= x' && sorted xs

// using pairs and List.foldBack

let rec pairs xs =
    match xs with
    | [] | [_]         -> []
    | x::(x'::_ as xs) -> (x, x') :: pairs xs

(*
let sorted xs = List.foldBack (fun (x, x') b -> x <= x' && b) (pairs xs) true
*)

// using pairs and List.forall

(*
let sorted xs = List.forall (fun (x, x') -> x <= x') (pairs xs)
*)

// Problem 3 (i)

let rec removeFirst y xs =
    match xs with
    | []  -> []
    | x::xs -> if y = x then xs else x :: removeFirst y xs

(*
removeFirst cannot be written as a List.fold, why?
*)

// (ii)

let rec remove y xs =
    match xs with
    | []  -> []
    | x::xs -> if y = x then remove y xs else x :: remove y xs

(*
let remove y xs =
    List.foldBack (fun x zs -> if y = x then zs else x :: zs) xs []
*)

(*
let remove y xs = List.filter (fun x -> y <> x) xs
*)

// (iii)

let rec nub xs =
    match xs with
    | []  -> []
    | x::xs -> x :: nub (remove x xs)

(*
nub cannot be written as a List.fold, why?
*)


// Problem 4 (i)


let rec suffixes xs =
    xs :: match xs with
        | []    -> []
        | _::xs -> suffixes xs

(*
// This function does exactly the same.

let rec suffixes xs =
    match xs with
    | []     -> [xs]
    | _::xs' -> xs :: suffixes xs'
*)

(*
// This function lists the suffixes in the reverse order.

let suffixes xs =
    let rec suffixes' xs acc =
        match xs with
            | []    -> acc
            | _::xs -> suffixes' xs (xs :: acc) 
    in suffixes' xs [xs]
*)
      

// (ii)

let rec prefixes xs =
    [] :: match xs with
          | []    -> []
          | x::xs -> List.map (fun ys -> x :: ys) (prefixes xs)


(*
// This function does exactly the same.

let rec prefixes xs =
    match xs with
        | []    -> [[]]
        | x::xs -> [] :: List.map (fun ys -> x :: ys) (prefixes xs)
*)

(*
// This is the same, written with List.foldBack.

let prefixes xs =
    List.foldBack (fun x yss -> [] :: List.map (fun ys -> x :: ys) yss) xs [[]]
*)



// (iii)

(*
let rec sublists xs =
    match xs with
    | [] -> [[]]
    | x::xs -> let yss = sublists xs
               List.map (fun ys -> x :: ys) yss @ yss
*)

(*
// This is the same, written with List.foldBack.

let sublists xs =
    List.foldBack (fun x yss -> List.map (fun ys -> x :: ys) yss @ yss) xs [[]]

*)

(*
let rec sublists xs =
    match xs with
    | [] -> [[]]
    | x::xs -> List.collect (fun ys -> [x :: ys; ys]) (sublists xs)
*)
