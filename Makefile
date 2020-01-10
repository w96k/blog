build:
	@emacs	-batch -Q --no-site-file --script .emacs	\
		--eval '(find-file-literally "index.org")'	\
		--eval '(org-publish-project "blog" t)'
	@echo "Done"

serve:
	@echo "Press <C-c> to interrupt"				
	@emacs 	-batch -Q --no-site-file --script .emacs	\
		--eval '(httpd-serve-directory "./dist")'	\
		--eval '(sit-for 10000)' >/dev/null; true

stop:
	@emacs 	-batch -Q --no-site-file --script .emacs	\
		--eval '(httpd-stop)'				\
