;;
;;
;;
(defvar serialspeed "115200")
(defvar serialport "/dev/ttyACM0")
(defvar serialbasename "serial")
(require 'term)


(defun setupserial (serialport serialspeed)
  (interactive
   (list
    (read-string
     (format "Serial Port (%s): "
	     serialport)
     nil nil
     serialport)
    (read-string
     (format "Speed (%s): "
	     serialspeed)
     nil nil
     serialspeed)))
  (setq uniqueid (format "%04x" (random (expt 16 4))))
  (setq serialid (concat serialbasename "-" uniqueid))
  (setq buffname (concat serialid "-buffer"))
  (setq termname (concat serialid "-term"))
  (set 'bufferid (get-buffer-create buffname))
  (make-serial-process
   :speed (string-to-number serialspeed)
   :port serialport
   :name termname
   :buffer buffname)
  (switch-to-buffer buffname)
  (with-current-buffer buffname
    (term-mode))
  (with-current-buffer buffname
    (term-char-mode))
  (local-set-key (kbd "M-r") #'resetserial)
  (local-set-key (kbd "M-k") #'killserial)
  (local-set-key (kbd "M-x") #'execute-extended-command)
  (local-set-key (kbd "M-o") #'ace-window)
  (make-variable-buffer-local 'serialid)
  (make-variable-buffer-local 'buffname)
  (make-variable-buffer-local 'termname)
  (message "Started Serial Terminal"))

(defun resetserial ()
  (interactive)
  (make-serial-process
   :speed (string-to-number serialspeed)
   :port serialport
   :name "serialterm"
   :buffer "serialbuffer")
  (message "Restarted Serial Terminal"))


(defun killserial ()
  (interactive)
  (delete-process "serialterm"))

(global-set-key (kbd "C-c s") #'setupserial)

(provide 'setup-serial)
