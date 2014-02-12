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

(require 'cider)
(require 'clojure-mode)

(defvar typed-clojure-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c C-x n") 'typed-clojure-check-ns)
    (define-key map (kbd "C-c C-x e") 'typed-clojure-check-last-form)
    (define-key map (kbd "C-c C-x i") 'typed-clojure-insert-ann)
    map))

(define-minor-mode typed-clojure-mode
  "Typed Clojure minor mode"
  :group 'typed-clojure
  :lighter " Typed"
  :keymap typed-clojure-mode-map)

(defun typed-clojure-check-last-form (&optional prefix)
  (interactive "P")
  (if prefix
      (cider-interactive-eval-print
       (format "(clojure.core.typed/cf %s)"
	       (cider-last-sexp)))
    (cider-interactive-eval
     (format "(clojure.core.typed/cf %s)"
	     (cider-last-sexp)))))

(defun typed-clojure-check-ns ()
  (interactive)
  (cider-interactive-eval-print
   "(clojure.core.typed/check-ns)"))

(defconst code " (require 'clojure.core.typed)
         (let [{:keys [delayed-errors]} (clojure.core.typed/check-ns-info)]
	    (if (seq delayed-errors)
		[:errors
		 (for [^Exception e delayed-errors]
		      (let [{:keys [env] :as data} (ex-data e)]
			{:message (.getMessage e) :line (:line env)
			:column (:column env) :form (if (contains? data :form) (str (:form data)) 0)
			:source (:source env) :ns (-> env :ns :name str)}))]
	      [:ok []]))")

(defun typed-clojure-pprint-eval-sexp (form)
  (let ((result-buffer (cider-popup-buffer cider-result-buffer nil)))
    (cider-tooling-eval form
                        (cider-popup-eval-out-handler result-buffer)
                        (cider-current-ns))))

(defun typed-clojure-check-ns ()
  (interactive)
  (typed-clojure-pprint-eval-sexp code))

(defun typed-clojure-insert-ann ()
  (interactive)
  (beginning-of-defun)
  (insert (format "(clojure.core.typed/ann %s)\n" (which-function)))
  (previous-line)
  (end-of-line))

(provide 'typed-clojure)

;;; typed-clojure.el ends here
