JEKYLL:=~/.gem/ruby/2.7.0/bin/jekyll

serve:
	$(JEKYLL) serve --incremental --watch -P 8080 -H \*

clean:
	$(JEKYLL) clean
