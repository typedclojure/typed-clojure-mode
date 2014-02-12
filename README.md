Typed-Clojure.el
================

Utilities for editing with Typed Clojure. 

### Typed-Clojure-mode

 Keyboard Shortcut    | Description                                              | Command                       
----------------------|----------------------------------------------------------|-------------------------------
 <kbd>C-c C-x n</kbd> | Checks the entire ns, printing errors                    | typed-clojure-check-ns        
 <kbd>C-c C-x f</kbd> | Checks the preceding form or symbol, as in cf            | typed-clojure-check-form 
 <kbd>C-c C-x i</kbd> | Inserts (ann ... ) form above the top level expression | typed-clojure-insert-ann      
 <kbd>C-c C-x w</kbd> | Wraps the current form with (ann-form ... )            | typed-clojure-wrap-form  

Dependencies
================
Paredit, Clojure-mode, Cider

Installation
================
<pre>
(require 'typed-clojure) ;; provided it's on your load-path
(add-hook 'clojure-mode-hook 'typed-clojure-mode)
</pre>

License
================

Copyright © 2012-2014 John Walker and contributors.

Distributed under the GNU General Public License, version 3
