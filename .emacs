;;; Emacs configuration for building a project

(require 'org)
(require 'ox-publish)
(require 's)
(require 'simple-httpd)

;; Use in:<invidio-id> syntax to include embed invidio video
(defvar in-iframe-format
  ;; You may want to change your width and height.
  (concat "<iframe id=\"ivplayer\" type=\"text/html\""
          "src=\"https://www.invidio.us/embed/%s\""
          " frameborder=\"0\""
          " allowfullscreen>%s</iframe>"))

(org-link-set-parameters
 "in"
 (lambda (handle)
   (browse-url
    (concat "https://www.invidio.us/embed/"
            handle)))
 (lambda (path desc backend)
   (cl-case backend
     (html (format in-iframe-format
                   path (or desc "")))
     (latex (format "\href{%s}{%s}"
                    path (or desc "video"))))))

(setq org-publish-project-alist
      `(("blog"
         :components ("blog-content" "blog-styles")
         :base-directory "./")
        ("blog-styles"
         :base-directory "./public"
         :base-extension "jpg\\|gif\\|png\\|ico\\|css"
         :publishing-directory "./dist/public"
         :recursive t
         :publishing-function org-publish-attachment
         )
        ("blog-content"
         :base-directory "./content"
         :publishing-directory "./dist"
         :recursive t
         :publishing-function org-html-publish-to-html

         :html-doctype "xhtml5"

         :with-title nil
         :with-author t
         :with-creator nil
         :with-date t
         :with-email t
         :with-footnotes t
         :html-html5-fancy t
         :html-preamble "
<header class=\"navbar\">
<a href=\"/\" class=\"logo\">@w96k</a>
<a class=\"button\" href=\"/about.html\">Обо мне</a>
<a class=\"button\" href=\"/cv.html\">CV</a>
</header>"

         :html-head "
<link rel=\"shortcut icon\" href=\"/public/favicon.ico\">
<link rel=\"stylesheet\" href=\"/public/css/mini.css\" type=\"text/css\"/>
<link rel=\"stylesheet\" href=\"/public/css/custom.css\" type=\"text/css\"/>
"

         :html-container "article"
         :html-postamble "
  <div class=\"row\">
    <div class=\"col-sm-12 col-md-4\">
      <p class=\"licenses\">
        <a href=\"https://creativecommons.org/licenses/by/4.0/\">
          <img alt=\"Лицензия Creative Commons\" src=\"/public/images/cc.png\" />
</a>
        <a href=\"https://www.gnu.org/licenses/gpl-3.0.txt\">
          <img src=\"/public/images/gpl.png\">
        </a>
     </p>
    </div>

    <div id=\"copyright\" class=\"col-sm-12 col-md-4\">
      <p>© 2019-2020 <i>Mikhail Kirillov</i></p>
      <p>
       Сайт работает в <a href=\"https://anybrowser.org/campaign/\">любом браузере</a>
      </p>
    </div>

    <div class=\"col-sm-12 col-md-4\" id=\"meta\">
      <p><span class=\"icon-settings\"></span> %c</p>
      <p><span class=\"icon-calendar\"></span> %d %C</p>
    </div>
  </div>

  <br>
  <div align=\"center\">
    <small>
      <p>Содержимое данного сайта доступно по лицензии
        <a href=\"https://creativecommons.org/licenses/by/4.0/\">
          Creative Commons «Attribution» («Атрибуция») 4.0 Всемирная
        </a>
      </p>
      <p>Исходный код данного сайта доступен по лицензии GNU General Public License Version 3</p>
    </small>
  </div>"

         :section-numbers nil
         :with-sub-superscript nil

         ;; sitemap - list of blog articles
         :auto-sitemap t
         :sitemap-filename "sitemap.org"
         :sitemap-title "@w96k"
         :sitemap-sort-files anti-chronologically)))

;; Don't ask for block evaluation
(setq org-confirm-babel-evaluate nil)

;; Set output folder
(setq httpd-root "./dist/")
