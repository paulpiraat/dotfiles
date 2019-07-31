;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Duplicate line
(defun duplicate-line()
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (open-line 1)
  (next-line 1)
  (yank)
  )
(define-key input-decode-map "\e\eOB" [(meta down)])
(global-set-key [(meta down)] 'duplicate-line)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SSH
(defun connect-to-ssh (user host path)
  (interactive "sUser:
sHost:
sPath: ")
  (find-file (concat "/ssh:" user "@" host ":" path )))

(global-set-key (kbd "C-c r") 'connect-to-ssh)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; General keybindings
(global-set-key (kbd "M-p") 'projectile-find-file)
(global-set-key (kbd "C-c c") 'comment-or-uncomment-region)
(global-set-key (kbd "M-<tab>") 'company-complete)
