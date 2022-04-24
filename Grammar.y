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
  ';'         { SemiColonToken _ }
  '{'         { CurLToken _ }
  '}'         { CurRToken _ }
  '<'         { AngBracketLToken _ } 
  '>'         { AngBracketRToken _ }
  '<='        { LessThanEqualToken _ }
  '>='        { MoreThanEqualToken _ }
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
    | int                                                                   { AssignInt $1 }
    | GET '[' listElement ']' WHERE '{' compareLists '}'                    { Get $3 $7 }
    | IN exp                                                                { In $2 }
    | AS exp                                                                { As $2 } 
    | IMPORT exp AS exp                                                     { Import $2 $4 }
	| EXPORT exp                                                            { Export $2}
    | IF exp THEN exp ELSE exp                                              { IfThenElse $2 $4 $6 }
    | int '<' int                                                           { LessThan $1 $3 }
    | int '>' int                                                           { MoreThan $1 $3 }
    | int '+' int                                                           { Add $1 $3 }
    | int '-' int                                                           { Minus $1 $3 }
    | int '<=' int                                                          { LessThanEqual $1 $3 }
    | int '>=' int                                                          { MoreThanEqual $1 $3 }
    | '(' exp ')'                                                           { $2 }

listElement : listElementContent                                            { [$1] }
            | listElementContent ',' listElement                            { $1 : $3 }

listElementContent : subj                                                   { Subject }
                   | pred                                                   { Predicate }
                   | obj                                                    { Object }
                   | subj IN exp                                            { SubjectIn $3}
                   | pred IN exp                                            { PredicateIn $3 }
                   | obj IN exp                                             { ObjectIn $3}
                   | true                                                   { TrueElem }
                   | false                                                  { FalseElem }
                   | exp                                                    { $1 }

compareLists : exp '[' listElement ']'                                          { [($1, $3)] }
             | exp '[' listElement ']' comparison compareLists                  { ($1, $3) : $6 }

comparison : OR                                                             { Or }
           | AND                                                            { And }

{
parseError :: [Token] -> a
parseError [] = error "Unknown Parse Error - empty token list." 
parseError (t:ts) = error ("Parse error at line:column " ++ (tokenPosn t))

data Expr = Var String
          | AssignInt Int
          | Import Expr Expr
          | Into Expr Expr 
          | Get [Expr] [(Expr, [Expr])]
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
		  | Export Expr
  deriving (Eq,Show)
}
