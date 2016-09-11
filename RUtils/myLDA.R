# (nikeethr)TODO: Class names
# (nikeethr)TODO: How to handle factors? can't, LDA is pretty obsolete for this
MyLDR <- function(y, x){
    # (nikeethr)TODO: make function arguments a formula
    ldrout <- list()
    class(ldrout) <- "myldr"
    result <- CalculateMeanAndVar(y, x)
    ldrout$mu <- result[[1]]
    ldrout$var <- result[[2]]
    ldrout$pk <- result[[3]]
    ldrout$names <- result[[4]]
    return(ldrout)
    # Display:
    # Variance by K
    # Mean by K
    # Class Map
    # Output function: log likelihood
}

print.myldr <- function(ldrfit){
    # (nikeethr)TODO: print formula as well
    cat("Mean:\n")
    print(ldrfit$mu)
    cat("\nCovariance:\n")
    print(ldrfit$var)
    cat("\nP_k:\n")
    print(ldrfit$pk)
}

predict.myldr <- function(ldrfit, x){
    if (!is.finite(determinant(ldrfit$var)$modulus)){
        stop("Covariance matrix is not invertible")
    }
    var.inv <- solve(ldrfit$var)
    mu <- ldrfit$mu
    pk <- ldrfit$pk
    pred <- rep(0, NROW(x))
    prob <- rep(0, NROW(mu))
    k <- length(pk)
    a <- var.inv %*% mu
    b <- diag(t(mu) %*% var.inv %*% mu)
    c <- log(pk)
    for (i in 1:NROW(x)){
        prob <- unlist(x[i,]) %*% a - 0.5 * b + c
        pred[i] <- ldrfit$names[which.max(prob)]
    }
    return(pred)
}

CalculateMeanAndVar <- function(y, x){
    # (nikeethr)TODO: how do we deal with NAs
    # (nikeethr)TODO: error conditions for x
    if (!is.vector(y)){
        stop("Error: y is not a vector")
    }
    split.xbyy <- split(x, y)
    k <- length(unique(y))
    n <- length(y)
    nk <- rep(0,k)
    cols <- NCOL(x)
    mu <- lapply(split.xbyy, colMeans)
    # Calcuate covariance
    vr <- matrix(0, cols, cols)
    for (i in 1:k){
        rows <- NROW(split.xbyy[[i]])
        nk[i] <- rows
        xnorm <- split.xbyy[[i]] - matrix(rep(mu[[i]], rows), 
                                          rows, 
                                          cols,
                                          byrow = T)
        for (j in 1:cols){
            for (l in j:cols){
                vr[l,j] <- vr[l,j] + t(xnorm[,l]) %*% xnorm[,j]
                if (l != j){
                    vr[j,l] <- vr[l,j]
                }
            }
        }
    }
    vr <- vr / (n - k)
    mu <- do.call(cbind, mu)
    pk <- nk / n
    k.names <- names(split.xbyy)
    return(list(mu, vr, pk, k.names))
}
