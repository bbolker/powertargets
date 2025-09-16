## code for placing direct labels in a stacked-area plot
## find positions of stacked lines
## find x,y corresponding to the middle of the widest interval

library(ggplot2)
## test: stacked areas for uneven x, y?
dd <- data.frame(x = c(1:3, (1:3)+0.5, (1:3)+0.25),
                 y = c(rep(1:3, 2), c(2, 2, 2)),
                 g = factor(rep(1:3, each = 3)))
gg0 <- ggplot(dd, aes(x, y, fill = g)) +
  geom_area(position = "stack")
bb <- ggplot_build(gg0)$data[[1]]
posfun <- function(dd) {
  with(dd, {
       w <- which.max(ymax-ymin)
       data.frame(x = x[w], y = (ymin[w] + ymax[w])/2)
       })
}

dpos <- bb |>
  split(bb$group) |>
  lapply(posfun) |>
  do.call(what = rbind)
dpos$label <- levels(dd$g)
  
gg0 + geom_label(data = dpos, mapping = aes(x, y, label = label), fill = "white")
