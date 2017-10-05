lambda <- seq(-5,5,0.01)

c_alpha1<-qnorm(1-0.05/2)
c_alpha1
c_alpha2<-qnorm(1-0.01/2)
c_alpha2

poder1<-1:1001
poder2<-1:1001

for (i in 1:length(lambda)) {
  poder1[i]<-pnorm(lambda[i]-c_alpha1)+pnorm(-c_alpha1 - lambda[i])
  poder2[i]<-pnorm(lambda[i]-c_alpha2)+pnorm(-c_alpha2 - lambda[i])
}


plot(lambda, poder1, main = "Função Poder de um teste z", type = "l", col="red", xlab="Lambda", ylab="Poder")
lines(lambda,poder2, type="l", col="black")

labels <- c("0.05", "0.01")
legend("bottomright", inset=.05, title="Valores de Alpha", legend=labels, lwd=2, lty=c(1, 1, 1, 1, 2), col=c("red","black"),cex=0.6)
