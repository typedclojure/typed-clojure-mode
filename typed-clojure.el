;;; typed-clojure.el --- Typed Clojure minor mode for Emacs

;; Copyright © 2014 John Walker
;;
;; Author: John Walker <john.lou.walker@gmail.com>, Ambrose Bonnaire-Sergeant <abonnairesergeant@gmail.com>
;; URL: https://github.com/typedclojure/typed-clojure-mode
;; Version: 1.0
;; Package-Requires: ((paredit "22") (clojure-mode "2.1.1") (cider "0.5.0"))

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
    (define-key map (kbd "C-c C-a v") 'typed-clojure-ann-var)
    (define-key map (kbd "C-c C-a f") 'typed-clojure-ann-form)
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

(defun lowest-ns (s)
  (interactive)
  (current-alias))

(defun typed-clojure-check-form (&optional prefix)
  "Typecheck the preceding form."
  (interactive "P")
  (let ((ca (lowest-ns 'cf)))
    (if prefix
	(cider-interactive-eval-print
	 (format "(%scf %s)" ca
		 (cider-last-sexp)))
      (cider-interactive-eval
       (format "(%scf %s)" ca
	       (cider-last-sexp))))))

(defconst code " 
         (let [_ (require 'clojure.core.typed)
               check-ns-info (find-var 'clojure.core.typed/check-ns-info)
               _ (assert check-ns-info 
                   \"clojure.core.typed/check-ns-info not found\")
               {:keys [delayed-errors]} (check-ns-info)]
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
	       (buffer-undo-list t)
	       (rd (read val)))
	   (goto-char (point-max))
	   (mapcar
	    (lambda (x)
	      (lexical-let ((msg    (first x))
			    (line   (second x))
			    (column (third x))
			    (form   (fourth x))
			    (source (fifth x))
			    (ns     (sixth x)))
		(insert "Type Error (")
		(insert-button (concat (or source "NO_SOURCE_FILE")
				       ":"
				       (format "%s:%s" line column))
			       'action
			       (lambda (y)
				 (switch-to-buffer cb)
				 (goto-line line)
				 (move-to-column column)))
		(insert ") ")
		(insert (format "%s\n" msg))
		(insert (format "in: %s\n\n" form))
		))
	    rd))))
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

(defun typed-clojure-ann-var ()
  (interactive)
  (beginning-of-defun)
  (insert (format "(%sann %s [])\n" (lowest-ns 'ann) (which-function)))
  (previous-line)
  (end-of-line)
  (backward-char 2))

(defun typed-clojure-ann-form ()
  (interactive)
  (lexical-let ((t (read-string "Annotate form with type (default Any): ")))
    (paredit-wrap-round)
    (insert (format "%sann-form " (lowest-ns 'ann-form)))
    (forward-sexp)
    (insert (concat "\n" (if (= 0 (length t)) "Any" t)))
    (backward-up-list)
    (paredit-reindent-defun)
 ; navigate to type
    (forward-sexp)
    (backward-char)
    (backward-sexp)))

(provide 'typed-clojure)

;;; typed-clojure.el ends here
