main: alexComp happyComp mainComp
	alexComp
	happyComp
	mainComp

alexComp: Tokens.x Tokens.hs
	alex Tokens.x
	stack ghc Tokens.hs

happyComp: Grammar.y Grammar.hs
	happy Grammar.y
	stack ghc Grammar.hs

mainComp: Stql.hs
	stack ghc Stql.hs

clean: 
	rm Grammar.info Tokens.hi Tokens.o Grammar.o main.o main.hi .*.swp
