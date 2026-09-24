# Build:  make
# Test:   make test    (runs tests/prN.stql and diffs the outN.ttl it writes
#                       against tests/expected/outN.ttl, then checks every
#                       program in tests/bad is rejected with a message, then
#                       repeats both checks through the in-memory evaluator
#                       the browser version uses)
# Report: make report  (regenerates rdf.pdf from README.md)
# Web:    make web     (builds the browser version with nix and GHCJS and puts
#                       the page, with rdf.pdf, in site/)
#         make serve   (serves site/ at http://localhost:8080)
#         make deploy  (builds, then publishes site/ with Firebase Hosting)
# Clean:  make clean

GHC      = ghc
RUNGHC   = runghc
ALEX     = alex
HAPPY    = happy
NIXBUILD = nix-build
PORT     = 8080

TESTS = 1 2 3 4 5 6 7 8 9 10 11 12 13

stql: Tokens.hs Grammar.hs Eval.hs Stql.hs
	$(GHC) -o stql Stql.hs

Tokens.hs: Tokens.x
	$(ALEX) $< -o $@

Grammar.hs: Grammar.y
	$(HAPPY) $< -o $@

test: stql
	@rm -rf .testrun; mkdir -p .testrun; cp tests/*.ttl tests/*.stql .testrun/; \
	fail=0; \
	for i in $(TESTS); do \
	  ( cd .testrun && ../stql pr$$i.stql >/dev/null ) || { echo "pr$$i ERROR"; fail=1; continue; }; \
	  if diff -q .testrun/out$$i.ttl tests/expected/out$$i.ttl >/dev/null 2>&1; then \
	    echo "pr$$i ok"; \
	  else \
	    echo "pr$$i FAILED"; fail=1; \
	  fi; \
	done; \
	cp tests/bad/*.stql .testrun/; \
	for f in tests/bad/*.stql; do \
	  b=`basename $$f`; \
	  if ( cd .testrun && ../stql $$b >/dev/null 2>msg ); then \
	    echo "bad/$$b FAILED (was accepted)"; fail=1; \
	  elif [ ! -s .testrun/msg ]; then \
	    echo "bad/$$b FAILED (no message on stderr)"; fail=1; \
	  else \
	    echo "bad/$$b ok (rejected)"; \
	  fi; \
	done; \
	( cd tests && $(RUNGHC) -i.. InMemoryTest.hs $(TESTS) ) || fail=1; \
	rm -rf .testrun; exit $$fail

report: README.md mkreport.py
	python3 mkreport.py

web/Examples.hs: web/examples.json web/mkexamples.py tests/*.stql tests/*.ttl
	python3 web/mkexamples.py

JSEXE = result/bin/stql-web.jsexe

web: web/Examples.hs
	$(NIXBUILD)
	rm -rf site; mkdir site
	cp $(JSEXE)/index.html $(JSEXE)/rts.js $(JSEXE)/lib.js $(JSEXE)/out.js $(JSEXE)/runmain.js site/
	cp rdf.pdf site/
	chmod -R u+w site

serve:
	cd site && python3 -m http.server $(PORT)

deploy: web
	firebase deploy --only hosting

clean:
	rm -f stql *.o *.hi Grammar.info result; rm -rf .testrun site

.PHONY: test clean report web serve deploy
