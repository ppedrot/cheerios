Require Import List.
Import ListNotations.
Require Vector String.

Require Import Cheerios.Core.
Require Import Cheerios.BasicSerializers.
Require Import Cheerios.DeserializerMonad.
Import DeserializerNotations.
Require Import Cheerios.Tactics.

Import ByteListSerializer.

(* These functions are either missing obvious implicits, or have
   implicit arguments that are not marked "maximally inserted", which
   means they cannot easily be used with map or fmap. *)
Arguments Some {_} _.
Arguments cons {_} _ _.
Arguments option_map {_ _} _ _.
Arguments Vector.nil {_}.
Arguments Vector.cons {_} _ {_} _.


Section combinators.

  (* This section gives instances for various type constructors, including pairs
    and lists. *)
  Variables A B : Type.
  Variable sA : Serializer A.
  Variable sB : Serializer B.

  Definition option_serialize (x : option A) : Serializer.t :=
    match x with
    | Some a => Serializer.append (serialize true) (serialize a)
    | None => serialize false
    end.

  Definition option_deserialize : Deserializer.t (option A) :=
    b <- deserialize ;;
    match b with
    | true => Some <$> deserialize
    | false => Deserializer.ret None
    end.
  
  Lemma option_serialize_deserialize_id :
    serialize_deserialize_id_spec option_serialize option_deserialize.
  Proof.
    intros.
    unfold option_serialize, option_deserialize.
    destruct a;
      repeat (cheerios_crush; simpl).
  Qed.

  Global Instance option_Serializer : Serializer (option A).
  Proof.
    exact {| serialize := option_serialize;
             deserialize := option_deserialize;
             serialize_deserialize_id := option_serialize_deserialize_id |}.
  Qed.

  
  Definition pair_serialize (x : A * B) : Serializer.t :=
    let (a, b) := x in Serializer.append (serialize a) (serialize b).
  
  Definition pair_deserialize : Deserializer.t (A * B) :=
    Deserializer.bind deserialize
                      (fun (a : A) =>
                         Deserializer.bind deserialize
                                           (fun b =>
                                              Deserializer.ret (a, b))).

  Lemma pair_serialize_deserialize_id :
    serialize_deserialize_id_spec pair_serialize pair_deserialize.
  Proof.
    intros.
    unfold pair_serialize, pair_deserialize.
    destruct a.
    cheerios_crush.
  Qed.

  Global Instance pair_Serializer : Serializer (A * B).
  Proof.
    exact {| serialize := pair_serialize;
             deserialize := pair_deserialize;
             serialize_deserialize_id := pair_serialize_deserialize_id |}.
  Qed.

  Definition sum_serialize (x : A + B) : Serializer.t :=
    match x with
    | inl a => Serializer.append (serialize true) (serialize a)
    | inr b => Serializer.append (serialize false) (serialize b)
    end.

  Definition sum_deserialize : Deserializer.t (A + B) :=
    b <- deserialize ;;
    match b with
    | true => inl <$> deserialize
    | false => inr <$> deserialize
    end.

  Lemma sum_serialize_deserialize_id :
    serialize_deserialize_id_spec sum_serialize sum_deserialize.
  Proof.
    unfold sum_serialize, sum_deserialize.
    destruct a; cheerios_crush.
  Qed.

  Global Instance sum_Serializer : Serializer (A + B).
  Proof.
    exact {| serialize := sum_serialize;
             deserialize := sum_deserialize;
             serialize_deserialize_id := sum_serialize_deserialize_id
          |}.
  Qed.
  
  Fixpoint list_serialize_rec (l : list A) : Serializer.t :=
    match l with
    | [] => Serializer.empty
    | a :: l' => Serializer.append (serialize a) (list_serialize_rec l')
    end.

  Fixpoint list_serialize_aux (l : list A) (acc : Serializer.t) : Serializer.t :=
    match l with
    | [] => acc
    | a :: l' =>  list_serialize_aux l' (Serializer.append acc (serialize a))
    end.

  Lemma list_serialize_rec'_aux : forall l acc,
      Serializer.unwrap (list_serialize_aux l acc) =
      Serializer.unwrap (Serializer.append acc (list_serialize_rec l)).
  Proof.
    intros l.
    induction l; intros.
    - simpl.
      cheerios_crush.
      now rewrite app_nil_r.
    - unfold list_serialize_aux. fold list_serialize_aux.
      rewrite IHl.
      unfold list_serialize_rec at 2.
      fold list_serialize_rec.
      cheerios_crush.
  Qed.

  Definition list_serialize_rec' (l : list A) : Serializer.t :=
    list_serialize_aux l Serializer.empty.

  Definition list_serialize (l : list A) : Serializer.t :=
    Serializer.append (serialize (length l)) (list_serialize_rec l).

  Definition list_serialize' (l : list A) : Serializer.t :=
    Serializer.append (serialize (length l)) (list_serialize_rec' l).

  Fixpoint list_deserialize_rec (n : nat) : Deserializer.t (list A) :=
    match n with
    | 0 => Deserializer.ret []
    | S n' => cons <$> deserialize <*> list_deserialize_rec n'
    end.

  Definition list_deserialize : Deserializer.t (list A) :=
    deserialize >>= list_deserialize_rec.

  Lemma list_serialize_deserialize_id_rec :
    forall l bin, Deserializer.unwrap (list_deserialize_rec (length l))
                                      (Serializer.unwrap (list_serialize_rec' l) ++ bin)
                  = Some(l, bin).
  Proof.
    intros.
    unfold list_serialize_rec'.
    rewrite list_serialize_rec'_aux.
    cheerios_crush. simpl.
    induction l;
      simpl;
      cheerios_crush.
    unfold sequence.
    cheerios_crush. 
    rewrite IHl.
    cheerios_crush.
  Qed.

  Lemma list_serialize'_deserialize_id :
    serialize_deserialize_id_spec list_serialize' list_deserialize.
  Proof.
    unfold list_serialize', list_deserialize.
    cheerios_crush.
    now rewrite list_serialize_deserialize_id_rec.
  Qed.

  Global Instance list_Serializer : Serializer (list A).
  Proof.
    exact {| serialize := list_serialize';
             deserialize := list_deserialize;
             serialize_deserialize_id := list_serialize'_deserialize_id
          |}.
  Qed.

  Fixpoint vector_serialize {n} (v : Vector.t A n) : Serializer.t :=
    match v with
    | Vector.nil => Serializer.empty
    | Vector.cons a v' => Serializer.append (serialize a) (vector_serialize v')
    end.

  Fixpoint vector_deserialize {n} : Deserializer.t (Vector.t A n) :=
    match n as n0 return Deserializer.t (Vector.t A n0) with
    | 0 => Deserializer.ret Vector.nil
    | S n' => a <- deserialize ;;
                v <- vector_deserialize ;;
                Deserializer.ret (Vector.cons a v)
    end.

  Lemma vector_serialize_deserialize_id :
    forall n, serialize_deserialize_id_spec vector_serialize (@vector_deserialize n).
  Proof.
    induction n; intros.
    - destruct a using Vector.case0. auto. unfold vector_serialize,  vector_deserialize.
      cheerios_crush.
    - destruct a using Vector.caseS'.
      simpl.
      cheerios_crush.
      rewrite IHn.
      cheerios_crush.
  Qed.

  Global Instance vector_Serializer n : Serializer (Vector.t A n).
  Proof.
    exact {| serialize := vector_serialize;
             deserialize := vector_deserialize;
             serialize_deserialize_id := vector_serialize_deserialize_id n
          |}.
  Qed.
End combinators.


(* This has to go here because it depends on having a serializer for
   lists available. *)

Fixpoint string_to_list s :=
  match s with
  | String.EmptyString => nil
  | String.String c s' => c :: (string_to_list s')
  end.

Fixpoint list_to_string l :=
  match l with
  | nil => String.EmptyString
  | h::l' => String.String h (list_to_string l')
  end.

Lemma string_to_list_to_string :
  forall s, list_to_string (string_to_list s) = s.
Proof.
  induction s; auto; simpl.
  now rewrite IHs.
Qed.

Definition string_serialize (s : String.string) :=
  serialize (string_to_list s).

Definition string_deserialize : Deserializer.t String.string :=
  list_to_string <$> deserialize.

Lemma string_serialize_deserialize_id :
  serialize_deserialize_id_spec string_serialize string_deserialize.
Proof.
  unfold string_deserialize, string_serialize.
  cheerios_crush.
  now rewrite string_to_list_to_string.
Qed.

Instance string_Serializer : Serializer String.string.
Proof.
  exact {| serialize := string_serialize;
           deserialize := string_deserialize;
           serialize_deserialize_id := string_serialize_deserialize_id
        |}.
Qed.