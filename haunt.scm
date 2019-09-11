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

(define (stylesheet name)
  `(link (@ (rel "stylesheet")
            (href ,(string-append "/css/" name ".css")))))

(define (anchor content uri)
  `(a (@ (href ,uri)) ,content))

(define (logo src)
  `(img (@ (class "logo") (src ,(string-append "/images/" src)))))

(define %cc-by-sa-link
  '(a (@ (href "https://creativecommons.org/licenses/by-sa/4.0/"))
      (img (@ (src "/images/cc.png")))))

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
                      (a (@ (class "button") (href "https://github.com/w96k/cv/raw/master/cv.pdf")) "CV")
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
               (p (small (a (@ (href "https://gitlab.com/w96k/blog")) "Исходный код")))
               (p (small "© 2019 Mikhail Kirillov"))
               (p (,%cc-by-sa-link))))))
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
                 (div (img (@ (src "/images/fsf.png")
                              (class "shadowed rounded")))))
            
            (div (@ (class "col-sm-12 col-md-9"))
                 (h2 "Кириллов Михаил")
                 (p "Я — фуллстек разработчик. Люблю функциональное
программирование, LISP и движение за свободное программное
обеспечение.")

                 (p "Вы можете мне написать на почту с вопросом или
темой для
поста " (a (@ (href "mailto:w96k@member.fsf.org")) "w96k@member.fsf.org")))))))

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
                       redirect-dobryakov
                       redirect-pirogov
                       redirect-libreboot
                       404-page
                       (static-directory "images")
                       (static-directory "css")
                       (static-directory "js")))
