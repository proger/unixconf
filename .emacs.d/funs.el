;; http://calvinyoung.org/2010/06/upgrading-backward-kill-word-in-emacs/

(defun my-backward-kill-word (&optional arg)
  "Replacement for the backward-kill-word command
If the region is active, then invoke kill-region.  Otherwise, use
the following custom backward-kill-word procedure.
If the previous word is on the same line, then kill the previous
word.  Otherwise, if the previous word is on a prior line, then kill
to the beginning of the line.  If point is already at the beginning
of the line, then kill to the end of the previous line.

With argument ARG and region inactive, do this that many times."
  (interactive "p")
  (if (use-region-p)
      (kill-region (mark) (point))
    (let (count)
      (dotimes (count arg)
        (if (bolp)
            (delete-backward-char 1)
          (kill-region (max (save-excursion (backward-word)(point))
                            (line-beginning-position))
                       (point)))))))

(defadvice isearch-search (after isearch-no-fail activate)
  (unless isearch-success
    (ad-disable-advice 'isearch-search 'after 'isearch-no-fail)
    (ad-activate 'isearch-search)
    (isearch-repeat (if isearch-forward 'forward))
    (ad-enable-advice 'isearch-search 'after 'isearch-no-fail)
    (ad-activate 'isearch-search)))

(provide 'funs)
