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
  '+'         { PlusToken _ }
  '-'         { MinusToken _ }
  '('         { ParenRToken _ }
  ')'         { ParenLToken _ }
  '['         { BracketLToken _ }
  ']'         { BracketRToken _ }
  ','         { CommaToken _ }

-- Operations wiht lowest precedence are listed first
-- Operations with equal precedence are listed on the same line

%left in
%right '='
%nonassoc int var '(' ')'

%%

stmts : stmt                                                                { [$1] }
      | stmts stmt                                                          { $2 : $1 }

stmt : exp ';'                                                              { $1 }

exp : INTO exp exp                                                          { Into $2 $3 }
    | var                                                                   { Var $1 }
    | NOTHING                                                               { NothingG }
    | int                                                                   { AssignInt $1 }
    | GET '[' listElement ']' WHERE '{' compareLists '}'                    { Get $3 $7 }
    | WRITE '{' compareLists '}'                                            { Write $3}
    | WRITETRUE '{' compareLists '}'                                        { WriteTrue $3}
    | WRITEFALSE '{' compareLists '}'                                       { WriteFalse $3} 
    | IN exp                                                                { In $2 }
    | AS exp                                                                { As $2 } 
    | IMPORT exp AS exp                                                     { Import $2 $4 }
    | IMPORT exp AS exp '{' var '}'                                         { ImportAs $2 $4 (Var $6)}
	| EXPORT exp                                                            { Export $2}
    | IF '{' conditions '}' THEN exp ELSE exp                               { IfThenElse $3 $6 $8 }
    | int '<' int                                                           { LessThan $1 $3 }
    | int '>' int                                                           { MoreThan $1 $3 }
    | int '+' int                                                           { Add $1 $3 }
    | int '-' int                                                           { Minus $1 $3 }
    | int '<=' int                                                          { LessThanEqual $1 $3 }
    | int '>=' int                                                          { MoreThanEqual $1 $3 }
    | '(' exp ')'                                                           { $2 }

listElement : listElementContent                                            { [$1] }
            | listElementContent ',' listElement                            { $1 : $3 }

listElementContent : triple                                                 { $1 }
                   | true                                                   { TrueElem }
                   | false                                                  { FalseElem }
                   | exp                                                    { $1 }

compareLists : exp '[' listElement ']'                                          { [($1, $3)] }
             | exp '[' listElement ']' comparison compareLists                  { ($1, $3) : $6 }

conditions : exp '[' condition ']'                                          { Base $1 $3 }
           | exp '[' condition ']' OR conditions                            { OrCond $1 $3 $6}
           | exp '[' condition ']' AND conditions                            { AndCond $1 $3 $6}

condition : conditionStatement                                              { InnerBase $1}
          | conditionStatement OR condition                                 { InnerOr (InnerBase $1) $3}
          | conditionStatement AND condition                                { InnerAnd (InnerBase $1) $3}

comparison : OR                                                             { Or }
           | AND                                                            { And }

conditionStatement : true                                                   { TrueElem}
                   | false                                                  { FalseElem}
                   | triple '<' int                                         { LTCond $1 $3 }
                   | triple '>' int                                         { GTCond $1 $3 }
                   | triple '<=' int                                        { LTECond $1 $3 }
                   | triple '>=' int                                         { GTECond $1 $3 }
                   | triple '=' int                                         { ECond $1 $3 }
                   | exp                                                    { $1 }

triple : subj                                                   { Subject }
       | pred                                                   { Predicate }
       | obj                                                    { Object }
       | subj IN exp                                            { SubjectIn $3}
       | pred IN exp                                            { PredicateIn $3 }
       | obj IN exp                                             { ObjectIn $3}
       | subj '+' int                                             { SubjectPlus $3}
       | pred '+' int                                            { PredicatePlus $3}
       | obj '+' int                                            { ObjectPlus $3}
       | subj '-' int                                             { SubjectMinus $3}
       | pred '-' int                                             { PredicateMinus $3}
       | obj '-' int                                             { ObjectMinus $3}
{
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
}
