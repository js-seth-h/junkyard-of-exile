R = require 'ramda'
RA = require 'ramda-adjunct'
dcon = require('deco-console')(__filename)

indentString = require 'indent-string'
mkdirp = require 'mkdirp'
path = require 'path'
fs = require 'mz/fs'

md_toc = require('markdown-toc')

marked = require('marked')
hljs = require('highlight.js')
marked.setOptions {
  renderer: new marked.Renderer(),
  highlight: (code, language)->
    validLanguage = if hljs.getLanguage(language)
      language
    else
      'plaintext';
    # console.log  hljs.highlight(validLanguage, code).value;
    html = hljs.highlight(validLanguage, code).value;
    return "<div class='hljs'>#{html}</div>"
  pedantic: false,
  gfm: true,
  breaks: false,
  sanitize: false,
  smartLists: true,
  smartypants: false,
  xhtml: false
}



get_target = Symbol('get_target')

createDoc = ->
  new Proxy [],
    get: (raw, name)->
      if name is get_target
        return raw
      return (args...)->
        raw.push [name, args]

getMarkdown = (doc, opt)->
  arr = doc[get_target]
  dcon.debug 'saveAsMarkdown', arr
  txt = genMd arr, opt

getHtml = (doc)->
  body = marked getMarkdown doc
  return """
    <!doctype html>
    <html>
    <head>
      <meta charset="utf-8"/>
      <title>Marked in the browser</title>
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/4.0.0/github-markdown.min.css" integrity="sha512-Oy18vBnbSJkXTndr2n6lDMO5NN31UljR8e/ICzVPrGpSud4Gkckb8yUpqhKuUNoE+o9gAb4O/rAxxw1ojyUVzg==" crossorigin="anonymous" />
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/10.1.2/styles/monokai-sublime.min.css" />
      <style>
        ul:first-of-type {
          list-style:decimal;
          padding-left:1.5em;

        }
        ul:first-of-type li {
          padding: 3px 0px;
        }
      </style>
    </head>
    <body>
      #{body}
    </body>
    </html>
  """


saveAsMarkdown = (doc, filepath)->
  await fs.writeFile filepath, getMarkdown doc

saveAsWikiWiki = (doc, filepath)->
  arr = doc[get_target]
  txt = genWiki arr
  await fs.writeFile filepath, txt

genMd = (arr)->
  post_process = {}
  txt = ""
  fn =
    toc: ()-> post_process.toc = true
    t: (strs...)-> txt += strs.join(' ') + '\n'
    lines: (cnt)-> txt += '\n' for i in [0...cnt]
    italic: (strs...)->
      @t "_#{strs.join(' ')}_"
    em: (strs...)->
      @t "__#{strs.join(' ')}__"
    quote: (strs...)->
      @t '>', strs...
      @lines 1
    comment: (strs...)->
      @t '<!---\n' + strs.join(' ') + '\n-->'
    json: (obj)->
      str = indentString JSON.stringify(obj, null, 2), 2
      @t "```json\n#{str}\n```"
    code: (lang, str)->
      str = indentString str, 2
      @t "```#{lang}\n#{str}\n```"
    hr: (ch, cnt)->
      cnt = R.defaultTo 40, cnt
      ch = R.defaultTo '-', ch
      @t ch.repeat cnt

  [1...10].map (lv)->
    reserv = '#'.repeat lv
    fn["h" + lv] = (strs...)-> @t reserv, strs...
  Array.prototype.map.call '*-++++++++', (ch, inx)->
    lv = inx + 1
    reserv = ' '.repeat(inx * 2) + ch
    fn["i" + lv] = (strs...)-> @t reserv, strs...

  for [tag, words] in arr
    dcon.log 'textify line', tag, words
    continue unless fn[tag]?
    fn[tag] words...
  if post_process.toc is true
    txt = md_toc(txt).content + '\n\n' + txt
  return  txt


genWiki = (arr)->
  txt = ""
  fn =
    t: (strs...)-> txt += strs.join(' ') + '\n'
    lines: (cnt)-> txt += '\n' for i in [0...cnt]
    italic: (strs...)->
      @t "''#{strs.join(' ')}''"
    em: (strs...)->
      @t "'''#{strs.join(' ')}'''"
    quote: (strs...)->
      @t '<blockquote>', strs..., '</blockquote>'
      @lines 1
    comment: (strs...)->
      @t '<!--\n' + strs.join(' ') + '\n-->'
    json: (obj)->
      str = indentString JSON.stringify(obj, null, 2), 2
      @t "<source lang='json'>\n#{str}\n</source>"
    code: (lang, str)->
      str = indentString str, 2
      @t "<source lang='#{lang}'>\n#{str}\n</source>"
    hr: (ch, cnt)->
      cnt = R.defaultTo 40, cnt
      ch = R.defaultTo '-', ch
      @t ch.repeat cnt

  [1...10].map (lv)->
    reserv = '='.repeat lv
    fn["h" + lv] = (strs...)-> @t reserv, strs..., reserv
  [1...10].map (lv)->
    reserv = '*'.repeat lv
    fn["i" + lv] = (strs...)-> @t reserv, strs...

  for [tag, words] in arr
    dcon.log 'textify line', tag, words
    continue unless fn[tag]?
    fn[tag] words...

  return txt

Object.assign exports, {
  createDoc
  getMarkdown
  getHtml

  saveAsMarkdown
  saveAsWikiWiki
}
