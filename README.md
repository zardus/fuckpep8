# FuckPEP8

This plugin is intended to make life feasible for those of us who are right in the head, and use the proper tools (tabs) for indentation. It uses the awesome detectindent plugin (http://www.vim.org/scripts/script.php?script_id=1171) to detect how many spaces the poor misguided souls that originally wrote a given Python file use, replace them with tabs, and switch it back before saving.

Pull requests to undo other annoying pep8 insanity are welcome :-)

Special thanks to Luca Invernizzi for the initial prototype of this concept!

## Install

### With [Vundle]
Add these lines to your .vimrc
```vim
Bundle 'zardus/fuckpep8'
Bundle 'ciaranm/detectindent'
```
And execute:
```bash
vim +BundleInstall  +qall
```

### Manually
First, install [detectindent] and configure some reasonable defaults.

Then, install fuckpep8.

Then, make sure you have filetype plugins enabled in VIM:
```vim
filetype plugin on
```
That's it!

[Vundle]:http://github.com/gmarik/vundle
[detectindent]:http://github.com/ciaranm/detectindent
