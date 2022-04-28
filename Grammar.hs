{-# OPTIONS_GHC -w #-}
module Grammar where
import Tokens
import qualified Data.Array as Happy_Data_Array
import qualified Data.Bits as Bits
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.20.0

data HappyAbsSyn t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14
	= HappyTerminal (Token)
	| HappyErrorToken Prelude.Int
	| HappyAbsSyn4 t4
	| HappyAbsSyn5 t5
	| HappyAbsSyn6 t6
	| HappyAbsSyn7 t7
	| HappyAbsSyn8 t8
	| HappyAbsSyn9 t9
	| HappyAbsSyn10 t10
	| HappyAbsSyn11 t11
	| HappyAbsSyn12 t12
	| HappyAbsSyn13 t13
	| HappyAbsSyn14 t14

happyExpList :: Happy_Data_Array.Array Prelude.Int Prelude.Int
happyExpList = Happy_Data_Array.listArray (0,272) ([49152,5055,32784,0,30712,514,16,0,0,0,0,0,16,0,0,0,6,0,0,0,61440,1263,8196,0,40446,128,4,49088,4115,128,0,0,8,0,0,256,0,0,8192,0,64512,315,2049,32768,10111,32,1,0,0,128,0,0,2,0,0,0,0,30712,514,16,65280,16462,512,0,0,0,0,0,0,16,32640,8231,256,61440,58607,8199,0,0,0,0,0,0,0,63488,631,4098,0,20223,64,2,57312,2057,64,64512,315,2049,0,0,0,0,16384,0,0,512,0,0,16384,0,0,0,8,0,0,256,0,0,8192,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,64512,315,2049,0,0,0,0,0,0,128,0,0,4,0,0,128,0,0,4096,0,0,0,0,0,0,0,2,0,0,128,0,0,0,0,32,6144,0,1024,0,3,32768,0,96,0,0,0,0,0,0,0,0,0,256,0,0,8,0,0,0,0,0,8,0,65024,64669,1024,49152,5055,32784,0,8,0,0,256,0,0,57344,2527,16392,0,4,0,0,128,0,0,61440,1263,8196,0,2,0,0,64,0,0,63488,62071,4099,0,256,0,0,0,0,0,0,0,0,0,0,0,0,61424,2020,32,0,0,0,32768,0,0,0,0,0,128,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,256,0,96,0,0,0,7936,0,0,0,0,0,0,0,57344,2527,16392,0,0,4,0,128,0,0,4096,0,0,0,2,0,0,64,0,0,2048,0,0,0,20223,126,2,57312,4041,64,0,192,0,32768,10111,32,1,0,3,0,0,0,4,0,0,0,0,30712,514,16,0,0,0,0,0,0,0,0,2048,0,32640,8231,256,61440,1263,8196,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,61424,1028,32,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	])

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_parseCalc","stmts","stmt","exp","listElement","listElementContent","compareLists","conditions","condition","comparison","conditionStatement","triple","int","var","IMPORT","EXPORT","INTO","WRITE","WRITETRUE","WRITEFALSE","WHERE","IN","AS","GET","AND","OR","IF","THEN","ELSE","subj","pred","obj","true","false","NOTHING","';'","'{'","'}'","'<'","'>'","'<='","'>='","'='","'+'","'-'","'('","')'","'['","']'","','","%eof"]
        bit_start = st Prelude.* 53
        bit_end = (st Prelude.+ 1) Prelude.* 53
        read_bit = readArrayBit happyExpList
        bits = Prelude.map read_bit [bit_start..bit_end Prelude.- 1]
        bits_indexed = Prelude.zip bits [0..52]
        token_strs_expected = Prelude.concatMap f bits_indexed
        f (Prelude.False, _) = []
        f (Prelude.True, nr) = [token_strs Prelude.!! nr]

action_0 (15) = happyShift action_4
action_0 (16) = happyShift action_5
action_0 (17) = happyShift action_6
action_0 (18) = happyShift action_7
action_0 (19) = happyShift action_8
action_0 (20) = happyShift action_9
action_0 (21) = happyShift action_10
action_0 (22) = happyShift action_11
action_0 (24) = happyShift action_12
action_0 (25) = happyShift action_13
action_0 (26) = happyShift action_14
action_0 (29) = happyShift action_15
action_0 (37) = happyShift action_16
action_0 (48) = happyShift action_17
action_0 (4) = happyGoto action_18
action_0 (5) = happyGoto action_2
action_0 (6) = happyGoto action_3
action_0 _ = happyFail (happyExpListPerState 0)

action_1 (15) = happyShift action_4
action_1 (16) = happyShift action_5
action_1 (17) = happyShift action_6
action_1 (18) = happyShift action_7
action_1 (19) = happyShift action_8
action_1 (20) = happyShift action_9
action_1 (21) = happyShift action_10
action_1 (22) = happyShift action_11
action_1 (24) = happyShift action_12
action_1 (25) = happyShift action_13
action_1 (26) = happyShift action_14
action_1 (29) = happyShift action_15
action_1 (37) = happyShift action_16
action_1 (48) = happyShift action_17
action_1 (5) = happyGoto action_2
action_1 (6) = happyGoto action_3
action_1 _ = happyFail (happyExpListPerState 1)

action_2 _ = happyReduce_1

action_3 (38) = happyShift action_37
action_3 _ = happyFail (happyExpListPerState 3)

action_4 (41) = happyShift action_31
action_4 (42) = happyShift action_32
action_4 (43) = happyShift action_33
action_4 (44) = happyShift action_34
action_4 (46) = happyShift action_35
action_4 (47) = happyShift action_36
action_4 _ = happyReduce_7

action_5 _ = happyReduce_5

action_6 (15) = happyShift action_4
action_6 (16) = happyShift action_5
action_6 (17) = happyShift action_6
action_6 (18) = happyShift action_7
action_6 (19) = happyShift action_8
action_6 (20) = happyShift action_9
action_6 (21) = happyShift action_10
action_6 (22) = happyShift action_11
action_6 (24) = happyShift action_12
action_6 (25) = happyShift action_13
action_6 (26) = happyShift action_14
action_6 (29) = happyShift action_15
action_6 (37) = happyShift action_16
action_6 (48) = happyShift action_17
action_6 (6) = happyGoto action_30
action_6 _ = happyFail (happyExpListPerState 6)

action_7 (15) = happyShift action_4
action_7 (16) = happyShift action_5
action_7 (17) = happyShift action_6
action_7 (18) = happyShift action_7
action_7 (19) = happyShift action_8
action_7 (20) = happyShift action_9
action_7 (21) = happyShift action_10
action_7 (22) = happyShift action_11
action_7 (24) = happyShift action_12
action_7 (25) = happyShift action_13
action_7 (26) = happyShift action_14
action_7 (29) = happyShift action_15
action_7 (37) = happyShift action_16
action_7 (48) = happyShift action_17
action_7 (6) = happyGoto action_29
action_7 _ = happyFail (happyExpListPerState 7)

action_8 (15) = happyShift action_4
action_8 (16) = happyShift action_5
action_8 (17) = happyShift action_6
action_8 (18) = happyShift action_7
action_8 (19) = happyShift action_8
action_8 (20) = happyShift action_9
action_8 (21) = happyShift action_10
action_8 (22) = happyShift action_11
action_8 (24) = happyShift action_12
action_8 (25) = happyShift action_13
action_8 (26) = happyShift action_14
action_8 (29) = happyShift action_15
action_8 (37) = happyShift action_16
action_8 (48) = happyShift action_17
action_8 (6) = happyGoto action_28
action_8 _ = happyFail (happyExpListPerState 8)

action_9 (39) = happyShift action_27
action_9 _ = happyFail (happyExpListPerState 9)

action_10 (39) = happyShift action_26
action_10 _ = happyFail (happyExpListPerState 10)

action_11 (39) = happyShift action_25
action_11 _ = happyFail (happyExpListPerState 11)

action_12 (15) = happyShift action_4
action_12 (16) = happyShift action_5
action_12 (17) = happyShift action_6
action_12 (18) = happyShift action_7
action_12 (19) = happyShift action_8
action_12 (20) = happyShift action_9
action_12 (21) = happyShift action_10
action_12 (22) = happyShift action_11
action_12 (24) = happyShift action_12
action_12 (25) = happyShift action_13
action_12 (26) = happyShift action_14
action_12 (29) = happyShift action_15
action_12 (37) = happyShift action_16
action_12 (48) = happyShift action_17
action_12 (6) = happyGoto action_24
action_12 _ = happyFail (happyExpListPerState 12)

action_13 (15) = happyShift action_4
action_13 (16) = happyShift action_5
action_13 (17) = happyShift action_6
action_13 (18) = happyShift action_7
action_13 (19) = happyShift action_8
action_13 (20) = happyShift action_9
action_13 (21) = happyShift action_10
action_13 (22) = happyShift action_11
action_13 (24) = happyShift action_12
action_13 (25) = happyShift action_13
action_13 (26) = happyShift action_14
action_13 (29) = happyShift action_15
action_13 (37) = happyShift action_16
action_13 (48) = happyShift action_17
action_13 (6) = happyGoto action_23
action_13 _ = happyFail (happyExpListPerState 13)

action_14 (50) = happyShift action_22
action_14 _ = happyFail (happyExpListPerState 14)

action_15 (39) = happyShift action_21
action_15 _ = happyFail (happyExpListPerState 15)

action_16 _ = happyReduce_6

action_17 (15) = happyShift action_4
action_17 (16) = happyShift action_5
action_17 (17) = happyShift action_6
action_17 (18) = happyShift action_7
action_17 (19) = happyShift action_8
action_17 (20) = happyShift action_9
action_17 (21) = happyShift action_10
action_17 (22) = happyShift action_11
action_17 (24) = happyShift action_12
action_17 (25) = happyShift action_13
action_17 (26) = happyShift action_14
action_17 (29) = happyShift action_15
action_17 (37) = happyShift action_16
action_17 (48) = happyShift action_17
action_17 (6) = happyGoto action_20
action_17 _ = happyFail (happyExpListPerState 17)

action_18 (15) = happyShift action_4
action_18 (16) = happyShift action_5
action_18 (17) = happyShift action_6
action_18 (18) = happyShift action_7
action_18 (19) = happyShift action_8
action_18 (20) = happyShift action_9
action_18 (21) = happyShift action_10
action_18 (22) = happyShift action_11
action_18 (24) = happyShift action_12
action_18 (25) = happyShift action_13
action_18 (26) = happyShift action_14
action_18 (29) = happyShift action_15
action_18 (37) = happyShift action_16
action_18 (48) = happyShift action_17
action_18 (53) = happyAccept
action_18 (5) = happyGoto action_19
action_18 (6) = happyGoto action_3
action_18 _ = happyFail (happyExpListPerState 18)

action_19 _ = happyReduce_2

action_20 (49) = happyShift action_61
action_20 _ = happyFail (happyExpListPerState 20)

action_21 (15) = happyShift action_4
action_21 (16) = happyShift action_5
action_21 (17) = happyShift action_6
action_21 (18) = happyShift action_7
action_21 (19) = happyShift action_8
action_21 (20) = happyShift action_9
action_21 (21) = happyShift action_10
action_21 (22) = happyShift action_11
action_21 (24) = happyShift action_12
action_21 (25) = happyShift action_13
action_21 (26) = happyShift action_14
action_21 (29) = happyShift action_15
action_21 (37) = happyShift action_16
action_21 (48) = happyShift action_17
action_21 (6) = happyGoto action_59
action_21 (10) = happyGoto action_60
action_21 _ = happyFail (happyExpListPerState 21)

action_22 (15) = happyShift action_4
action_22 (16) = happyShift action_5
action_22 (17) = happyShift action_6
action_22 (18) = happyShift action_7
action_22 (19) = happyShift action_8
action_22 (20) = happyShift action_9
action_22 (21) = happyShift action_10
action_22 (22) = happyShift action_11
action_22 (24) = happyShift action_12
action_22 (25) = happyShift action_13
action_22 (26) = happyShift action_14
action_22 (29) = happyShift action_15
action_22 (32) = happyShift action_54
action_22 (33) = happyShift action_55
action_22 (34) = happyShift action_56
action_22 (35) = happyShift action_57
action_22 (36) = happyShift action_58
action_22 (37) = happyShift action_16
action_22 (48) = happyShift action_17
action_22 (6) = happyGoto action_50
action_22 (7) = happyGoto action_51
action_22 (8) = happyGoto action_52
action_22 (14) = happyGoto action_53
action_22 _ = happyFail (happyExpListPerState 22)

action_23 _ = happyReduce_13

action_24 _ = happyReduce_12

action_25 (15) = happyShift action_4
action_25 (16) = happyShift action_5
action_25 (17) = happyShift action_6
action_25 (18) = happyShift action_7
action_25 (19) = happyShift action_8
action_25 (20) = happyShift action_9
action_25 (21) = happyShift action_10
action_25 (22) = happyShift action_11
action_25 (24) = happyShift action_12
action_25 (25) = happyShift action_13
action_25 (26) = happyShift action_14
action_25 (29) = happyShift action_15
action_25 (37) = happyShift action_16
action_25 (48) = happyShift action_17
action_25 (6) = happyGoto action_46
action_25 (9) = happyGoto action_49
action_25 _ = happyFail (happyExpListPerState 25)

action_26 (15) = happyShift action_4
action_26 (16) = happyShift action_5
action_26 (17) = happyShift action_6
action_26 (18) = happyShift action_7
action_26 (19) = happyShift action_8
action_26 (20) = happyShift action_9
action_26 (21) = happyShift action_10
action_26 (22) = happyShift action_11
action_26 (24) = happyShift action_12
action_26 (25) = happyShift action_13
action_26 (26) = happyShift action_14
action_26 (29) = happyShift action_15
action_26 (37) = happyShift action_16
action_26 (48) = happyShift action_17
action_26 (6) = happyGoto action_46
action_26 (9) = happyGoto action_48
action_26 _ = happyFail (happyExpListPerState 26)

action_27 (15) = happyShift action_4
action_27 (16) = happyShift action_5
action_27 (17) = happyShift action_6
action_27 (18) = happyShift action_7
action_27 (19) = happyShift action_8
action_27 (20) = happyShift action_9
action_27 (21) = happyShift action_10
action_27 (22) = happyShift action_11
action_27 (24) = happyShift action_12
action_27 (25) = happyShift action_13
action_27 (26) = happyShift action_14
action_27 (29) = happyShift action_15
action_27 (37) = happyShift action_16
action_27 (48) = happyShift action_17
action_27 (6) = happyGoto action_46
action_27 (9) = happyGoto action_47
action_27 _ = happyFail (happyExpListPerState 27)

action_28 (15) = happyShift action_4
action_28 (16) = happyShift action_5
action_28 (17) = happyShift action_6
action_28 (18) = happyShift action_7
action_28 (19) = happyShift action_8
action_28 (20) = happyShift action_9
action_28 (21) = happyShift action_10
action_28 (22) = happyShift action_11
action_28 (24) = happyShift action_12
action_28 (25) = happyShift action_13
action_28 (26) = happyShift action_14
action_28 (29) = happyShift action_15
action_28 (37) = happyShift action_16
action_28 (48) = happyShift action_17
action_28 (6) = happyGoto action_45
action_28 _ = happyFail (happyExpListPerState 28)

action_29 _ = happyReduce_16

action_30 (25) = happyShift action_44
action_30 _ = happyFail (happyExpListPerState 30)

action_31 (15) = happyShift action_43
action_31 _ = happyFail (happyExpListPerState 31)

action_32 (15) = happyShift action_42
action_32 _ = happyFail (happyExpListPerState 32)

action_33 (15) = happyShift action_41
action_33 _ = happyFail (happyExpListPerState 33)

action_34 (15) = happyShift action_40
action_34 _ = happyFail (happyExpListPerState 34)

action_35 (15) = happyShift action_39
action_35 _ = happyFail (happyExpListPerState 35)

action_36 (15) = happyShift action_38
action_36 _ = happyFail (happyExpListPerState 36)

action_37 _ = happyReduce_3

action_38 _ = happyReduce_21

action_39 _ = happyReduce_20

action_40 _ = happyReduce_23

action_41 _ = happyReduce_22

action_42 _ = happyReduce_19

action_43 _ = happyReduce_18

action_44 (15) = happyShift action_4
action_44 (16) = happyShift action_5
action_44 (17) = happyShift action_6
action_44 (18) = happyShift action_7
action_44 (19) = happyShift action_8
action_44 (20) = happyShift action_9
action_44 (21) = happyShift action_10
action_44 (22) = happyShift action_11
action_44 (24) = happyShift action_12
action_44 (25) = happyShift action_13
action_44 (26) = happyShift action_14
action_44 (29) = happyShift action_15
action_44 (37) = happyShift action_16
action_44 (48) = happyShift action_17
action_44 (6) = happyGoto action_79
action_44 _ = happyFail (happyExpListPerState 44)

action_45 _ = happyReduce_4

action_46 (50) = happyShift action_78
action_46 _ = happyFail (happyExpListPerState 46)

action_47 (40) = happyShift action_77
action_47 _ = happyFail (happyExpListPerState 47)

action_48 (40) = happyShift action_76
action_48 _ = happyFail (happyExpListPerState 48)

action_49 (40) = happyShift action_75
action_49 _ = happyFail (happyExpListPerState 49)

action_50 _ = happyReduce_30

action_51 (51) = happyShift action_74
action_51 _ = happyFail (happyExpListPerState 51)

action_52 (52) = happyShift action_73
action_52 _ = happyReduce_25

action_53 _ = happyReduce_27

action_54 (24) = happyShift action_70
action_54 (46) = happyShift action_71
action_54 (47) = happyShift action_72
action_54 _ = happyReduce_49

action_55 (24) = happyShift action_67
action_55 (46) = happyShift action_68
action_55 (47) = happyShift action_69
action_55 _ = happyReduce_50

action_56 (24) = happyShift action_64
action_56 (46) = happyShift action_65
action_56 (47) = happyShift action_66
action_56 _ = happyReduce_51

action_57 _ = happyReduce_28

action_58 _ = happyReduce_29

action_59 (50) = happyShift action_63
action_59 _ = happyFail (happyExpListPerState 59)

action_60 (40) = happyShift action_62
action_60 _ = happyFail (happyExpListPerState 60)

action_61 _ = happyReduce_24

action_62 (30) = happyShift action_99
action_62 _ = happyFail (happyExpListPerState 62)

action_63 (15) = happyShift action_4
action_63 (16) = happyShift action_5
action_63 (17) = happyShift action_6
action_63 (18) = happyShift action_7
action_63 (19) = happyShift action_8
action_63 (20) = happyShift action_9
action_63 (21) = happyShift action_10
action_63 (22) = happyShift action_11
action_63 (24) = happyShift action_12
action_63 (25) = happyShift action_13
action_63 (26) = happyShift action_14
action_63 (29) = happyShift action_15
action_63 (32) = happyShift action_54
action_63 (33) = happyShift action_55
action_63 (34) = happyShift action_56
action_63 (35) = happyShift action_97
action_63 (36) = happyShift action_98
action_63 (37) = happyShift action_16
action_63 (48) = happyShift action_17
action_63 (6) = happyGoto action_93
action_63 (11) = happyGoto action_94
action_63 (13) = happyGoto action_95
action_63 (14) = happyGoto action_96
action_63 _ = happyFail (happyExpListPerState 63)

action_64 (15) = happyShift action_4
action_64 (16) = happyShift action_5
action_64 (17) = happyShift action_6
action_64 (18) = happyShift action_7
action_64 (19) = happyShift action_8
action_64 (20) = happyShift action_9
action_64 (21) = happyShift action_10
action_64 (22) = happyShift action_11
action_64 (24) = happyShift action_12
action_64 (25) = happyShift action_13
action_64 (26) = happyShift action_14
action_64 (29) = happyShift action_15
action_64 (37) = happyShift action_16
action_64 (48) = happyShift action_17
action_64 (6) = happyGoto action_92
action_64 _ = happyFail (happyExpListPerState 64)

action_65 (15) = happyShift action_91
action_65 _ = happyFail (happyExpListPerState 65)

action_66 (15) = happyShift action_90
action_66 _ = happyFail (happyExpListPerState 66)

action_67 (15) = happyShift action_4
action_67 (16) = happyShift action_5
action_67 (17) = happyShift action_6
action_67 (18) = happyShift action_7
action_67 (19) = happyShift action_8
action_67 (20) = happyShift action_9
action_67 (21) = happyShift action_10
action_67 (22) = happyShift action_11
action_67 (24) = happyShift action_12
action_67 (25) = happyShift action_13
action_67 (26) = happyShift action_14
action_67 (29) = happyShift action_15
action_67 (37) = happyShift action_16
action_67 (48) = happyShift action_17
action_67 (6) = happyGoto action_89
action_67 _ = happyFail (happyExpListPerState 67)

action_68 (15) = happyShift action_88
action_68 _ = happyFail (happyExpListPerState 68)

action_69 (15) = happyShift action_87
action_69 _ = happyFail (happyExpListPerState 69)

action_70 (15) = happyShift action_4
action_70 (16) = happyShift action_5
action_70 (17) = happyShift action_6
action_70 (18) = happyShift action_7
action_70 (19) = happyShift action_8
action_70 (20) = happyShift action_9
action_70 (21) = happyShift action_10
action_70 (22) = happyShift action_11
action_70 (24) = happyShift action_12
action_70 (25) = happyShift action_13
action_70 (26) = happyShift action_14
action_70 (29) = happyShift action_15
action_70 (37) = happyShift action_16
action_70 (48) = happyShift action_17
action_70 (6) = happyGoto action_86
action_70 _ = happyFail (happyExpListPerState 70)

action_71 (15) = happyShift action_85
action_71 _ = happyFail (happyExpListPerState 71)

action_72 (15) = happyShift action_84
action_72 _ = happyFail (happyExpListPerState 72)

action_73 (15) = happyShift action_4
action_73 (16) = happyShift action_5
action_73 (17) = happyShift action_6
action_73 (18) = happyShift action_7
action_73 (19) = happyShift action_8
action_73 (20) = happyShift action_9
action_73 (21) = happyShift action_10
action_73 (22) = happyShift action_11
action_73 (24) = happyShift action_12
action_73 (25) = happyShift action_13
action_73 (26) = happyShift action_14
action_73 (29) = happyShift action_15
action_73 (32) = happyShift action_54
action_73 (33) = happyShift action_55
action_73 (34) = happyShift action_56
action_73 (35) = happyShift action_57
action_73 (36) = happyShift action_58
action_73 (37) = happyShift action_16
action_73 (48) = happyShift action_17
action_73 (6) = happyGoto action_50
action_73 (7) = happyGoto action_83
action_73 (8) = happyGoto action_52
action_73 (14) = happyGoto action_53
action_73 _ = happyFail (happyExpListPerState 73)

action_74 (23) = happyShift action_82
action_74 _ = happyFail (happyExpListPerState 74)

action_75 _ = happyReduce_11

action_76 _ = happyReduce_10

action_77 _ = happyReduce_9

action_78 (15) = happyShift action_4
action_78 (16) = happyShift action_5
action_78 (17) = happyShift action_6
action_78 (18) = happyShift action_7
action_78 (19) = happyShift action_8
action_78 (20) = happyShift action_9
action_78 (21) = happyShift action_10
action_78 (22) = happyShift action_11
action_78 (24) = happyShift action_12
action_78 (25) = happyShift action_13
action_78 (26) = happyShift action_14
action_78 (29) = happyShift action_15
action_78 (32) = happyShift action_54
action_78 (33) = happyShift action_55
action_78 (34) = happyShift action_56
action_78 (35) = happyShift action_57
action_78 (36) = happyShift action_58
action_78 (37) = happyShift action_16
action_78 (48) = happyShift action_17
action_78 (6) = happyGoto action_50
action_78 (7) = happyGoto action_81
action_78 (8) = happyGoto action_52
action_78 (14) = happyGoto action_53
action_78 _ = happyFail (happyExpListPerState 78)

action_79 (39) = happyShift action_80
action_79 _ = happyReduce_14

action_80 (16) = happyShift action_111
action_80 _ = happyFail (happyExpListPerState 80)

action_81 (51) = happyShift action_110
action_81 _ = happyFail (happyExpListPerState 81)

action_82 (39) = happyShift action_109
action_82 _ = happyFail (happyExpListPerState 82)

action_83 _ = happyReduce_26

action_84 _ = happyReduce_58

action_85 _ = happyReduce_55

action_86 _ = happyReduce_52

action_87 _ = happyReduce_59

action_88 _ = happyReduce_56

action_89 _ = happyReduce_53

action_90 _ = happyReduce_60

action_91 _ = happyReduce_57

action_92 _ = happyReduce_54

action_93 _ = happyReduce_48

action_94 (51) = happyShift action_108
action_94 _ = happyFail (happyExpListPerState 94)

action_95 (27) = happyShift action_106
action_95 (28) = happyShift action_107
action_95 _ = happyReduce_36

action_96 (41) = happyShift action_101
action_96 (42) = happyShift action_102
action_96 (43) = happyShift action_103
action_96 (44) = happyShift action_104
action_96 (45) = happyShift action_105
action_96 _ = happyFail (happyExpListPerState 96)

action_97 _ = happyReduce_41

action_98 _ = happyReduce_42

action_99 (15) = happyShift action_4
action_99 (16) = happyShift action_5
action_99 (17) = happyShift action_6
action_99 (18) = happyShift action_7
action_99 (19) = happyShift action_8
action_99 (20) = happyShift action_9
action_99 (21) = happyShift action_10
action_99 (22) = happyShift action_11
action_99 (24) = happyShift action_12
action_99 (25) = happyShift action_13
action_99 (26) = happyShift action_14
action_99 (29) = happyShift action_15
action_99 (37) = happyShift action_16
action_99 (48) = happyShift action_17
action_99 (6) = happyGoto action_100
action_99 _ = happyFail (happyExpListPerState 99)

action_100 (31) = happyShift action_126
action_100 _ = happyFail (happyExpListPerState 100)

action_101 (15) = happyShift action_125
action_101 _ = happyFail (happyExpListPerState 101)

action_102 (15) = happyShift action_124
action_102 _ = happyFail (happyExpListPerState 102)

action_103 (15) = happyShift action_123
action_103 _ = happyFail (happyExpListPerState 103)

action_104 (15) = happyShift action_122
action_104 _ = happyFail (happyExpListPerState 104)

action_105 (15) = happyShift action_121
action_105 _ = happyFail (happyExpListPerState 105)

action_106 (15) = happyShift action_4
action_106 (16) = happyShift action_5
action_106 (17) = happyShift action_6
action_106 (18) = happyShift action_7
action_106 (19) = happyShift action_8
action_106 (20) = happyShift action_9
action_106 (21) = happyShift action_10
action_106 (22) = happyShift action_11
action_106 (24) = happyShift action_12
action_106 (25) = happyShift action_13
action_106 (26) = happyShift action_14
action_106 (29) = happyShift action_15
action_106 (32) = happyShift action_54
action_106 (33) = happyShift action_55
action_106 (34) = happyShift action_56
action_106 (35) = happyShift action_97
action_106 (36) = happyShift action_98
action_106 (37) = happyShift action_16
action_106 (48) = happyShift action_17
action_106 (6) = happyGoto action_93
action_106 (11) = happyGoto action_120
action_106 (13) = happyGoto action_95
action_106 (14) = happyGoto action_96
action_106 _ = happyFail (happyExpListPerState 106)

action_107 (15) = happyShift action_4
action_107 (16) = happyShift action_5
action_107 (17) = happyShift action_6
action_107 (18) = happyShift action_7
action_107 (19) = happyShift action_8
action_107 (20) = happyShift action_9
action_107 (21) = happyShift action_10
action_107 (22) = happyShift action_11
action_107 (24) = happyShift action_12
action_107 (25) = happyShift action_13
action_107 (26) = happyShift action_14
action_107 (29) = happyShift action_15
action_107 (32) = happyShift action_54
action_107 (33) = happyShift action_55
action_107 (34) = happyShift action_56
action_107 (35) = happyShift action_97
action_107 (36) = happyShift action_98
action_107 (37) = happyShift action_16
action_107 (48) = happyShift action_17
action_107 (6) = happyGoto action_93
action_107 (11) = happyGoto action_119
action_107 (13) = happyGoto action_95
action_107 (14) = happyGoto action_96
action_107 _ = happyFail (happyExpListPerState 107)

action_108 (27) = happyShift action_117
action_108 (28) = happyShift action_118
action_108 _ = happyReduce_33

action_109 (15) = happyShift action_4
action_109 (16) = happyShift action_5
action_109 (17) = happyShift action_6
action_109 (18) = happyShift action_7
action_109 (19) = happyShift action_8
action_109 (20) = happyShift action_9
action_109 (21) = happyShift action_10
action_109 (22) = happyShift action_11
action_109 (24) = happyShift action_12
action_109 (25) = happyShift action_13
action_109 (26) = happyShift action_14
action_109 (29) = happyShift action_15
action_109 (37) = happyShift action_16
action_109 (48) = happyShift action_17
action_109 (6) = happyGoto action_46
action_109 (9) = happyGoto action_116
action_109 _ = happyFail (happyExpListPerState 109)

action_110 (27) = happyShift action_114
action_110 (28) = happyShift action_115
action_110 (12) = happyGoto action_113
action_110 _ = happyReduce_31

action_111 (40) = happyShift action_112
action_111 _ = happyFail (happyExpListPerState 111)

action_112 _ = happyReduce_15

action_113 (15) = happyShift action_4
action_113 (16) = happyShift action_5
action_113 (17) = happyShift action_6
action_113 (18) = happyShift action_7
action_113 (19) = happyShift action_8
action_113 (20) = happyShift action_9
action_113 (21) = happyShift action_10
action_113 (22) = happyShift action_11
action_113 (24) = happyShift action_12
action_113 (25) = happyShift action_13
action_113 (26) = happyShift action_14
action_113 (29) = happyShift action_15
action_113 (37) = happyShift action_16
action_113 (48) = happyShift action_17
action_113 (6) = happyGoto action_46
action_113 (9) = happyGoto action_131
action_113 _ = happyFail (happyExpListPerState 113)

action_114 _ = happyReduce_40

action_115 _ = happyReduce_39

action_116 (40) = happyShift action_130
action_116 _ = happyFail (happyExpListPerState 116)

action_117 (15) = happyShift action_4
action_117 (16) = happyShift action_5
action_117 (17) = happyShift action_6
action_117 (18) = happyShift action_7
action_117 (19) = happyShift action_8
action_117 (20) = happyShift action_9
action_117 (21) = happyShift action_10
action_117 (22) = happyShift action_11
action_117 (24) = happyShift action_12
action_117 (25) = happyShift action_13
action_117 (26) = happyShift action_14
action_117 (29) = happyShift action_15
action_117 (37) = happyShift action_16
action_117 (48) = happyShift action_17
action_117 (6) = happyGoto action_59
action_117 (10) = happyGoto action_129
action_117 _ = happyFail (happyExpListPerState 117)

action_118 (15) = happyShift action_4
action_118 (16) = happyShift action_5
action_118 (17) = happyShift action_6
action_118 (18) = happyShift action_7
action_118 (19) = happyShift action_8
action_118 (20) = happyShift action_9
action_118 (21) = happyShift action_10
action_118 (22) = happyShift action_11
action_118 (24) = happyShift action_12
action_118 (25) = happyShift action_13
action_118 (26) = happyShift action_14
action_118 (29) = happyShift action_15
action_118 (37) = happyShift action_16
action_118 (48) = happyShift action_17
action_118 (6) = happyGoto action_59
action_118 (10) = happyGoto action_128
action_118 _ = happyFail (happyExpListPerState 118)

action_119 _ = happyReduce_37

action_120 _ = happyReduce_38

action_121 _ = happyReduce_47

action_122 _ = happyReduce_46

action_123 _ = happyReduce_45

action_124 _ = happyReduce_44

action_125 _ = happyReduce_43

action_126 (15) = happyShift action_4
action_126 (16) = happyShift action_5
action_126 (17) = happyShift action_6
action_126 (18) = happyShift action_7
action_126 (19) = happyShift action_8
action_126 (20) = happyShift action_9
action_126 (21) = happyShift action_10
action_126 (22) = happyShift action_11
action_126 (24) = happyShift action_12
action_126 (25) = happyShift action_13
action_126 (26) = happyShift action_14
action_126 (29) = happyShift action_15
action_126 (37) = happyShift action_16
action_126 (48) = happyShift action_17
action_126 (6) = happyGoto action_127
action_126 _ = happyFail (happyExpListPerState 126)

action_127 _ = happyReduce_17

action_128 _ = happyReduce_34

action_129 _ = happyReduce_35

action_130 _ = happyReduce_8

action_131 _ = happyReduce_32

happyReduce_1 = happySpecReduce_1  4 happyReduction_1
happyReduction_1 (HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn4
		 ([happy_var_1]
	)
happyReduction_1 _  = notHappyAtAll 

happyReduce_2 = happySpecReduce_2  4 happyReduction_2
happyReduction_2 (HappyAbsSyn5  happy_var_2)
	(HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn4
		 (happy_var_2 : happy_var_1
	)
happyReduction_2 _ _  = notHappyAtAll 

happyReduce_3 = happySpecReduce_2  5 happyReduction_3
happyReduction_3 _
	(HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn5
		 (happy_var_1
	)
happyReduction_3 _ _  = notHappyAtAll 

happyReduce_4 = happySpecReduce_3  6 happyReduction_4
happyReduction_4 (HappyAbsSyn6  happy_var_3)
	(HappyAbsSyn6  happy_var_2)
	_
	 =  HappyAbsSyn6
		 (Into happy_var_2 happy_var_3
	)
happyReduction_4 _ _ _  = notHappyAtAll 

happyReduce_5 = happySpecReduce_1  6 happyReduction_5
happyReduction_5 (HappyTerminal (VarToken _ happy_var_1))
	 =  HappyAbsSyn6
		 (Var happy_var_1
	)
happyReduction_5 _  = notHappyAtAll 

happyReduce_6 = happySpecReduce_1  6 happyReduction_6
happyReduction_6 _
	 =  HappyAbsSyn6
		 (NothingG
	)

happyReduce_7 = happySpecReduce_1  6 happyReduction_7
happyReduction_7 (HappyTerminal (IntToken _ happy_var_1))
	 =  HappyAbsSyn6
		 (AssignInt happy_var_1
	)
happyReduction_7 _  = notHappyAtAll 

happyReduce_8 = happyReduce 8 6 happyReduction_8
happyReduction_8 (_ `HappyStk`
	(HappyAbsSyn9  happy_var_7) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn7  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (Get happy_var_3 happy_var_7
	) `HappyStk` happyRest

happyReduce_9 = happyReduce 4 6 happyReduction_9
happyReduction_9 (_ `HappyStk`
	(HappyAbsSyn9  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (Write happy_var_3
	) `HappyStk` happyRest

happyReduce_10 = happyReduce 4 6 happyReduction_10
happyReduction_10 (_ `HappyStk`
	(HappyAbsSyn9  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (WriteTrue happy_var_3
	) `HappyStk` happyRest

happyReduce_11 = happyReduce 4 6 happyReduction_11
happyReduction_11 (_ `HappyStk`
	(HappyAbsSyn9  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (WriteFalse happy_var_3
	) `HappyStk` happyRest

happyReduce_12 = happySpecReduce_2  6 happyReduction_12
happyReduction_12 (HappyAbsSyn6  happy_var_2)
	_
	 =  HappyAbsSyn6
		 (In happy_var_2
	)
happyReduction_12 _ _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_2  6 happyReduction_13
happyReduction_13 (HappyAbsSyn6  happy_var_2)
	_
	 =  HappyAbsSyn6
		 (As happy_var_2
	)
happyReduction_13 _ _  = notHappyAtAll 

happyReduce_14 = happyReduce 4 6 happyReduction_14
happyReduction_14 ((HappyAbsSyn6  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn6  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (Import happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_15 = happyReduce 7 6 happyReduction_15
happyReduction_15 (_ `HappyStk`
	(HappyTerminal (VarToken _ happy_var_6)) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn6  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn6  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (ImportAs happy_var_2 happy_var_4 (Var happy_var_6)
	) `HappyStk` happyRest

happyReduce_16 = happySpecReduce_2  6 happyReduction_16
happyReduction_16 (HappyAbsSyn6  happy_var_2)
	_
	 =  HappyAbsSyn6
		 (Export happy_var_2
	)
happyReduction_16 _ _  = notHappyAtAll 

happyReduce_17 = happyReduce 8 6 happyReduction_17
happyReduction_17 ((HappyAbsSyn6  happy_var_8) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn6  happy_var_6) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn10  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (IfThenElse happy_var_3 happy_var_6 happy_var_8
	) `HappyStk` happyRest

happyReduce_18 = happySpecReduce_3  6 happyReduction_18
happyReduction_18 (HappyTerminal (IntToken _ happy_var_3))
	_
	(HappyTerminal (IntToken _ happy_var_1))
	 =  HappyAbsSyn6
		 (LessThan happy_var_1 happy_var_3
	)
happyReduction_18 _ _ _  = notHappyAtAll 

happyReduce_19 = happySpecReduce_3  6 happyReduction_19
happyReduction_19 (HappyTerminal (IntToken _ happy_var_3))
	_
	(HappyTerminal (IntToken _ happy_var_1))
	 =  HappyAbsSyn6
		 (MoreThan happy_var_1 happy_var_3
	)
happyReduction_19 _ _ _  = notHappyAtAll 

happyReduce_20 = happySpecReduce_3  6 happyReduction_20
happyReduction_20 (HappyTerminal (IntToken _ happy_var_3))
	_
	(HappyTerminal (IntToken _ happy_var_1))
	 =  HappyAbsSyn6
		 (Add happy_var_1 happy_var_3
	)
happyReduction_20 _ _ _  = notHappyAtAll 

happyReduce_21 = happySpecReduce_3  6 happyReduction_21
happyReduction_21 (HappyTerminal (IntToken _ happy_var_3))
	_
	(HappyTerminal (IntToken _ happy_var_1))
	 =  HappyAbsSyn6
		 (Minus happy_var_1 happy_var_3
	)
happyReduction_21 _ _ _  = notHappyAtAll 

happyReduce_22 = happySpecReduce_3  6 happyReduction_22
happyReduction_22 (HappyTerminal (IntToken _ happy_var_3))
	_
	(HappyTerminal (IntToken _ happy_var_1))
	 =  HappyAbsSyn6
		 (LessThanEqual happy_var_1 happy_var_3
	)
happyReduction_22 _ _ _  = notHappyAtAll 

happyReduce_23 = happySpecReduce_3  6 happyReduction_23
happyReduction_23 (HappyTerminal (IntToken _ happy_var_3))
	_
	(HappyTerminal (IntToken _ happy_var_1))
	 =  HappyAbsSyn6
		 (MoreThanEqual happy_var_1 happy_var_3
	)
happyReduction_23 _ _ _  = notHappyAtAll 

happyReduce_24 = happySpecReduce_3  6 happyReduction_24
happyReduction_24 _
	(HappyAbsSyn6  happy_var_2)
	_
	 =  HappyAbsSyn6
		 (happy_var_2
	)
happyReduction_24 _ _ _  = notHappyAtAll 

happyReduce_25 = happySpecReduce_1  7 happyReduction_25
happyReduction_25 (HappyAbsSyn8  happy_var_1)
	 =  HappyAbsSyn7
		 ([happy_var_1]
	)
happyReduction_25 _  = notHappyAtAll 

happyReduce_26 = happySpecReduce_3  7 happyReduction_26
happyReduction_26 (HappyAbsSyn7  happy_var_3)
	_
	(HappyAbsSyn8  happy_var_1)
	 =  HappyAbsSyn7
		 (happy_var_1 : happy_var_3
	)
happyReduction_26 _ _ _  = notHappyAtAll 

happyReduce_27 = happySpecReduce_1  8 happyReduction_27
happyReduction_27 (HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn8
		 (happy_var_1
	)
happyReduction_27 _  = notHappyAtAll 

happyReduce_28 = happySpecReduce_1  8 happyReduction_28
happyReduction_28 _
	 =  HappyAbsSyn8
		 (TrueElem
	)

happyReduce_29 = happySpecReduce_1  8 happyReduction_29
happyReduction_29 _
	 =  HappyAbsSyn8
		 (FalseElem
	)

happyReduce_30 = happySpecReduce_1  8 happyReduction_30
happyReduction_30 (HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn8
		 (happy_var_1
	)
happyReduction_30 _  = notHappyAtAll 

happyReduce_31 = happyReduce 4 9 happyReduction_31
happyReduction_31 (_ `HappyStk`
	(HappyAbsSyn7  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn6  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn9
		 ([(happy_var_1, happy_var_3)]
	) `HappyStk` happyRest

happyReduce_32 = happyReduce 6 9 happyReduction_32
happyReduction_32 ((HappyAbsSyn9  happy_var_6) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn7  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn6  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn9
		 ((happy_var_1, happy_var_3) : happy_var_6
	) `HappyStk` happyRest

happyReduce_33 = happyReduce 4 10 happyReduction_33
happyReduction_33 (_ `HappyStk`
	(HappyAbsSyn11  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn6  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (Base happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_34 = happyReduce 6 10 happyReduction_34
happyReduction_34 ((HappyAbsSyn10  happy_var_6) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn11  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn6  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (OrCond happy_var_1 happy_var_3 happy_var_6
	) `HappyStk` happyRest

happyReduce_35 = happyReduce 6 10 happyReduction_35
happyReduction_35 ((HappyAbsSyn10  happy_var_6) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn11  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn6  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (AndCond happy_var_1 happy_var_3 happy_var_6
	) `HappyStk` happyRest

happyReduce_36 = happySpecReduce_1  11 happyReduction_36
happyReduction_36 (HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn11
		 (InnerBase happy_var_1
	)
happyReduction_36 _  = notHappyAtAll 

happyReduce_37 = happySpecReduce_3  11 happyReduction_37
happyReduction_37 (HappyAbsSyn11  happy_var_3)
	_
	(HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn11
		 (InnerOr (InnerBase happy_var_1) happy_var_3
	)
happyReduction_37 _ _ _  = notHappyAtAll 

happyReduce_38 = happySpecReduce_3  11 happyReduction_38
happyReduction_38 (HappyAbsSyn11  happy_var_3)
	_
	(HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn11
		 (InnerAnd (InnerBase happy_var_1) happy_var_3
	)
happyReduction_38 _ _ _  = notHappyAtAll 

happyReduce_39 = happySpecReduce_1  12 happyReduction_39
happyReduction_39 _
	 =  HappyAbsSyn12
		 (Or
	)

happyReduce_40 = happySpecReduce_1  12 happyReduction_40
happyReduction_40 _
	 =  HappyAbsSyn12
		 (And
	)

happyReduce_41 = happySpecReduce_1  13 happyReduction_41
happyReduction_41 _
	 =  HappyAbsSyn13
		 (TrueElem
	)

happyReduce_42 = happySpecReduce_1  13 happyReduction_42
happyReduction_42 _
	 =  HappyAbsSyn13
		 (FalseElem
	)

happyReduce_43 = happySpecReduce_3  13 happyReduction_43
happyReduction_43 (HappyTerminal (IntToken _ happy_var_3))
	_
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn13
		 (LTCond happy_var_1 happy_var_3
	)
happyReduction_43 _ _ _  = notHappyAtAll 

happyReduce_44 = happySpecReduce_3  13 happyReduction_44
happyReduction_44 (HappyTerminal (IntToken _ happy_var_3))
	_
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn13
		 (GTCond happy_var_1 happy_var_3
	)
happyReduction_44 _ _ _  = notHappyAtAll 

happyReduce_45 = happySpecReduce_3  13 happyReduction_45
happyReduction_45 (HappyTerminal (IntToken _ happy_var_3))
	_
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn13
		 (LTECond happy_var_1 happy_var_3
	)
happyReduction_45 _ _ _  = notHappyAtAll 

happyReduce_46 = happySpecReduce_3  13 happyReduction_46
happyReduction_46 (HappyTerminal (IntToken _ happy_var_3))
	_
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn13
		 (GTECond happy_var_1 happy_var_3
	)
happyReduction_46 _ _ _  = notHappyAtAll 

happyReduce_47 = happySpecReduce_3  13 happyReduction_47
happyReduction_47 (HappyTerminal (IntToken _ happy_var_3))
	_
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn13
		 (ECond happy_var_1 happy_var_3
	)
happyReduction_47 _ _ _  = notHappyAtAll 

happyReduce_48 = happySpecReduce_1  13 happyReduction_48
happyReduction_48 (HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn13
		 (happy_var_1
	)
happyReduction_48 _  = notHappyAtAll 

happyReduce_49 = happySpecReduce_1  14 happyReduction_49
happyReduction_49 _
	 =  HappyAbsSyn14
		 (Subject
	)

happyReduce_50 = happySpecReduce_1  14 happyReduction_50
happyReduction_50 _
	 =  HappyAbsSyn14
		 (Predicate
	)

happyReduce_51 = happySpecReduce_1  14 happyReduction_51
happyReduction_51 _
	 =  HappyAbsSyn14
		 (Object
	)

happyReduce_52 = happySpecReduce_3  14 happyReduction_52
happyReduction_52 (HappyAbsSyn6  happy_var_3)
	_
	_
	 =  HappyAbsSyn14
		 (SubjectIn happy_var_3
	)
happyReduction_52 _ _ _  = notHappyAtAll 

happyReduce_53 = happySpecReduce_3  14 happyReduction_53
happyReduction_53 (HappyAbsSyn6  happy_var_3)
	_
	_
	 =  HappyAbsSyn14
		 (PredicateIn happy_var_3
	)
happyReduction_53 _ _ _  = notHappyAtAll 

happyReduce_54 = happySpecReduce_3  14 happyReduction_54
happyReduction_54 (HappyAbsSyn6  happy_var_3)
	_
	_
	 =  HappyAbsSyn14
		 (ObjectIn happy_var_3
	)
happyReduction_54 _ _ _  = notHappyAtAll 

happyReduce_55 = happySpecReduce_3  14 happyReduction_55
happyReduction_55 (HappyTerminal (IntToken _ happy_var_3))
	_
	_
	 =  HappyAbsSyn14
		 (SubjectPlus happy_var_3
	)
happyReduction_55 _ _ _  = notHappyAtAll 

happyReduce_56 = happySpecReduce_3  14 happyReduction_56
happyReduction_56 (HappyTerminal (IntToken _ happy_var_3))
	_
	_
	 =  HappyAbsSyn14
		 (PredicatePlus happy_var_3
	)
happyReduction_56 _ _ _  = notHappyAtAll 

happyReduce_57 = happySpecReduce_3  14 happyReduction_57
happyReduction_57 (HappyTerminal (IntToken _ happy_var_3))
	_
	_
	 =  HappyAbsSyn14
		 (ObjectPlus happy_var_3
	)
happyReduction_57 _ _ _  = notHappyAtAll 

happyReduce_58 = happySpecReduce_3  14 happyReduction_58
happyReduction_58 (HappyTerminal (IntToken _ happy_var_3))
	_
	_
	 =  HappyAbsSyn14
		 (SubjectMinus happy_var_3
	)
happyReduction_58 _ _ _  = notHappyAtAll 

happyReduce_59 = happySpecReduce_3  14 happyReduction_59
happyReduction_59 (HappyTerminal (IntToken _ happy_var_3))
	_
	_
	 =  HappyAbsSyn14
		 (PredicateMinus happy_var_3
	)
happyReduction_59 _ _ _  = notHappyAtAll 

happyReduce_60 = happySpecReduce_3  14 happyReduction_60
happyReduction_60 (HappyTerminal (IntToken _ happy_var_3))
	_
	_
	 =  HappyAbsSyn14
		 (ObjectMinus happy_var_3
	)
happyReduction_60 _ _ _  = notHappyAtAll 

happyNewToken action sts stk [] =
	action 53 53 notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	IntToken _ happy_dollar_dollar -> cont 15;
	VarToken _ happy_dollar_dollar -> cont 16;
	ImportToken _ -> cont 17;
	ExportToken _ -> cont 18;
	IntoToken _ -> cont 19;
	WriteToken _ -> cont 20;
	WriteTrueToken _ -> cont 21;
	WriteFalseToken _ -> cont 22;
	WhereToken _ -> cont 23;
	InToken _ -> cont 24;
	AsToken _ -> cont 25;
	GetToken _ -> cont 26;
	AndToken _ -> cont 27;
	OrToken _ -> cont 28;
	IfToken _ -> cont 29;
	ThenToken _ -> cont 30;
	ElseToken _ -> cont 31;
	SubjectToken _ -> cont 32;
	PredicateToken _ -> cont 33;
	ObjectToken _ -> cont 34;
	TrueToken _ -> cont 35;
	FalseToken _ -> cont 36;
	NothingGToken _ -> cont 37;
	SemiColonToken _ -> cont 38;
	CurLToken _ -> cont 39;
	CurRToken _ -> cont 40;
	AngBracketLToken _ -> cont 41;
	AngBracketRToken _ -> cont 42;
	LessThanEqualToken _ -> cont 43;
	MoreThanEqualToken _ -> cont 44;
	EqualsToken _ -> cont 45;
	PlusToken _ -> cont 46;
	MinusToken _ -> cont 47;
	ParenRToken _ -> cont 48;
	ParenLToken _ -> cont 49;
	BracketLToken _ -> cont 50;
	BracketRToken _ -> cont 51;
	CommaToken _ -> cont 52;
	_ -> happyError' ((tk:tks), [])
	}

happyError_ explist 53 tk tks = happyError' (tks, explist)
happyError_ explist _ tk tks = happyError' ((tk:tks), explist)

newtype HappyIdentity a = HappyIdentity a
happyIdentity = HappyIdentity
happyRunIdentity (HappyIdentity a) = a

instance Prelude.Functor HappyIdentity where
    fmap f (HappyIdentity a) = HappyIdentity (f a)

instance Applicative HappyIdentity where
    pure  = HappyIdentity
    (<*>) = ap
instance Prelude.Monad HappyIdentity where
    return = pure
    (HappyIdentity p) >>= q = q p

happyThen :: () => HappyIdentity a -> (a -> HappyIdentity b) -> HappyIdentity b
happyThen = (Prelude.>>=)
happyReturn :: () => a -> HappyIdentity a
happyReturn = (Prelude.return)
happyThen1 m k tks = (Prelude.>>=) m (\a -> k a tks)
happyReturn1 :: () => a -> b -> HappyIdentity a
happyReturn1 = \a tks -> (Prelude.return) a
happyError' :: () => ([(Token)], [Prelude.String]) -> HappyIdentity a
happyError' = HappyIdentity Prelude.. (\(tokens, _) -> parseError tokens)
parseCalc tks = happyRunIdentity happySomeParser where
 happySomeParser = happyThen (happyParse action_0 tks) (\x -> case x of {HappyAbsSyn4 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


parseError :: [Token] -> a
parseError [] = error "Unknown Parse Error - empty token list." 
parseError (t:ts) = error ("Parse error at line:column " ++ (tokenPosn t))

data Expr = Var String
          | AssignInt Int
          | NothingG
          | Import Expr Expr
          | ImportAs Expr Expr Expr
          | Into Expr Expr
          | Get [Expr] [(Expr, [Expr])]
          | Write [(Expr, [Expr])]
          | WriteTrue [(Expr, [Expr])]
          | WriteFalse [(Expr, [Expr])]
          | In Expr
          | As Expr
          | IfThenElse Expr Expr Expr
          | MoreThan Int Int 
          | LessThan Int Int  
          | Add Int Int 
          | Minus Int Int 
          | MoreThanEqual Int Int 
          | LessThanEqual Int Int 
          | Subject 
          | Predicate 
          | Object
          | PredicateIn Expr
          | SubjectIn Expr
          | ObjectIn Expr
          | FalseElem
          | TrueElem
          | And
          | Or
		  | FileLines [String]
          | StoreLines [(Bool,String)]
		  | Export Expr
          | LTCond Expr Int
          | LTECond Expr Int
          | GTCond Expr Int
          | GTECond Expr Int
          | ECond Expr Int
          | Base Expr Expr
          | OrCond Expr Expr Expr
          | AndCond Expr Expr Expr
          | InnerBase Expr
          | InnerOr Expr Expr
          | InnerAnd Expr Expr
          | SubjectPlus Int
          | PredicatePlus Int
          | ObjectPlus Int
          | SubjectMinus Int
          | PredicateMinus Int
          | ObjectMinus Int
  deriving (Eq,Show)
{-# LINE 1 "templates/GenericTemplate.hs" #-}
-- $Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp $










































data Happy_IntList = HappyCons Prelude.Int Happy_IntList








































infixr 9 `HappyStk`
data HappyStk a = HappyStk a (HappyStk a)

-----------------------------------------------------------------------------
-- starting the parse

happyParse start_state = happyNewToken start_state notHappyAtAll notHappyAtAll

-----------------------------------------------------------------------------
-- Accepting the parse

-- If the current token is ERROR_TOK, it means we've just accepted a partial
-- parse (a %partial parser).  We must ignore the saved token on the top of
-- the stack in this case.
happyAccept (1) tk st sts (_ `HappyStk` ans `HappyStk` _) =
        happyReturn1 ans
happyAccept j tk st sts (HappyStk ans _) = 
         (happyReturn1 ans)

-----------------------------------------------------------------------------
-- Arrays only: do the next action









































indexShortOffAddr arr off = arr Happy_Data_Array.! off


{-# INLINE happyLt #-}
happyLt x y = (x Prelude.< y)






readArrayBit arr bit =
    Bits.testBit (indexShortOffAddr arr (bit `Prelude.div` 16)) (bit `Prelude.mod` 16)






-----------------------------------------------------------------------------
-- HappyState data type (not arrays)



newtype HappyState b c = HappyState
        (Prelude.Int ->                    -- token number
         Prelude.Int ->                    -- token number (yes, again)
         b ->                           -- token semantic value
         HappyState b c ->              -- current state
         [HappyState b c] ->            -- state stack
         c)



-----------------------------------------------------------------------------
-- Shifting a token

happyShift new_state (1) tk st sts stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--     trace "shifting the error token" $
     new_state i i tk (HappyState (new_state)) ((st):(sts)) (stk)

happyShift new_state i tk st sts stk =
     happyNewToken new_state ((st):(sts)) ((HappyTerminal (tk))`HappyStk`stk)

-- happyReduce is specialised for the common cases.

happySpecReduce_0 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_0 nt fn j tk st@((HappyState (action))) sts stk
     = action nt j tk st ((st):(sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@(((st@(HappyState (action))):(_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_2 nt fn j tk _ ((_):(sts@(((st@(HappyState (action))):(_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_3 nt fn j tk _ ((_):(((_):(sts@(((st@(HappyState (action))):(_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k Prelude.- ((1) :: Prelude.Int)) sts of
         sts1@(((st1@(HappyState (action))):(_))) ->
                let r = fn stk in  -- it doesn't hurt to always seq here...
                happyDoSeq r (action nt j tk st1 sts1 r)

happyMonadReduce k nt fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
          let drop_stk = happyDropStk k stk in
          happyThen1 (fn stk tk) (\r -> action nt j tk st1 sts1 (r `HappyStk` drop_stk))

happyMonad2Reduce k nt fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
         let drop_stk = happyDropStk k stk





             _ = nt :: Prelude.Int
             new_state = action

          in
          happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))

happyDrop (0) l = l
happyDrop n ((_):(t)) = happyDrop (n Prelude.- ((1) :: Prelude.Int)) t

happyDropStk (0) l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n Prelude.- ((1)::Prelude.Int)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction









happyGoto action j tk st = action j j tk (HappyState action)


-----------------------------------------------------------------------------
-- Error recovery (ERROR_TOK is the error token)

-- parse error if we are in recovery and we fail again
happyFail explist (1) tk old_st _ stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--      trace "failing" $ 
        happyError_ explist i tk

{-  We don't need state discarding for our restricted implementation of
    "error".  In fact, it can cause some bogus parses, so I've disabled it
    for now --SDM

-- discard a state
happyFail  ERROR_TOK tk old_st CONS(HAPPYSTATE(action),sts) 
                                                (saved_tok `HappyStk` _ `HappyStk` stk) =
--      trace ("discarding state, depth " ++ show (length stk))  $
        DO_ACTION(action,ERROR_TOK,tk,sts,(saved_tok`HappyStk`stk))
-}

-- Enter error recovery: generate an error token,
--                       save the old token and carry on.
happyFail explist i tk (HappyState (action)) sts stk =
--      trace "entering error recovery" $
        action (1) (1) tk (HappyState (action)) sts ((HappyErrorToken (i)) `HappyStk` stk)

-- Internal happy errors:

notHappyAtAll :: a
notHappyAtAll = Prelude.error "Internal Happy error\n"

-----------------------------------------------------------------------------
-- Hack to get the typechecker to accept our action functions







-----------------------------------------------------------------------------
-- Seq-ing.  If the --strict flag is given, then Happy emits 
--      happySeq = happyDoSeq
-- otherwise it emits
--      happySeq = happyDontSeq

happyDoSeq, happyDontSeq :: a -> b -> b
happyDoSeq   a b = a `Prelude.seq` b
happyDontSeq a b = b

-----------------------------------------------------------------------------
-- Don't inline any functions from the template.  GHC has a nasty habit
-- of deciding to inline happyGoto everywhere, which increases the size of
-- the generated parser quite a bit.









{-# NOINLINE happyShift #-}
{-# NOINLINE happySpecReduce_0 #-}
{-# NOINLINE happySpecReduce_1 #-}
{-# NOINLINE happySpecReduce_2 #-}
{-# NOINLINE happySpecReduce_3 #-}
{-# NOINLINE happyReduce #-}
{-# NOINLINE happyMonadReduce #-}
{-# NOINLINE happyGoto #-}
{-# NOINLINE happyFail #-}

-- end of Happy Template.
