# Emacs Realtime JFM Viewer
Emacs realtime JFM(Jay Flavored Markdown) viewer is a viewer with Rails-websocket.
Please refer to [jay's repository](https://github.com/nomlab/jay) in order to know jay and JFM.

## Acknowledgement
This code refers to [syohex/emacs-realtime-markdown-viewer](https://github.com/syohex/emacs-realtime-markdown-viewer).

## Version
0.1

## Requirements
+ Emacs 24 or higher
+ Latest [websocket.el](https://github.com/ahyatt/emacs-websocket)

## Install and Setup

### Install Emacs Realtime JFM Viewer.

```sh
$ cd ~/.emacs.d/elpa
$ git clone git@github.com:okada-takuya/emacs-realtime-jfm-viewer.git
```

### Add load path

```sh
$ echo "(add-to-list 'load-path \"~/.emacs.d/elpa/emacs-realtime-jfm-viewer\")" >> ~/.emacs.d/init.el
```

### Require Emacs Realtime JFM Viewer and set custom value

```sh
$ echo "(require 'realtime-jfm-viewer)" >> ~/.emacs.d/init.el
$ echo "(custom-set-variables '(jay-url localhost:3000))" >> ~/.emacs.d/init.el # your jay root url excluding "http(s)://"
```

## How to use

### Enable Realtime JFM Viewer Mode
After you enable mode, input JFM.

```
M-x realtime-jfm-viewer-mode
```

### Access Jay
Access to http://your-jay-url/minutes/realtime_preview
