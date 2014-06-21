Typed-Clojure-Mode
================


<a href='http://typedclojure.org'><img src='images/part-of-typed-clojure-project.png'></a>

The official Typed Clojure Emacs plugin.

### Typed-Clojure-mode

 Keyboard Shortcut    | Description                                              | Command                       
----------------------|----------------------------------------------------------|-------------------------------
 <kbd>C-c C-x n</kbd> | Checks the entire ns, printing errors                    | typed-clojure-check-ns        
 <kbd>C-c C-x f</kbd> | Checks the preceding form or symbol, as in cf            | typed-clojure-check-form 
 <kbd>C-c C-a v</kbd> | Inserts (ann ... ) form above the top level expression | typed-clojure-ann-var      
 <kbd>C-c C-a f</kbd> | Wraps the current form with (ann-form ... t)           | typed-clojure-ann-form  

Dependencies
================
Clojure-mode, Cider

Installation
================

Install via [MELPA](http://melpa.milkbox.net/#/typed-clojure-mode).

<pre>
(add-hook 'clojure-mode-hook 'typed-clojure-mode)
</pre>

License
================

Copyright © 2012-2014 John Walker and contributors.

Distributed under the GNU General Public License, version 3
