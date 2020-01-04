
README.md: Base.pm
	perl -MPod::Markdown::Github -e "Pod::Markdown::Github->filter('Base.pm')" > README.md
