# tree-swift
A swift implementation of the command line tool tree.  
Using a swift package https://github.com/ehemmete/FilesystemTree

	OVERVIEW: Builds a tree of a directory's files and all subdirectores and files.  Can output in text, json, and html.

	USAGE: tree [--json] [--html] [--show-hidden-files] [--version] [<root-dir>]

	ARGUMENTS:
	  <root-dir>              The full path to the directory that will be root level for the tree.
	
	OPTIONS:
	  -j, --json              Output JSON
	  -h, --html              Output HTML
	  -s, --show-hidden-files Include hidden files
	  --version               Print version number
	  -h, --help              Show help information.
