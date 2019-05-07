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
               (p (small "Работает на "
                         (a (@ (href "https://dthompson.us/projects/haunt.html"))
                            Haunt)
                         " при помощи "
                         (a (@ (href "https://www.gnu.org/software/guile/"))
                            "Guile Scheme")))
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
                         (class "shadowed rounded")
                         (style "max-width: 300px; width: 100%;")))
                 (div (@ (class "button-group"))
                      (a (@ (href "https://twitter.com/w96kz") (class "shadowed button")) "Twitter"))
                 (div (@ (class "button-group"))
                      (a (@ (href "https://t.me/w96k_log") (class "shadowed button")) "Telegram")))
            
            (div (@ (class "col-sm-12 col-md-9"))
                 (h2 "Кириллов Михаил")
                 (p "Я — фуллстек разработчик. Люблю функциональное
программирование, LISP и движение за свободное программное
обеспечение.")
                 (h3 "Чем занимаюсь")
                 (ul
                  (li "Учусь на " (a (@ (href "https://ru.hexlet.io/u/w96k")) "Hexlet") " ")
                  (li "Читаю на " (a (@ (href "https://www.goodreads.com/user/show/71049684-mikhail-kirillov")) "Goodreads") " ")
                  (li "Пилю на " (a (@ (href "https://github.com/w96k/")) "Github") " ")
                  (li "Практикуюсь на " (a (@ (href "https://www.codewars.com/users/w96k")) "Codewars")))

                 (p "Вы можете мне написать на почту с вопросом или
темой для
поста " (a (@ (href "mailto:w96k.ru@gmail.com")) "w96k.ru@gmail.com")))))))

  (make-page "about.html"
             (with-layout mini-theme site "Обо мне" body)
             sxml->html))

(define (redirect-dobryakov site posts)
  (define body
    `((article
       (meta (@
              (http-equiv "refresh")
              (content "0; url=/григорий-добряков-об-устройстве-на-работу.html")))
       (h2 "Перенаправляю...")
       (p (a (@ (href "/григорий-добряков-об-устройстве-на-работу.html"))
             "Нажмите если не перенаправилось"))
       )))
  
  (make-page "dobryakov_employment.html"
             (with-layout mini-theme site "Редирект" body)
             sxml->html))

(define (redirect-pirogov site posts)
  (define body
    `((article
       (meta (@
              (http-equiv "refresh")
              (content "0; url=/алексей-пирогов-про-фп.html")))
       (h2 "Перенаправляю...")
       (p (a (@ (href "/алексей-пирогов-про-фп.html"))
             "Нажмите если не перенаправилось"))
       )))
  
  (make-page "pirogov_fp.html"
             (with-layout mini-theme site "Редирект" body)
             sxml->html))

(define (redirect-libreboot site posts)
  (define body
    `((article
       (meta (@
              (http-equiv "refresh")
              (content "0; url=/libreboot-x200t.html")))
       (h2 "Перенаправляю...")
       (p (a (@ (href "/libreboot-x200t.html"))
             "Нажмите если не перенаправилось"))
       )))
  
  (make-page "libreboot_x200t.html"
             (with-layout mini-theme site "Редирект" body)
             sxml->html))

(define (404-page site posts)
  (define body
    `((article (@ (style "text-align: center;"))
               (h2 "Ошибка 404"
                   (small "Страница не найдена"))

               (div
                (a (@ (class "button")
                      (href "/"))
                   "На главную"))

               (img (@ (id "youmu")
                       (src "/images/youmu.png")))
               )))
  
  (make-page "404.html"
             (with-layout mini-theme site "Not Found" body)
             sxml->html))

;; TODO: Refactor book creating
(define (make-book name sub cover) (0))

(define (bookshelf-page site posts)
  (define body
    `(
      ;; Пиши сокращай
      (article
       (div (@ (class "row"))
            (div (@ (class "col-sm-12 col-md-3"))
                 (img (@ (class "cover")
                         (src "/images/books/pishi.jpg")))
                 )
            (div (@ (class "col-sm-12 col-md-9"))
                 (div (@ (class "card fluid"))
                      (h3 (@ (class "section")) "Пиши сокращай")
                      (p "Полезна для всех, кто публикует хоть что-нибудь в
                      интернете. После прочтения стараюсь применять советы из книги на
                      практике.")
                      (p "Оценка: "
                         (mark (@ (class "tertiary")) "Рекомендую"))
                      )

                 (p (@ (style "text-align: center;"))
                 (a
                  (@ (href "https://www.goodreads.com/book/show/31855502"))
                  "Книга на Goodreads"))

              )))

      ;; Learning GNU EMACS
      (article
       (div (@ (class "row"))
            (div (@ (class "col-sm-12 col-md-3"))
                 (img (@ (class "cover")
                         (src "/images/books/emacs.jpg")))
                 )
            (div (@ (class "col-sm-12 col-md-9"))
                 (div (@ (class "card fluid"))
                      (h3 (@ (class "section")) "Learning GNU Emacs")
                      (p "Отличная и объемная книга для первичного
погружения в мир имакс. Местами устарело, но в целом стиль
повествования и само содержание написано качественно.")
                      (p "Оценка: "
                         (mark (@ (class "tertiary")) "Рекомендую"))
                      )

                 (p (@ (style "text-align: center;"))
                    (a
                     (@ (href "https://www.goodreads.com/book/show/31855502"))
                     "Книга на Goodreads")))))

      ;; Важные годы
      (article
       (div (@ (class "row"))
            (div (@ (class "col-sm-12 col-md-3"))
                 (img (@ (class "cover")
                         (src "/images/books/20-30.jpg")))
                 )
            (div (@ (class "col-sm-12 col-md-9"))
                 (div (@ (class "card fluid"))
                      (h3 (@ (class "section")) "Важные годы"
                          (small "Почему не стоит откладывать жизнь на потом."))
                      (p "Автор — психотерапевт. Книга основана на
посещениях клиентами автора книги. Основной посыл — в возрасте от 20
до 30 лет надо усердно работать, а не отдыхать 'по-молодости'.")
                      (p "Оценка: "
                         (mark (@ (class "secondary")) "Не рекомендую"))
                      )

                 (p (@ (style "text-align: center;"))
                    (a
                     (@ (href "https://www.goodreads.com/book/show/31855502"))
                     "Книга на Goodreads")))))

      ;; Clojure for the brave and true
      (article
       (div (@ (class "row"))
            (div (@ (class "col-sm-12 col-md-3"))
                 (img (@ (class "cover")
                         (src "/images/books/clojure-for-brave.jpg")))
                 )
            (div (@ (class "col-sm-12 col-md-9"))
                 (div (@ (class "card fluid"))
                      (h3 (@ (class "section")) "Clojure For The Brave & True")
                      (p "Отличная книга для первичного погружения в Clojure.")
                      
                      (p "Оценка: "
                         (mark (@ (class "tertiary")) "Рекомендую"))
                      )

                 (p (@ (style "text-align: center;"))
                    (a
                     (@ (href "https://www.goodreads.com/book/show/31855502"))
                     "Книга на Goodreads")))))

      ;; Girls Last Tour
      (article
       (div (@ (class "row"))
            (div (@ (class "col-sm-12 col-md-3"))
                 (img (@ (class "cover")
                         (src "/images/books/girls-last-tour.jpg")))
                 )
            (div (@ (class "col-sm-12 col-md-9"))
                 (div (@ (class "card fluid"))
                      (h3 (@ (class "section")) "Girls Last Tour")
                      
                      (p "Оценка: "
                         (mark (@ (class "tertiary")) "Рекомендую"))
                      )

                 (p (@ (style "text-align: center;"))
                    (a
                     (@ (href "https://www.goodreads.com/book/show/31855502"))
                     "Книга на Goodreads")))))

      ;; Lesbian Experience
      (article
       (div (@ (class "row"))
            (div (@ (class "col-sm-12 col-md-3"))
                 (img (@ (class "cover")
                         (src "/images/books/lesbian.jpg")))
                 )
            (div (@ (class "col-sm-12 col-md-9"))
                 (div (@ (class "card fluid"))
                      (h3 (@ (class "section")) "My Lesbian Experience with Loneliness")
                      (p "Оценка: "
                         (mark (@ (class "tertiary")) "Рекомендую"))
                      )

                 (p (@ (style "text-align: center;"))
                    (a
                     (@ (href "https://www.goodreads.com/book/show/33113683-my-lesbian-experience-with-loneliness"))
                     "Книга на Goodreads")))))

      (article
       (p (@ (style "text-align: center;"))
          (a (@ (href "https://www.goodreads.com/user/show/71049684-mikhail-kirillov")
                (class "button"))
             "Мой Goodreads")))))

  (make-page "bookshelf.html"
             (with-layout mini-theme site "Книжная полка" body)
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
                       bookshelf-page
                       redirect-dobryakov
                       redirect-pirogov
                       redirect-libreboot
                       404-page
                       (static-directory "images")
                       (static-directory "css")
                       (static-directory "js")))
