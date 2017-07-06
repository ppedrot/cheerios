open Positive_extracted

let rec print_positive p =
  match p with
  | XI p -> Printf.printf "XI "; print_positive p
  | XO p -> Printf.printf "XO "; print_positive p
  | XH -> Printf.printf "XH"
;;
  
let make_positive n =
  let rec aux n flag k =
    if n = 0
    then k XH
    else aux (n - 1) (not flag) (if flag
                                 then fun p -> XI (k p)
                                 else fun p -> XO (k p)) in
  aux n true (fun p -> p)
;;

let rec serialize_positive_two p =
  match p with
  | XI (XI p) ->
     Serializer_primitives.append (byte_Serializer.serialize '\000')
                                  (serialize_positive_two p)
  | XI (XO p) ->
     Serializer_primitives.append (byte_Serializer.serialize '\001')
                                  (serialize_positive_two p)
  | XO (XI p) ->
     Serializer_primitives.append (byte_Serializer.serialize '\002')
                                  (serialize_positive_two p)
  | XO (XO p) ->
     Serializer_primitives.append (byte_Serializer.serialize '\003')
                                  (serialize_positive_two p)
  | XI p ->
     Serializer_primitives.append (byte_Serializer.serialize '\004')
                                  (serialize_positive_two p)
  | XO p ->
     Serializer_primitives.append (byte_Serializer.serialize '\005')
                                  (serialize_positive_two p)
  | XH -> byte_Serializer.serialize '\006'
;;

(* unverified and doesn't correspond to any deserializer *)
let rec serialize_positive_three p =
  match p with
  | XI (XI (XI p)) ->
     Serializer_primitives.append (byte_Serializer.serialize '\014')
                                  (serialize_positive_three p)
  | XI (XI (XO p)) ->
     Serializer_primitives.append (byte_Serializer.serialize '\013')
                                  (serialize_positive_three p)
  | XI (XO (XI p)) ->
     Serializer_primitives.append (byte_Serializer.serialize '\012')
                                  (serialize_positive_three p)
  | XI (XO (XO p)) ->
     Serializer_primitives.append (byte_Serializer.serialize '\011')
                                  (serialize_positive_three p)
  | XO (XI (XI p)) ->
     Serializer_primitives.append (byte_Serializer.serialize '\010')
                                  (serialize_positive_three p)
  | XO (XI (XO p)) ->
     Serializer_primitives.append (byte_Serializer.serialize '\009')
                                  (serialize_positive_three p)
  | XO (XO (XI p)) ->
     Serializer_primitives.append (byte_Serializer.serialize '\008')
                                  (serialize_positive_three p)
  | XO (XO (XO p)) ->
     Serializer_primitives.append (byte_Serializer.serialize '\007')
                                  (serialize_positive_three p)
  | XI (XI p) ->
     Serializer_primitives.append (byte_Serializer.serialize '\006')
                                  (serialize_positive_three p)
  | XI (XO p) ->
     Serializer_primitives.append (byte_Serializer.serialize '\005')
                                  (serialize_positive_three p)
  | XO (XI p) ->
     Serializer_primitives.append (byte_Serializer.serialize '\004')
                                  (serialize_positive_three p)
  | XO (XO p) ->
     Serializer_primitives.append (byte_Serializer.serialize '\003')
                                  (serialize_positive_three p)
  | XI p ->
     Serializer_primitives.append (byte_Serializer.serialize '\002')
                                  (serialize_positive_three p)
  | XO p ->
     Serializer_primitives.append (byte_Serializer.serialize '\001')
                                  (serialize_positive_three p)
  | XH -> byte_Serializer.serialize '\000'
;;

let rec serialize_positive_four p =
  match p with
  | XI (XI (XI (XI p))) ->
     Serializer_primitives.append (byte_Serializer.serialize '\030')
                                  (serialize_positive_four p)
  | XI (XI (XI (XO p))) ->
     Serializer_primitives.append (byte_Serializer.serialize '\029')
                                  (serialize_positive_four p)
  | XI (XI (XO (XI p))) ->
     Serializer_primitives.append (byte_Serializer.serialize '\028')
                                  (serialize_positive_four p)
  | XI (XI (XO (XO p))) ->
     Serializer_primitives.append (byte_Serializer.serialize '\027')
                                  (serialize_positive_four p)
  | XI (XO (XI (XI p))) ->
     Serializer_primitives.append (byte_Serializer.serialize '\026')
                                  (serialize_positive_four p)
  | XI (XO (XI (XO p))) ->
     Serializer_primitives.append (byte_Serializer.serialize '\025')
                                  (serialize_positive_four p)
  | XI (XO (XO (XI p))) ->
     Serializer_primitives.append (byte_Serializer.serialize '\024')
                                  (serialize_positive_four p)
  | XI (XO (XO (XO p))) ->
     Serializer_primitives.append (byte_Serializer.serialize '\023')
                                  (serialize_positive_four p)
  | XO (XI (XI (XI p))) ->
     Serializer_primitives.append (byte_Serializer.serialize '\022')
                                  (serialize_positive_four p)
  | XO (XI (XI (XO p))) ->
     Serializer_primitives.append (byte_Serializer.serialize '\021')
                                  (serialize_positive_four p)
  | XO (XI (XO (XI p))) ->
     Serializer_primitives.append (byte_Serializer.serialize '\020')
                                  (serialize_positive_four p)
  | XO (XI (XO (XO p))) ->
     Serializer_primitives.append (byte_Serializer.serialize '\019')
                                  (serialize_positive_four p)
  | XO (XO (XI (XI p))) ->
     Serializer_primitives.append (byte_Serializer.serialize '\018')
                                  (serialize_positive_four p)
  | XO (XO (XI (XO p))) ->
     Serializer_primitives.append (byte_Serializer.serialize '\017')
                                  (serialize_positive_four p)
  | XO (XO (XO (XI p))) ->
     Serializer_primitives.append (byte_Serializer.serialize '\016')
                                  (serialize_positive_four p)
  | XO (XO (XO (XO p))) ->
     Serializer_primitives.append (byte_Serializer.serialize '\015')
                                  (serialize_positive_four p)
  | XI (XI (XI p)) ->
     Serializer_primitives.append (byte_Serializer.serialize '\014')
                                  (serialize_positive_four p)
  | XI (XI (XO p)) ->
     Serializer_primitives.append (byte_Serializer.serialize '\013')
                                  (serialize_positive_four p)
  | XI (XO (XI p)) ->
     Serializer_primitives.append (byte_Serializer.serialize '\012')
                                  (serialize_positive_four p)
  | XI (XO (XO p)) ->
     Serializer_primitives.append (byte_Serializer.serialize '\011')
                                  (serialize_positive_four p)
  | XO (XI (XI p)) ->
     Serializer_primitives.append (byte_Serializer.serialize '\010')
                                  (serialize_positive_four p)
  | XO (XI (XO p)) ->
     Serializer_primitives.append (byte_Serializer.serialize '\009')
                                  (serialize_positive_four p)
  | XO (XO (XI p)) ->
     Serializer_primitives.append (byte_Serializer.serialize '\008')
                                  (serialize_positive_four p)
  | XO (XO (XO p)) ->
     Serializer_primitives.append (byte_Serializer.serialize '\007')
                                  (serialize_positive_four p)
  | XI (XI p) ->
     Serializer_primitives.append (byte_Serializer.serialize '\006')
                                  (serialize_positive_four p)
  | XI (XO p) ->
     Serializer_primitives.append (byte_Serializer.serialize '\005')
                                  (serialize_positive_four p)
  | XO (XI p) ->
     Serializer_primitives.append (byte_Serializer.serialize '\004')
                                  (serialize_positive_four p)
  | XO (XO p) ->
     Serializer_primitives.append (byte_Serializer.serialize '\003')
                                  (serialize_positive_four p)
  | XI p ->
     Serializer_primitives.append (byte_Serializer.serialize '\002')
                                  (serialize_positive_four p)
  | XO p ->
     Serializer_primitives.append (byte_Serializer.serialize '\001')
                                  (serialize_positive_four p)
  | XH -> byte_Serializer.serialize '\000'
;;

let test_positive p print = 
  let _ = Printf.printf "Serializing/deserializing ";
          print p;
          Printf.printf "... " in
  let w = Bit_vector.makeWriter () in
  let _ = positive_serialize p w in
  let r = Bit_vector.writerToReader w in
  let p' = positive_deserialize r in
  (assert (p = p'));
  Printf.printf "success\n"
;;

let test_main max =
  let rec loop n =
    if n < max
    then (test_positive (make_positive n)
                        (fun _ -> Printf.printf "make_positive %d" n);
          loop (n + 1))
  in loop 0
;;

let _ = test_main 1000;;

(* benchmarking *)
  
let time_serialize_deserialize (p : positive)
                               (serialize : positive -> 'a)
                               (deserialize: 'a -> positive) : float * float =
  let serialize_start = Sys.time () in
  let serialized = serialize p in
  let serialize_stop = Sys.time () in
  let _ = deserialize serialized in
  let deserialize_stop = Sys.time () in
  (serialize_stop -. serialize_start, deserialize_stop -. serialize_stop)
;;

let rec time_serialize_deserialize_loop size n serialize deserialize =
  let rec loop i acc = 
    if i = n
    then acc
    else loop (i + 1)
              (time_serialize_deserialize (make_positive size)
                                          serialize
                                          deserialize :: acc)
  in loop 0 []
;;

let avg l =
  (List.fold_left (+.) 0.0 l) /. (float_of_int (List.length l))
;;

let compare_cheerios_marshal_space size =
  let p = make_positive size in
  let cheerios_size =
    let w = Bit_vector.makeWriter () in
    (positive_serialize p w;
     Bit_vector.numBytes w) in
  let marshal_size = Marshal.total_size (Marshal.to_bytes p []) 0
  in Printf.printf "size: %d - cheerios: %d bytes, marshal: %d bytes\n"
                   size cheerios_size marshal_size
;;
  
let compare_cheerios_marshal_time size n =
  let cheerios_results : (float * float) list =
    time_serialize_deserialize_loop
      size n
      (fun p -> let w = Bit_vector.makeWriter ()
                in (positive_serialize p w);
                   w)
      (fun w -> positive_deserialize (Bit_vector.writerToReader w)) in
  let marshal_results : (float * float) list =
    time_serialize_deserialize_loop
      size n
      (fun p -> Marshal.to_bytes p [])
      (fun b -> (Marshal.from_bytes b 0)) in
  let cheerios_serialize_avg = avg (List.map fst cheerios_results) in
  let marshal_serialize_avg =  avg (List.map fst marshal_results) in
  let cheerios_deserialize_avg = avg (List.map snd cheerios_results) in
  let marshal_deserialize_avg =  avg (List.map snd marshal_results) in
  Printf.printf "size %d - serialize: cheerios %f, marshal %f"
                size cheerios_serialize_avg marshal_serialize_avg;
  Printf.printf " || deserialize: cheerios %f, marshal %f\n"
                cheerios_deserialize_avg marshal_deserialize_avg
;;

let marshal_test n =
  let rec loop i =
    if i < n
    then let bytes = Marshal.to_bytes (make_positive i) [] in
         let p = Marshal.from_bytes bytes 0 in
         (Printf.printf "testing marshal on make_positive %d...\n" i;
          assert (p = make_positive i);
          loop (i + 1)) in
  loop 0
;;
  
let compare_main max interval =
  let rec loop n =
    if n < max
    then let num_tries = 50 in
         (compare_cheerios_marshal_time n num_tries;
          loop (n + interval)) in
  loop 0
;;

let _ = compare_main 350000 20000

