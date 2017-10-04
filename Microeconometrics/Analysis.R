######################################
# Descriptives
######################################

# Packages used
library(gplots)
library(foreign)
library(plm)
library(ggplot2)
library(doBy)
library(corrplot)
library(xtable)
library(stargazer)
library(reshape2)

############################################
# Share of Women
############################################

# Summaryzing data
head(dados)
s_propme <- summarySE(dados, measurevar = "prop_me", groupvars = c("ano.x", "regiao"), na.rm = TRUE)
s_propme

# Making the mean plot
pd <- position_dodge(0.1) # move them .05 to the left and right
pdf("Regions.pdf", width = 5.7, height = 2.75)
ggplot(s_propme, aes(x=ano.x, y=prop_me, colour = regiao, group = regiao)) + 
  geom_errorbar(aes(ymin=prop_me-se, ymax=prop_me+se), colour = "black", width=.1, position = pd) +
  geom_line(position=pd) +
  geom_point(position = pd, size = 3, shape = 21, fill = "white") +
  xlab("Year") +
  ylab("Share of Elected Women") +
  scale_colour_hue(name = "Region",
                   labels = c("Central-West", "Northeast", "North", "Southeast", "South"),
                   l = 40) +
  ggtitle("") +
  theme_bw() +
  theme(plot.title = element_text(size = 10))
  #theme(legend.justification = c(1,0),
        #legend.position = c(1,0)) +
  guides(colour = guide_legend(title.hjust = 0.3))
dev.off()
  
  
# Another graph, without regions

s2_propme <- summarySE(dados, measurevar = "prop_me", groupvars = c("ano.x"), na.rm = TRUE)
s2_propme
pdf("Share.pdf", width = 2.2, height = 2.75)
ggplot(s2_propme, aes(x=ano.x, y=prop_me)) + 
  geom_errorbar(aes(ymin=prop_me-se, ymax=prop_me+se), colour = "black", width=.1, position = pd) +
  geom_line(position=pd) +
  geom_point(position = pd, size = 3, shape = 21, fill = "white") +
  xlab("Year") +
  ylab("Share of Elected Women") +
  #ggtitle("Share of women elected in city council elections in Brazil") +
  theme_bw() +
  theme(plot.title = element_text(size = 10))
dev.off()

# Now the share of female candidates
s2_propcm <- summarySE(dados, measurevar = "prop_cm", groupvars = "ano.x", na.rm = TRUE)
s2_propcm
pdf("Share-candidates.pdf", width = 2.2, height = 2.75)
ggplot(s2_propcm, aes(x=ano.x, y=prop_cm)) + 
  geom_errorbar(aes(ymin=prop_cm-se, ymax=prop_cm+se), colour = "black", width=.1, position = pd) +
  geom_line(position=pd) +
  geom_point(position = pd, size = 3, shape = 21, fill = "white") +
  xlab("Year") +
  ylab("Share of Women Candidates") +
  #ggtitle("Share of candidates in city council elections in Brazil") +
  theme_bw() +
  theme(plot.title = element_text(size = 10))
dev.off()

# Overlaying plots (to look prettier :D )
df1<-data.frame(c(2004,2008,2012,2016,2004,2008,2012,2016),
           c("prop_cm","prop_cm","prop_cm","prop_cm","prop_me","prop_me","prop_me","prop_me"),
           c(20.61005, 20.65634, 32.49647, 33.12181, 12.42661, 12.30195, 13.56884, 13.73379))
df1
colnames(df1)<-c("dados.ano.x", "variable", "value")
df1
pdf("Share-overall.pdf", width = 5.7, height = 2.75)
ggplot(df1, aes(x=dados.ano.x, y=log(value), colour = variable, group = variable)) + 
  geom_line(position=pd) +
  geom_point(position = pd, size = 3, shape = 21, fill = "white") +
  xlab("Year") +
  ylab("Share") +
  scale_colour_hue(name = "Share of",
                   labels = c("Women candidate", "Women Elected"),
                   l = 40) +
  theme(legend.justification = c(1,0),
        legend.position = c(20,0)) +
  guides(colour = guide_legend(title.hjust = 0.3)) +
  theme_bw() +
  theme(plot.title = element_text(size = 10))
dev.off()

# Making boxplots
pdf("Boxplots.pdf", width = 5.7, height = 2.75)
ggplot(dados, aes(x=factor(ano.x), y=prop_me, fill=factor(ano.x))) + 
  geom_boxplot() +
  guides(fill=FALSE)+
  xlab("Year") +
  ylab("Share of Elected Women") +
  #ggtitle("Distribution of the proportion of women elected in city council elections \n Brazil - 2004-2016") +
  theme_bw() +
  theme(plot.title = element_text(size = 10))+
  scale_fill_brewer(palette = "Blues")
dev.off()

# Getting the descriptives
summary(dados$prop_me[dados$ano.x==2004])
summary(dados$prop_me[dados$ano.x==2008], na.rm = TRUE)
summary(dados$prop_me[dados$ano.x==2012])
summary(dados$prop_me[dados$ano.x==2016], na.rm = TRUE)

# Calculating the means
mean(dados$prop_me[dados$ano.x==2004])
mean(dados$prop_me[dados$ano.x==2008], na.rm = TRUE)
mean(dados$prop_me[dados$ano.x==2012])
mean(dados$prop_me[dados$ano.x==2016], na.rm = TRUE)

#######################################################
# Looking into the covariates
#######################################################

summary(dados[dados$ano.x == 2004,])
table(dados$dummy_cota, dados$ano.x)
table(dados$regiao, dados$ano.x)


quantitativas<-subset(dados, ano.x==2004, select = c(prop_me, gini, idhm, idhm_e, idhm_r,
                                        esperanca_anos_estudo, expectativa_vida, percentual_pobres,
                                        percentual_pobres_criancas, pib_pc, taxa_fecundidade, tx_analbabetismo,
                                        pop_urb_proporcao, prop_mul))

xtable(round(cor(quantitativas, method="spearman"),2))

quant_selected<-quantitativas[c("gini", "idhm", "esperanca_anos_estudo", "taxa_fecundidade", "pop_urb_proporcao")]
head(quant_selected)

dtf <- sapply(quant_selected, each(min, mean, max, sd, var))
xtable(dtf)

plotmeans(prop_me ~ dummy_mun, main="Heterogeineity across regions", data=dados[dados$regiao == "Nordeste",], bars = FALSE)

######################################################
# Fitting the model
#######################################################

library(lmtest)
library(plm)

head(dados)

# Fixed effect model
reg_FE1<- plm(ln_prop_me ~ dummy_cota + gini + idhm + esperanca_anos_estudo + taxa_fecundidade  + pop_urb_proporcao + ne + se + su + co + prop_mul, data = dados, index = c("SIGLA_UE", "ano.x"), model = "within")
summary(reg_FE1)
stargazer(reg_FE1)

fixef(reg_FE1)

# FE model estimating two-way effects: time and individuals
# This take more than an hour to run and the results are horrible!
reg_FE2<- plm(ln_prop_me ~ dummy_cota + gini + idhm + esperanca_anos_estudo + taxa_fecundidade  + pop_urb_proporcao + ne + se + su + co  + prop_mul, data = dados, index = c("SIGLA_UE", "ano.x"), model = "within", effect = "twoways")
summary(reg_FE2)

# FE model estimating one effect: time
# This model dropped the dummy
reg_FE3<- plm(ln_prop_me ~ dummy_cota + gini + idhm + esperanca_anos_estudo + taxa_fecundidade  + pop_urb_proporcao + ne + se + su + co  + prop_mul, data = dados, index = c("SIGLA_UE", "ano.x"), model = "within", effect = "time")
summary(reg_FE3)

# FE model estimating one effect: individuals
# This one have the same result from the first
reg_FE4<- plm(ln_prop_me ~ dummy_cota + gini + idhm + esperanca_anos_estudo + taxa_fecundidade  + pop_urb_proporcao + ne + se + su + co  + prop_mul, data = dados, index = c("SIGLA_UE", "ano.x"), model = "within", effect = "individual")
summary(reg_FE4)

# Random effect model
reg_RE<- plm(ln_prop_me ~ dummy_cota + gini + idhm + esperanca_anos_estudo + taxa_fecundidade  + pop_urb_proporcao + ne + se + su + co  + prop_mul, data = dados, index = c("SIGLA_UE", "ano.x"), model = "random")
summary(reg_RE)

# New RE model without non-significant variables
reg_RE2<- plm(ln_prop_me ~ dummy_cota + ne + se + no + co, data = dados, index = c("SIGLA_UE", "ano.x"), model = "random")
summary(reg_RE2)
stargazer(reg_RE2)

# Comparing both models using the Hausman test
phtest(reg_FE1, reg_RE2)

# Pooled OLS
reg_pool<- plm(ln_prop_me ~ dummy_cota + ne + se + su + co, data = dados, index = c("SIGLA_UE", "ano.x"), model = "pooling")
summary(reg_pool)

# Breusch-Pagan Lagrange Multiplier. H0 = no panel effect
plmtest(reg_pool, type=c("bp"))

coeftest(reg_RE2, vcov=vcovHC(reg_RE2, cluster="group"))

alpha<- 0.352854

exp(alpha)
100*(exp(alpha)-1)

boxplot(dados$prop_me ~ dados$dummy_cota)
