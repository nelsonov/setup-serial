;;
;;
;;
(defvar serialspeed "115200")
(defvar serialport "/dev/ttyACM0")
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
  (set 'bufferid (get-buffer-create "serialbuffer"))
  (make-serial-process
   :speed (string-to-number serialspeed)
   :port serialport
   :name "serialterm"
   :buffer "serialbuffer")
  (switch-to-buffer "serialbuffer")
  (with-current-buffer "serialbuffer"
    (term-mode))
  (with-current-buffer "serialbuffer"
    (term-char-mode))
  (local-set-key (kbd "M-r") #'resetserial)
  (local-set-key (kbd "M-k") #'killserial)
  (local-set-key (kbd "M-x") #'execute-extended-command)
  (local-set-key (kbd "M-o") #'ace-window)
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
