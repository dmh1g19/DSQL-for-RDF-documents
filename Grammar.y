{
module Grammar where
import Tokens
}

%name parseCalc
%tokentype { Token }
%error { parseError }
%token
  int         { IntToken _ $$ }
  var         { VarToken _ $$ }
  IMPORT      { ImportToken _ }
  EXPORT      { ExportToken _}
  INTO        { IntoToken _ }
  WRITE       { WriteToken _ }
  WRITETRUE   { WriteTrueToken _ }
  WRITEFALSE  { WriteFalseToken _ }
  WHERE       { WhereToken _ }
  IN          { InToken _ }
  AS          { AsToken _ }
  GET         { GetToken _ }
  FROM        { FromToken _ }
  NOT         { NotToken _ }
  AND         { AndToken _ }
  OR          { OrToken _ }
  IF          { IfToken _ }
  THEN        { ThenToken _ }
  ELSE        { ElseToken _ }
  subj        { SubjectToken _ }
  pred        { PredicateToken _ }
  obj         { ObjectToken _ }
  true        { TrueToken _ }
  false       { FalseToken _ }
  NOTHING     { NothingGToken _}
  ';'         { SemiColonToken _ }
  '{'         { CurLToken _ }
  '}'         { CurRToken _ }
  '<'         { AngBracketLToken _ } 
  '>'         { AngBracketRToken _ }
  '<='        { LessThanEqualToken _ }
  '>='        { MoreThanEqualToken _ }
  '='        {EqualsToken _ }
  '!='        { NotEqualToken _ }
  '+'         { PlusToken _ }
  '-'         { MinusToken _ }
  '('         { ParenLToken _ }
  ')'         { ParenRToken _ }
  '['         { BracketLToken _ }
  ']'         { BracketRToken _ }
  ','         { CommaToken _ }

%%

stmts : stmt                                                                { [$1] }
      | stmts stmt                                                          { $2 : $1 }

stmt : exp ';'                                                              { $1 }

exp : INTO var exp                                                          { Into (Var $2) $3 }
    | var                                                                   { Var $1 }
    | NOTHING                                                               { NothingG }
    | int                                                                   { AssignInt $1 }
    | GET '[' listElement ']' WHERE '{' compareLists '}'                    { Get $3 $7 }
    | GET '[' listElement ']' FROM var                                      { Get $3 [(Var $6, $3)] }
    | WRITE '{' compareLists '}'                                            { Write $3}
    | WRITETRUE '{' compareLists '}'                                        { WriteTrue $3}
    | WRITEFALSE '{' compareLists '}'                                       { WriteFalse $3} 
    | IN exp                                                                { In $2 }
    | AS exp                                                                { As $2 } 
    | IMPORT var AS var                                                     { Import (Var $2) (Var $4) }
	| EXPORT var                                                            { Export (Var $2)}
    | IF '{' conditions '}' THEN exp ELSE exp                               { IfThenElse $3 $6 $8 }
    | int '<' int                                                           { LessThan $1 $3 }
    | int '>' int                                                           { MoreThan $1 $3 }
    | int '+' int                                                           { Add $1 $3 }
    | int '-' int                                                           { Minus $1 $3 }
    | int '<=' int                                                          { LessThanEqual $1 $3 }
    | int '>=' int                                                          { MoreThanEqual $1 $3 }
    | '(' exp ')'                                                           { $2 }

number : int                                                                { $1 }
       | '-' int                                                            { negate $2 }

listElement : listElementContent                                            { [$1] }
            | listElementContent ',' listElement                            { $1 : $3 }

listElementContent : triple                                                 { $1 }
                   | '-' int                                                { AssignInt (negate $2) }
                   | true                                                   { TrueElem }
                   | false                                                  { FalseElem }
                   | exp                                                    { $1 }

compareLists : var '[' listElement ']'                                          { [(Var $1, $3)] }
             | var '[' listElement ']' comparison compareLists                  { (Var $1, $3) : $6 }

conditions : var '[' condition ']'                                          { Base (Var $1) $3 }
           | var '[' condition ']' OR conditions                            { OrCond (Var $1) $3 $6}
           | var '[' condition ']' AND conditions                            { AndCond (Var $1) $3 $6}

condition : conditionStatement                                              { InnerBase $1}
          | conditionStatement OR condition                                 { InnerOr (InnerBase $1) $3}
          | conditionStatement AND condition                                { InnerAnd (InnerBase $1) $3}

comparison : OR                                                             { Or }
           | AND                                                            { And }

conditionStatement : true                                                   { TrueElem}
                   | false                                                  { FalseElem}
                   | triple '<' number                                         { LTCond $1 $3 }
                   | triple '>' number                                         { GTCond $1 $3 }
                   | triple '<=' number                                        { LTECond $1 $3 }
                   | triple '>=' number                                         { GTECond $1 $3 }
                   | triple '=' number                                         { ECond $1 $3 }
                   | triple '!=' number                                        { NECond $1 $3 }
                   | NOT conditionStatement                                 { NotCond $2 }

triple : subj                                                   { Subject }
       | pred                                                   { Predicate }
       | obj                                                    { Object }
       | subj IN var                                            { SubjectIn (Var $3) }
       | pred IN var                                            { PredicateIn (Var $3) }
       | obj IN var                                             { ObjectIn (Var $3) }
       | subj '+' number                                             { SubjectPlus $3}
       | pred '+' number                                            { PredicatePlus $3}
       | obj '+' number                                            { ObjectPlus $3}
       | subj '-' number                                             { SubjectMinus $3}
       | pred '-' number                                             { PredicateMinus $3}
       | obj '-' number                                             { ObjectMinus $3}
{
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
}
