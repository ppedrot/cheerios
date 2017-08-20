type iostream = 
    | Empty
    | WriteByte of char 
    | Seq of (unit -> iostream) * (unit -> iostream)

type serializer = iostream
type 'a deserializer = Bit_vector.reader -> 'a
type wire = bytes

exception Serialization_error of string

(* serializer *)

let empty : serializer =
  Empty

let putByte (b : char) : serializer =
  WriteByte b

let append (s1 : unit -> serializer) (s2 : unit -> serializer) : serializer =
  Seq (s1, s2)

let putInt (i : int32) : serializer =
  let aux n = putByte (Char.chr ((Int32.to_int i lsr n) land 0xff))
  in append (fun () -> (aux 24))
            (fun () -> (append (fun () -> (aux 16))
                               (fun () -> (append (fun () -> (aux 8))
                                                  (fun () -> (aux 0))))))

let putFloat (f : float) =
  putInt (Int32.bits_of_float f)

let rec putChars (s : char list) : serializer =
  match s with
  | [] -> empty
  | c :: s -> append (fun () -> putByte c) (fun () -> putChars s)

(* deserializer *)
  
let getByte r =
  Bit_vector.pop r

let bind (d : 'a deserializer) (f : 'a -> 'b deserializer) : 'b deserializer =
  fun r -> let v = d r in (f v) r

let ret (v : 'a) : 'a deserializer =
  fun r -> v

let getInt : int32 deserializer =
  let aux b n = Char.code b lsl n in
  bind getByte (fun b1 ->
         bind getByte (fun b2 ->
                bind getByte (fun b3 ->
                       bind getByte (fun b4 ->
                              let i = (aux b1 24) lor
                                        (aux b2 16) lor
                                          (aux b3 8) lor
                                            (aux b4 0) in
                                       ret (Int32.of_int i)))))

let fail : 'a deserializer =
  fun r -> raise (Serialization_error "deserialization failed")
  
type ('s, 'a) fold_state =
  | Done of 'a
  | More of 's
  | Error

let map (f : 'a -> 'b) (d : 'a deserializer) : 'b deserializer =
  bind d (fun a -> ret (f a))

let rec fold (f : char -> 's -> ('s, 'a) fold_state)
                          (s : 's) : 'a deserializer =
  fun r -> let b = (Bit_vector.pop r)
           in match f b s with
              | Done a -> a
              | More s -> fold f s r
              | Error -> raise (Serialization_error "fold deserialization error")

let getFloat =
  map Int32.float_of_bits getInt

let getChars (n : int) : (char list) deserializer =
  if n = 0
  then ret []
  else let step c (n, acc) =
         let acc' = c :: acc
         in if n = 0
            then Done (List.rev acc')
            else More (n - 1, acc')
       in fold step (n - 1, [])    
  
(* wire *)

let rec iostream_interp (s : serializer) (w : Bit_vector.writer) =
  match s with
  | Empty -> ()
  | WriteByte b -> Bit_vector.pushBack w b
  | Seq (t1, t2) -> (iostream_interp (t1 ()) w;
                   iostream_interp (t2 ()) w)
                    
let wire_wrap (s : serializer) : wire =
  let w = Bit_vector.makeWriter () in
  (iostream_interp s w;
   Bit_vector.writerToBytes w)

let size : wire -> int =
  Bytes.length

let deserialize_top (d : 'a deserializer) (w : wire) : 'a option =
  try Some (d (Bit_vector.bytesToReader w))
  with Serialization_error _ -> None

let dump (w : wire) : unit =
  let rec loop i =
    if i < Bytes.length w
    then (Printf.printf "%x %!" (Char.code (Bytes.get w i));
          loop (i + 1)) in
  loop 0; Printf.printf "\n%!"
