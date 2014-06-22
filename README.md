Typed-Clojure-Mode
================


<a href='http://typedclojure.org'><img src='images/part-of-typed-clojure-project.png'></a>

The official Typed Clojure Emacs minor mode.

Installation
================

Install via [MELPA](http://melpa.milkbox.net/#/typed-clojure-mode).

<pre>
(add-hook 'clojure-mode-hook 'typed-clojure-mode)
</pre>

### Typed-Clojure-mode

Keyboard Shortcut    | Description                                      | Command
---------------------|--------------------------------------------------|----------------------------
<kbd>C-c C-x n</kbd> | Print errors in the namespace                    | typed-clojure-check-ns
<kbd>C-c C-x f</kbd> | Check the preceding form or symbol               | typed-clojure-check-form
<kbd>C-c C-a v</kbd> | Insert (ann ... ) above the top expression       | typed-clojure-ann-var
<kbd>C-c C-a f</kbd> | Wrap the current form with (ann-form ... t)      | typed-clojure-ann-form

Dependencies
================
Clojure-mode, Cider

License
================

Copyright © 2012-2014 John Walker and contributors.

Distributed under the GNU General Public License, version 3
