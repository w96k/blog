;;; ;;;; My Blog made in Guile Haunt
;;;;
;;;; https://w96k.com/
;;;; 2019 (c) Mikhail w96k Kirillov

(use-modules (haunt site)
             (haunt reader)
             (haunt asset)
             (haunt page)
             (haunt post)
             (haunt html)
             (haunt utils)
             (haunt builder blog)
             (haunt builder atom)
             (haunt builder assets)
             (srfi srfi-19)
             (ice-9 rdelim)
             (ice-9 match)
             (web uri))

(define %releases
  '(("0.1" "c81dbcdf33f9b0a19442d3701cffa3b60c8891ce")))

(define (tarball-url version)
  (string-append "http://files.dthompson.us/haunt/haunt-"
                 version ".tar.gz"))

(define (stylesheet name)
  `(link (@ (rel "stylesheet")
            (href ,(string-append "/css/" name ".css")))))

(define (anchor content uri)
  `(a (@ (href ,uri)) ,content))

(define (logo src)
  `(img (@ (class "logo") (src ,(string-append "/images/" src)))))

(define %cc-by-sa-link
  '(a (@ (href "https://creativecommons.org/licenses/by-sa/4.0/"))
      "Creative Commons Attribution Share-Alike 4.0 International"))

(define mini-theme
  (theme #:name "Mini"
         #:layout
         (lambda (site title body)
           `((doctype "html")
             (head
              (meta (@ (charset "utf-8")))
              (title ,(string-append title " — " (site-title site)))
              ,(stylesheet "mini")
              ,(stylesheet "custom"))
             (body
              (header (@ (class "navbar"))
                      (a (@ (href "/")
                            (class "logo"))
                         ,(string-append (site-title site)))
                      (a (@ (class "button") (href "/about.html")) "Обо мне")
                      (a (@ (class "button") (href "/bookshelf.html")) "Книжная полка")
                      (a (@ (class "button") (href "/feed.xml"))
                         (span (@ (class "icon-rss"))))
                      )
              (div (@ (class "container"))
                   ,body)
              (footer
               (p (small "© 2019 Mikhail Kirillov"))))))
         #:post-template
         (lambda (post)
           `(article
             (h2 ,(post-ref post 'title)
                 (small (span (@ (class "icon-calendar"))) " " ,(date->string* (post-date post))))
             (div ,(post-sxml post))))
         #:collection-template
         (lambda (site title posts prefix)
           (define (post-uri post)
             (string-append "/" (or prefix "")
                            (site-post-slug site post) ".html"))

           `((h2 "Посты")
             (ul
              ,@(map (lambda (post)
                       `(li
                         (a (@ (href ,(post-uri post)))
                            ,(post-ref post 'title))))
                     (posts/reverse-chronological posts)))))))

(define (about-page site posts)
  (define body
    `((article
       (div (@ (class "row"))
            (div (@ (class "col-sm-12 col-md-3"))
                 (img (@ (src "/images/ava.jpg")
                         (class "rounded")
                         (style "max-width: 300px; width: 100%;")))
                 (div (@ (class "button-group"))
                      (a (@ (href "https://twitter.com/w96kz") (class "button")) "Twitter"))
                 (div (@ (class "button-group"))
                      (a (@ (href "https://t.me/w96k_log") (class "button")) "Telegram")))
            
            (div (@ (class "col-sm-12 col-md-9"))
                 (h2 "Обо мне")
                 (p "Я — фуллстек разработчик. Люблю функциональное
программирование, LISP и движение за свободное программное
обеспечение.")
                 (h3 "Чем занимаюсь")
                 (ul
                  (li "Учусь на " (a (@ (href "https://ru.hexlet.io/u/w96k")) "Hexlet") " ")
                  (li "Читаю на " (a (@ (href "https://www.goodreads.com/user/show/71049684-mikhail-kirillov")) "Goodreads") " ")
                  (li "Пилю на " (a (@ (href "https://github.com/w96k/")) "Github") " ")
                  (li "Практикуюсь на " (a (@ (href "https://www.codewars.com/users/w96k")) "Codewars")))

                 (p "Вы можете мне написать на почту с вопросом или темой для поста " (span (@ (class "icon-mail"))) "w96k.ru@gmail.com"))
            ))))

  (make-page "about.html"
             (with-layout mini-theme site "Обо мне" body)
             sxml->html))

(define %collections
`(("Главная" "index.html" ,posts/reverse-chronological)))

(site #:title "@w96k"
      #:domain "w96k.com"
      #:default-metadata
      '((author . "Mikhail Kirillov")
        (email  . "w96k.ru@gmail.com"))
      #:readers (list sxml-reader html-reader)
      #:builders (list (blog #:theme mini-theme #:collections %collections)
                       (atom-feed)
                       (atom-feeds-by-tag)
                       about-page
                       (static-directory "images")
                       (static-directory "css")
                       (static-directory "js")))
