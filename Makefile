build:
	rm -rf site/
	sassc ./css/mini.scss --style compressed > ./css/mini.css
	haunt build
	mkdir site/posts
	mkdir site/posts/dobryakov_employment
	mv site/dobryakov_employment.html site/posts/dobryakov_employment/index.html
	mkdir site/posts/pirogov_fp
	mv site/pirogov_fp.html site/posts/pirogov_fp/index.html
	mkdir site/posts/libreboot_x200t
	mv site/libreboot_x200t.html site/posts/libreboot_x200t/index.html
