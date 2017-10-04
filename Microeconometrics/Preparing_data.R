###########################################################################
# Census Data
###########################################################################

# Load all packages used
library(readstata13)
library(readxl)
library(plyr)
library(electionsBR)
library(dplyr)

# Load the package and read the stata file with census data
censo <- read.dta13("data.dta")
head(censo)

# Read the IBGE file with municipalities' names and codes, drops unused columns and change column names
nomes_municipios <- read_excel("dtb_2010.xls")
head(nomes_municipios)
nomes_municipios<-nomes_municipios[,c(2,7,8)]
colnames(nomes_municipios)<-c("uf", "cod_munic", "nome_municipio")

# Merge data to get the correct names for municipalities and states, make some adjustments
# in the columns
censo_2<-merge(censo,nomes_municipios, by = "cod_munic", all.y=TRUE)
ncol(censo_2)
head(censo_2[,1:5])
censo_2[,3]<-censo_2[,310]
censo_2[,5]<-censo_2[,309]
censo_2<-censo_2[,1:308]
head(censo_2)

# Choose some variables from census to keep

variables<-c("ano", "cod_munic", "nome_municipio.x", "gini", "idhm", "idhm_e", "idhm_l",
             "idhm_r", "pop_rur", "pop_urb", "pop_total", "num_homens_total", "num_mulheres_total",
             "pia", "pea", "pop_ocup", "esperanca_anos_estudo", "expectativa_vida", 
             "num_empregos_formais", "numero_homicidios", "percentual_pobres", "percentual_pobres_criancas",
             "pib_pc", "taxa_fecundidade", "tx_analbabetismo", "pop_urb_proporcao",
             "pia_proporcao", "pop_ocup_proporcao", "ln_pop", "no", "ne", "se", "su",
             "co")
variables
head(censo_2)
censo_3<-censo_2[,variables]

# Verifying temporal stability of the selected variables
little_test<-censo_2[,c("cod_munic", "ano", "gini", "idhm", "esperanca_anos_estudo", "taxa_fecundidade", "pop_urb_proporcao")]
head(little_test)
summary(little_test[little_test$ano == 0,])
summary(little_test[little_test$ano == 1,])

little_testf<-melt(little_test, id.vars = c("cod_munic", "ano"), measure.vars = c("gini", "idhm", "esperanca_anos_estudo", "taxa_fecundidade", "pop_urb_proporcao"))

bp1 <- ggplot(little_testf[little_testf$variable == "gini",], aes(x = factor(ano), y=value, colour = factor(ano)))+
  geom_boxplot(width = .7) +
  xlab("") +
  ylab("Gini Index") +
  scale_x_discrete(labels=c("2000", "2010"))+
  theme_bw() +
  theme(axis.title = element_text(size = 10))+
  theme(legend.position = "none")
bp1

bp2 <- ggplot(little_testf[little_testf$variable == "idhm",], aes(x = factor(ano), y=value, colour = factor(ano)))+
  geom_boxplot(width = .7) +
  xlab("") +
  ylab("HDI") +
  scale_x_discrete(labels=c("2000", "2010"))+
  theme_bw() +
  theme(axis.title = element_text(size = 10))+
  theme(legend.position = "none")
bp2

bp3 <- ggplot(little_testf[little_testf$variable == "esperanca_anos_estudo",], aes(x = factor(ano), y=value, colour = factor(ano)))+
  geom_boxplot(width = .7) +
  xlab("") +
  ylab("Study (yrs)") +
  scale_x_discrete(labels=c("2000", "2010"))+
  theme_bw() +
  theme(axis.title = element_text(size = 10))+
  theme(legend.position = "none")
bp3

bp4 <- ggplot(little_testf[little_testf$variable == "taxa_fecundidade",], aes(x = factor(ano), y=value, colour = factor(ano)))+
  geom_boxplot(width = .7) +
  xlab("") +
  ylab("Fertility Rate") +
  scale_x_discrete(labels=c("2000", "2010"))+
  theme_bw() +
  theme(axis.title = element_text(size = 10))+
  theme(legend.position = "none")
bp4


bp5 <- ggplot(little_testf[little_testf$variable == "pop_urb_proporcao",], aes(x = factor(ano), y=value, colour = factor(ano), group = factor(ano)))+
  geom_boxplot(width = .7) +
  xlab("") +
  ylab("Urban Pop (%)") +
  scale_x_discrete(labels=c("2000", "2010"))+
  theme_bw() +
  theme(axis.title = element_text(size = 10))+
  theme(legend.position = "none")
bp5

pdf("Census-comparison.pdf", width = 5.7, height = 2.75)
gridExtra::grid.arrange(bp1, bp2, bp3, bp4, bp5, ncol=3)
dev.off()

# Choosing saving data from both census (just in case...)
censo_2002<-censo_3[censo_3$ano == 0,]
censo_2010<-censo_3[censo_3$ano == 1,]

# Saving only data from 2010 to use later
censo_3<-censo_3[censo_3$ano == 1]
head(censo_3)

###########################################################################
#    Electoral data (from TSE)
###########################################################################

# Get data from server (local elections from 2004 to 2016)
anos <- seq(2004, 2016, by = 4)
dados <- lapply(anos, candidate_local)

######################################
# YEAR: 2004                           #
######################################

head(dados[[1]])

# Create a list of cities without duplicates

mun<-unique(dados[[1]][c("DESCRICAO_UE", "SIGLA_UE", "SIGLA_UF")])

# Create auxiliary variables
ano<-rep(2004, nrow(mun))
mulher_ver<-rep(0,nrow(mun))
total_ver<-rep(0,nrow(mun))
mulher_ele<-rep(0,nrow(mun))
total_ele<-rep(0,nrow(mun))

# Start a long and inefficient proccess of counting people who match the desired characteristics

for (i in 1:nrow(mun)){
  # Counts women candidates -- CODIGO_SEXO == 4
  # To city council (câmara de vereadores) -- CODIGO_CARGO == 13
  # Whose candidatacy was accepted -- COD_SITUACAO_CANDIDATURA == 2
  # At first round  -- NUM_TURNO == 1
     #(this one is probably redundanct, but helps to avoid data with errors)

  mulher_ver[i]<-length(which(dados[[1]]$SIGLA_UE == mun[i,2] 
                         & dados[[1]]$CODIGO_SEXO == 4 
                         & dados[[1]]$COD_SITUACAO_CANDIDATURA == 2 
                         & dados[[1]]$CODIGO_CARGO == 13 
                         & dados[[1]]$NUM_TURNO == 1))

  # Counts the total number of candidates (both genders)
  # To city council -- CODIGO_CARGO == 13
  # Whose candidatacy was accepted -- COD_SITUACAO_CANDIDATURA == 2
  # At first round  -- NUM_TURNO == 1
      #(this one is probably redundanct, but helps to avoid data with errors)
 
  total_ver[i] <- length(which(dados[[1]]$SIGLA_UE == mun[i,2] 
                             & dados[[1]]$COD_SITUACAO_CANDIDATURA == 2 
                             & dados[[1]]$CODIGO_CARGO == 13 
                             & dados[[1]]$NUM_TURNO == 1))
  
  # Counts women candidates -- CODIGO_SEXO == 4
  # To city council (câmara de vereadores) -- CODIGO_CARGO == 13
  # Whose candidatacy was accepted -- COD_SITUACAO_CANDIDATURA == 2
  # At first round  -- NUM_TURNO == 1
      #(this one is probably redundanct, but helps to avoid data with errors)
  # That were elected -- COD_SIT_TOT_TURNO == 1
  
  mulher_ele[i]<-length(which(dados[[1]]$SIGLA_UE == mun[i,2]
                              & dados[[1]]$CODIGO_SEXO == 4 
                              & dados[[1]]$COD_SITUACAO_CANDIDATURA == 2 
                              & dados[[1]]$CODIGO_CARGO == 13 
                              & dados[[1]]$NUM_TURNO == 1
                              & dados[[1]]$COD_SIT_TOT_TURNO == 1))
  
  # Counts total candidates
  # To city council (câmara de vereadores) -- CODIGO_CARGO == 13
  # Whose candidatacy was accepted -- COD_SITUACAO_CANDIDATURA == 2
  # At first round  -- NUM_TURNO == 1
  #(this one is probably redundanct, but helps to avoid data with errors)
  # That were elected -- COD_SIT_TOT_TURNO == 1
  
  total_ele[i]<-length(which(dados[[1]]$SIGLA_UE == mun[i,2]
                              & dados[[1]]$COD_SITUACAO_CANDIDATURA == 2 
                              & dados[[1]]$CODIGO_CARGO == 13 
                              & dados[[1]]$NUM_TURNO == 1
                              & dados[[1]]$COD_SIT_TOT_TURNO == 1))
}

# Creates a data-frame with all variables that were calculated in the for loop
eleicoes_2004<-cbind(mun, ano, mulher_ver, total_ver, mulher_ele, total_ele)
eleicoes_2004<-as.data.frame(eleicoes_2004)

head(eleicoes_2004)

######################################
# YEAR: 2008                         #
######################################

# Create a list of cities without duplicates
mun<-unique(dados[[2]][c("DESCRICAO_UE", "SIGLA_UE", "SIGLA_UF")])

# Create auxiliary variables
ano<-rep(2008, nrow(mun))
mulher_ver<-rep(0,nrow(mun))
total_ver<-rep(0,nrow(mun))
mulher_ele<-rep(0,nrow(mun))
total_ele<-rep(0,nrow(mun))

# Start a long and inefficient proccess of counting people who match the desired characteristics

for (i in 1:nrow(mun)){
  # Counts women candidates -- CODIGO_SEXO == 4
  # To city council (câmara de vereadores) -- CODIGO_CARGO == 13
  # Whose candidatacy was accepted -- COD_SITUACAO_CANDIDATURA == 2
  # At first round  -- NUM_TURNO == 1
        #(this one is probably redundanct, but helps to avoid data with errors)
  
  mulher_ver[i]<-length(which(dados[[2]]$SIGLA_UE == mun[i,2] 
                              & dados[[2]]$CODIGO_SEXO == 4 
                              & dados[[2]]$COD_SITUACAO_CANDIDATURA == 2 
                              & dados[[2]]$CODIGO_CARGO == 13 
                              & dados[[2]]$NUM_TURNO == 1))
  
  # Counts the total number of candidates (both genders)
  # To city council -- CODIGO_CARGO == 13
  # Whose candidatacy was accepted -- COD_SITUACAO_CANDIDATURA == 2
  # At first round  -- NUM_TURNO == 1
       #(this one is probably redundanct, but helps to avoid data with errors)
  
  total_ver[i] <- length(which(dados[[2]]$SIGLA_UE == mun[i,2] 
                               & dados[[2]]$COD_SITUACAO_CANDIDATURA == 2 
                               & dados[[2]]$CODIGO_CARGO == 13 
                               & dados[[2]]$NUM_TURNO == 1))
  
  # Counts women candidates -- CODIGO_SEXO == 4
  # To city council (câmara de vereadores) -- CODIGO_CARGO == 13
  # Whose candidatacy was accepted -- COD_SITUACAO_CANDIDATURA == 2
  # At first round  -- NUM_TURNO == 1
        #(this one is probably redundanct, but helps to avoid data with errors)
  # That were elected -- COD_SIT_TOT_TURNO == 1
  
  mulher_ele[i]<-length(which(dados[[2]]$SIGLA_UE == mun[i,2]  
                              & dados[[2]]$CODIGO_SEXO == 4 
                              & dados[[2]]$COD_SITUACAO_CANDIDATURA == 2 
                              & dados[[2]]$CODIGO_CARGO == 13 
                              & dados[[2]]$NUM_TURNO == 1
                              & dados[[2]]$COD_SIT_TOT_TURNO == 1))
  
  # Counts total candidates
  # To city council (câmara de vereadores) -- CODIGO_CARGO == 13
  # Whose candidatacy was accepted -- COD_SITUACAO_CANDIDATURA == 2
  # At first round  -- NUM_TURNO == 1
      # (this one is probably redundanct, but helps to avoid data with errors)
  # That were elected -- COD_SIT_TOT_TURNO == 1
  
  total_ele[i]<-length(which(dados[[2]]$SIGLA_UE == mun[i,2] 
                             & dados[[2]]$COD_SITUACAO_CANDIDATURA == 2 
                             & dados[[2]]$CODIGO_CARGO == 13 
                             & dados[[2]]$NUM_TURNO == 1
                             & dados[[2]]$COD_SIT_TOT_TURNO == 1))
}

# Creates a data-frame with all variables that were calculated in the for loop
eleicoes_2008<-cbind(mun, ano, mulher_ver, total_ver, mulher_ele, total_ele)
eleicoes_2008<-as.data.frame(eleicoes_2008)

######################################
# YEAR: 2012                         #
######################################

# Create a list of cities without duplicates
mun<-unique(dados[[3]][c("DESCRICAO_UE", "SIGLA_UE", "SIGLA_UF")])

# Create auxiliary variables
ano<-rep(2012, nrow(mun))
mulher_ver<-rep(0,nrow(mun))
total_ver<-rep(0,nrow(mun))
mulher_ele<-rep(0,nrow(mun))
total_ele<-rep(0,nrow(mun))

# Start a long and inefficient proccess of counting people who match the desired characteristics
for (i in 1:nrow(mun)){
  # Counts women candidates -- CODIGO_SEXO == 4
  # To city council (câmara de vereadores) -- CODIGO_CARGO == 13
  # Whose candidatacy was accepted -- COD_SITUACAO_CANDIDATURA == 2
  # At first round  -- NUM_TURNO == 1
       #(this one is probably redundanct, but helps to avoid data with errors)
  
  mulher_ver[i]<-length(which(dados[[3]]$SIGLA_UE == mun[i,2]
                              & dados[[3]]$CODIGO_SEXO == 4 
                              & dados[[3]]$COD_SITUACAO_CANDIDATURA == 2 
                              & dados[[3]]$CODIGO_CARGO == 13 
                              & dados[[3]]$NUM_TURNO == 1))
  
  # Counts the total number of candidates (both genders)
  # To city council -- CODIGO_CARGO == 13
  # Whose candidatacy was accepted -- COD_SITUACAO_CANDIDATURA == 2
  # At first round  -- NUM_TURNO == 1
        #(this one is probably redundanct, but helps to avoid data with errors)

  total_ver[i] <- length(which(dados[[3]]$SIGLA_UE == mun[i,2] 
                               & dados[[3]]$COD_SITUACAO_CANDIDATURA == 2 
                               & dados[[3]]$CODIGO_CARGO == 13 
                               & dados[[3]]$NUM_TURNO == 1))
  
  # Counts women candidates -- CODIGO_SEXO == 4
  # To city council (câmara de vereadores) -- CODIGO_CARGO == 13
  # Whose candidatacy was accepted -- COD_SITUACAO_CANDIDATURA == 2
  # At first round  -- NUM_TURNO == 1
      #(this one is probably redundanct, but helps to avoid data with errors)
  # That were elected -- COD_SIT_TOT_TURNO == 1
  
  mulher_ele[i]<-length(which(dados[[3]]$SIGLA_UE == mun[i,2]
                              & dados[[3]]$CODIGO_SEXO == 4 
                              & dados[[3]]$COD_SITUACAO_CANDIDATURA == 2 
                              & dados[[3]]$CODIGO_CARGO == 13 
                              & dados[[3]]$NUM_TURNO == 1
                              & (dados[[3]]$COD_SIT_TOT_TURNO == 1 
                                      | dados[[3]]$COD_SIT_TOT_TURNO == 2 
                                      | dados[[3]]$COD_SIT_TOT_TURNO == 3)))
  
  # Counts total candidates
  # To city council (câmara de vereadores) -- CODIGO_CARGO == 13
  # Whose candidatacy was accepted -- COD_SITUACAO_CANDIDATURA == 2
  # At first round  -- NUM_TURNO == 1
  # (this one is probably redundanct, but helps to avoid data with errors)
  # That were elected -- COD_SIT_TOT_TURNO == 1
  
  total_ele[i]<-length(which(dados[[3]]$SIGLA_UE == mun[i,2] 
                             & dados[[3]]$COD_SITUACAO_CANDIDATURA == 2 
                             & dados[[3]]$CODIGO_CARGO == 13 
                             & dados[[3]]$NUM_TURNO == 1
                             & (dados[[3]]$COD_SIT_TOT_TURNO == 1 
                                | dados[[3]]$COD_SIT_TOT_TURNO == 2 
                                | dados[[3]]$COD_SIT_TOT_TURNO == 3)))
}



# Creates a data-frame with all variables that were calculated in the for loop
eleicoes_2012<-cbind(mun, ano, mulher_ver, total_ver, mulher_ele, total_ele)
eleicoes_2012<-as.data.frame(eleicoes_2012)

head(eleicoes_2012)

######################################
# YEAR: 2016                         #
######################################

# Create a list of cities without duplicates
mun<-unique(dados[[4]][c("DESCRICAO_UE", "SIGLA_UE", "SIGLA_UF")])

# Create auxiliary variables
ano<-rep(2016, nrow(mun))
mulher_ver<-rep(0,nrow(mun))
total_ver<-rep(0,nrow(mun))
mulher_ele<-rep(0,nrow(mun))
total_ele<-rep(0,nrow(mun))

# Start a long and inefficient proccess of counting people who match the desired characteristics
for (i in 1:nrow(mun)){
  # Counts women candidates -- CODIGO_SEXO == 4
  # To city council (câmara de vereadores) -- CODIGO_CARGO == 13
  # Whose candidatacy was accepted -- COD_SITUACAO_CANDIDATURA == 2
  # At first round  -- NUM_TURNO == 1
       #(this one is probably redundanct, but helps to avoid data with errors)
  
  mulher_ver[i]<-length(which(dados[[4]]$SIGLA_UE == mun[i,2]  
                              & dados[[4]]$CODIGO_SEXO == 4 
                              & dados[[4]]$COD_SITUACAO_CANDIDATURA == 2 
                              & dados[[4]]$CODIGO_CARGO == 13 
                              & dados[[4]]$NUM_TURNO == 1))
  
  # Counts the total number of candidates (both genders)
  # To city council -- CODIGO_CARGO == 13
  # Whose candidatacy was accepted -- COD_SITUACAO_CANDIDATURA == 2
  # At first round  -- NUM_TURNO == 1
       #(this one is probably redundanct, but helps to avoid data with errors)
  
  total_ver[i] <- length(which(dados[[4]]$SIGLA_UE == mun[i,2]  
                               & dados[[4]]$COD_SITUACAO_CANDIDATURA == 2 
                               & dados[[4]]$CODIGO_CARGO == 13 
                               & dados[[4]]$NUM_TURNO == 1))
  
  # Counts women candidates -- CODIGO_SEXO == 4
  # To city council (câmara de vereadores) -- CODIGO_CARGO == 13
  # Whose candidatacy was accepted -- COD_SITUACAO_CANDIDATURA == 2
  # At first round  -- NUM_TURNO == 1
      #(this one is probably redundanct, but helps to avoid data with errors)
  # That were elected -- COD_SIT_TOT_TURNO == 1
  
  mulher_ele[i]<-length(which(dados[[4]]$SIGLA_UE == mun[i,2]  
                              & dados[[4]]$CODIGO_SEXO == 4 
                              & dados[[4]]$COD_SITUACAO_CANDIDATURA == 2 
                              & dados[[4]]$CODIGO_CARGO == 13 
                              & dados[[4]]$NUM_TURNO == 1
                              & (dados[[4]]$COD_SIT_TOT_TURNO == 1 
                                 | dados[[4]]$COD_SIT_TOT_TURNO == 2 
                                 | dados[[4]]$COD_SIT_TOT_TURNO == 3)))
  
  # Counts total candidates
  # To city council (câmara de vereadores) -- CODIGO_CARGO == 13
  # Whose candidatacy was accepted -- COD_SITUACAO_CANDIDATURA == 2
  # At first round  -- NUM_TURNO == 1
       # (this one is probably redundanct, but helps to avoid data with errors)
  # That were elected -- COD_SIT_TOT_TURNO == 1
  
  total_ele[i]<-length(which(dados[[4]]$SIGLA_UE == mun[i,2]  
                             & dados[[4]]$COD_SITUACAO_CANDIDATURA == 2 
                             & dados[[4]]$CODIGO_CARGO == 13 
                             & dados[[4]]$NUM_TURNO == 1
                             & (dados[[4]]$COD_SIT_TOT_TURNO == 1 
                                | dados[[4]]$COD_SIT_TOT_TURNO == 2 
                                | dados[[4]]$COD_SIT_TOT_TURNO == 3)))
}


# Creates a data-frame with all variables that were calculated in the for loop
eleicoes_2016<-cbind(mun, ano, mulher_ver, total_ver, mulher_ele, total_ele)
eleicoes_2016<-as.data.frame(eleicoes_2016)



# Merge all electoral data in one data.frame and saves in csv format

eleicoes<-rbind(eleicoes_2004, eleicoes_2008, eleicoes_2012, eleicoes_2016)

# Calculating the proportions

eleicoes$prop_cm <- round((eleicoes$mulher_ver/eleicoes$total_ver)*100,5)
eleicoes$prop_me <- round((eleicoes$mulher_ele/eleicoes$total_ele)*100,5)

eleicoes$ln_prop_cm<-ifelse(log(eleicoes$prop_cm)==-Inf, 0, log(eleicoes$prop_cm)) 
eleicoes$ln_prop_me<-ifelse(log(eleicoes$prop_me)==-Inf,0,log(eleicoes$prop_me))

write.csv(eleicoes, file = "eleicoes.csv", quote = FALSE)

###############################################################################
# Merging everything
###############################################################################

# First, we put the TSE Key in census data (key from: https://github.com/tbrugz/ribge)
chave_mun<-read.csv("ibge-tse-map.csv")
head(chave_mun)
rownames(chave_mun)<-c("uf", "cod_munic", "cod_")
censo_4<- merge(censo_3, chave_mun, by.x = "cod_munic", by.y = "cod_municipio_ibge", all.x = TRUE)
head(censo_4)

# Now we merge with elections data

dados<-merge(eleicoes, censo_4, by.x = "SIGLA_UE", by.y = "cod_municipio_tse", all.x = TRUE)
head(dados)

# Save in one csv file and hope to never again have to re-do this calculations

write.csv(dados, file = "dados_completos.csv", quote = FALSE)
fac
######################################################################################
# Database manipulation
######################################################################################

# Reading the csv file
dados<-read.csv("dados_completos.csv")

# Eliminates municipalities that for some reason has NA in their codes
# I made this by visual inspection because for some odd reason could't do using a more autonomous rotine
# 12 observations were dropped - they had only 3 data.
# I think the trouble was in the archives with keys from IBGE. Maybe they are new places, but I'll check them later.

summary(dados$cod_munic)
dados[is.na(dados$cod_munic),]
mun_drop <- unique(dados[is.na(dados$cod_munic),"DESCRICAO_UE"])
dados<-dados[!is.na(dados$cod_munic),]

# Creating dummies for the law (0 if year = 04 or 08 and 1 otherwise)
dados$dummy_cota<- ifelse(dados$ano.x == 2004 | dados$ano.x == 2008, 0, 1)
table(dados$dummy_cota, dados$ano.x)

# Creating categorical variable for years (EF_t)
dados$dummy_ano<- ifelse(dados$ano.x == 2004, 0, ifelse(dados$ano.x == 2008, 1, ifelse(dados$ano.x == 2012, 2, 3)))
table(dados$dummy_ano, dados$ano.x)

# Creating year dummies
dados$a04 <- ifelse(dados$ano.x == 2004, 1, 0)
dados$a08 <- ifelse(dados$ano.x == 2008, 1, 0)
dados$a12 <- ifelse(dados$ano.x == 2012, 1, 0)
dados$a16 <- ifelse(dados$ano.x == 2016, 1, 0)

# Creating the fixed effect for municipalities
dados$dummy_mun <- as.double(factor(dados$cod_munic)) - 1
summary(dados$dummy_mun)

# Calculates the proportion of women in the city
dados$prop_mul <- round(dados$num_mulheres_total/dados$pop_total*100,2)

# Creates a factor for region
dados$regiao <- ifelse(dados$no == 1, "Norte", 
                       ifelse(dados$ne == 1, "Nordeste", 
                              ifelse(dados$se == 1, "Sudeste",
                                     ifelse(dados$su == 1, "Sul","Centro-Oeste"))))
table(dados$regiao)
