;;; typed-clojure-error-mode.el --- Major mode for Typed Clojure errors

;; Copyright © 2014 John Walker
;;
;; Author: John Walker <john.lou.walker@gmail.com>,
;;         Ambrose Bonnaire-Sergeant <abonnairesergeant@gmail.com>
;; URL: https://github.com/typedclojure/typed-clojure-mode
;; Version: 1.1.0
;; Package-Requires: ((clojure-mode "2.1.1") (cider "0.8.1"))

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

;; Adds syntax coloring for type reports from typed-clojure-mode

;;; Code:

(setq typed-clojure-error-mode-keywords
      '(("Type Error" . font-lock-constant-face)
	("in:\\|with expected type:\\|Arguments:\\|Domains:\\|Ranges:" . font-lock-variable-name-face)))

(define-derived-mode typed-clojure-error-mode fundamental-mode
  "CTYP"
  "Major mode for typed-clojure errors"
  (setq font-lock-defaults '(typed-clojure-error-mode-keywords)))
