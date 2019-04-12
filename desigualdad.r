# install.packages('ineq')

data = read.csv("NCV_concentrado_2014_concil_2010.csv")

values = data$ing_cor
weights = data$factor_hog
integ = data$tot_integ

# Per cápita
values = data$ing_cor / data$tot_integ
weights = data$factor_hog * data$tot_integ

library(ineq)
l <- Lc(values / 3, weights)

png('lorenz.png')
plot(l, general=TRUE, col="red")
dev.off()

ineq_curve <- function(x, n)
{
    o <- order(values)
    x <- x[o]
    n <- n[o]

    p <- (cumsum(n) / sum(n)) * 100

    plot(p, x,
         type="l", col="blue", xlab="poblacion", ylab="ingreso")
}

png('desigualdad.png')
ineq_curve(values / 3, weights)
dev.off()
