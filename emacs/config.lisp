;;; FOR TERN TO WORK IN JS2:
;;; $ npm install -g tern
;;; place a .tern-project file in the root folder of a project

;;; Load PATH variables
(exec-path-from-shell-initialize)

;;; Additional emacs configurations

;;; Temp solution for tern bug. See https://emacs.stackexchange.com/questions/40865/emacs-lisp-error-need-a-pre-parsed-url
;; (cl-old-struct-compat-mode 1)

;;; Turn of lisp mode for this file
(add-to-list 'auto-mode-alist '("\\.config\\'" . lisp-mode))

;;; Autosave & Backup
;; Put autosave files (ie #foo#) and backup files (ie foo~) in ~/.emacs.d/.
(custom-set-variables
  '(auto-save-file-name-transforms '((".*" "~/.emacs.d/autosaves/\\1" t)))
  '(backup-directory-alist '((".*" . "~/.emacs.d/backups/"))))

;; create the autosave dir if necessary, since emacs won't.
(make-directory "~/.emacs.d/autosaves/" t)

;; ;;; Flycheck
(defun my/use-eslint-from-node-modules ()
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (eslint (and root
                      (expand-file-name "node_modules/eslint/bin/eslint.js"
                                        root))))
    (when (and eslint (file-executable-p eslint))
      (setq-local flycheck-javascript-eslint-executable eslint))))

(add-hook 'flycheck-mode-hook #'my/use-eslint-from-node-modules)
(add-hook 'rjsx-mode-hook 'flycheck-mode)

;; (defun my/use-tslint-from-node-modules ()
;;   (let* ((root (locate-dominating-file
;;                 (or (buffer-file-name) default-directory)
;;                 "node_modules"))
;;          (tslint (and root
;;                       (expand-file-name "node_modules/tslint/bin/tslint"
;;                                         root))))
;;     (when (and tslint (file-executable-p tslint))
;;       (setq-local flycheck-typescript-tslint-executable tslint))))

;; (add-hook 'flycheck-mode-hook #'my/use-tslint-from-node-modules)
;; (add-hook 'typescript-mode-hook 'flycheck-mode)

;;; Shell
(add-hook 'shell-script-mode-hook 'flycheck-mode)
(add-hook 'sh-mode-hook 'flycheck-mode)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Javascript
(add-to-list 'auto-mode-alist '("\\.js\\'" . rjsx-mode))
(add-to-list 'interpreter-mode-alist '("node" . js2-mode))
(eval-after-load "js2-highlight-vars-autoloads"
  '(add-hook 'rjsx-mode-hook (lambda () (js2-highlight-vars-mode))))

(setq js2-mode-show-parse-errors nil)
(setq js2-mode-show-strict-warnings nil)

;;; Javascript Refactor
(add-hook 'rjsx-mode-hook #'js2-refactor-mode)

;;; JSX
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . rjsx-mode))

(eval-after-load 'rjsx-mode
  '(progn
     (add-hook 'rjsx-mode-hook #'add-node-modules-path)
     (add-hook 'rjsx-mode-hook #'prettier-js-mode)))

;;; Company
(eval-after-load 'company
  '(progn
     '(add-to-list 'company-backends 'company-tern)
     '(add-to-list 'company-backends 'company-glsl)))
(add-hook 'rjsx-mode-hook 'company-mode)
;;(setq company-backends '(company-tern))
;;;;;;;; (add-hook 'rjsx-mode-hook (lambda () (set (make-local-variable 'company-backends) '(company-tern))))

;; Tern for Javascript
(add-hook 'rjsx-mode-hook (lambda ()
                           (unless (eq major-mode 'json-mode)
                             (tern-mode))))

;;; Remove whitespaces after save
 (add-hook 'rjsx-hook
	   (lambda () (add-to-list 'write-file-functions 'delete-trailing-whitespace)))


;;; Eslint
(defun eslint-fix-file ()
  (interactive)
  (message "eslint --fixing the file" (buffer-file-name))
  (shell-command (concat "node_modules/.bin/eslint --fix " (buffer-file-name))))

(defun eslint-fix-file-and-revert ()
  (interactive)
  (eslint-fix-file)
  (revert-buffer t t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; JSON
(add-hook 'json-mode-hook #'flycheck-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Typescript
(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; formats the buffer before saving
(add-hook 'before-save-hook 'tide-format-before-save)

(add-hook 'typescript-mode-hook #'setup-tide-mode)


;;; TSX
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))
;; enable typescript-tslint checker
;;(flycheck-add-mode 'typescript-tslint 'web-mode)
(add-hook 'web-mode-hook 'flycheck-mode)
(add-hook 'typescript-mode-hook 'flycheck-mode)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; GLSL
(add-hook 'glsl-mode-hook 'company-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Rust
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))

(with-eval-after-load 'rust-mode
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)
  (add-hook 'rust-mode-hook 'flycheck-mode))

;; rust fmt
(add-hook 'rust-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c <tab>") #'rust-format-buffer)))

;;; Racer
(setq racer-cmd "~/.cargo/bin/racer") ;; Rustup binaries PATH
(setq racer-rust-src-path "~/.multirust/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src") 
(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)
(add-hook 'racer-mode-hook #'company-mode)

;;; Cargo
(add-hook 'rust-mode-hook 'cargo-minor-mode)

;;; Prevent rjsx-mode from auto inserting html tags
(with-eval-after-load 'rjsx-mode
  (define-key rjsx-mode-map "<" nil)
  (define-key rjsx-mode-map (kbd "C-d") nil)
  (define-key rjsx-mode-map ">" nil))

;;; Keybindings js2
;; (add-hook 'rjsx-hook
;;           (lambda () (global-set-key (kbd "C-c e") 'eslint-fix-file))) ; Ctrl+e


;;; GLSL
(add-to-list 'auto-mode-alist '("\\.vert\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.tesc\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.tese\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.geom\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.frag\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.comp\\'" . glsl-mode))

;;; Prevent auto indent on html </>
(defun js-jsx-indent-line-align-closing-bracket ()
  "Workaround sgml-mode and align closing bracket with opening bracket"
  (save-excursion
    (beginning-of-line)
    (when (looking-at-p "^ +\/?> *$")
      (delete-char sgml-basic-offset))))
(advice-add #'js-jsx-indent-line :after #'js-jsx-indent-line-align-closing-bracket)

;; Flycheck for GLSL
(require 'flycheck)
(flycheck-define-checker glsl-checker
  "A GLSL syntax checker using glslangValidator."
  :command ("glslangValidator" source)
  :error-patterns
  ((error line-start
          "ERROR: "
          column ":"
          line ":"
          (message)
          line-end)
   (warning line-start
            "wARNING: "
            column ":"
            line ":"
            (message)
            line-end)
   (info line-start
         "NOTE: "
         column ":"
         line ":"
         (message)
         line-end))
  :modes (glsl-mode))

;; (with-eval-after-load 'rust-mode
;;   (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)
;;   (add-hook 'rust-mode-hook 'flycheck-mode))

;; (add-hook 'flycheck-mode-hook #'my/use-eslint-from-node-modules)

(add-hook 'glsl-mode-hook (lambda ()
                            (flycheck-mode)
                            (flycheck-select-checker 'glsl-checker)))
;; (add-hook 'glsl-mode-hook #

;;; Font
(add-to-list 'default-frame-alist '(font . "DejaVu Sans Mono-9" ))
(set-face-attribute 'default t :font "DejaVu Sans Mono-9" )
;;(add-to-list 'default-frame-alist '(font . "Cousine-10" ))
;;(set-face-attribute 'default t :font "Cousine-10" )

;; eslint flycheck test
(defun test-checkstyle ()
  (interactive)
  (goto-char (point-max))
  (let ((output (buffer-string)))
    (dolist (flycheck-xml-parser '(flycheck-parse-xml-region libxml-parse-xml-region))
      (insert (format "\n\n== Parsing with %s:\n%s" flycheck-xml-parser
                      (flycheck-parse-checkstyle output 'eslint (current-buffer)))))))

(setq flycheck-xml-parser 'flycheck-parse-xml-region)

;;; Font
;; (add-to-list 'default-frame-alist '(font . "mononoki-10" ))
;; (set-face-attribute 'default t :font "mononoki-10" )
;; (set-face-attribute 'default nil :height 90)
(add-to-list 'default-frame-alist '(font . "Cousine-8" ))
(set-face-attribute 'default t :font "Cousine-8" )


(hl-line-mode 1)


(setq hl-line-mode '(1))

;; Load keybindings
(load "~/.config/emacs/keybindings.lisp")
;;; config.lisp ends here
