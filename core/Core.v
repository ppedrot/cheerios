Require Import Ascii List ZArith.
Import ListNotations.

Require Import Cheerios.Types.

Set Implicit Arguments.

Module Serializer : WRITER.
  Definition t := list byte.
  Definition wire := list byte.
  Axiom wire_eq_dec : forall w w' : wire, {w = w'}+{w <> w'}.
  
  Definition empty : t := [].
  Definition putByte (a : byte) : t := [a].

  Definition append (x y : t) : t := x ++ y.

  Definition unwrap (x : t) : list byte := x.
  Definition wire_wrap (x : t) : wire := x.
  Definition wire_unwrap (x : wire) : list byte := x.
  
  Lemma empty_unwrap : unwrap empty = [].
  Proof. reflexivity. Qed.

  Lemma putByte_unwrap : forall (a : byte), unwrap (putByte a) = [a].
  Proof. reflexivity. Qed.

  Lemma append_unwrap :
    forall x y : t, unwrap (append x y) = unwrap x ++ unwrap y.
  Proof. reflexivity. Qed.

  Lemma wire_wrap_unwrap : forall x, wire_unwrap (wire_wrap x) = unwrap x.
  Proof. reflexivity. Qed.
End Serializer.

(* This is the monad used to write deserializers. It is a state monad with
    failure, where the state is the serialized bits. *)

Module Deserializer : READER.
  Definition t (A : Type) := list byte -> option (A * list byte).
  Definition unwrap {A} (x : t A) := x.

  Definition getByte (l : list byte) :=
    match l with
    | [] => None
    | b :: l => Some (b, l)
    end.

  Definition ret {A} (a : A) : t A := fun s => Some (a, s).

  Definition bind {A B} (m : t A) (f : A -> t B) : t B :=
    fun s => match m s with None => None
                       | Some (a, s') => f a s'
             end.

  Definition map {A B} (f : A -> B) (d : Deserializer.t A) : Deserializer.t B :=
    bind d (fun a => ret (f a)).

  Definition error {A} : t A :=
    fun l => None.

  Lemma getByte_unwrap : forall l,
      unwrap getByte l = match l with
                         | [] => None
                         | b :: l => Some (b, l)
                        end.
  Proof. reflexivity. Qed.

  Lemma bind_unwrap : forall A B (m : t A)
                             (f : A -> t B) bytes,
      unwrap (bind m f) bytes = match unwrap m bytes with
                                | None => None
                                | Some (v, bytes) => unwrap (f v) bytes
                                end.
  Proof.
    unfold bind.
    intros.
    reflexivity.
  Qed.

  Fixpoint fold {S A}
           (f : byte -> S -> fold_state S A) (s : S) (l : list byte) :=
    match l with
    | [] => None
    | b :: l => match f b s with
                | Done a => Some (a, l)
                | More s => fold f s l
                | Error => None
                end
    end.

  Lemma ret_unwrap : forall {A} (x: A) bytes, unwrap (ret x) bytes = Some (x, bytes).
  Proof. reflexivity. Qed.

  Lemma map_unwrap: forall A B (f: A -> B) (d: Deserializer.t A) bytes,
      Deserializer.unwrap (map f d) bytes =
      match (Deserializer.unwrap d bytes) with
      | None => None
      | Some (v, bytes) => Some (f v, bytes)
      end.
  Proof. reflexivity. Qed.

  Lemma fold_unwrap : forall {S A : Type}
                             (f : byte -> S -> fold_state S A) (s : S) l,
      unwrap (fold f s) l =
      match l with
      | [] => None
      | b :: l => match f b s with
                  | Done a => Some (a, l)
                  | More s => unwrap (fold f s) l
                  | Error => None
                  end
      end.
  Proof.
    intros.
    simpl. destruct l; reflexivity.
  Qed.
End Deserializer.
Arguments Deserializer.error {_}.

Module ByteListSerializer := SerializerClass Serializer Deserializer.