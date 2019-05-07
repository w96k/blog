watch:
	sassc ./css/mini.scss --style compressed > ./css/mini.css & \
	haunt serve --watch
