render_this = function(this){
  rmarkdown::render(this, rmarkdown::html_notebook(toc = T, toc_float = T, toc_depth = 3, code_folding = 'hide'))
}

