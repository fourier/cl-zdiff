;;; base-view.lisp --- base class for TUI view (window) 

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

;; Base View

;;; Code:
(defpackage :zdircmp.view.base
  (:use ::common-lisp :cl-ncurses :zdircmp.ui.utils)
  ;; shadowing refresh from cl-ncurses, we don't use it anyway
  (:shadow :refresh)
  (:export :view
           :window
           :x
           :y
           :width
           :height
           :with-window
           :refresh
           :destroy
           :resize
           :visible
           :show
           :process-key))

(in-package :zdircmp.view.base)

(defclass view ()
  ;; ncurses window
  ((window :initform nil :accessor window)
   (x :initarg :x :initform 0 :accessor x)
   (y :initarg :y :initform 0 :accessor y)
   (width :initarg :width :initform 0 :accessor width)
   (height :initarg :height :initform 0 :accessor height)))

(defmacro with-window (v w &body body)
  "When-let pattern. Set the W to the ncurses window and executes the body"
  `(let ((,w (window ,v)))
     (when ,w
       ,@body)))


(defgeneric destroy (v)
  (:documentation "Destroy the associated with view ncurses window"))

(defmethod destroy ((v view))
  (with-window v w
    (delwin w)
    (setf (window v) nil)))

;; constructor for the view
(defmethod initialize-instance :after ((v view) &rest args)
  ;; ignore unused args warning
  (declare (ignore args))
  (setf (window v) (newwin (height v) (width v) (y v) (x v)))
  (refresh v)
  (wrefresh (window v)))


(defgeneric refresh (v &key force)
  (:documentation "Refreshes the associated ncurses window"))

(defmethod refresh ((v view) &key (force t))
  (declare (ignore force))
  (with-window v w
    (wrefresh w)))

(defgeneric resize (v x y width height)
  (:documentation "Process the resize command, resizing the associated ncurses window"))

(defmethod resize ((v view) x y width height)
  (with-window v w
    (setf (x v) x)
    (setf (y v) y)
    (setf (width v) width)
    (setf (height v) height)
    (wclear w)
    (wresize w height width)
    (mvwin w y x)
    (refresh v)))

(defgeneric visible (v)
  (:documentation "Determines if the window is visible"))

(defmethod visible ((v view))
  (window v))

(defgeneric show (v show)
  (:documentation "Show or hides window depending on SHOW argument"))

(defmethod show ((v view) show)
  (let ((w (window v)))
    (when w
      (wclear w)
      (wrefresh w)
      (delwin w))
    (setf (window v) 
          (if show (newwin (height v)
                              (width v)
                           (y v)
                           (x v))
              nil))
    (refresh v)))

(defgeneric process-key (v key)
  (:documentation "Key handler for view"))


;;; base-view.lisp ends here