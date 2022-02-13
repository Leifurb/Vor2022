

let rec take n xs =
    match n, xs with 
    | 0, xs      -> []
    | n, []      -> []
    | n, x :: xs -> x :: take (n - 1) xs

let rec drop n xs =
    match n, xs with
    | 0, xs      -> xs
    | n, []      -> []
    | n, x :: xs -> drop (n - 1) xs


drop 10 [5];

take 10 [5];