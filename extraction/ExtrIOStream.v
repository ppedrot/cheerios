Require Import ZArith.

Require Import Cheerios.BasicSerializers.
Require Import Cheerios.Core.
Require Import Cheerios.Types.
Require Import Cheerios.IOStream.

Module IOStreamSerializer := SerializerClass IOStream ByteListReader.
Module Basics := BasicSerializers IOStream ByteListReader.
Import Basics.

Extract Constant
        IOStream.t => "Iostream_primitives.serializer".
Extract Constant
        IOStream.wire => "Iostream_primitives.wire".
Extract Constant
        ByteListReader.t "'a"  => "'a Serializer_primitives.deserializer".

Extract Inductive fold_state => "Serializer_primitives.fold_state"
                                  ["Serializer_primitives.Done"
                                     "Serializer_primitives.More"
                                     "Serializer_primitives.Error"].

Extract Inductive byte =>
"char"
  ["'\000'" "'\001'" "'\002'" "'\003'" "'\004'" "'\005'" "'\006'" "'\007'" "'\008'" "'\009'" "'\010'" "'\011'" "'\012'" "'\013'" "'\014'" "'\015'" "'\016'" "'\017'" "'\018'" "'\019'" "'\020'" "'\021'" "'\022'" "'\023'" "'\024'" "'\025'" "'\026'" "'\027'" "'\028'" "'\029'" "'\030'" "'\031'" "'\032'" "'\033'" "'\034'" "'\035'" "'\036'" "'\037'" "'\038'" "'\039'" "'\040'" "'\041'" "'\042'" "'\043'" "'\044'" "'\045'" "'\046'" "'\047'" "'\048'" "'\049'" "'\050'" "'\051'" "'\052'" "'\053'" "'\054'" "'\055'" "'\056'" "'\057'" "'\058'" "'\059'" "'\060'" "'\061'" "'\062'" "'\063'" "'\064'" "'\065'" "'\066'" "'\067'" "'\068'" "'\069'" "'\070'" "'\071'" "'\072'" "'\073'" "'\074'" "'\075'" "'\076'" "'\077'" "'\078'" "'\079'" "'\080'" "'\081'" "'\082'" "'\083'" "'\084'" "'\085'" "'\086'" "'\087'" "'\088'" "'\089'" "'\090'" "'\091'" "'\092'" "'\093'" "'\094'" "'\095'" "'\096'" "'\097'" "'\098'" "'\099'" "'\100'" "'\101'" "'\102'" "'\103'" "'\104'" "'\105'" "'\106'" "'\107'" "'\108'" "'\109'" "'\110'" "'\111'" "'\112'" "'\113'" "'\114'" "'\115'" "'\116'" "'\117'" "'\118'" "'\119'" "'\120'" "'\121'" "'\122'" "'\123'" "'\124'" "'\125'" "'\126'" "'\127'" "'\128'" "'\129'" "'\130'" "'\131'" "'\132'" "'\133'" "'\134'" "'\135'" "'\136'" "'\137'" "'\138'" "'\139'" "'\140'" "'\141'" "'\142'" "'\143'" "'\144'" "'\145'" "'\146'" "'\147'" "'\148'" "'\149'" "'\150'" "'\151'" "'\152'" "'\153'" "'\154'" "'\155'" "'\156'" "'\157'" "'\158'" "'\159'" "'\160'" "'\161'" "'\162'" "'\163'" "'\164'" "'\165'" "'\166'" "'\167'" "'\168'" "'\169'" "'\170'" "'\171'" "'\172'" "'\173'" "'\174'" "'\175'" "'\176'" "'\177'" "'\178'" "'\179'" "'\180'" "'\181'" "'\182'" "'\183'" "'\184'" "'\185'" "'\186'" "'\187'" "'\188'" "'\189'" "'\190'" "'\191'" "'\192'" "'\193'" "'\194'" "'\195'" "'\196'" "'\197'" "'\198'" "'\199'" "'\200'" "'\201'" "'\202'" "'\203'" "'\204'" "'\205'" "'\206'" "'\207'" "'\208'" "'\209'" "'\210'" "'\211'" "'\212'" "'\213'" "'\214'" "'\215'" "'\216'" "'\217'" "'\218'" "'\219'" "'\220'" "'\221'" "'\222'" "'\223'" "'\224'" "'\225'" "'\226'" "'\227'" "'\228'" "'\229'" "'\230'" "'\231'" "'\232'" "'\233'" "'\234'" "'\235'" "'\236'" "'\237'" "'\238'" "'\239'" "'\240'" "'\241'" "'\242'" "'\243'" "'\244'" "'\245'" "'\246'" "'\247'" "'\248'" "'\249'" "'\250'" "'\251'" "'\252'" "'\253'" "'\254'" "'\255'" ].

Extract Constant IOStream.putByte => "Iostream_primitives.putByte".
Extract Constant IOStream.empty => "Iostream_primitives.empty".
Extract Constant IOStream.append => "Iostream_primitives.append".
Extract Constant IOStream.wire_wrap => "Iostream_primitives.wire_wrap".
Extract Constant IOStream.wire_eq_dec => "(=)".

Extract Constant ByteListReader.getByte => "Serializer_primitives.getByte".
Extract Constant ByteListReader.bind => "Serializer_primitives.bind".
Extract Constant ByteListReader.error => "Serializer_primitives.fail".
Extract Constant ByteListReader.map => "Serializer_primitives.map".
Extract Constant ByteListReader.ret => "Serializer_primitives.ret".
Extract Constant ByteListReader.fold => "Serializer_primitives.fold".

Extract Inlined Constant Basics.RWClass.deserialize_top =>
"Serializer_primitives.deserialize_top".

Extract Constant IOStream.empty_unwrap => "Obj.magic".
Extract Constant IOStream.putByte_unwrap => "Obj.magic".
Extract Constant IOStream.append_unwrap => "Obj.magic".
Extract Constant IOStream.wire_wrap_unwrap => "Obj.magic".

Extract Constant ByteListReader.getByte_unwrap => "Obj.magic".
Extract Constant ByteListReader.bind_unwrap => "Obj.magic".
Extract Constant ByteListReader.ret_unwrap => "Obj.magic".
Extract Constant ByteListReader.map_unwrap => "Obj.magic".
Extract Constant ByteListReader.fold_unwrap => "Obj.magic".

Extract Constant IOStream.unwrap => "Obj.magic".
Extract Constant IOStream.wire_unwrap => "Obj.magic".

Extract Constant ByteListReader.unwrap => "Obj.magic".