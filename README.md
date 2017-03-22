# Free Code Camp Pomodoro Project

This is a pomodoro timer built with haxe and mithril (using the hx-mithril
library).


## Building

To locally build this web app, you will need Haxe 3.4.2 from
[haxe.org](http://haxe.org/download/version/3.4.2/). Once you have downloaded and
installed Haxe, cd into this folder and run the following commands:
```sh
# in the root of the repository
haxelib install build.hxml
haxe build.hxml
```
Then run a web server to view the results. I personally use `http-server` from
npm for testing, like so:
```sh
# in the root of the repository
http-server bin/
```
