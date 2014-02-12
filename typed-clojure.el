;;; typed-clojure.el --- Typed Clojure Utilities for Emacs

;; Copyright © 2014 John Walker
;;
;; Author: John Walker <john.lou.walker@gmail.com>

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.

;; This file is not part of GNU Emacs.

;;; Commentary:

;; Provides utility functions for Typed Clojure

;;; Code:

(require 'button)
(require 'cider)
(require 'clojure-mode)
(require 'paredit)

(defvar typed-clojure-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c C-x n") 'typed-clojure-check-ns)
    (define-key map (kbd "C-c C-x f") 'typed-clojure-check-form)
    (define-key map (kbd "C-c C-x i") 'typed-clojure-insert-ann)
    (define-key map (kbd "C-c C-x w") 'typed-clojure-wrap-form)
    map))

(define-minor-mode typed-clojure-mode
  "Typed Clojure minor mode"
  :group 'typed-clojure
  :lighter " Typed"
  :keymap typed-clojure-mode-map)

(defconst current-alias-clj 
  "(if-let [[al typedns] (first (filter #(=
                                       (find-ns 'clojure.core.typed)
                                       (val %))
                                     (ns-aliases *ns*)))]
  (str al \"/\")
  \"clojure.core.typed/\")")

(defun current-alias ()
  (cider-eval-and-get-value current-alias-clj))

(defun typed-clojure-check-form (&optional prefix)
  "Typecheck the preceding form."
  (interactive "P")
  (let ((ca (current-alias)))
    (if prefix
	(cider-interactive-eval-print
	 (format "(%scf %s)" ca
		 (cider-last-sexp)))
      (cider-interactive-eval
       (format "(%scf %s)" ca
	       (cider-last-sexp))))))

(defconst code " 
         (let [{:keys [delayed-errors]} (clojure.core.typed/check-ns-info)]
	    (if (seq delayed-errors)
		 (for [^Exception e delayed-errors]
		      (let [{:keys [env] :as data} (ex-data e)]
			(list (.getMessage e) (:line env)
			(:column env) (if (contains? data :form) (str (:form data)) 0)
			(:source env) (-> env :ns :name str))))
	      :ok))")

(defun print-handler (cb buffer)
  (lexical-let ((cb cb))
    (nrepl-make-response-handler
     buffer
     (lambda (buffer val)
       (with-current-buffer buffer
	 (let ((inhibit-read-only t)
	       (buffer-undo-list t))
	   (goto-char (point-max))
	   (mapcar
	    (lambda (x)
	      (lexical-let ((msg    (first x))
			    (line   (second x))
			    (column (third x))
			    (form   (fourth x))
			    (source (fifth x))
			    (ns     (sixth x)))
		(insert (format "%s\n" msg))
		(insert-button (format "%s:%s" line column)
			       'action
			       (lambda (y)
				 (switch-to-buffer cb)
				 (goto-line line)
				 (move-to-column column)))
		(insert (format "\n%s\n%s\n\n" form source ns))))
	    (read val)))))
     '()
     '()
     '())))

(defun typed-clojure-check-ns ()
  "Type check and pretty print errors for the namespace."
  (interactive)
  (let ((cb (current-buffer)))
    (cider-tooling-eval code
			(print-handler cb
				       (cider-popup-buffer
					cider-error-buffer
					nil))
			(cider-current-ns))))

(defun typed-clojure-insert-ann ()
  (interactive)
  (beginning-of-defun)
  (insert (format "(%sann %s [])\n" (current-alias) (which-function)))
  (previous-line)
  (end-of-line)
  (backward-char 2))

(defun typed-clojure-wrap-form ()
  (interactive)
  (beginning-of-defun)
  (paredit-wrap-round)
  (beginning-of-defun)
  (forward-char)
  (insert (format "%sann-form " (current-alias)))
  (beginning-of-defun)
  (paredit-forward)
  (backward-char)
  (insert " []")
  (backward-char))

(provide 'typed-clojure)

;;; typed-clojure.el ends here
