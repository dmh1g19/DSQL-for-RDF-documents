{-# OPTIONS_GHC -w #-}
module Grammar where
import Tokens
import qualified Data.Array as Happy_Data_Array
import qualified Data.Bits as Bits
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.20.1.1

data HappyAbsSyn t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15
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
	| HappyAbsSyn15 t15

happyExpList :: Happy_Data_Array.Array Prelude.Int Prelude.Int
happyExpList = Happy_Data_Array.listArray (0,227) ([32768,34687,128,8,65280,270,4097,0,0,0,0,0,0,8,0,0,32768,103,0,0,0,0,64,0,0,32768,0,0,0,256,0,0,0,0,1024,0,0,0,8,0,0,4096,0,63488,2167,32776,0,61424,4112,256,0,0,0,8,0,0,1,0,0,0,0,65280,270,4097,0,7678,514,32,0,0,0,0,0,0,256,8192,0,0,0,57312,16161,768,0,0,0,0,0,0,0,0,2,0,0,1024,0,0,0,8,0,0,63488,2167,32776,0,0,0,0,0,128,0,0,64,0,0,32768,0,0,0,256,0,0,0,2,0,0,1024,0,0,0,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4096,0,0,0,0,0,0,0,0,256,0,0,0,4096,0,0,1024,0,0,0,8,0,0,0,0,0,0,0,2,0,0,2048,0,0,0,0,16384,0,384,0,128,0,3,0,1,1536,0,0,0,0,0,0,0,0,4,0,0,0,0,64,0,0,0,1024,0,0,0,0,0,15880,0,0,0,1,0,0,0,0,0,4,0,0,1024,0,8192,0,8,0,64,8192,0,0,0,32,0,256,16384,0,0,2,256,0,0,0,1,0,8,512,0,4096,0,15356,2020,96,0,136,0,0,0,0,0,0,0,0,0,49088,32323,1536,0,0,0,0,0,0,0,0,0,0,256,0,0,16,0,16,0,0,0,0,0,0,0,0,0,0,0,0,0,128,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,65280,270,4097,0,0,0,256,0,768,0,0,0,32768,31,0,33280,15,0,0,0,0,0,0,0,0,0,0,0,0,1,0,8,512,0,4096,0,4,0,32,2048,0,16384,0,16,0,128,8192,0,0,1,0,15880,0,0,4096,124,0,0,192,0,0,0,8,0,0,0,0,0,0,0,0,8192,0,0,0,0,24,0,32768,0,0,0,0,0,0,0,0,0,0,0,0,16,0,15356,1028,64,4096,0,0,0,32,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	])

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_parseCalc","stmts","stmt","exp","number","listElement","listElementContent","compareLists","conditions","condition","comparison","conditionStatement","triple","int","var","IMPORT","EXPORT","INTO","WRITE","WRITETRUE","WRITEFALSE","WHERE","IN","AS","GET","FROM","NOT","AND","OR","IF","THEN","ELSE","subj","pred","obj","true","false","NOTHING","';'","'{'","'}'","'<'","'>'","'<='","'>='","'='","'!='","'+'","'-'","'('","')'","'['","']'","','","%eof"]
        bit_start = st Prelude.* 57
        bit_end = (st Prelude.+ 1) Prelude.* 57
        read_bit = readArrayBit happyExpList
        bits = Prelude.map read_bit [bit_start..bit_end Prelude.- 1]
        bits_indexed = Prelude.zip bits [0..56]
        token_strs_expected = Prelude.concatMap f bits_indexed
        f (Prelude.False, _) = []
        f (Prelude.True, nr) = [token_strs Prelude.!! nr]

action_0 (16) = happyShift action_4
action_0 (17) = happyShift action_5
action_0 (18) = happyShift action_6
action_0 (19) = happyShift action_7
action_0 (20) = happyShift action_8
action_0 (21) = happyShift action_9
action_0 (22) = happyShift action_10
action_0 (23) = happyShift action_11
action_0 (25) = happyShift action_12
action_0 (26) = happyShift action_13
action_0 (27) = happyShift action_14
action_0 (32) = happyShift action_15
action_0 (40) = happyShift action_16
action_0 (52) = happyShift action_17
action_0 (4) = happyGoto action_18
action_0 (5) = happyGoto action_2
action_0 (6) = happyGoto action_3
action_0 _ = happyFail (happyExpListPerState 0)

action_1 (16) = happyShift action_4
action_1 (17) = happyShift action_5
action_1 (18) = happyShift action_6
action_1 (19) = happyShift action_7
action_1 (20) = happyShift action_8
action_1 (21) = happyShift action_9
action_1 (22) = happyShift action_10
action_1 (23) = happyShift action_11
action_1 (25) = happyShift action_12
action_1 (26) = happyShift action_13
action_1 (27) = happyShift action_14
action_1 (32) = happyShift action_15
action_1 (40) = happyShift action_16
action_1 (52) = happyShift action_17
action_1 (5) = happyGoto action_2
action_1 (6) = happyGoto action_3
action_1 _ = happyFail (happyExpListPerState 1)

action_2 _ = happyReduce_1

action_3 (41) = happyShift action_37
action_3 _ = happyFail (happyExpListPerState 3)

action_4 (44) = happyShift action_31
action_4 (45) = happyShift action_32
action_4 (46) = happyShift action_33
action_4 (47) = happyShift action_34
action_4 (50) = happyShift action_35
action_4 (51) = happyShift action_36
action_4 _ = happyReduce_7

action_5 _ = happyReduce_5

action_6 (17) = happyShift action_30
action_6 _ = happyFail (happyExpListPerState 6)

action_7 (17) = happyShift action_29
action_7 _ = happyFail (happyExpListPerState 7)

action_8 (17) = happyShift action_28
action_8 _ = happyFail (happyExpListPerState 8)

action_9 (42) = happyShift action_27
action_9 _ = happyFail (happyExpListPerState 9)

action_10 (42) = happyShift action_26
action_10 _ = happyFail (happyExpListPerState 10)

action_11 (42) = happyShift action_25
action_11 _ = happyFail (happyExpListPerState 11)

action_12 (16) = happyShift action_4
action_12 (17) = happyShift action_5
action_12 (18) = happyShift action_6
action_12 (19) = happyShift action_7
action_12 (20) = happyShift action_8
action_12 (21) = happyShift action_9
action_12 (22) = happyShift action_10
action_12 (23) = happyShift action_11
action_12 (25) = happyShift action_12
action_12 (26) = happyShift action_13
action_12 (27) = happyShift action_14
action_12 (32) = happyShift action_15
action_12 (40) = happyShift action_16
action_12 (52) = happyShift action_17
action_12 (6) = happyGoto action_24
action_12 _ = happyFail (happyExpListPerState 12)

action_13 (16) = happyShift action_4
action_13 (17) = happyShift action_5
action_13 (18) = happyShift action_6
action_13 (19) = happyShift action_7
action_13 (20) = happyShift action_8
action_13 (21) = happyShift action_9
action_13 (22) = happyShift action_10
action_13 (23) = happyShift action_11
action_13 (25) = happyShift action_12
action_13 (26) = happyShift action_13
action_13 (27) = happyShift action_14
action_13 (32) = happyShift action_15
action_13 (40) = happyShift action_16
action_13 (52) = happyShift action_17
action_13 (6) = happyGoto action_23
action_13 _ = happyFail (happyExpListPerState 13)

action_14 (54) = happyShift action_22
action_14 _ = happyFail (happyExpListPerState 14)

action_15 (42) = happyShift action_21
action_15 _ = happyFail (happyExpListPerState 15)

action_16 _ = happyReduce_6

action_17 (16) = happyShift action_4
action_17 (17) = happyShift action_5
action_17 (18) = happyShift action_6
action_17 (19) = happyShift action_7
action_17 (20) = happyShift action_8
action_17 (21) = happyShift action_9
action_17 (22) = happyShift action_10
action_17 (23) = happyShift action_11
action_17 (25) = happyShift action_12
action_17 (26) = happyShift action_13
action_17 (27) = happyShift action_14
action_17 (32) = happyShift action_15
action_17 (40) = happyShift action_16
action_17 (52) = happyShift action_17
action_17 (6) = happyGoto action_20
action_17 _ = happyFail (happyExpListPerState 17)

action_18 (16) = happyShift action_4
action_18 (17) = happyShift action_5
action_18 (18) = happyShift action_6
action_18 (19) = happyShift action_7
action_18 (20) = happyShift action_8
action_18 (21) = happyShift action_9
action_18 (22) = happyShift action_10
action_18 (23) = happyShift action_11
action_18 (25) = happyShift action_12
action_18 (26) = happyShift action_13
action_18 (27) = happyShift action_14
action_18 (32) = happyShift action_15
action_18 (40) = happyShift action_16
action_18 (52) = happyShift action_17
action_18 (57) = happyAccept
action_18 (5) = happyGoto action_19
action_18 (6) = happyGoto action_3
action_18 _ = happyFail (happyExpListPerState 18)

action_19 _ = happyReduce_2

action_20 (53) = happyShift action_62
action_20 _ = happyFail (happyExpListPerState 20)

action_21 (17) = happyShift action_61
action_21 (11) = happyGoto action_60
action_21 _ = happyFail (happyExpListPerState 21)

action_22 (16) = happyShift action_4
action_22 (17) = happyShift action_5
action_22 (18) = happyShift action_6
action_22 (19) = happyShift action_7
action_22 (20) = happyShift action_8
action_22 (21) = happyShift action_9
action_22 (22) = happyShift action_10
action_22 (23) = happyShift action_11
action_22 (25) = happyShift action_12
action_22 (26) = happyShift action_13
action_22 (27) = happyShift action_14
action_22 (32) = happyShift action_15
action_22 (35) = happyShift action_54
action_22 (36) = happyShift action_55
action_22 (37) = happyShift action_56
action_22 (38) = happyShift action_57
action_22 (39) = happyShift action_58
action_22 (40) = happyShift action_16
action_22 (51) = happyShift action_59
action_22 (52) = happyShift action_17
action_22 (6) = happyGoto action_50
action_22 (8) = happyGoto action_51
action_22 (9) = happyGoto action_52
action_22 (15) = happyGoto action_53
action_22 _ = happyFail (happyExpListPerState 22)

action_23 _ = happyReduce_14

action_24 _ = happyReduce_13

action_25 (17) = happyShift action_47
action_25 (10) = happyGoto action_49
action_25 _ = happyFail (happyExpListPerState 25)

action_26 (17) = happyShift action_47
action_26 (10) = happyGoto action_48
action_26 _ = happyFail (happyExpListPerState 26)

action_27 (17) = happyShift action_47
action_27 (10) = happyGoto action_46
action_27 _ = happyFail (happyExpListPerState 27)

action_28 (16) = happyShift action_4
action_28 (17) = happyShift action_5
action_28 (18) = happyShift action_6
action_28 (19) = happyShift action_7
action_28 (20) = happyShift action_8
action_28 (21) = happyShift action_9
action_28 (22) = happyShift action_10
action_28 (23) = happyShift action_11
action_28 (25) = happyShift action_12
action_28 (26) = happyShift action_13
action_28 (27) = happyShift action_14
action_28 (32) = happyShift action_15
action_28 (40) = happyShift action_16
action_28 (52) = happyShift action_17
action_28 (6) = happyGoto action_45
action_28 _ = happyFail (happyExpListPerState 28)

action_29 _ = happyReduce_16

action_30 (26) = happyShift action_44
action_30 _ = happyFail (happyExpListPerState 30)

action_31 (16) = happyShift action_43
action_31 _ = happyFail (happyExpListPerState 31)

action_32 (16) = happyShift action_42
action_32 _ = happyFail (happyExpListPerState 32)

action_33 (16) = happyShift action_41
action_33 _ = happyFail (happyExpListPerState 33)

action_34 (16) = happyShift action_40
action_34 _ = happyFail (happyExpListPerState 34)

action_35 (16) = happyShift action_39
action_35 _ = happyFail (happyExpListPerState 35)

action_36 (16) = happyShift action_38
action_36 _ = happyFail (happyExpListPerState 36)

action_37 _ = happyReduce_3

action_38 _ = happyReduce_21

action_39 _ = happyReduce_20

action_40 _ = happyReduce_23

action_41 _ = happyReduce_22

action_42 _ = happyReduce_19

action_43 _ = happyReduce_18

action_44 (17) = happyShift action_81
action_44 _ = happyFail (happyExpListPerState 44)

action_45 _ = happyReduce_4

action_46 (43) = happyShift action_80
action_46 _ = happyFail (happyExpListPerState 46)

action_47 (54) = happyShift action_79
action_47 _ = happyFail (happyExpListPerState 47)

action_48 (43) = happyShift action_78
action_48 _ = happyFail (happyExpListPerState 48)

action_49 (43) = happyShift action_77
action_49 _ = happyFail (happyExpListPerState 49)

action_50 _ = happyReduce_33

action_51 (55) = happyShift action_76
action_51 _ = happyFail (happyExpListPerState 51)

action_52 (56) = happyShift action_75
action_52 _ = happyReduce_27

action_53 _ = happyReduce_29

action_54 (25) = happyShift action_72
action_54 (50) = happyShift action_73
action_54 (51) = happyShift action_74
action_54 _ = happyReduce_53

action_55 (25) = happyShift action_69
action_55 (50) = happyShift action_70
action_55 (51) = happyShift action_71
action_55 _ = happyReduce_54

action_56 (25) = happyShift action_66
action_56 (50) = happyShift action_67
action_56 (51) = happyShift action_68
action_56 _ = happyReduce_55

action_57 _ = happyReduce_31

action_58 _ = happyReduce_32

action_59 (16) = happyShift action_65
action_59 _ = happyFail (happyExpListPerState 59)

action_60 (43) = happyShift action_64
action_60 _ = happyFail (happyExpListPerState 60)

action_61 (54) = happyShift action_63
action_61 _ = happyFail (happyExpListPerState 61)

action_62 _ = happyReduce_24

action_63 (29) = happyShift action_101
action_63 (35) = happyShift action_54
action_63 (36) = happyShift action_55
action_63 (37) = happyShift action_56
action_63 (38) = happyShift action_102
action_63 (39) = happyShift action_103
action_63 (12) = happyGoto action_98
action_63 (14) = happyGoto action_99
action_63 (15) = happyGoto action_100
action_63 _ = happyFail (happyExpListPerState 63)

action_64 (33) = happyShift action_97
action_64 _ = happyFail (happyExpListPerState 64)

action_65 _ = happyReduce_30

action_66 (17) = happyShift action_96
action_66 _ = happyFail (happyExpListPerState 66)

action_67 (16) = happyShift action_87
action_67 (51) = happyShift action_88
action_67 (7) = happyGoto action_95
action_67 _ = happyFail (happyExpListPerState 67)

action_68 (16) = happyShift action_87
action_68 (51) = happyShift action_88
action_68 (7) = happyGoto action_94
action_68 _ = happyFail (happyExpListPerState 68)

action_69 (17) = happyShift action_93
action_69 _ = happyFail (happyExpListPerState 69)

action_70 (16) = happyShift action_87
action_70 (51) = happyShift action_88
action_70 (7) = happyGoto action_92
action_70 _ = happyFail (happyExpListPerState 70)

action_71 (16) = happyShift action_87
action_71 (51) = happyShift action_88
action_71 (7) = happyGoto action_91
action_71 _ = happyFail (happyExpListPerState 71)

action_72 (17) = happyShift action_90
action_72 _ = happyFail (happyExpListPerState 72)

action_73 (16) = happyShift action_87
action_73 (51) = happyShift action_88
action_73 (7) = happyGoto action_89
action_73 _ = happyFail (happyExpListPerState 73)

action_74 (16) = happyShift action_87
action_74 (51) = happyShift action_88
action_74 (7) = happyGoto action_86
action_74 _ = happyFail (happyExpListPerState 74)

action_75 (16) = happyShift action_4
action_75 (17) = happyShift action_5
action_75 (18) = happyShift action_6
action_75 (19) = happyShift action_7
action_75 (20) = happyShift action_8
action_75 (21) = happyShift action_9
action_75 (22) = happyShift action_10
action_75 (23) = happyShift action_11
action_75 (25) = happyShift action_12
action_75 (26) = happyShift action_13
action_75 (27) = happyShift action_14
action_75 (32) = happyShift action_15
action_75 (35) = happyShift action_54
action_75 (36) = happyShift action_55
action_75 (37) = happyShift action_56
action_75 (38) = happyShift action_57
action_75 (39) = happyShift action_58
action_75 (40) = happyShift action_16
action_75 (51) = happyShift action_59
action_75 (52) = happyShift action_17
action_75 (6) = happyGoto action_50
action_75 (8) = happyGoto action_85
action_75 (9) = happyGoto action_52
action_75 (15) = happyGoto action_53
action_75 _ = happyFail (happyExpListPerState 75)

action_76 (24) = happyShift action_83
action_76 (28) = happyShift action_84
action_76 _ = happyFail (happyExpListPerState 76)

action_77 _ = happyReduce_12

action_78 _ = happyReduce_11

action_79 (16) = happyShift action_4
action_79 (17) = happyShift action_5
action_79 (18) = happyShift action_6
action_79 (19) = happyShift action_7
action_79 (20) = happyShift action_8
action_79 (21) = happyShift action_9
action_79 (22) = happyShift action_10
action_79 (23) = happyShift action_11
action_79 (25) = happyShift action_12
action_79 (26) = happyShift action_13
action_79 (27) = happyShift action_14
action_79 (32) = happyShift action_15
action_79 (35) = happyShift action_54
action_79 (36) = happyShift action_55
action_79 (37) = happyShift action_56
action_79 (38) = happyShift action_57
action_79 (39) = happyShift action_58
action_79 (40) = happyShift action_16
action_79 (51) = happyShift action_59
action_79 (52) = happyShift action_17
action_79 (6) = happyGoto action_50
action_79 (8) = happyGoto action_82
action_79 (9) = happyGoto action_52
action_79 (15) = happyGoto action_53
action_79 _ = happyFail (happyExpListPerState 79)

action_80 _ = happyReduce_10

action_81 _ = happyReduce_15

action_82 (55) = happyShift action_118
action_82 _ = happyFail (happyExpListPerState 82)

action_83 (42) = happyShift action_117
action_83 _ = happyFail (happyExpListPerState 83)

action_84 (17) = happyShift action_116
action_84 _ = happyFail (happyExpListPerState 84)

action_85 _ = happyReduce_28

action_86 _ = happyReduce_62

action_87 _ = happyReduce_25

action_88 (16) = happyShift action_115
action_88 _ = happyFail (happyExpListPerState 88)

action_89 _ = happyReduce_59

action_90 _ = happyReduce_56

action_91 _ = happyReduce_63

action_92 _ = happyReduce_60

action_93 _ = happyReduce_57

action_94 _ = happyReduce_64

action_95 _ = happyReduce_61

action_96 _ = happyReduce_58

action_97 (16) = happyShift action_4
action_97 (17) = happyShift action_5
action_97 (18) = happyShift action_6
action_97 (19) = happyShift action_7
action_97 (20) = happyShift action_8
action_97 (21) = happyShift action_9
action_97 (22) = happyShift action_10
action_97 (23) = happyShift action_11
action_97 (25) = happyShift action_12
action_97 (26) = happyShift action_13
action_97 (27) = happyShift action_14
action_97 (32) = happyShift action_15
action_97 (40) = happyShift action_16
action_97 (52) = happyShift action_17
action_97 (6) = happyGoto action_114
action_97 _ = happyFail (happyExpListPerState 97)

action_98 (55) = happyShift action_113
action_98 _ = happyFail (happyExpListPerState 98)

action_99 (30) = happyShift action_111
action_99 (31) = happyShift action_112
action_99 _ = happyReduce_39

action_100 (44) = happyShift action_105
action_100 (45) = happyShift action_106
action_100 (46) = happyShift action_107
action_100 (47) = happyShift action_108
action_100 (48) = happyShift action_109
action_100 (49) = happyShift action_110
action_100 _ = happyFail (happyExpListPerState 100)

action_101 (29) = happyShift action_101
action_101 (35) = happyShift action_54
action_101 (36) = happyShift action_55
action_101 (37) = happyShift action_56
action_101 (38) = happyShift action_102
action_101 (39) = happyShift action_103
action_101 (14) = happyGoto action_104
action_101 (15) = happyGoto action_100
action_101 _ = happyFail (happyExpListPerState 101)

action_102 _ = happyReduce_44

action_103 _ = happyReduce_45

action_104 _ = happyReduce_52

action_105 (16) = happyShift action_87
action_105 (51) = happyShift action_88
action_105 (7) = happyGoto action_133
action_105 _ = happyFail (happyExpListPerState 105)

action_106 (16) = happyShift action_87
action_106 (51) = happyShift action_88
action_106 (7) = happyGoto action_132
action_106 _ = happyFail (happyExpListPerState 106)

action_107 (16) = happyShift action_87
action_107 (51) = happyShift action_88
action_107 (7) = happyGoto action_131
action_107 _ = happyFail (happyExpListPerState 107)

action_108 (16) = happyShift action_87
action_108 (51) = happyShift action_88
action_108 (7) = happyGoto action_130
action_108 _ = happyFail (happyExpListPerState 108)

action_109 (16) = happyShift action_87
action_109 (51) = happyShift action_88
action_109 (7) = happyGoto action_129
action_109 _ = happyFail (happyExpListPerState 109)

action_110 (16) = happyShift action_87
action_110 (51) = happyShift action_88
action_110 (7) = happyGoto action_128
action_110 _ = happyFail (happyExpListPerState 110)

action_111 (29) = happyShift action_101
action_111 (35) = happyShift action_54
action_111 (36) = happyShift action_55
action_111 (37) = happyShift action_56
action_111 (38) = happyShift action_102
action_111 (39) = happyShift action_103
action_111 (12) = happyGoto action_127
action_111 (14) = happyGoto action_99
action_111 (15) = happyGoto action_100
action_111 _ = happyFail (happyExpListPerState 111)

action_112 (29) = happyShift action_101
action_112 (35) = happyShift action_54
action_112 (36) = happyShift action_55
action_112 (37) = happyShift action_56
action_112 (38) = happyShift action_102
action_112 (39) = happyShift action_103
action_112 (12) = happyGoto action_126
action_112 (14) = happyGoto action_99
action_112 (15) = happyGoto action_100
action_112 _ = happyFail (happyExpListPerState 112)

action_113 (30) = happyShift action_124
action_113 (31) = happyShift action_125
action_113 _ = happyReduce_36

action_114 (34) = happyShift action_123
action_114 _ = happyFail (happyExpListPerState 114)

action_115 _ = happyReduce_26

action_116 _ = happyReduce_9

action_117 (17) = happyShift action_47
action_117 (10) = happyGoto action_122
action_117 _ = happyFail (happyExpListPerState 117)

action_118 (30) = happyShift action_120
action_118 (31) = happyShift action_121
action_118 (13) = happyGoto action_119
action_118 _ = happyReduce_34

action_119 (17) = happyShift action_47
action_119 (10) = happyGoto action_138
action_119 _ = happyFail (happyExpListPerState 119)

action_120 _ = happyReduce_43

action_121 _ = happyReduce_42

action_122 (43) = happyShift action_137
action_122 _ = happyFail (happyExpListPerState 122)

action_123 (16) = happyShift action_4
action_123 (17) = happyShift action_5
action_123 (18) = happyShift action_6
action_123 (19) = happyShift action_7
action_123 (20) = happyShift action_8
action_123 (21) = happyShift action_9
action_123 (22) = happyShift action_10
action_123 (23) = happyShift action_11
action_123 (25) = happyShift action_12
action_123 (26) = happyShift action_13
action_123 (27) = happyShift action_14
action_123 (32) = happyShift action_15
action_123 (40) = happyShift action_16
action_123 (52) = happyShift action_17
action_123 (6) = happyGoto action_136
action_123 _ = happyFail (happyExpListPerState 123)

action_124 (17) = happyShift action_61
action_124 (11) = happyGoto action_135
action_124 _ = happyFail (happyExpListPerState 124)

action_125 (17) = happyShift action_61
action_125 (11) = happyGoto action_134
action_125 _ = happyFail (happyExpListPerState 125)

action_126 _ = happyReduce_40

action_127 _ = happyReduce_41

action_128 _ = happyReduce_51

action_129 _ = happyReduce_50

action_130 _ = happyReduce_49

action_131 _ = happyReduce_48

action_132 _ = happyReduce_47

action_133 _ = happyReduce_46

action_134 _ = happyReduce_37

action_135 _ = happyReduce_38

action_136 _ = happyReduce_17

action_137 _ = happyReduce_8

action_138 _ = happyReduce_35

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
	(HappyTerminal (VarToken _ happy_var_2))
	_
	 =  HappyAbsSyn6
		 (Into (Var happy_var_2) happy_var_3
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
	(HappyAbsSyn10  happy_var_7) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn8  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (Get happy_var_3 happy_var_7
	) `HappyStk` happyRest

happyReduce_9 = happyReduce 6 6 happyReduction_9
happyReduction_9 ((HappyTerminal (VarToken _ happy_var_6)) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn8  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (Get happy_var_3 [(Var happy_var_6, happy_var_3)]
	) `HappyStk` happyRest

happyReduce_10 = happyReduce 4 6 happyReduction_10
happyReduction_10 (_ `HappyStk`
	(HappyAbsSyn10  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (Write happy_var_3
	) `HappyStk` happyRest

happyReduce_11 = happyReduce 4 6 happyReduction_11
happyReduction_11 (_ `HappyStk`
	(HappyAbsSyn10  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (WriteTrue happy_var_3
	) `HappyStk` happyRest

happyReduce_12 = happyReduce 4 6 happyReduction_12
happyReduction_12 (_ `HappyStk`
	(HappyAbsSyn10  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (WriteFalse happy_var_3
	) `HappyStk` happyRest

happyReduce_13 = happySpecReduce_2  6 happyReduction_13
happyReduction_13 (HappyAbsSyn6  happy_var_2)
	_
	 =  HappyAbsSyn6
		 (In happy_var_2
	)
happyReduction_13 _ _  = notHappyAtAll 

happyReduce_14 = happySpecReduce_2  6 happyReduction_14
happyReduction_14 (HappyAbsSyn6  happy_var_2)
	_
	 =  HappyAbsSyn6
		 (As happy_var_2
	)
happyReduction_14 _ _  = notHappyAtAll 

happyReduce_15 = happyReduce 4 6 happyReduction_15
happyReduction_15 ((HappyTerminal (VarToken _ happy_var_4)) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (VarToken _ happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (Import (Var happy_var_2) (Var happy_var_4)
	) `HappyStk` happyRest

happyReduce_16 = happySpecReduce_2  6 happyReduction_16
happyReduction_16 (HappyTerminal (VarToken _ happy_var_2))
	_
	 =  HappyAbsSyn6
		 (Export (Var happy_var_2)
	)
happyReduction_16 _ _  = notHappyAtAll 

happyReduce_17 = happyReduce 8 6 happyReduction_17
happyReduction_17 ((HappyAbsSyn6  happy_var_8) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn6  happy_var_6) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn11  happy_var_3) `HappyStk`
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
happyReduction_25 (HappyTerminal (IntToken _ happy_var_1))
	 =  HappyAbsSyn7
		 (happy_var_1
	)
happyReduction_25 _  = notHappyAtAll 

happyReduce_26 = happySpecReduce_2  7 happyReduction_26
happyReduction_26 (HappyTerminal (IntToken _ happy_var_2))
	_
	 =  HappyAbsSyn7
		 (negate happy_var_2
	)
happyReduction_26 _ _  = notHappyAtAll 

happyReduce_27 = happySpecReduce_1  8 happyReduction_27
happyReduction_27 (HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn8
		 ([happy_var_1]
	)
happyReduction_27 _  = notHappyAtAll 

happyReduce_28 = happySpecReduce_3  8 happyReduction_28
happyReduction_28 (HappyAbsSyn8  happy_var_3)
	_
	(HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn8
		 (happy_var_1 : happy_var_3
	)
happyReduction_28 _ _ _  = notHappyAtAll 

happyReduce_29 = happySpecReduce_1  9 happyReduction_29
happyReduction_29 (HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn9
		 (happy_var_1
	)
happyReduction_29 _  = notHappyAtAll 

happyReduce_30 = happySpecReduce_2  9 happyReduction_30
happyReduction_30 (HappyTerminal (IntToken _ happy_var_2))
	_
	 =  HappyAbsSyn9
		 (AssignInt (negate happy_var_2)
	)
happyReduction_30 _ _  = notHappyAtAll 

happyReduce_31 = happySpecReduce_1  9 happyReduction_31
happyReduction_31 _
	 =  HappyAbsSyn9
		 (TrueElem
	)

happyReduce_32 = happySpecReduce_1  9 happyReduction_32
happyReduction_32 _
	 =  HappyAbsSyn9
		 (FalseElem
	)

happyReduce_33 = happySpecReduce_1  9 happyReduction_33
happyReduction_33 (HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn9
		 (happy_var_1
	)
happyReduction_33 _  = notHappyAtAll 

happyReduce_34 = happyReduce 4 10 happyReduction_34
happyReduction_34 (_ `HappyStk`
	(HappyAbsSyn8  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (VarToken _ happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 ([(Var happy_var_1, happy_var_3)]
	) `HappyStk` happyRest

happyReduce_35 = happyReduce 6 10 happyReduction_35
happyReduction_35 ((HappyAbsSyn10  happy_var_6) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn8  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (VarToken _ happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 ((Var happy_var_1, happy_var_3) : happy_var_6
	) `HappyStk` happyRest

happyReduce_36 = happyReduce 4 11 happyReduction_36
happyReduction_36 (_ `HappyStk`
	(HappyAbsSyn12  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (VarToken _ happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn11
		 (Base (Var happy_var_1) happy_var_3
	) `HappyStk` happyRest

happyReduce_37 = happyReduce 6 11 happyReduction_37
happyReduction_37 ((HappyAbsSyn11  happy_var_6) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn12  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (VarToken _ happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn11
		 (OrCond (Var happy_var_1) happy_var_3 happy_var_6
	) `HappyStk` happyRest

happyReduce_38 = happyReduce 6 11 happyReduction_38
happyReduction_38 ((HappyAbsSyn11  happy_var_6) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn12  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (VarToken _ happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn11
		 (AndCond (Var happy_var_1) happy_var_3 happy_var_6
	) `HappyStk` happyRest

happyReduce_39 = happySpecReduce_1  12 happyReduction_39
happyReduction_39 (HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn12
		 (InnerBase happy_var_1
	)
happyReduction_39 _  = notHappyAtAll 

happyReduce_40 = happySpecReduce_3  12 happyReduction_40
happyReduction_40 (HappyAbsSyn12  happy_var_3)
	_
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn12
		 (InnerOr (InnerBase happy_var_1) happy_var_3
	)
happyReduction_40 _ _ _  = notHappyAtAll 

happyReduce_41 = happySpecReduce_3  12 happyReduction_41
happyReduction_41 (HappyAbsSyn12  happy_var_3)
	_
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn12
		 (InnerAnd (InnerBase happy_var_1) happy_var_3
	)
happyReduction_41 _ _ _  = notHappyAtAll 

happyReduce_42 = happySpecReduce_1  13 happyReduction_42
happyReduction_42 _
	 =  HappyAbsSyn13
		 (Or
	)

happyReduce_43 = happySpecReduce_1  13 happyReduction_43
happyReduction_43 _
	 =  HappyAbsSyn13
		 (And
	)

happyReduce_44 = happySpecReduce_1  14 happyReduction_44
happyReduction_44 _
	 =  HappyAbsSyn14
		 (TrueElem
	)

happyReduce_45 = happySpecReduce_1  14 happyReduction_45
happyReduction_45 _
	 =  HappyAbsSyn14
		 (FalseElem
	)

happyReduce_46 = happySpecReduce_3  14 happyReduction_46
happyReduction_46 (HappyAbsSyn7  happy_var_3)
	_
	(HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn14
		 (LTCond happy_var_1 happy_var_3
	)
happyReduction_46 _ _ _  = notHappyAtAll 

happyReduce_47 = happySpecReduce_3  14 happyReduction_47
happyReduction_47 (HappyAbsSyn7  happy_var_3)
	_
	(HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn14
		 (GTCond happy_var_1 happy_var_3
	)
happyReduction_47 _ _ _  = notHappyAtAll 

happyReduce_48 = happySpecReduce_3  14 happyReduction_48
happyReduction_48 (HappyAbsSyn7  happy_var_3)
	_
	(HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn14
		 (LTECond happy_var_1 happy_var_3
	)
happyReduction_48 _ _ _  = notHappyAtAll 

happyReduce_49 = happySpecReduce_3  14 happyReduction_49
happyReduction_49 (HappyAbsSyn7  happy_var_3)
	_
	(HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn14
		 (GTECond happy_var_1 happy_var_3
	)
happyReduction_49 _ _ _  = notHappyAtAll 

happyReduce_50 = happySpecReduce_3  14 happyReduction_50
happyReduction_50 (HappyAbsSyn7  happy_var_3)
	_
	(HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn14
		 (ECond happy_var_1 happy_var_3
	)
happyReduction_50 _ _ _  = notHappyAtAll 

happyReduce_51 = happySpecReduce_3  14 happyReduction_51
happyReduction_51 (HappyAbsSyn7  happy_var_3)
	_
	(HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn14
		 (NECond happy_var_1 happy_var_3
	)
happyReduction_51 _ _ _  = notHappyAtAll 

happyReduce_52 = happySpecReduce_2  14 happyReduction_52
happyReduction_52 (HappyAbsSyn14  happy_var_2)
	_
	 =  HappyAbsSyn14
		 (NotCond happy_var_2
	)
happyReduction_52 _ _  = notHappyAtAll 

happyReduce_53 = happySpecReduce_1  15 happyReduction_53
happyReduction_53 _
	 =  HappyAbsSyn15
		 (Subject
	)

happyReduce_54 = happySpecReduce_1  15 happyReduction_54
happyReduction_54 _
	 =  HappyAbsSyn15
		 (Predicate
	)

happyReduce_55 = happySpecReduce_1  15 happyReduction_55
happyReduction_55 _
	 =  HappyAbsSyn15
		 (Object
	)

happyReduce_56 = happySpecReduce_3  15 happyReduction_56
happyReduction_56 (HappyTerminal (VarToken _ happy_var_3))
	_
	_
	 =  HappyAbsSyn15
		 (SubjectIn (Var happy_var_3)
	)
happyReduction_56 _ _ _  = notHappyAtAll 

happyReduce_57 = happySpecReduce_3  15 happyReduction_57
happyReduction_57 (HappyTerminal (VarToken _ happy_var_3))
	_
	_
	 =  HappyAbsSyn15
		 (PredicateIn (Var happy_var_3)
	)
happyReduction_57 _ _ _  = notHappyAtAll 

happyReduce_58 = happySpecReduce_3  15 happyReduction_58
happyReduction_58 (HappyTerminal (VarToken _ happy_var_3))
	_
	_
	 =  HappyAbsSyn15
		 (ObjectIn (Var happy_var_3)
	)
happyReduction_58 _ _ _  = notHappyAtAll 

happyReduce_59 = happySpecReduce_3  15 happyReduction_59
happyReduction_59 (HappyAbsSyn7  happy_var_3)
	_
	_
	 =  HappyAbsSyn15
		 (SubjectPlus happy_var_3
	)
happyReduction_59 _ _ _  = notHappyAtAll 

happyReduce_60 = happySpecReduce_3  15 happyReduction_60
happyReduction_60 (HappyAbsSyn7  happy_var_3)
	_
	_
	 =  HappyAbsSyn15
		 (PredicatePlus happy_var_3
	)
happyReduction_60 _ _ _  = notHappyAtAll 

happyReduce_61 = happySpecReduce_3  15 happyReduction_61
happyReduction_61 (HappyAbsSyn7  happy_var_3)
	_
	_
	 =  HappyAbsSyn15
		 (ObjectPlus happy_var_3
	)
happyReduction_61 _ _ _  = notHappyAtAll 

happyReduce_62 = happySpecReduce_3  15 happyReduction_62
happyReduction_62 (HappyAbsSyn7  happy_var_3)
	_
	_
	 =  HappyAbsSyn15
		 (SubjectMinus happy_var_3
	)
happyReduction_62 _ _ _  = notHappyAtAll 

happyReduce_63 = happySpecReduce_3  15 happyReduction_63
happyReduction_63 (HappyAbsSyn7  happy_var_3)
	_
	_
	 =  HappyAbsSyn15
		 (PredicateMinus happy_var_3
	)
happyReduction_63 _ _ _  = notHappyAtAll 

happyReduce_64 = happySpecReduce_3  15 happyReduction_64
happyReduction_64 (HappyAbsSyn7  happy_var_3)
	_
	_
	 =  HappyAbsSyn15
		 (ObjectMinus happy_var_3
	)
happyReduction_64 _ _ _  = notHappyAtAll 

happyNewToken action sts stk [] =
	action 57 57 notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	IntToken _ happy_dollar_dollar -> cont 16;
	VarToken _ happy_dollar_dollar -> cont 17;
	ImportToken _ -> cont 18;
	ExportToken _ -> cont 19;
	IntoToken _ -> cont 20;
	WriteToken _ -> cont 21;
	WriteTrueToken _ -> cont 22;
	WriteFalseToken _ -> cont 23;
	WhereToken _ -> cont 24;
	InToken _ -> cont 25;
	AsToken _ -> cont 26;
	GetToken _ -> cont 27;
	FromToken _ -> cont 28;
	NotToken _ -> cont 29;
	AndToken _ -> cont 30;
	OrToken _ -> cont 31;
	IfToken _ -> cont 32;
	ThenToken _ -> cont 33;
	ElseToken _ -> cont 34;
	SubjectToken _ -> cont 35;
	PredicateToken _ -> cont 36;
	ObjectToken _ -> cont 37;
	TrueToken _ -> cont 38;
	FalseToken _ -> cont 39;
	NothingGToken _ -> cont 40;
	SemiColonToken _ -> cont 41;
	CurLToken _ -> cont 42;
	CurRToken _ -> cont 43;
	AngBracketLToken _ -> cont 44;
	AngBracketRToken _ -> cont 45;
	LessThanEqualToken _ -> cont 46;
	MoreThanEqualToken _ -> cont 47;
	EqualsToken _ -> cont 48;
	NotEqualToken _ -> cont 49;
	PlusToken _ -> cont 50;
	MinusToken _ -> cont 51;
	ParenLToken _ -> cont 52;
	ParenRToken _ -> cont 53;
	BracketLToken _ -> cont 54;
	BracketRToken _ -> cont 55;
	CommaToken _ -> cont 56;
	_ -> happyError' ((tk:tks), [])
	}

happyError_ explist 57 tk tks = happyError' (tks, explist)
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
          | NECond Expr Int
          | NotCond Expr
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
