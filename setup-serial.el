;;; -*- lexical-binding: t; -*-
(defvar serialbasename "serial")
(defvar defserialspeed "115200")
(defvar defserialport "/dev/ttyACM0")
;;(setq defserialspeed "115200")
;;(setq defserialport "/dev/ttyACM0")

(require 'term)


(defun setupserial (serialport serialspeed)
  (interactive
   (list
    (read-string
     (format "Serial Port (%s): "
	     defserialport)
     nil nil
     defserialport)
    (read-string
     (format "Speed (%s): "
	     defserialspeed)
     nil nil
     defserialspeed)))
  (setq uniqueid (format "%04x" (random (expt 16 4))))
  (setq serialid (concat serialbasename "-" uniqueid))
  (setq buffname (concat serialid "-buffer"))
  (setq bufferid (get-buffer-create buffname))
  (setq termname (concat serialbasename "-" uniqueid "-term"))
  (make-serial-process
   :speed (string-to-number serialspeed)
   :port serialport
   :name termname
   :buffer buffname)
  (switch-to-buffer bufferid)
  (term-mode)
  (term-char-mode)
  (make-local-variable 'buffname)
  (make-local-variable 'bufferid)
  (make-local-variable 'termname)
  (set (make-local-variable 'serialspeed) serialspeed)
  (set (make-local-variable 'serialport) serialport)
  (local-set-key (kbd "M-r") #'resetserial)
  (local-set-key (kbd "M-k") #'killserial)
  (local-set-key (kbd "M-x") #'execute-extended-command)
  (local-set-key (kbd "M-o") #'ace-window)
  (message "Started Serial Terminal"))

(defun resetserial ()
  (interactive)
  (make-serial-process
   :port serialport
   :speed (string-to-number serialspeed)
   :name termname
   :buffer bufferid)
  (message "Restarted Serial Terminal"))


(defun killserial ()
  (interactive)
  (delete-process termname))

(global-set-key (kbd "C-c s") #'setupserial)

(provide 'setup-serial)
