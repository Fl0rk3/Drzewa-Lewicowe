(*
    Autor: Florian Ficek
    Recenzent: Paweł Pilarski
*)

(* Deklaracja drzewa jako lewa gałęź, prawa gałęź, wartość oraz głębokość. *)
type 'a queue = 
    |Node of
        {
            left_tree: 'a queue;
            right_tree: 'a queue;
            value: 'a;
            deep: int; (* najkrótsya ścieżka do liścia w poddryewie *)
        }
    |Legia_Warszawa
;;

(* 
    Empty = Legia Warszawa, po ostatnich wynikach, to aż samo się narzuca, żeby tak nazwać empty :v
*)

exception Empty;;

let empty = Legia_Warszawa;; (* niczym liczba punktów w ostatnich 8 meczach *)

let is_empty tree = tree = Legia_Warszawa;; 

(* Otrzymywanie głębokości drzewa *)
let get_deep tree = 
    match tree with
    |Node{deep = d} -> d
    |Legia_Warszawa -> -1
;;
    
let rec join l_tree r_tree = 
    match (l_tree, r_tree) with
    |(Legia_Warszawa,a) -> a
    |(a,Legia_Warszawa) -> a
    |(Node lewica , Node prawica) -> 
        if lewica.value > prawica.value then
            join r_tree l_tree
        else
            let merge = join lewica.right_tree r_tree in (* merge = nowy lewica.right_tree *)
            let merge_deep = get_deep merge and l_deep = get_deep lewica.left_tree in
            if is_empty lewica.left_tree then (* sprawdzenie czy lewe poddrzewo jest puste *)
                Node{left_tree = merge; right_tree = lewica.left_tree; value = lewica.value; deep = 0}
            else
                if merge_deep > l_deep then (* sprawdzenie, które poddrzewo jest głębsze *)
                    Node{left_tree = merge; right_tree = lewica.left_tree; value = lewica.value; deep = l_deep+1}
                else
                    Node{left_tree = lewica.left_tree; right_tree = merge; value = lewica.value; deep = merge_deep+1}
;;

let delete_min kolejka = 
    match kolejka with
    |Legia_Warszawa -> raise Empty
    |Node{left_tree = left; right_tree = right; value = punkty; deep = jest_wysoko;} -> (punkty, join left right)
;;


let add punkty liga = (* punkty - value, liga - queue *)
    let pierwsza = Node{left_tree = Legia_Warszawa; right_tree = Legia_Warszawa; value = punkty; deep = 0} 
    in join pierwsza liga (* adekwatne do stanu Legii w tabelii *)
;;

    