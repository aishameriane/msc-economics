## Simulando a distribuição da estatística de teste sob H0
#PGD: 
#$$ y_t=\beta_1 + \beta_2x_t+\beta_3x_t^2+v_t, \qquad E[v_t|x_t]=0. $$
# Modelo estimado :
#$$ y_t=\beta_1 + \beta_2x_t+u_t, \qquad E[u_t|x_t]=0. $$ (sem o beta 3)

#############################
# Usando os dados da renda  #
#############################

renda<-read.csv("C:\\Users\\Aishameriane\\Documents\\Arquivos de dados do R\\Econometria - Mestrado\\serie_renda.csv",sep=";", dec=",")

head(renda)
tail(renda)
renda$Datas=seq(as.Date("1975-01-01"), as.Date("2012-12-01"), by="3 mon")

# Fica apenas com as observações onde o ano é maior ou igual a 1995
renda<-renda[renda$Ano>=1995,] 

# O comando attach() faz com que as variáveis do banco de dados possam ser chamadas pelo nome
attach(renda)

####################################################

n=nrow(renda)
n
# Vetor de betas completo
betas=matrix(c(1000,0.8,-0.01), nrow=3, ncol=1)
betas  

# Vetor de betas sob H0
beta0<-matrix(c(1000,0.8,0), nrow=3, ncol=1)

# Número de regressores
k=length(betas)

# Desvio padrÃ£o do erro
dp=10

# Variáveis independentes do PGD
X=matrix(c(rep(1,n), Renda, Renda^2), nrow=n, ncol=3)
X

head(X)
tail(X)
solve(t(X)%*%(X)) ### The fucking problem is here.

# Simulação dos dados sob H0
v=seq(0,n)
Y=seq(0,n)

# Fixa a semente
set.seed(1234)

# Número de simulações
MC=1000

t_b20<-rep(0,n)

for (i in 1:MC){
  v<-rnorm(n,mean=0,sd=dp)             # simula os erros normais com desvio igual a dp
  Y <- X%*%beta0+v                     # simula a função
  bet <- solve(t(X)%*%(X))%*%t(X)%*%Y  # estima o beta por MQO
  u_c <- Y-X%*%bet                     # calcula o resíduo
  s2<- (t(u_c)%*%u_c)/(n-2)              # estima a variância do erro
  Varb <- s2[1]*solve(t(X)%*%X)         # calcula a variância de beta chapéu
  t_b20[i] <- bet[3]/sqrt(Varb[3,3])    
}

summary(t_b20)

d<-density(t_b20)

head(d)
tzinho<- seq(from = -4,to = 4,by = 0.01)
head(tzinho)
t_nk<- dt(tzinho, n-2)

hist(t_nk)

plot(d, xlim=c(-4,4),col='red', lty=2)
lines(t_nk~tzinho, col='black')
legend("topleft", c("Distribuição empírica", "Distribuição teóica"), cex=.5, col = c("red", "black"), lty = c(1,3))

########################
# Teste de hipóteses   #
########################

# Simulação do modelo bem especificado

v_certo<-rnorm(n,mean=0,sd=dp) 
Y_certo <- X%*%betas+v 

# Estima o modelo por MQO

beta_MQO <- solve(t(X)%*%X)%*%t(X)%*%Y_certo
Y_hat<-X%*%beta_MQO
u_hat<-Y_certo-Y_hat
s2 <- (t(u_hat)%*%u_hat)/(n-k)
invXX <- solve(t(X)%*%X)

beta_MQO

# Calcula a estatística de teste para a amostra

t_b3 <- beta_MQO[3]/sqrt(s2%*%invXX[3,3])

tsim<-c(t_b20,t_b3)

trank<-sort(tsim,decreasing=FALSE)

summary(trank)
length(trank)
length(t_b3)

pos<- match(t_b3,trank)-1

pchapeu<- pos/MC

pchapeu
