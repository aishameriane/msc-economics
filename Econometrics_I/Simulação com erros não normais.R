## Exercício de econometria III

# Simulação de teste de hipóteses em um modelo de regressão quando os erros não são normais.

beta<-5

n<-5000

x<-rep(0,n)
u_normal<-rep(0,n)
u_chi<-rep(0,n)
y_normal<-rep(0,n)
y_chi<-rep(0,n)

beta_normal<-rep(0,100)
beta_chi<-rep(0,100)

for(i in 1:100){
  x<-rgamma(n,2,1)
  u_normal<-rnorm(n,0,1)
  u_chi<-rchisq(n,1) ### o termo de erro tem que ter média zero ou adicionar uma constante ao modelo
  y_normal<-beta*x+u_normal
  y_chi<-beta*x+u_chi-mean(u_chi)
  beta_normal[i]<-solve(t(x)%*%(x))%*%t(x)%*%y_normal
  beta_chi[i]<-solve(t(x)%*%(x))%*%t(x)%*%y_chi
  
}

# grafico 

plot(beta_normal, ylim=c(min(beta_normal, beta_chi),max(beta_normal, beta_chi)))
points(beta_chi, col=2)
abline(h=5)

###

# Gráfico com ggplot2 - é necessário instalar o pacote antes de usar

# import the required libraries
library(ggplot2)
library(reshape2)

length(beta_chi)
df = data.frame(beta_normal, beta_chi, count = c(1:length(beta_chi)))

df.m = melt(df, id.vars ="count", measure.vars = c("beta_normal","beta_chi"))

head(df.m)

ggplot(df.m, aes(count, value, colour = variable)) + geom_point() + ylim(min(beta_normal, beta_chi),max(beta_normal, beta_chi))
