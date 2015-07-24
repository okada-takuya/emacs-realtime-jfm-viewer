;;; realtime-jfm-viewer.el --- Real time Jay flavored markdown viewer with Rails-websocket

;; Copyright (C) 2015 by Takuya Okada

;; Author: Takuya Okada <pitipitiunsyumikan@gmail.com>
;; URL: https://github.com/okada-takuya/emacs-realtime-jfm-viewer
;; Version: 0.1
;; Package-Requires: ((cl-lib "0.5") (json "1.2") (websocket "1.4"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; realtime-markdown-viewer.el --- Real time markdown viewer with WebSocket

;; Copyright (C) 2015 by Syohei YOSHIDA

;; Author: Syohei YOSHIDA <syohex@gmail.com>
;; URL: https://github.com/syohex/emacs-realtime-markdown-viewer
;; Version: 0.01
;; Package-Requires: ((cl-lib "0.5") (websocket "1.4"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(require 'cl-lib)
(require 'json)
(require 'websocket)

(defgroup realtime-jfm-viewer nil
  "Realtime Jay Flavored Markdown Viewer"
  :group 'text
  :prefix "rtjfmv:")

(defcustom rtjfmv:jay-url 'localhost:3000
  "jay url"
  :type 'string
  :group 'realtime-jfm-viewer)

(defvar rtjfmv:websocket)

(defun rtjfmv:init-websocket ()
  (let ((ws-url (format "ws://%s/websocket" rtjfmv:jay-url)))
    (message "Connect to %s" ws-url)
    (setq rtjfmv:websocket
          (websocket-open
           ws-url
           :on-message (lambda (websocket frame))
           :on-error (lambda (ws type err)
                       (message "error connecting"))
           :on-close (lambda (_websocket))))))

(defun rtjfmv:websocket-rails-send-text (websocket string)
  (let ((json `[:convert_markdown (:id ,(random 65536) :data ,string)]))
    (websocket-send-text websocket (json-encode json))))

(defun rtjfmv:send-all-string-to-server ()
  (when realtime-jfm-viewer-mode
    (let ((string (buffer-substring-no-properties (point-min) (point-max))))
      (rtjfmv:websocket-rails-send-text rtjfmv:websocket string))))

(defun rtjfmv:init ()
  (rtjfmv:init-websocket)
  (add-hook 'post-command-hook 'rtjfmv:send-all-string-to-server))

(defun rtjfmv:finalize ()
  (websocket-close rtjfmv:websocket)
  (remove-hook 'post-command-hook 'rtjfmv:send-all-string-to-server))


;;; autoload
(define-minor-mode realtime-jfm-viewer-mode
  "Realtime Jay Flavored Markdown Viewer mode"
  :group      'realtime-jfm-viewer
  :init-value nil
  :global     nil
  (if realtime-jfm-viewer-mode
      (rtjfmv:init)
    (rtjfmv:finalize)))

(provide 'realtime-jfm-viewer)
