GREP = grep -a

TDIR = targets/js
META = $(TDIR)/meta.fth
PARAMS = params.fth jump.fth threading.fth

METACOMPILE = echo 'include $(META)  bye' | ./forth | tail -n+3 > $@ ; \
	$(GREP) Meta-OK $@

all forth: kernel.js

kernel.js: $(DEPS) $(PARAMS) $(META)
	$(METACOMPILE)

params.fth: $(TDIR)/params.fth
	cp $^ $@

jump.fth: targets/c/jump.fth
	cp $^ $@

threading.fth: targets/ctc.fth
	cp $^ $@

clean:
	rm -f kernel.js
