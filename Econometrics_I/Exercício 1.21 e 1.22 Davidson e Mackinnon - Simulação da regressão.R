# Clique no link para o texto completo: https://www.overleaf.com/read/nqqyrnwqvbbc

# Lista 2 Econometria 1 - Mestrado
# 2016-1
# Exercício 1.21 e 1.22 - David e Mackinnon

# 1.21
# O arquivo consumption.data contém dados de renda disponível e gastos com consumo no Canadá¡,
# com sazonalidade ajustada para o dólar de 1986, que vão do primeiro quadrimestre de 
# 1947 até o último quadrimestre de 1996. O modelo mais simples a ser imaginado para a função
# consumo canadense teria os gastos com consumo como variável dependente, uma constante e a 
# renda disponíel como variáveis independentes. Rode essa regressão para o período de
# 1953:1 a 1996:4. Qual a sua estimativa para a propensão marginal a consumir?

consumo<-read.csv("C:\\Users\\Aishameriane\\Documents\\Arquivos de dados do R\\Econometria - Mestrado\\Dados_consumo.csv", sep=";")
head(consumo)

attach(consumo)

consumo1<-consumo[25:200,]

head(consumo1)

# beta = (Xt * X)^-1 XtY

constante<-rep(1,nrow(consumo1))

X1<-cbind(constante,consumo1$Renda)
head(X1)

beta_chapeu<-solve(t(X1)%*%(X1))%*%t(X1)%*%consumo1$Consumo

beta_chapeu

Consumo_estimado1<- (X1)%*%beta_chapeu

Consumo_estimado1

u <- consumo1$Consumo - Consumo_estimado1

u
sum(u)
head(consumo)
plot(u)

# Exercicio 1.22

set.seed(1234)
erro<-rnorm(nrow(consumo1), 0, sd(u))
erro<-cbind(erro)
erro

Consumo_estimado2<-X1 %*% beta_chapeu + erro


beta_chapeu2<-solve(t(X1)%*%(X1))%*%t(X1)%*%Consumo_estimado2

beta_chapeu2

Consumo_estimado3<- (X1)%*%beta_chapeu2

Consumo_estimado3

u <- Consumo_estimado2 - Consumo_estimado3

u
sum(u)
head(consumo)
plot(u)
