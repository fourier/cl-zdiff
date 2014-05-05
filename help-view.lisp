;;; head-view.lisp --- Help text view (window) for directory trees

;; Copyright (C) 2014 Alexey Veretennikov
;;
;; Author: Alexey Veretennikov <alexey dot veretennikov at gmail dot com>
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;
;;; Commentary:

;; Help View

;;; Code:
(defpackage :zdircmp.view.help
  (:use ::common-lisp :cl-ncurses :zdircmp.util :zdircmp.ui.utils :zdircmp.view.base)
  ;; shadowing refresh from cl-ncurses, we use the one in base-view
  (:shadowing-import-from :zdircmp.view.base :refresh)
  (:export :help-view))


(in-package :zdircmp.view.help)

(defstruct point
  "Point position. LINE is the line number in window, COLUMN is the column.
Both 0-based"
  (line 0)
  (column 0))


(defclass help-view (view)
  ((point-pos :initform (make-point)
               :accessor point-pos
               :documentation "Current point position"))
   (:documentation "Help window class"))


(defgeneric goto-point (v &key line col))
(defmethod goto-point ((v help-view) &key (line (point-line (point-pos v)))
                                     (col (point-column (point-pos v))))
  (setf (point-line (point-pos v)) line)
  (setf (point-column (point-pos v)) col))


(defgeneric print-string (v string &key with-color line col))
(defmethod print-string ((v help-view) string &key (with-color :white) line col)
  (with-window v w
               (let ((l (if line line 
                            (point-line (point-pos v))))
                     (c (if col col (point-column (point-pos v))))
                     (size (length string)))
                 (goto-point v :line l :col c )
                 (with-color-win w with-color
                                 (mvwprintw w l c string))
                 (goto-point v :col (+ c size)))))

(defmethod refresh :before ((v help-view) &key (force t))
  (declare (ignore force))
  (goto-point v :line 0 :col 0)
  (print-string v "Directory tree differences report tool.")
  (goto-point v :line 1 :col 0)
  (print-string v "Navigation: ")
  (print-string v "LEFT/RIGHT/UP/DOWN" :with-color :green)
  (print-string v " and ")
  (print-string v "TAB" :with-color :green)
  (print-string v " to switch between panes")
  (goto-point v :line 2 :col 0)
  (print-string v "Press ")
  (print-string v "ESC" :with-color :green)
  (print-string v " to exit")
  (goto-point v :line 3 :col 0)
  (print-string v "Press ")
  (print-string v "ENTER" :with-color :green)
  (print-string v " to open/close directories or start ")  
  (print-string v "vimdiff" :with-color :red)
  (print-string v " on different files")
  (goto-point v :line 4 :col 0)
  (print-string v "Press ")
  (print-string v "BACKSPACE" :with-color :green)
  (print-string v " to jump up in tree or close current directory")
  (goto-point v :line 5 :col 0)
  (print-string v "Legend:")
  (goto-point v :line 6 :col 0)
  (print-string v "\"file name\" - files/dirs are the same")
  (goto-point v :line 7 :col 0)
  (print-string v "\"file name\"" :with-color :red)
  (print-string v " - files/dirs are different")
  (goto-point v :line 8 :col 0)
  (print-string v "\"file name\"" :with-color :cyan)
  (print-string v " - files(or contents of dir) exist only on one pane"))
  

#|
  (with-window v w
    (mvwprintw w 0 0 "Directory tree differences report tool.")
    (mvwprintw w 1 0 "Navigation: ")
    (with-color-win w :green
                    (mvwprintw w 1 (length "Navigation: ") "Point keys and TAB"))
    (mvwprintw w 2 0 "Press")
    (with-color-win w :green
                    (mvwprintw w 2 (length "Press ") "ESC"))))
    
  |#  





;;; head-view.lisp ends here
