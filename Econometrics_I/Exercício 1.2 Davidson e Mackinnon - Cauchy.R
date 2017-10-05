# Exercício com relatório aqui: https://www.overleaf.com/read/ndjgtmtkmkmy

# Gera o vetor para os tamanhos de amostra, com 10.001 valores (iniciando em 0) e retira uma para que o tamanho fique 10.000
amostra<-seq(0,100000,100)
amostra<-amostra[-1]
amostra

# Gera o vetor para armazenar a o tamanho da amostra e a média
media<-rep(0,length(n))

# Percorre os valores de 1 a 10.000
for (i in 1:length(amostra)) 
  j<-amostra[i]            # Salva o i-ésimo valor do vetor amostra em j 
  x<-rcauchy(j,0,1)        # gera j valores de uma cauchy de média zero
  media[i]<-sum(x)/j}      # calcula a média, dividindo a soma dos x pelo tamanho da amostra.

# Faz o gráfico
options(scipen=5)
plot(amostra, media, xlab="Tamanho da amostra", ylab="Média", xlim=c(100,100000), main="Valores da média amostral para 1000 amostras \n de tamanhos diferentes de uma Cauchy")

# Repete o procedimento mas agora para uma distribuição normal padrão
for (i in 1:length(amostra)) {
  j<-amostra[i]
  x<-rnorm(j,0,1)
  media[i]<-sum(x)/j}

options(scipen=5)
plot(amostra, media, xlab="Tamanho da amostra", ylab="Média", xlim=c(100,100000), main="Valores da média amostral para 1000 amostras \n de tamanhos diferentes de uma Normal padrão")

