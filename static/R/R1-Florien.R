


# =========================================================================================================
# REGRESSION LOGISTIQUE
# =========================================================================================================


# ---------------------------------------------------------------------------------------------------------
# exemples vus en cours
# ---------------------------------------------------------------------------------------------------------


# Comparaison des r?gressions lin?aire et logistique

set.seed(42)
n <- 100
x <- c(rnorm(n), 1+rnorm(n))
y <- c(rep(0,n), rep(1,n))
plot(y~x)
# pr?diction brutale
m1 <- mean(x[y==0])
m2 <- mean(x[y==1])
m <- mean(c(m1,m2))
if(m1<m2) a <- 0
if(m1>m2) a <- 1
if(m1==m2) a <- .5
lines( c(min(x),m,m,max(x)), c(a,a,1-a,1-a), col='blue')  
# r?gression lin?aire
abline(lm(y~x), col='red')
# r?gression logistique
xp <- seq(min(x), max(x), length=200)
mod <- glm(y~x, family=binomial(link = "logit"))
yp <- predict(mod, data.frame(x=xp), type='response')
lines(xp, yp, col='orange') 
# courbe th?orique
curve(dnorm(x,1,1)*.5/(dnorm(x,1,1)*.5+dnorm(x,0,1)*(1-.5)), add=T, lty=3, lwd=3)
legend( .95*par('usr')[1]+.05*par('usr')[2], .9, #par('usr')[4],
        c('pr?diction brutale', "r?gression lin?aire", "r?gression logit", "courbe th?orique"),
        col=c('blue','red','orange', par('fg')), lty=c(1,1,1,3), lwd=c(1,1,1,3))
title(main="Comparaison des r?gressions lin?aire et logistique")

# s?paration compl?te en r?gression logistique

X1  <- c(9,10,11,11,12,14,14,15,16,18,12,13,15,17,19,18,20,21,22,23)
X2  <- c(42,63,54,68,48,37,55,60,52,62,15,9,20,5,19,44,34,11,40,23)
Y1 <- c(0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1)
Y2 <- c(0,0,0,0,0,0,0,0,1,0,1,1,1,1,1,1,1,1,1,1)
plot(X1, X2, col=factor(Y1), cex=2, pch=16)
modele1 <- glm(Y1~X1+X2, family=binomial(link = "logit"))
summary(modele1)
# s?paration incompl?te
plot(X1, X2, col=factor(Y2), cex=2, pch=16)
modele2 <- glm(Y2~X1+X2, family=binomial(link = "logit"))
summary(modele2)



# ---------------------------------------------------------------------------------------------------------
# exemple th?orique de recherche du maximum de vraisemblance
# ---------------------------------------------------------------------------------------------------------

# jeu de donn?es
set.seed(123) 
n <- 1000
p <- 5
A <- matrix (runif(n*p), n, p)
A <- data.frame(A, y = sample(c(0,1), n, replace = T))
dim(A)
head(A)
Y <- A[,"y"]
X <- as.matrix(cbind(1, A[,!names(A) %in% "y"]))

# r?gression logistique avec glm
system.time(L <- glm(y ~., data=A, family=binomial(link="logit")))
summary(L)

# r?gression logistique "? la main"
time <- proc.time()
maxiter <- 5
beta <- lm(Y~0+X)$coefficients
for (s in 1:maxiter){
pi <- 1/(1+exp(-X%*%beta)) 
gradient <- t(X)%*%(Y-pi)
omega <- matrix(0,nrow(X),nrow(X))
diag(omega) <- (pi*(1-pi))
hessian <- -t(X)%*%omega%*%X
if (sum(abs(solve(hessian)%*%gradient)) < (p*0.000001)) break
beta <- beta - solve(hessian)%*%gradient
}
sd <- sqrt(diag(solve(-hessian)))
# p-value associ?e au test de Student
modele <- data.frame(beta, sd, beta/sd, 2*(1-pnorm(abs(beta/sd))))
colnames(modele) <- c("Estimate", "Std. Error", "z value", "Pr(>|z|)")
modele
cat("\n", "Convergence en ", s-1 ," it?rations","\n")
proc.time() - time

# l'encapsulage du code dans une fonction divise son temps d'ex?cution par au moins 3
f <- function(x,y){
maxiter <- 5
beta <- lm(y~0+x)$coefficients
for (s in 1:maxiter){
pi <- 1/(1+exp(-x%*%beta)) 
gradient <- t(x)%*%(y-pi)
omega <- matrix(0,nrow(x),nrow(x))
diag(omega) <- (pi*(1-pi))
hessian <- -t(x)%*%omega%*%x
if (sum(abs(solve(hessian)%*%gradient)) < (p*0.000001)) break
beta <- beta - solve(hessian)%*%gradient
}
sd <- sqrt(diag(solve(-hessian)))
# p-value associ?e au test de Student
modele <- data.frame(beta, sd, beta/sd, 2*(1-pnorm(abs(beta/sd))))
colnames(modele) <- c("Estimate", "Std. Error", "z value", "Pr(>|z|)")
print(modele)
cat("\n", "Convergence en ", s-1 ," it?rations","\n")
}
system.time(f(X,Y))



# =========================================================================================================
# ANALYSE DES DONNEES
# =========================================================================================================


# ---------------------------------------------------------------------------------------------------------
# jeu de donn?es "German Credit"
# ---------------------------------------------------------------------------------------------------------

# noms des variables
myVariableNames <- c("Comptes","Duree_credit","Historique_credit","Objet_credit",
"Montant_credit","Epargne","Anciennete_emploi","Taux_effort",
"Situation_familiale","Garanties","Anciennete_domicile","Biens","Age",
"Autres_credits","Statut_domicile","Nb_credits","Type_emploi",
"Nb_pers_charge","Telephone","Etranger","Cible")

# jeu de donn?es
credit = read.table("http://archive.ics.uci.edu/ml/machine-learning-databases/statlog/german/german.data", h=FALSE, col.names=myVariableNames)
credit = read.table("D:/Data Mining/Universit? Rennes 1/Cours/Cours Data Mining/Donn?es/german credit risk dataset.txt", h=F, col.names=myVariableNames)
credit = read.table("C:/Users/TUFFERST/Documents/Data Mining/Cours Data Mining/Master Rennes/Cours Data Mining/Donn?es/german credit risk dataset.txt", h=F, col.names=myVariableNames)

credit$Etranger <- NULL

# variable ? expliquer
credit$Cible[credit$Cible == 1] <- 0 # cr?dits OK
credit$Cible[credit$Cible == 2] <- 1 # cr?dits KO
credit$Cible <- factor(credit$Cible)

# transformation en facteurs des variables discr?tes
credit[["Taux_effort"]] <- factor(credit[["Taux_effort"]])
credit[["Anciennete_domicile"]] <- factor(credit[["Anciennete_domicile"]])
credit[["Nb_credits"]] <- factor(credit[["Nb_credits"]])
credit[["Nb_pers_charge"]] <- factor(credit[["Nb_pers_charge"]])



# ---------------------------------------------------------------------------------------------------------
# jeu de donn?es "German Credit" : libell?s des modalit?s
# ---------------------------------------------------------------------------------------------------------


# recodage et fusion des modalit?s
install.packages("pbkrtest", dependencies = TRUE)
install.packages("quantreg", dependencies = TRUE)
install.packages("lme4", dependencies = TRUE)

install.packages("car",dependencies=TRUE)

library(car)
credit2 <- credit

# attention aux simples et doubles quotes dans le "recode"

credit2$Comptes <- recode(credit$Comptes,"
      'A11'='CC < 0 euros';
      'A12'='CC [0-200 euros[';
      'A13'='CC > 200 euros';
      'A14'='Pas de compte'")
table(credit2$Comptes)

credit2$Historique_credit <- recode(credit$Historique_credit,"
      'A30' = 'Impay?s pass?s';
      'A31' = 'Impay? en cours dans autre banque'; 
      'A32' = 'Jamais aucun cr?dit';
      'A33' = 'Cr?dits en cours sans retard' ; 
      'A34' = 'Cr?dits pass?s sans retard'")
table(credit2$Historique_credit)

credit2$Objet_credit <- recode(credit$Objet_credit,"
	 'A40'='Voiture neuve';
	 'A41' = 'Voiture occasion';
     'A42' = 'Mobilier';
     'A43' = 'Vid?o HIFI';
     'A44' = 'Electrom?nager';
     'A45' = 'Travaux';
     'A46' = 'Etudes';
     'A47' = 'Vacances';
     'A48' = 'Formation';
     'A49' = 'Business';
      else = 'Autres'")
table(credit2$Objet_credit)

credit2$Epargne <- recode(credit$Epargne,"
      'A61' = '< 100 euros';
      'A62' = '[100-500 euros['; 
      'A63' = '[500-1000 euros['; 
      'A64' = '+ de 1000 euros';
      'A65' = 'Sans ?pargne'")
table(credit2$Epargne)

credit2$Anciennete_emploi<- recode(credit$Anciennete_emploi,"
      'A71' = 'Sans emploi';
      'A72' = 'Empl < 1 an';
      'A73' = 'Empl dans [1-4[ ans';
      'A74' = 'Empl dans [4-7[ ans';
      'A75' = 'Empl + de 7 ans'")
table(credit2$Anciennete_emploi)

credit2$Situation_familiale<- recode(credit$Situation_familiale,"
     'A91' = 'Homme divorc?/s?par?';
     'A92' = 'Femme divorc?e/s?par?e/mari?e';
     'A93' = 'Homme c?libataire';
     'A94' = 'Homme mari?/veuf';
     'A95' = 'Femme c?libataire'")
table(credit2$Situation_familiale)

credit2$Garanties <- recode(credit$Garanties,"
     'A101' = 'Pas de garantie';
     'A102' = 'Co-emprunteur';
     'A103' = 'Garant'")
table(credit2$Garanties)

credit2$Biens <- recode(credit$Biens,"
     'A121' = 'Immobilier';
     'A122' = 'Assurance-vie';
     'A123' = 'Voiture ou autre';
     'A124' = 'Aucun bien connu'")
table(credit2$Biens)

credit2$Autres_credits <- recode(credit$Autres_credits,"
     'A141' = 'Autres banques';
     'A142' = '?tablissements cr?dit';
     'A143' = 'Aucun cr?dit'")
table(credit2$Autres_credits)

credit2$Statut_domicile <- recode(credit$Statut_domicile,"
     'A151' = 'Locataire';
     'A152' = 'Propri?taire';
     'A153' = 'Logement gratuit'")
table(credit2$Statut_domicile)

credit2$Type_emploi <- recode(credit$Type_emploi,"
     'A171' = 'Sans emploi';
     'A172' = 'Non qualifi?';
     'A173' = 'Employ?-Ouvrier qualifi?';
     'A174' = 'Cadre'")
table(credit2$Type_emploi)

credit2$Anciennete_domicile <- recode(credit$Anciennete_domicile,"
      1 = 'Dom < 1 an';
      2 = 'Dom dans [1-4[ ans';
      3 = 'Dom dans [4-7[ ans';
      4 = 'Dom + de 7 ans' ")
table(credit2$Anciennete_domicile)

credit2$Nb_credits <- recode(credit$Nb_credits,"
      1 = '1 cr?dit ';
      2 = '2 ou 3 cr?dits';
      3 = '4 ou 5 cr?dits';
      4 = '+ de 6 cr?dits' ")
table(credit2$Nb_credits)

credit2$Nb_pers_charge <- recode(credit$Nb_pers_charge,"
      1 = '0-2 pers';
      2 = '+ de 3 pers' ")
table(credit2$Nb_pers_charge)

credit2$Taux_effort <- recode(credit$Taux_effort,"
      1 = 'Endt < 20 %   ';
      2 = 'Endt dans [20-25 %[';
      3 = 'Endt dans [25-35 %[';
      4 = 'Endt + de 35 %  ' ")
table(credit2$Taux_effort)

credit2$Telephone <- recode(credit$Telephone,"
     'A191' = 'Sans T?l';
     'A192' = 'Avec T?l' ")
table(credit2$Telephone)

# structure du fichier de cr?dit apr?s transformations
summary(credit2)




# =========================================================================================================
# ECHANTILLONS D'APPRENTISSAGE ET DE TEST
# =========================================================================================================
install.packages('sampling')

# tirage al?atoire simple sans remise
set.seed(123)
id <- sort(sample(nrow(credit), nrow(credit)*2/3, replace=F))

# tirage al?atoire stratifi? sans remise
library(sampling)
set.seed(123)
id <- strata(credit, stratanames="Cible", size=c(sum(credit$Cible==0)*2/3,sum(credit$Cible==1)*2/3), method="srswor", description=T)$ID_unit
id
# ?chantillons d'apprentissage et de validation
train  <- credit2[id,]
valid  <- credit2[-id,]
table(train$Cible)/nrow(train)
table(valid$Cible)/nrow(valid)
?strata
# mod?le logit sur donn?es non retravaill?es

logit <- glm(Cible~., data=train, family=binomial(link = "logit"))
logit <- glm(Cible~Comptes+Historique_credit+Duree_credit+Age+Epargne+Garanties+Autres_credits, data=train, family=binomial(link = "logit"))
summary(logit)
pred.logit <- predict(logit, newdata=valid, type="response")
# aire sous la courbe ROC
install.packages("pROC")
library(pROC)
auc(valid$Cible,pred.logit, quiet=TRUE) # Area under the curve: 0.7517
# nombre de coefficients non significatifs au seuil de 5%
sum(summary(logit)$coefficients[,4] >= 0.05) # 12

# mod?le logit sur WOE
woe <- function(X,Y){
tab <- table(X,Y)
woe <- log((tab[,1]/sum(tab[,1])) /(tab[,2]/sum(tab[,2])))
levels(X) <- woe
return(as.numeric(as.character(X)))
}
Z <- woe(credit2$Comptes,credit2$Cible)
table(Z,credit2$Cible)
# application de la fonction pr?c?dente ? toutes les variables explicatives qui sont des facteurs
varquali   <- intersect(which(sapply(credit2, is.factor)==T), which(names(credit2) != "Cible"))
varquanti  <- setdiff(names(credit2), names(credit2)[varquali])
credit_woe <- sapply(varquali, function(i) woe(credit2[[i]], credit2$Cible))
colnames(credit_woe) <- names(credit2)[varquali]
credit_woe <- data.frame(credit_woe, credit2[,varquanti])
head(credit_woe)
# ?chantillons d'apprentissage et de validation
train  <- credit_woe[id,]
valid  <- credit_woe[-id,]
# mod?le logit
logit <- glm(Cible~Comptes+Historique_credit+Duree_credit+Age+Epargne+Garanties+Autres_credits, data=train, family=binomial(link = "logit"))
summary(logit)
pred.logit <- predict(logit, newdata=valid, type="response")
head(pred.logit)
auc(valid$Cible, pred.logit, quiet=TRUE) # Area under the curve: 0.7594
# nombre de coefficients non significatifs au seuil de 5%
sum(summary(logit)$coefficients[,4] >= 0.05) # 1

# fonction de s?lection de variables sur la base de la significativit? des coefficients des mod?les sur des ?chantillons bootstrap
library(boot)
fonction <- function(data, i){
  d <- data[i,]
  logit <- glm(Cible ~ ., data=d, family=binomial(link = "logit"))
  return((summary(logit)$coefficients[,4] < 0.05))
}
fonction(credit,1:1000)
set.seed(123)
(resultat <- boot(data=credit, statistic=fonction, R=100))
resultat$t0
resultat$t
apply(resultat$t,2,sum)
as.matrix(cbind(resultat$t0, apply(resultat$t,2,sum)))



# =========================================================================================================
# PREPARATION DES DONNEES POUR LA REGRESSION LOGISTIQUE
# =========================================================================================================


# ---------------------------------------------------------------------------------------------------------
# premi?res analyses descriptives
# ---------------------------------------------------------------------------------------------------------

credit <- credit2

# statistiques de base
summary(credit)
library(Hmisc)
hist.data.frame(credit[,1:16])

# statistiques descriptives par groupes
by(credit[,c("Age","Duree_credit","Montant_credit")], list(Cible=credit$Cible), summary)
by(credit[,1:20], list(Cible=credit$Cible), summary)

# test de Kruskal-Wallis
kruskal.test(credit$Age~credit$Cible)$statistic
kruskal.test(credit$Duree_credit~credit$Cible)$statistic
kruskal.test(credit$Montant_credit~credit$Cible)$statistic

# histogramme
library(lattice)
histogram(~Duree_credit | Cible , data = credit, type="percent", col="grey", breaks=10)
histogram(~Montant_credit | Cible , data = credit, type="percent", col="grey", breaks=20)
histogram(~Age | Cible , data = credit, type="percent", col="grey", breaks=10)

# superposition des fonctions de densit? des bons et mauvais dossiers
plot(density(credit$Age[credit$Cible==0]),main="Fonction de densit?",col="blue",
xlim = c(18,80), ylim = c(0,0.1),lwd=2)
lines(density(credit$Age[credit$Cible==1]),col="red",lty=3,lwd=2)
legend("topright",c("Cible=0","Cible=1"),
lty=c(1,3),col=c("blue","red"),lwd=2)

# superposition des fonctions de densit? et des bo?tes ? moustaches des bons et mauvais dossiers
varQuanti = function(base,y,x)
{
old <- par(no.readonly = TRUE)
layout(matrix(c(1, 2)), heights=c(3, 1))
par(mar = c(2, 4, 2, 1))
base0 <- base[base[,y]==0,]
base1 <- base[base[,y]==1,]
xlim1 <- range(c(base0[,x],base1[,x]))
ylim1 <- c(0,max(max(density(base0[,x])$y),max(density(base1[,x])$y)))
plot(density(base0[,x]),main=" ",col="blue",ylab=paste("Densit? de ",x),
xlim = xlim1, ylim = ylim1 ,lwd=2)
lines(density(base1[,x]),col="red",lty=3,lwd=2,
xlim = xlim1, ylim = ylim1,xlab = '', ylab = '',main=' ')
legend("topright", c(paste(y," = 0"), paste(y," = 1")), lty=c(1,3), col=c("blue","red"),lwd=2)
texte <- c("Chi? de Kruskal-Wallis = \n\n",round(kruskal.test(base[,x]~base[,y])$statistic,digits=3))
text(xlim1[2]*0.8, ylim1[2]*0.5, texte,cex=0.75)
plot(base[,x]~base[,y], horizontal = TRUE, xlab= y, col=c("blue","red"))
par(old)
}
varQuanti(credit,"Cible","Duree_credit")

# taux d'impay?s par d?cile de l'?ge
q <- quantile(credit$Age, seq(0, 1, by=0.1))
# comme les intervalles sont en (a,b], que q[1]=19 et que la base contient deux clients de 19 ans
# l'option include.lowest=TRUE permet de fermer ? gauche le premier intervalle
qage <- cut(credit$Age, q, include.lowest=TRUE)
tab <- table(qage,credit$Cible)
prop.table(tab,1) # affichage % en ligne
#barplot(t(prop.table(tab,1)[,2]),las=3,main="Age",ylab="Taux impay?s",density=0)
barplot(prop.table(tab,1)[,2],las=3,ylim=c(0,0.5),main="Age",ylab="Taux impay?s",density=0)
abline(h=.3,lty=2)

# taux d'impay?s par quantile de la dur?e de cr?dit
q <- unique(quantile(credit$Duree_credit, seq(0, 1, by=0.05)))
q
unique(q)
qage <- cut(credit$Duree_credit, q, include.lowest=TRUE)
tab <- table(qage,credit$Cible)
prop.table(tab,1) # affichage % en ligne
barplot(prop.table(tab,1)[,2],las=3,main="Dur?e de cr?dit",ylab="Taux impay?s",density=0)
abline(h=.3,lty=2)

# taux d'impay?s par quantile du montant de cr?dit
# augmentation de la marge du bas pour ?viter la l?gende tronqu?e pour les montants de cr?dit
(newOmi <- par()$omi)    
newOmi[1] <- 1     
par(omi=newOmi)
q <- unique(quantile(credit$Montant_credit, seq(0, 1, by=0.05)))
q
unique(q)
qage <- cut(credit$Montant_credit, q, include.lowest=TRUE)
tab <- table(qage,credit$Cible)
prop.table(tab,1) # affichage % en ligne
barplot(prop.table(tab,1)[,2],las=3,main="Montant de cr?dit",ylab="Taux impay?s",density=0)
abline(h=.3,lty=2)

# fonction d'affichage du taux d'impay?s par quantile
ti = function(x,pas=0.1)
{
(newOmi <- par()$omi)    
newOmi[1] <- 1
old <- par(no.readonly = TRUE)   
par(omi=newOmi)
q <- unique(quantile(x, seq(0, 1, by=pas)))
qx <- cut(x, q, include.lowest=TRUE)
tab <- table(qx,credit$Cible)
print(prop.table(tab,1)) # affichage % en ligne
barplot(prop.table(tab,1)[,2], las=3, main=deparse(substitute(x)), ylab="Taux impay?s", density=0, horiz=F)
abline(h=prop.table(table(credit$Cible))[2], lty=2)
par(old)
}
ti(credit$Age)
ti(credit$Duree_credit, pas=0.05)
ti(credit$Montant_credit, pas=0.05)

# fonction d'affichage du taux de d'impay?s par quantile
ti = function(BASE,X,pas=0.1)
{
q <- unique(quantile(BASE[,X], seq(0, 1, by=pas)))
qx <- cut(BASE[,X], q, include.lowest=TRUE)
tab <- table(qx,BASE$Cible)
#cat("\n",substitute(X),"\n")
print(cbind(prop.table(tab,1),addmargins(tab,2)))
#barplot(prop.table(tab,1)[,2], las=2, main=deparse(substitute(X)), ylab="Taux impay?s", density=0, horiz=F)
barplot(prop.table(tab,1)[,2], las=2, ylab="Taux impay?s", density=0, horiz=F)
abline(h=prop.table(table(BASE$Cible))[2], lty=2)
}
ti(credit,"Age")
for (i in (1:ncol(credit)))
{ if (is.numeric(credit[,i])) { nom <- names(credit)[i] ; cat("\n",nom,"\n") ; x11() ; ti(credit,nom) ; legend("topright",nom)}
}

# discr?tisation des variables continues
credit$Age <- cut(credit$Age,c(0,25,Inf),right=TRUE) #intervalle semi-ferm? ? droite
tab <- table(credit$Age,credit$Cible)
prop.table(tab,1)
credit$Duree_credit <- cut(credit$Duree_credit,c(0,15,36,Inf),right=TRUE)
tab <- table(credit$Duree_credit,credit$Cible)
prop.table(tab,1)
credit$Montant_credit <- cut(credit$Montant_credit,c(0,4000,Inf),right=TRUE)
tab <- table(credit$Montant_credit,credit$Cible)
prop.table(tab,1)



# ---------------------------------------------------------------------------------------------------------
# Liaison des variables explicatives avec la variable ? expliquer
# ---------------------------------------------------------------------------------------------------------


# calcul de la valeur d'information d'une variable (VI)
IV <- function(X,Y){
tab <- table(X,Y)
IV <- 100*sum(((tab[,1]/sum(tab[,1])) - (tab[,2]/sum(tab[,2]))) * log((tab[,1]/sum(tab[,1])) /(tab[,2]/sum(tab[,2]))))
return(IV)
}
IV(credit$Comptes,credit$Cible)

# calcul du V de Cramer qui est ici la racine carr?e de (chi2 / effectif)
cramer  <- data.frame(NA,ncol(credit),4)
effectif <- dim(credit)[1]
for (i in (1:ncol(credit)))
{   cramer[i,1] <- names(credit[i])
                cramer[i,2] <- sqrt(chisq.test(table(credit[,i],credit$Cible))$statistic/effectif)
                cramer[i,3] <- chisq.test(table(credit[,i],credit$Cible))$p.value
                cramer[i,4] <- IV(credit[,i],credit$Cible)}
colnames(cramer) <- c("variable", "V de Cramer", "p-value chi2", "Valeur d'information")

# affichage des variables par VI d?croissantes
vcramer <- cramer [order(cramer[,4], decreasing=T),]
vcramer

# graphique des V de Cramer
old <- par(no.readonly = TRUE)
par(mar = c(8, 4, 4, 0))
barplot(as.numeric(vcramer[-1,2]),col=gray(0:nrow(vcramer)/nrow(vcramer)),
names.arg=vcramer[-1,1], ylab='V de Cramer', ylim=c(0,0.35), cex.names = 0.8, las=3)
par(old)

# graphique des VI
old <- par(no.readonly = TRUE)
par(mar = c(8, 4, 4, 0))
barplot(as.numeric(vcramer[-1,4]),col=gray(0:nrow(vcramer)/nrow(vcramer)),
names.arg=vcramer[-1,1], ylab="Valeur d'information", ylim=c(0,70), cex.names = 0.8, las=3)
par(old)

# tableaux crois?s comme SAS et SPSS
library(gmodels)
CrossTable(credit$Comptes, credit$Cible, prop.chisq=F, chisq = T, format="SAS")

# tableaux crois?s
ct <- function(x)
{ cat("\n",names(credit)[x])
prop.table(table(credit[,x],credit$Cible),1) }
for (i in (1:ncol(credit)))
{ if (!(names(credit[i])) %in% c("Cible","Duree_credit","Montant_credit","Age"))
	{ print(ct(i)) }
}

# tableaux crois?s - version avec effectifs
ct <- function(x)
{ cat("\n",names(credit)[x],"\n")
cbind(prop.table(table(credit[,x],credit$Cible),1), table(credit[,x])) }
for (i in (1:ncol(credit))) { print(ct(i)) }



# ---------------------------------------------------------------------------------------------------------
# Liaisons entre variables explicatives
# ---------------------------------------------------------------------------------------------------------


# V de Cramer des paires de variables explicatives

library(questionr)
cramer  <- matrix(NA,ncol(credit),ncol(credit))
# variante 1
for (i in (1:ncol(credit)))
{     for (j in (1:ncol(credit)))
	{
	cramer[i,j] <- cramer.v(table(credit[,i],credit[,j]))
	}
}
warnings()
# variante 2
vcram <- function(i,j) { cramer.v(table(credit[,i],credit[,j])) }
i <- (1:ncol(credit))
j <- (1:ncol(credit))
cramer <- outer(i,j,Vectorize(vcram))
# fin variantes
colnames(cramer) <- colnames(credit)
rownames(cramer) <- colnames(credit)
cramer
#install.packages("corrplot")
library(corrplot)
corrplot(cramer)
corrplot(cramer, method="shade", shade.col=NA, tl.col="black", tl.srt=45)
old <- par(no.readonly = TRUE)
par(omi=c(0.4,0.4,0.4,0.4))
corrplot(cramer, type="upper", tl.srt=45, tl.col="black", tl.cex=1, diag=F, addCoef.col="black", addCoefasPercent=T)
par(old)

# Gamma de Goodman and Kruskal
install.packages('vcdExtra')
library(vcdExtra)
GKgamma(table(credit$Comptes, credit$Cible), level = 0.95)
GKgamma(table(credit$Comptes, credit$Cible))$gamma

# Gamma de Goodman and Kruskal des paires de variables explicatives
goodman <- function(x,y){ 
    Rx <- outer(x,x,function(u,v) sign(u-v)) 
    Ry <- outer(y,y,function(u,v) sign(u-v)) 
    S1 <- Rx*Ry 
    return(sum(S1)/sum(abs(S1)))
  } 
goodman(as.numeric(credit2$Comptes), as.numeric(credit2$Cible))
gammaGK  <- matrix(NA,ncol(credit),ncol(credit))
vcram <- function(i,j) { GKgamma(table(credit[,i],credit[,j]))$gamma }
vcram <- function(i,j) { goodman(as.numeric(credit[,i]), as.numeric(credit[,j])) }
i <- (1:ncol(credit))
j <- (1:ncol(credit))
gammaGK <- outer(i,j,Vectorize(vcram))
colnames(gammaGK) <- colnames(credit)
rownames(gammaGK) <- colnames(credit)
corrplot(gammaGK, type="upper", tl.srt=45, tl.col="black", tl.cex=1, diag=F, cl.cex=0.5, addCoef.col="black", addCoefasPercent=T)

# croisement des variables explicatives les plus fortement li?es

tab <- table(credit$Biens,credit$Statut_domicile)
prop.table(tab,1)

tab <- table(credit$Duree_credit, credit$Montant_credit)
prop.table(tab,1)
tab <- table(credit$Duree_credit,credit$Cible)
cbind(prop.table(tab,1),addmargins(tab,2))
tab <- table(credit$Montant_credit,credit$Cible)
cbind(prop.table(tab,1),addmargins(tab,2))

tab <- table(credit$Type_emploi,credit$Telephone)
prop.table(tab,1)


		
# ---------------------------------------------------------------------------------------------------------
# Jeu de donn?es "German Credit" : regroupement de modalit?s
# ---------------------------------------------------------------------------------------------------------


myVariableNames <- c("Comptes","Duree_credit","Historique_credit","Objet_credit",
"Montant_credit","Epargne","Anciennete_emploi","Taux_effort",
"Situation_familiale","Garanties","Anciennete_domicile","Biens","Age",
"Autres_credits","Statut_domicile","Nb_credits","Type_emploi",
"Nb_pers_charge","Telephone","Etranger","Cible")

# jeu de donn?es
credit = read.table("http://archive.ics.uci.edu/ml/machine-learning-databases/statlog/german/german.data",h=FALSE,
col.names=myVariableNames)
#credit = read.table("D:/Data M", h=F, col.names=myVariableNames)
#credit = read.table("C:", h=F, col.names=myVariableNames)

credit$Etranger <- NULL

# variable ? expliquer
credit$Cible[credit$Cible == 1] <- 0 # cr?dits OK
credit$Cible[credit$Cible == 2] <- 1 # cr?dits KO
credit$Cible <- factor(credit$Cible)

# discr?tisation des variables continues
credit$Age <- cut(credit$Age,c(0,25,Inf),right=TRUE) #intervalle semi-ferm? ? droite
credit$Duree_credit <- cut(credit$Duree_credit,c(0,15,36,Inf),right=TRUE)
credit$Montant_credit <- cut(credit$Montant_credit,c(0,4000,Inf),right=TRUE)

# transformation en facteurs des variables discr?tes
credit[["Taux_effort"]] <- factor(credit[["Taux_effort"]])
credit[["Anciennete_domicile"]] <- factor(credit[["Anciennete_domicile"]])
credit[["Nb_credits"]] <- factor(credit[["Nb_credits"]])
credit[["Nb_pers_charge"]] <- factor(credit[["Nb_pers_charge"]])

# recodage et fusion des modalit?s
library(car)
credit2 <- credit

# attention aux simples et doubles quotes dans le "recode"
credit2$Comptes <- recode(credit$Comptes,"'A14'='Pas de compte';'A11'='CC < 0 euros';'A12'='CC [0-200 euros[';'A13'='CC > 200 euros' ")
table(credit2$Comptes)

credit2$Historique_credit <- recode(credit$Historique_credit,"c('A30','A31')='Cr?dits en impay?';
c('A32','A33')='Pas de cr?dits ou en cours sans retard';'A34'='Cr?dits pass?s sans retard'")
table(credit2$Historique_credit)

credit2$Objet_credit <- recode(credit$Objet_credit,"'A40'='Voiture neuve';
'A41'='Voiture occasion';c('A42','A43','A44','A45')='Int?rieur';c('A46','A48','A49','A410')='Etudes-business';
'A47'='Vacances';else='Autres'")
table(credit2$Objet_credit)

credit2$Epargne <- recode(credit$Epargne,"c('A61','A62')='< 500 euros';else='Pas ?pargne ou > 500 euros'")
table(credit2$Epargne)

credit2$Anciennete_emploi<- recode(credit$Anciennete_emploi,
"c('A71','A72')='Sans emploi ou < 1 an';'A73'='E [1-4[ ans';c('A74','A75')='E GE 4 ans'")
table(credit2$Anciennete_emploi)

credit2$Situation_familiale<- recode(credit$Situation_familiale,
"'A91'='Homme divorc?/s?par?';'A92'='Femme divorc?e/s?par?e/mari?e';
c('A93','A94')='Homme c?libataire/mari?/veuf';'A95'='Femme c?libataire'")
table(credit2$Situation_familiale)

credit2$Garanties <- recode(credit$Garanties,"'A103'='Avec garant';else='Sans garant'")
table(credit2$Garanties)

credit2$Biens <- recode(credit$Biens,"'A121'='Immobilier';'A124'='Aucun bien';else='Non immobilier'")
table(credit2$Biens)

credit2$Autres_credits <- recode(credit$Autres_credits,"'A143'='Aucun cr?dit ext?rieur';else='Cr?dits ext?rieurs'")
table(credit2$Autres_credits)

credit2$Statut_domicile <- recode(credit$Statut_domicile,"'A152'='Propri?taire';else='Non Propri?taire'")
table(credit2$Statut_domicile)

credit2$Type_emploi <- recode(credit$Type_emploi,"
     'A171' = 'Sans emploi';
     'A172' = 'Non qualifi?';
     'A173' = 'Employ?-Ouvrier qualifi?';
     'A174' = 'Cadre'")
table(credit2$Type_emploi)

credit2$Nb_credits <- recode(credit$Nb_credits,"
      1 = '1 cr?dit ';
      2 = '2 ou 3 cr?dits';
      3 = '4 ou 5 cr?dits';
      4 = '+ de 6 cr?dits' ")
table(credit2$Nb_credits)

credit2$Taux_effort <- recode(credit$Taux_effort,"
      1 = 'Endt < 20 %   ';
      2 = 'Endt dans [20-25 %[';
      3 = 'Endt dans [25-35 %[';
      4 = 'Endt + de 35 %  ' ")
table(credit2$Taux_effort)

credit2$Anciennete_domicile <- recode(credit$Anciennete_domicile,"
      1 = 'Dom < 1 an';
      2 = 'Dom dans [1-4[ ans';
      3 = 'Dom dans [4-7[ ans';
      4 = 'Dom + de 7 ans' ")
table(credit2$Anciennete_domicile)

credit2$Nb_pers_charge <- recode(credit$Nb_pers_charge,"
      1 = '0-2 pers';
      2 = '+ de 3 pers' ")
table(credit2$Nb_pers_charge)

# structure du fichier de cr?dit apr?s transformations
summary(credit2)

# ?chantillons d'apprentissage et de validation
train  <- credit2[id,]
valid  <- credit2[-id,]
summary(train)



# ---------------------------------------------------------------------------------------------------------
# retour au German Credit Data
# ---------------------------------------------------------------------------------------------------------


# mod?le logit
logit <- glm(Cible~Comptes+Historique_credit+Duree_credit+Age+Epargne+Garanties+Autres_credits, data=train, family=binomial(link = "logit"))
summary(logit)
summary(logit)$coefficients
pred.logit <- predict(logit, newdata=valid, type="response")
head(pred.logit)

# aire sous la courbe ROC
library(pROC)
auc(valid$Cible,pred.logit, quiet=TRUE) # Area under the curve: 0.7596
roc <- plot.roc(valid$Cible, pred.logit, main="", percent=TRUE, ci=FALSE)
roc <- plot.roc(valid$Cible, pred.logit, main="", percent=TRUE, ci=TRUE)
roc.se <- ci.se(roc, specificities=seq(0, 100, 5))
plot(roc.se, type="shape", col="grey")

# nombre de coefficients non significatifs au seuil de 5%
sum(summary(logit)$coefficients[,4] >= 0.05) # 3

# mod?le logit sur WOE
woe <- function(X,Y){
tab <- table(X,Y)
woe <- log((tab[,1]/sum(tab[,1])) /(tab[,2]/sum(tab[,2])))
levels(X) <- woe
return(as.numeric(as.character(X)))
}
# application de la fonction WOE ? toutes les variables explicatives qui sont des facteurs
varquali   <- intersect(which(sapply(credit2, is.factor)==T), which(names(credit2) != "Cible"))
varquanti  <- setdiff(names(credit2), names(credit2)[varquali])
credit_woe <- sapply(varquali, function(i) woe(credit2[[i]], credit2$Cible))
colnames(credit_woe) <- names(credit2)[varquali]
credit_woe <- data.frame(credit_woe, Cible=credit2$Cible)
head(credit_woe)
# ?chantillons d'apprentissage et de validation
train  <- credit_woe[id,]
valid  <- credit_woe[-id,]
# mod?le logit
logit <- glm(Cible~Comptes+Historique_credit+Duree_credit+Age+Epargne+Garanties+Autres_credits+Objet_credit, data=train, family=binomial(link = "logit"))
logit <- glm(Cible~Comptes+Historique_credit+Duree_credit+Age+Epargne+Garanties+Autres_credits, data=train, family=binomial(link = "logit"))
summary(logit)
pred.logit <- predict(logit, newdata=valid, type="response")
auc(valid$Cible, pred.logit, quiet=TRUE) # Area under the curve: 0.7657 sans l'objet de cr?dit, 0,7801 avec l'objet de cr?dit
# nombre de coefficients non significatifs au seuil de 5%
sum(summary(logit)$coefficients[,4] >= 0.05) # 1

# superposition des fonctions de densit? des bons et mauvais dossiers
plot(density(pred.logit[valid$Cible==0]), main="Fonction de densit? du score", col="blue", xlim = c(-0.2,1.1), ylim = c(0,3),lwd=2)
lines(density(pred.logit[valid$Cible==1]), col="red", lty=3, lwd=2)
legend("topright",c("Cible=0","Cible=1"), lty=c(1,3), col=c("blue","red"), lwd=2)


# ---------------------------------------------------------------------------------------------------------
# seuils de score (du mod?le sur variables qualitatives)
# ---------------------------------------------------------------------------------------------------------

# application du mod?le ? l'ensemble des donn?es
pred.logit <- predict(logit, newdata=credit2, type="response")
# taux d'impay?s par d?cile du score
q <- quantile(pred.logit, seq(0, 1, by=0.05))
qscore <- cut(pred.logit, q)
tab <- table(qscore, credit2$Cible)
ti <- prop.table(tab,1)[,2] # affichage % en ligne
old <- par(no.readonly = TRUE)
par(mar = c(7, 4, 2, 0))
barplot(as.numeric(ti), col=gray(0:length(ti)/length(ti)),
names.arg=names(ti), ylab='Taux impay?s', ylim=c(0,1), cex.names = 0.8, las=3)
abline(v=c(7.3,19.3),col="red")
par(old)

# application des seuils de score
zscore <- recode(pred.logit, "lo:0.11='Faible'; 0.11:0.527='Moyen'; 0.527:hi='Fort'")
tab <- table(zscore,credit2$Cible)
cbind(prop.table(tab,1), addmargins(tab,2))


# ---------------------------------------------------------------------------------------------------------
# grille de score
# ---------------------------------------------------------------------------------------------------------

(VARIABLE=c("", rep(names(logit$xlevels),sapply(logit$xlevels,length))))
(MODALITE=c("", unlist(logit$xlevels)))
(names=data.frame(VARIABLE,MODALITE,NOMVAR=c("(Intercept)", paste(VARIABLE,MODALITE,sep="")[-1])))
#PASTE COLLLE LES VARIABLE ET LES MODALITe pour question d'affichage, le mod?le restitue les coefficient et on rajoute ca pour avoir le nom de svariables avec
(regression=data.frame(NOMVAR=names(coefficients(logit)), COEF=as.numeric(coefficients(logit))))
param = merge(names,regression,all.x=TRUE)[-1] #all x=true pour dire qu'on garde toutes le slignes du cot? x(names) m^^eme si du cot? r?gression elles sont absentes
param$COEF[is.na(param$COEF)] <- 0 
param
#R renvoie le mod?le mais sans la modalit? de r?f?rence
# calcul du poids total pour normalisation
mini=aggregate(data.frame(min = param$COEF), by = list(VARIABLE = param$VARIABLE), min)
maxi=aggregate(data.frame(max = param$COEF), by = list(VARIABLE = param$VARIABLE), max)
total=merge(mini,maxi)
total$diff = total$max - total$min
poids_total = sum(total$diff)
poids_total

# calcul des poids par modalit?
grille = merge(param,mini,all.x=TRUE)
grille$delta = grille$COEF - grille$min
grille$POIDS = round((100*grille$delta) / poids_total)
grille[order(grille$VARIABLE,grille$MODALITE)[which(VARIABLE!="")], c("VARIABLE","MODALITE","POIDS")]

# application de la grille de score
card <- function(base,i){
noquote(paste0("((",base,"$",grille[i,"VARIABLE"],"=='",grille[i,"MODALITE"],"')*",grille[i,"POIDS"],")"))
}
card("credit2",2)
scorecard <- rbind(sapply(2:nrow(grille), function(x) card("credit2",x)))
scorecard <- noquote(paste(scorecard, collapse = '+'))
pred.grille <- eval(parse(text=scorecard))
head(pred.grille)
summary(pred.grille)
cor(pred.grille,pred.logit,method="spearman")
plot(pred.grille,pred.logit)

# taux d'impay?s par d?cile de la scorecard
q <- quantile(pred.grille, seq(0, 1, by=0.05))
qscore <- cut(pred.grille, q)
tab <- table(qscore, credit2$Cible)
ti <- prop.table(tab,1)[,2] # affichage % en ligne
old <- par(no.readonly = TRUE)
par(mar = c(7, 4, 2, 0))
barplot(as.numeric(ti), col=gray(0:length(ti)/length(ti)),
names.arg=names(ti), ylab='Taux impay?s', ylim=c(0,1), cex.names = 0.8, las=3)
abline(v=c(7.3,19.3),col="red")
par(old)

# application des seuils de la scorecard
zscore <- recode(pred.grille, "lo:37='Faible'; 37:63='Moyen'; 63:hi='Fort'")
tab <- table(zscore,credit2$Cible)
cbind(prop.table(tab,1), addmargins(tab,2))


# ---------------------------------------------------------------------------------------------------------
# croisements de mod?les de r?gression logistique
# ---------------------------------------------------------------------------------------------------------

pos <- -grep('(Cle|Cible)', names(train)) # position variable ? expliquer
# ensemble des combinaisons de variables
library(combinat)
combis <- unlist(sapply(1:5, function(x) apply(combn(names(train)[pos], x), 2, paste, collapse = " + ")))
head(combis)
#test la performance des mod?les a 2 variables
# r?gressions lin?aires
lapply(combis, function(x) lm(as.formula(paste("y ~", x)), data = df))
# r?gressions logistiques
lapply(combis, function(x) glm(as.formula(paste("y ~", x)), data = df, family=binomial(link = "logit")))
# liste des mod?les croisant toutes les variables
lst.model <- lapply(combis, function(x) glm(as.formula(paste("Cible ~", x)), data = train, family=binomial(link = "logit")))
# nombre de mod?les
length(lst.model)
# application de la liste des mod?les ? un ?chantillon de validation
lst.pred <- lapply(lst.model, function(x) {predict(x, newdata=valid)})
# AUC de la liste des mod?les sur un data frame de validation
library(pROC)
AUC <- sapply(lst.pred, function(x) {auc(valid$Cible, x, quiet=TRUE)})
# AUC de chaque combinaison de variables
resultats <- data.frame(combis, AUC)
head(resultats,10)
# combinaisons de variables tri?es par AUC d?croissantes
head(resultats[order(resultats[,2], decreasing=T),])


# ---------------------------------------------------------------------------------------------------------
# r?gression logistique avec s?lection pas ? pas
# ---------------------------------------------------------------------------------------------------------

# formule avec l'ensemble des pr?dicteurs
predicteurs <- -grep('(Cle|Cible)', names(train))
# formule sans interaction
formule <- as.formula(paste("y ~ ",paste(names(train[,predicteurs]),collapse="+")))
# formule avec interactions
formule <- as.formula(paste("y ~ ( ",paste(names(train[,predicteurs]),collapse="+"),")^2"))
formule

# s?lection de mod?le ascendante
logit <- glm(Cible~1, data=train, family=binomial(link = "logit"))
summary(logit)
# recherche maximale
selection <- step(logit, direction="forward", trace=TRUE, k = 2, scope=list(upper=formule))
selection <- step(logit, direction="forward", trace=TRUE, k = log(nrow(train)), scope=list(upper=formule))
selection
summary(selection)
# s?lection avec AIC : k = 2 (valeur par d?faut)
# variante avec BIC au lieu de AIC : k = log(nrow(train))
# variante avec AIC corrig? : k = 2 + 2(d+1)/(n?d?1), avec :
# d <- length(logit$coefficients)-1 # nb de degr?s de libert?
# n <- nrow(train)

#il faut enlever les variables ? partir du bas du resultat 

# application du mod?le ? un jeu de donn?es
train.ascbic <- predict(selection, newdata=train, type="response")
valid.ascbic <- predict(selection, newdata=valid, type="response")

# aire sous la courbe ROC
library(pROC)
auc(train$Cible,train.ascbic)
auc(valid$Cible,valid.ascbic)

# s?lection de mod?le descendante
logit <- glm(Cible~., data=train, family=binomial(link = "logit"))
selection <- step(logit, direction="backward", trace=TRUE, k = log(nrow(train)))
#FORWARD pour avoir selection ascendante 
#AIC ici correspond au BIC, on veut avoir le BIC le plus faible
#on part du BIC=830 on enleve les variables qui donnent le bic le plus inf?rieur ? celui de d?part
#Squand on a toutes les variables la d?viance est maximale
#il ne faut pas enelever les variables qui sont en dessous de none car rendrait le mod?le moins bon 
#la variable qui apporte le moins au mod?le est celle qui fait le + baisser le bic
#recommencer l'ananlyse ? chaque fois qu'on enleve une variable 
selection <- step(logit, direction="backward", trace=TRUE, k = log(nrow(train)),
#scope=list(lower=~Comptes+Historique_credit+Duree_credit+Age+Epargne+Garanties+Autres_credits))
scope=list(lower=~1))
selection



# ---------------------------------------------------------------------------------------------------------
# r?gression lin?aire clusterwise
# ---------------------------------------------------------------------------------------------------------
#Em?thode qui permet ? la fois de s?gmenter la population (d?couper en cluster) et de faire une r?gression dessus
set.seed(2)
x1 <- rnorm(100)
set.seed(3)
y1 <- x1 + rnorm(100, sd=0.5)
set.seed(5)
y2 <- - x1 + rnorm(100, sd=0.5)
x <- c(x1,x1)
y <- c(y1,y2)
modele <- lm(y ~ x)
summary(modele)
plot(x,y)
abline(modele, lty=3) # en d?coupant en deux on aura deux r?gressions bien meilleures

#install.packages('flexmix')
library(flexmix)
clw <- flexmix(y ~ x, k=2)
#clustering+ regression
#cherche le clustering qui optimise au mieux la r?gression

summary(clw)
parameters(clw, component = 1)
parameters(clw, component = 2)
summary(refit(clw))
#plot(clw)
#plot(x, y, pch=clusters(clw), col=clusters(clw))
plot(x, y, pch=clusters(clw), col=c("blue", "purple")[clusters(clw)])
abline(parameters(clw, component = 1)[1:2], lty=3, col="black")
abline(parameters(clw, component = 2)[1:2], lty=4, col="grey")




# =========================================================================================================
# ARBRES DE DECISION
# =========================================================================================================


# ---------------------------------------------------------------------------------------------------------
# jeu de donn?es "German Credit"
# ---------------------------------------------------------------------------------------------------------

# noms des variables
myVariableNames <- c("Comptes","Duree_credit","Historique_credit","Objet_credit",
"Montant_credit","Epargne","Anciennete_emploi","Taux_effort",
"Situation_familiale","Garanties","Anciennete_domicile","Biens","Age",
"Autres_credits","Statut_domicile","Nb_credits","Type_emploi",
"Nb_pers_charge","Telephone","Etranger","Cible")

# jeu de donn?es
credit = read.table("http://archive.ics.uci.edu/ml/machine-learning-databases/statlog/german/german.data", h=FALSE, col.names=myVariableNames)
#credit = read.table("", h=F, col.names=myVariableNames)

credit$Etranger <- NULL

# variable ? expliquer
credit$Cible[credit$Cible == 1] <- 0 # cr?dits OK
credit$Cible[credit$Cible == 2] <- 1 # cr?dits KO
credit$Cible <- factor(credit$Cible)

# transformation en facteurs des variables discr?tes
credit[["Taux_effort"]] <- factor(credit[["Taux_effort"]])
credit[["Anciennete_domicile"]] <- factor(credit[["Anciennete_domicile"]])
credit[["Nb_credits"]] <- factor(credit[["Nb_credits"]])
credit[["Nb_pers_charge"]] <- factor(credit[["Nb_pers_charge"]])

# recodage et fusion des modalit?s
install.packages("car")
library(car)
credit2 <- credit

# attention aux simples et doubles quotes dans le "recode"
credit2$Comptes <- recode(credit$Comptes,"
      'A11'='CC < 0 euros';
      'A12'='CC [0-200 euros[';
      'A13'='CC > 200 euros';
      'A14'='Pas de compte'")

credit2$Historique_credit <- recode(credit$Historique_credit,"
      'A30' = 'Impay?s pass?s';
      'A31' = 'Impay? en cours dans autre banque'; 
      'A32' = 'Jamais aucun cr?dit';
      'A33' = 'Cr?dits en cours sans retard' ; 
      'A34' = 'Cr?dits pass?s sans retard'")

credit2$Objet_credit <- recode(credit$Objet_credit,"
	 'A40'='Voiture neuve';
	 'A41' = 'Voiture occasion';
     'A42' = 'Mobilier';
     'A43' = 'Vid?o HIFI';
     'A44' = 'Electrom?nager';
     'A45' = 'Travaux';
     'A46' = 'Etudes';
     'A47' = 'Vacances';
     'A48' = 'Formation';
     'A49' = 'Business';
      else = 'Autres'")

credit2$Epargne <- recode(credit$Epargne,"
      'A61' = '< 100 euros';
      'A62' = '[100-500 euros['; 
      'A63' = '[500-1000 euros['; 
      'A64' = '+ de 1000 euros';
      'A65' = 'Sans ?pargne'")

credit2$Anciennete_emploi<- recode(credit$Anciennete_emploi,"
      'A71' = 'Sans emploi';
      'A72' = 'Empl < 1 an';
      'A73' = 'Empl dans [1-4[ ans';
      'A74' = 'Empl dans [4-7[ ans';
      'A75' = 'Empl + de 7 ans'")

credit2$Situation_familiale<- recode(credit$Situation_familiale,"
     'A91' = 'Homme divorc?/s?par?';
     'A92' = 'Femme divorc?e/s?par?e/mari?e';
     'A93' = 'Homme c?libataire';
     'A94' = 'Homme mari?/veuf';
     'A95' = 'Femme c?libataire'")

credit2$Garanties <- recode(credit$Garanties,"
     'A101' = 'Pas de garantie';
     'A102' = 'Co-emprunteur';
     'A103' = 'Garant'")

credit2$Biens <- recode(credit$Biens,"
     'A121' = 'Immobilier';
     'A122' = 'Assurance-vie';
     'A123' = 'Voiture ou autre';
     'A124' = 'Aucun bien connu'")

credit2$Autres_credits <- recode(credit$Autres_credits,"
     'A141' = 'Autres banques';
     'A142' = '?tablissements cr?dit';
     'A143' = 'Aucun cr?dit'")

credit2$Statut_domicile <- recode(credit$Statut_domicile,"
     'A151' = 'Locataire';
     'A152' = 'Propri?taire';
     'A153' = 'Logement gratuit'")

credit2$Type_emploi <- recode(credit$Type_emploi,"
     'A171' = 'Sans emploi';
     'A172' = 'Non qualifi?';
     'A173' = 'Employ?-Ouvrier qualifi?';
     'A174' = 'Cadre'")

credit2$Anciennete_domicile <- recode(credit$Anciennete_domicile,"
      1 = 'Dom < 1 an';
      2 = 'Dom dans [1-4[ ans';
      3 = 'Dom dans [4-7[ ans';
      4 = 'Dom + de 7 ans' ")

credit2$Nb_credits <- recode(credit$Nb_credits,"
      1 = '1 cr?dit ';
      2 = '2 ou 3 cr?dits';
      3 = '4 ou 5 cr?dits';
      4 = '+ de 6 cr?dits' ")

credit2$Nb_pers_charge <- recode(credit$Nb_pers_charge,"
      1 = '0-2 pers';
      2 = '+ de 3 pers' ")

credit2$Taux_effort <- recode(credit$Taux_effort,"
      1 = 'Endt < 20 %   ';
      2 = 'Endt dans [20-25 %[';
      3 = 'Endt dans [25-35 %[';
      4 = 'Endt + de 35 %  ' ")

credit2$Telephone <- recode(credit$Telephone,"
     'A191' = 'Sans T?l';
     'A192' = 'Avec T?l' ")

# ?chantillons d'apprentissage et de validation
library(sampling)
set.seed(123)
id <- strata(credit, stratanames="Cible", size=c(sum(credit$Cible==0)*2/3,sum(credit$Cible==1)*2/3), method="srswor", description=T)$ID_unit
train  <- credit2[id,]
valid  <- credit2[-id,]


# ---------------------------------------------------------------------------------------------------------
# arbre de d?cision CART
# ---------------------------------------------------------------------------------------------------------


# arbre CART
library(rpart)

# param?tres de rpart
# methode = class ou anova pour arbre de r?gression
# minsplit = 20 par d?faut
# minbucket = 1/3*minsplit par d?faut

# premiers exemples
set.seed(235)
cart <- rpart(Cible ~ . , data = train, method="class", parms=list(split="gini"), cp=0)
cart <- rpart(Cible ~ . , data = train, method="class", parms=list(split="gini"), control=list(minbucket=30, minsplit=30*2, maxdepth=4))
# stumps : rpart.control(maxdepth=1,cp=-1,minsplit=0)
cart <- rpart(Cible ~ . , data = train, method="class", parms=list(split="gini"), control=list(maxdepth=1,cp=-1,minsplit=0))

cart # commande ?quivalente ? "print(cart)"
summary(cart, digits=3) # plus d'informations sur les scissions

# affichage graphique de l'arbre
plot(cart, branch=.2, uniform=T, compress=T, margin=.1)
text(cart, fancy=T,use.n=T,pretty=0,all=T, cex=1)

# affichage graphique un peu am?lior? de l'arbre
plot(cart,branch=.2, uniform=T, compress=T, margin=.1) # trac? de l'arbre
text(cart, fancy=T, use.n=T, pretty=0, all=T, cex=.6) # ajout des l?gendes des noeuds
# cex est un facteur multiplicateur de la taille des caract?res
# affichage am?lior? avec package rpart.plot
install.packages("rpart.plot")
library(rpart.plot)
prp(cart,type=2,extra=4,split.box.col="lightgray")
# affichage am?lior? avec package partykit
library(partykit)
#affiche des arbres de d?cisions fait avec le package
plot(as.party(cart))
#on affiche l'arbe fait avec cart mais avec partykit
# affichage am?lior? avec package rattle
library(rattle)
fancyRpartPlot(cart, sub=" ")
# cr?ation d'un fichier graphique au format PDF
pdf("Histograms.pdf") # cr?e un fichier PDF dans le r?pertoire de travail
fancyRpartPlot(cart, sub=" ")
dev.off() # fermer le fichier PDF

# Titanic
titanic <- read.csv2("D:/Data/Jeux de donn?es/titanic.csv", h=TRUE)
head(titanic)
cart <- rpart(survie ~ . , data = titanic, method="class", parms=list(split="gini"), cp=0)
fancyRpartPlot(cart, sub=" ", type=1)

# on peut afficher l'erreur xerror calcul?e par validation crois?e
# et le nb nsplit de scissions
# en fonction du coefficient de complexit?
set.seed(235)
printcp(cart)
print(cart$cptable)

# calcul erreur absolue par resusbstitution
# arbre maximal
sum(predict(cart,type="class") != train$Cible)/nrow(train)
0.495*200/666
# calcul ?cart-type absolu de l'erreur xerror
x <- 0.960*200/666 # xerror absolue
# calcul ?cart-type relatif de l'erreur xerror
sqrt((x*(1-x))/666)/(200/666)

# on peut aussi afficher cela dans un graphique
# montrant la d?croissance erreur relative en fonction du coefficient de complexit?
plotcp(cart) # calcul par validation crois?e

# ?laguage
prunedcart5f  <- prune(cart, cp=0.035)
# affichage avec package rpart.plot
prp(prunedcart5f, type=2, extra=1, split.box.col="lightgray")
# affichage am?lior? avec package rpart.plot
cols <- ifelse(prunedcart5f$frame$yval == 1,"green3","red")
prp(prunedcart5f, type=2, extra=101, split.box.col="lightgray", nn=TRUE, col=cols, border.col=cols)
# affichage am?lior? avec package partykit
plot(as.party(prunedcart5f))
# affichage am?lior? avec package rattle
library(rattle)
fancyRpartPlot(prunedcart5f, sub=" ")

# ?laguage automatique au minimum d'erreur + 1 ?cart-type
xerr <- cart$cptable[,"xerror"]
minxerr <- which.min(xerr)
seuilerr <- cart$cptable[minxerr, "xerror"]+cart$cptable[minxerr, "xstd"]
xerr [xerr < seuilerr][1]
mincp <- cart$cptable[names(xerr [xerr < seuilerr][1]), "CP"]
prunedcart <- prune(cart, cp=mincp)

# ?laguage automatique au minimum d'erreur
xerr <- cart$cptable[,"xerror"]
minxerr <- which.min(xerr)
mincp <- cart$cptable[minxerr, "CP"]
prunedcart <- prune(cart, cp=mincp)
# code plus compact :
prunedcart <- prune(cart, cp=cart$cptable[which.min(cart$cptable[,"xerror"]),"CP"])
# affichage de l'arbre ?lagu?
fancyRpartPlot(prunedcart, sub=" ")

# ?lagage au nombre minimum de feuilles
mincart <- prune(cart,cp=cart$cptable[min(2,nrow(cart$cptable)), "CP"])
plot(mincart,branch=.2, uniform=T, compress=T, margin=.1)
text(mincart, fancy=T,use.n=T,pretty=0,all=T,cex=.5)
prp(mincart,type=2,extra=1,split.box.col="lightgray")

# mesure des performances sur l'?chantillon de validation
pred.cart  <- predict(prunedcart5f, type="prob", valid)
head(pred.cart,5)

# calcul de l'aire sous la courbe ROC
library(pROC)
auc(valid$Cible, pred.cart[,2], quiet=TRUE)

# comparaison de courbes ROC avec intervalles de confiance
prunedcart6f <- prune(cart, cp=0.0183333)
pred.cart6f  <- predict(prunedcart6f, type="prob", valid)
roc <- plot.roc(valid$Cible, pred.cart[,2], col='black', lty=1, ci=TRUE)
plot.roc(valid$Cible, pred.cart6f[,2], add=TRUE, col='red', lty=2, ci=TRUE)
# calcul des intervalles de confiance par simulation de Monte-Carlo
roc.se <- ci.se(roc, specificities=seq(0,1,.01), boot.n=2000)
plot(roc.se, type="shape", col="#0000ff22")
legend("bottomright",c('6 feuilles','5 feuilles'),col=c('red','black'),lty=c(2,1),lwd=3)

# ajout de l'AUC ? c?t? de l'erreur xerror
library(pROC)
set.seed(235)
auc <- matrix(NA,nrow(cart$cptable)-1,4)
for(i in 2:nrow(cart$cptable))
{
cartp <- prune(cart, cp=cart$cptable[i,"CP"])
predc <- predict(cartp, type="prob", test)[,2]
auc[i-1,1] <- cart$cptable[i,"CP"]
auc[i-1,2] <- cart$cptable[i,"nsplit"]+1
auc[i-1,3] <- cart$cptable[i,"xerror"]
auc[i-1,4] <- auc(test$Cible, predc)
} # fin de la boucle
colnames(auc) <- c("CP","nfeuilles","erreur","AUC")
auc


# gestion des valeurs manquantes
cart <- rpart(Cible ~ . ,data = credit[id,vars],method="class",parms=list(split="gini"),cp=0.05,control=list(usesurrogate=0,maxcompete=0))
summary(cart)
test2 <- test
ms <- sample(dim(test)[1],100)
test2$Objet_credit[ms] <- test2$Duree_credit[ms] <- test2$Comptes[ms] <- NA
summary(test2)
testNA <- predict(cart,type="prob",test2,na.action = na.omit)
summary(testNA)
head(test2$Comptes,100)
head(testNA,100)




# =========================================================================================================
# ANALYSE FACTORIELLE ET CLASSIFICATION
# =========================================================================================================


# ---------------------------------------------------------------------------------------------------------
# Analyse factorielle
# ---------------------------------------------------------------------------------------------------------

credit <- credit2

# discr?tisation des variables continues
credit$Age <- cut(credit$Age,c(0,25,Inf),right=TRUE) #intervalle semi-ferm? ? droite
credit$Duree_credit <- cut(credit$Duree_credit,c(0,15,36,Inf),right=TRUE)
credit$Montant_credit <- cut(credit$Montant_credit,c(0,4000,Inf),right=TRUE)
str(credit)

# chargement du package
library(FactoMineR)

# nombre de modalit?s par variable
(modal <- apply(credit[,-20], 2, function(x) nlevels(as.factor(x))))
# nb de valeurs propres non triviales
# = nb modalit?s - nb variables
sum(modal) - ncol(credit[,-20])
# inertie totale = (# modalit?s / # variables) - 1
(sum(modal)/ncol(credit[,-20]))-1

# ACM
ACM <- MCA(credit, ncp = 54, axes = c(1,2), graph = TRUE, quali.sup = 20)
summary(ACM)
# ellipses de confiance
plotellipses(ACM, means=T, level = 0.95, keepvar="Cible", label='quali')
# variables et modalit?s caract?risant chaque axe
dimdesc(ACM, axes = 1:2) # test ANOVA pour mesurer la liaison entre chaque variable qualitative et chaque axe

# valeurs propres
head(ACM$eig)
barplot(ACM$eig[,2], names=paste("Dim",1:nrow(ACM$eig)))

# inertie totale = somme des valeurs propres sur ACM sur le tableau disjonctif complet
sum(ACM$eig[,1]) # somme des valeurs propres

# individus, colori?s selon "Cible"
plot(ACM,choix="ind", invisible="var", habillage="Cible")

# individus colori?s selon leurs modalit?s sur les 2 premiers axes
plotellipses(ACM, keepvar=1:4)

# graphique des variables
plot(ACM, choix="var")
# graphique des modalit?s
plot(ACM, choix="ind", invisible="ind", xlim=c(-1,2), autoLab="yes", cex=0.7)

# r?sultats pour les individus
ACM$ind$coord[1:10,1:6]

# coordonn?es des modalit?s sur les axes factoriels
ACM$var$coord[1:5,1:3]
# explication de la modalit? par l?axe = carr? du coefficient de corr?lation de la modalit? et de l'axe
ACM$var$cos2[1:5,1:3]
rowSums(ACM$var$cos2) # somme des cos2 pour l'ensemble des axes = 1 pour chaque modalit?
# contribution de la modalit? aux axes factoriels = proportion de l?inertie de la modalit? dans l?inertie de l?axe
ACM$var$contrib[1:5,1:3]
colSums(ACM$var$contrib) # somme des contributions pour chaque colonne = 100 pour chaque axe
# On s?int?ressera g?n?ralement aux modalit?s dont la contribution est sup?rieure au poids,
# c?est-?-dire dont la coordonn?e est sup?rieure ? la racine carr?e de l'inertie de l'axe


# ACM avec autres packages

library(MASS)
ACM2 <- mca(credit[,-20], nf = 54)
ACM2$d # ce sont les valeurs singuli?res des axes factoriels qui sont contenus dans ACM2$d, et il faut les ?lever au carr? pour retrouver les valeurs propres
ACM2$d^2 # eigenvalues
ACM2$cs[,1:3] # coordonn?es des modalit?s
ACM2$cs[,1:3]*(ncol(credit)-1)*sqrt(nrow(credit))
# les coordonn?es factorielles des individus sont beaucoup plus petites que celles fournies par FactoMineR et la plupart des logiciels
ACM2$rs[1:10,1:6] # coordonn?es des individus
ACM2$rs[1:10,1:6]*(ncol(credit)-1)*sqrt(nrow(credit))
# les coordonn?es factorielles des individus sont beaucoup plus petites que celles fournies par FactoMineR et la plupart des logiciels
# Il faut les multiplier par le nombre de variables et la racine carr?e du nombre d?individus pour trouver les coordonn?es habituelles
# plan factoriel
plot(ACM2, rows=F)
# ajout au plan factoriel des modalit?s d'un facteur suppl?mentaire
predict(ACM2, credit[20], type="factor") # facteur suppl?mentaire
points(predict(ACM2, credit[20], type="factor")[,1:2], cex=2, pch=16, col="blue")
# coord(FactoMineR) / (coord(MASS) * sqrt(eigenvalue)) = constante
# la m?me constante pour tous les axes et toutes les modalit?s
# coord_var(MASS) = coord_var(FactoMineR) / (p * sqrt(n) * sqrt(eigenvalue)) 
# coord_ind(MASS) = coord_ind(FactoMineR) / (p * sqrt(n)) 

#install.packages('ade4')
library(ade4)
ACM3 <- dudi.acm(credit[,-20], scannf = F, nf = 54)
ACM3$eig
ACM3$co[,1:3]

# comparaison des temps de calcul pour ACM
install.packages('microbenchmark')
library(microbenchmark)
compare <- microbenchmark(Facto=MCA(credit[,-20], ncp = 54, graph = F), MASS=mca(credit[,-20], nf = 54), ade4=dudi.acm(credit[,-20], scannf = F, nf = 54),
times=10, unit="ms")
compare
library(ggplot2)
autoplot(compare)



# ---------------------------------------------------------------------------------------------------------
# CAH
# ---------------------------------------------------------------------------------------------------------


# CAH avec FactoMineR
library(FactoMineR)
ACM <- MCA(credit, ncp = 54, axes = c(1,2), graph = F, quali.sup = 20)
#cah <- HCPC(ACM, consol=F, method="single", nb.clust=2)
cah <- HCPC(ACM, nb.clust=3)
plot(cah, choice ="tree", cex = 0.6)
plot(cah, choice ="map", draw.tree = FALSE)
plot(cah, choice ="map", draw.tree = FALSE, ind.names = FALSE, centers.plot = TRUE)
# taille des classes
table(cah$data.clust$clust)

# taux d'impay?s par classe
tab <- table(cah$data.clust$clust,credit$Cible)
prop.table(tab,1)

# caract?risation des classes par les variables initiales
cah$desc.var
(0.50-0.234)/sqrt((0.234*(1-0.234)/1000)+(0.5*(1-0.5)/22))
(0.50-0.228)/sqrt((0.228*(1-0.228)/978)+(0.5*(1-0.5)/22))
cah$desc.var$test.chi2
cah$desc.var$category
# caract?risation des classes par les axes
cah$desc.axes

# inertie
cah$call$t$within[1] # inertie totale
cah$call$bw.before.consol # inertie inter-classe pour le nombre de classes retenu
(intra <- cah$call$t$within[1:20]) # inertie intraclasse
cah$call$t$within[1] - cah$call$t$within[1:20] # inertie inter-classe
(cah$call$t$within[1] - cah$call$t$within[1:20]) / cah$call$t$within[1] # R? = inertie inter-classe / inertie totale
cah$call$t$inert.gain[1:20] # gain d'inertie intraclasse
intra[1:19] - intra[2:20] # gain d'inertie intraclasse
plot(cah$call$t$inert.gain[1:20])
# maximisation du gain d'inertie intraclasse
1+which.max(sapply(1:19, function(n) (cah$call$t$inert.gain[n]/cah$call$t$inert.gain[n+1])))
sapply(1:19, function(n) (cah$call$t$inert.gain[n]/cah$call$t$inert.gain[n+1]))

# CAH avec package stats
d <- dist(ACM$ind$coord, method = "euclidean") # distance matrix
h <- stats::hclust(d, method="ward.D2")
h <- stats::hclust(ACM$ind$coord, method="ward.D2")
h <- hclust(d^2, method="ward.D") # on obtient les m?mes classes mais pas la m?me inertie qu'avec hclust(d, method="ward.D2")
h <- hclust(d, method="single") # method=single
plot(h) # affichage du dendrogramme
# nb de classes optimal obtenu par maximisation du gain d'inertie intraclasse
# rev(h$height)[n] contient le gain d'inertie intraclasse en passant de n+1 ? n classes
# le 1er ?l?ment du vecteur rev(h$height) contient ainsi le gain d'inertie intraclasse en passant de 2 ? 1 classes
# <=> le dernier ?l?ment du vecteur h$height contient ainsi le gain d'inertie intraclasse en passant de 2 ? 1 classes
1+which.max(sapply(1:19, function(n) (rev(h$height)[n]/rev(h$height)[n+1])))
rev(h$height)[1:19]
rev(h$height)[1:19]/cah$call$t$inert.gain[1:19] # quotient = 2 * effectif (pourquoi "2 fois" ?)
sapply(1:19, function(n) (rev(h$height)[n]/rev(h$height)[n+1]))
rect.hclust(h, k=3, border="red") # dendrogram with red borders around the clusters
# affectation de chaque observation ? un groupe
hc.clust <- cutree(h, k=3) # d?coupage du dendrogramme
table(hc.clust)
# comparaison avec FactoMineR
cah <- HCPC(ACM, nb.clust=3, consol=F)
table(cah$data.clust$clust, hc.clust)

# CAH avec package cluster
library(cluster)
d <- dist(ACM$ind$coord, method = "euclidean") # distance matrix
ag <- agnes(d, method="ward", trace.lev=1)
ag.clust <- cutree(ag, k=3) # d?coupage du dendrogramme
clusplot(credit, ag.clust, color = T, shade = T, labels = 3)
table(ag.clust)
table(cah$data.clust$clust, ag.clust)

# CAH avec flashClust
library(flashClust)
d <- dist(ACM$ind$coord, method = "euclidean") # distance matrix
fh <- flashClust::hclust(d, method="ward")
fc.clust <- cutree(fh, k=3) # cut tree into clusters
table(fc.clust)

# comparaison des CAH
table(cah$data.clust$clust, hc.clust)
table(cah$data.clust$clust, ag.clust)
table(cah$data.clust$clust, fc.clust)

# comparaison des temps de calcul pour ACM
library(microbenchmark)
compare <- microbenchmark(HCPC=HCPC(ACM, consol=F, nb.clust=-1, graph=F), hclust=stats::hclust(d, method="ward.D2"), hclust1=stats::hclust(d, method="ward.D"), 
flashClust=flashClust::hclust(d, method="ward"), agnes=agnes(d, method="ward"), 
times=10, unit="ms")
compare
library(ggplot2)
autoplot(compare)

# d?termination du nb optimal de classes
install.packages('clusterSim')
library(clusterSim)
sim <- cluster.Sim(ACM$ind$coord, p=7, minClusterNo=2, maxClusterNo=16, icq="S", methods="m7")
sim <- cluster.Sim(ACM$ind$coord, p=9, minClusterNo=3, maxClusterNo=6, icq="G1", methods="m9", normalizations="n1")
sim$path
sim$result # valeur optimale de icq
sim$normalization
sim$distance
sim$method
sim$classes # nb de classes
# valeur de path (param?tre "p")
path of simulation: 1 - ratio data, 2 - interval or mixed (ratio & interval) data, 3
- ordinal data, 4 - nominal data, 5 - binary data, 6 - ratio data without normaliza-
tion, 7 - interval or mixed (ratio & interval) data without normalization, 8 - ratio
data with k-means, 9 - interval or mixed (ratio & interval) data with k-means

install.packages('NbClust')
library(NbClust)
NbClust(d, distance="euclidean", min.nc=2, max.nc=8, method = "ward.D2", index = "ch")



# ---------------------------------------------------------------------------------------------------------
# k-means
# ---------------------------------------------------------------------------------------------------------


# k-means
set.seed(123) # pour partir des m?mes centres initiaux
k <- kmeans(ACM$ind$coord, centers=3, nstart=10)
# 'nstart' feature in kmeans gives the best results out of n trials
# (minimizing the total within cluster sum of squares)
# taille des classes
k$size
# no de classe de chaque observation
head(k$cluster,10)
# centres des classes
k$centers
# centre des classes calcul?s (pour v?rification)
aggregate(ACM$ind$coord, by=list(k$cluster), FUN=mean)
# individus sur plan factoriel colori?s selon leur classe
plot(ACM$ind$coord[,1], ACM$ind$coord[,2], col=k$cluster)
#k1 <- kmeans(ACM$ind$coord, centers=4, nstart=1)
#comparing.Partitions(k$cluster,k1$cluster,type="rand")
# ajout du no de classe aux donn?es
ACM$ind$coord <- data.frame(ACM$ind$coord, k$cluster)
# comparaison avec CAH
table(cah=cah$data.clust$clust, kmeans=k$cluster)

# ?volution de l'inertie intra-classe
set.seed(123) # pour partir des m?mes centres initiaux
wss <- 0
for (i in 1:16) wss[i] <- sum(kmeans(ACM$ind$coord, centers=i, nstart=10)$withinss)
wss
plot(1:16, wss, type="b", xlab="Number of Clusters", ylab="Within groups sum of squares")
# comparaison avec CAH
cah$call$t$within[1:16]

# d?termination du nb optimal de classes
library(fpc)
# utilisation du crit?re de Calinski-Harabasz (ratio variance interclasse / variance intraclasse)
set.seed(123)
system.time(clustering.ch <- kmeansruns(ACM$ind$coord, krange=3:6, criterion="ch"))
clustering.ch$crit # valeurs du crit?re
clustering.ch$bestk
# utilisation de l'indice Silhouette
set.seed(123)
system.time(clustering.asw <- kmeansruns(ACM$ind$coord, krange=3:6, criterion="asw"))
clustering.asw$crit # valeurs de l'indice
clustering.asw$bestk



# ---------------------------------------------------------------------------------------------------------
# k-means tronqu?s et sparse
# ---------------------------------------------------------------------------------------------------------

library(RSKC)
d <- dist(ACM$ind$coord, method = "euclidean") # distance matrix
head(ACM$ind$coord)
reRSK <- RSKC(ACM$ind$coord, L1 = 10, nstart = 10, ncl = 3, alpha = 0.1, silent=F)
table(RSKC=reRSK$labels, kmeans=k$cluster)
reRSK$weights
barplot(reRSK$weights)
barplot(log(reRSK$weights))
# k-means
set.seed(123)
r1 <- RSKC(ACM$ind$coord, L1 = NULL, ncl = 3, alpha = 0, nstart = 10, silent=F)
r1$WSS # inertie intraclasse
table(RSKC=r1$labels, kmeans=k$cluster)
r1$weights
barplot(log(r1$weights))
# Sparse K-means
set.seed(123)
r2 <- RSKC(ACM$ind$coord, L1 = 1000000, ncl = 3, alpha = 0, nstart = 10, silent=F)
r2$WBS
rev(r2$WBS)[1] # inertie interclasse
table(RSKC=r2$labels, kmeans=k$cluster)
r2$weights
barplot(r2$weights[3:54])
barplot(r2$weights)
barplot(log(r2$weights))
# trimmed K-means
set.seed(123)
r3 <- RSKC(ACM$ind$coord, L1 = NULL, ncl = 3, alpha = 0.1, nstart = 10, silent=F)
table(RSKC=r3$labels, kmeans=k$cluster)
r3$weights
barplot(r3$weights)

# ?volution de l'inertie intra-classe
wss <- 0
wss <- (nrow(ACM$ind$coord)-1)*sum(apply(ACM$ind$coord,2,var))
# k-means tronqu?s
set.seed(123) # pour partir des m?mes centres initiaux
for (i in 2:16) wss[i] <- RSKC(ACM$ind$coord, L1 = NULL, ncl = i, alpha = 0.1, nstart = 10, silent=F)$WSS
wss
# k-means sparse (c'est l'inertie inter-classe qui est restitu?e)
set.seed(123) # pour partir des m?mes centres initiaux
for (i in 2:16) wss[i] <- wss[1] - rev(RSKC(ACM$ind$coord, L1 = 50, ncl = i, alpha = 0, nstart = 10, silent=F)$WBS)[1]
wss
plot(1:16, wss, type="b", xlab="Number of Clusters", ylab="Within groups sum of squares")
# maximisation du gain d'inertie intraclasse
inert.gain <- intra[1:15] - intra[2:16]
1+which.max(sapply(1:16, function(n) (inert.gain[n]/inert.gain[n+1])))



# ---------------------------------------------------------------------------------------------------------
# Autres jeux de donn?es
# ---------------------------------------------------------------------------------------------------------


# D?mo simple
set.seed(123)
x <- c(rnorm(15)+5, rnorm(15)+10, rnorm(15)+15)
y <- c(rnorm(15)+10, rnorm(15)+15, rnorm(15)+5)
plot(x,y)
k <- kmeans(cbind(x,y), centers=3, nstart=10)
k
k$cluster
plot(x,y,col=k$cluster)
# cluster centers
round(k$centers, digits=3)


# DBSCAN

dbscan <- read.csv("C:/Users/TUFFERY/Documents/Data Mining/Universit? Rennes 1/Cours/Cours Data Mining/Donn?es/dbscan.csv", h=T)
plot(dbscan[,1:2], col=dbscan[,3])
legend("topleft", legend=levels(factor(dbscan[,3])), text.col=seq_along(levels(factor(dbscan[,3]))))

# CAH avec package stats
d <- dist(dbscan, method = "euclidean") # distance matrix
h <- hclust(d, method="ward.D2")
h <- hclust(d, method="single") # erreur nulle avec method=single
plot(h) # affichage du dendrogramme
# nb de classes optimal obtenu par maximisation du gain d'inertie intraclasse
# rev(h$height)[n] contient le gain d'inertie intraclasse en passant de n+1 ? n classes
# le 1er ?l?ment du vecteur rev(h$height) contient ainsi le gain d'inertie intraclasse en passant de 2 ? 1 classes
# <=> le dernier ?l?ment du vecteur h$height contient ainsi le gain d'inertie intraclasse en passant de 2 ? 1 classes
1+which.max(sapply(1:16, function(n) (rev(h$height)[n]/rev(h$height)[n+1])))
rect.hclust(h, k=4, border="red") # dendrogram with red borders around the clusters
# affectation de chaque observation ? un groupe
cluster <- cutree(h, k=4) # d?coupage du dendrogramme
# erreurs de classification
table(dbscan[,3], cluster)
(nrow(dbscan)-sum(diag(table(dbscan[,3], cluster))))/nrow(dbscan)
> (nrow(dbscan)-sum(diag(table(dbscan[,3], cluster))))/nrow(dbscan)
[1] 0.2283105
# individus sur plan factoriel colori?s selon leur classe
plot(dbscan$X, dbscan$Y, col=cluster)

# k-means
set.seed(123) # pour partir des m?mes centres initiaux
k <- kmeans(dbscan, centers=4, nstart=10)
# taille des classes
k$size
# erreurs de classification
table(dbscan[,3], k$cluster)
# individus sur plan factoriel colori?s selon leur classe
plot(dbscan$X, dbscan$Y, col=k$cluster)

# Sparse k-means
library(RSKC)
d <- dist(dbscan, method = "euclidean") # distance matrix
# k-means
set.seed(123)
r1 <- RSKC(dbscan, L1 = NULL, ncl = 4, alpha = 0, nstart = 10, silent=F)
table(RSKC=r1$labels, kmeans=k$cluster)
# Sparse K-means
set.seed(123)
r2 <- RSKC(dbscan, L1 = 10, ncl = 4, alpha = 0, nstart = 10, silent=F)
table(RSKC=r2$labels, kmeans=k$cluster)
r2$weights
table(dbscan[,3], r2$labels)
plot(dbscan$X, dbscan$Y, col=r2$labels)
barplot(r2$weights)
barplot(log(r2$weights))
# trimmed K-means
set.seed(123)
r3 <- RSKC(dbscan, L1 = NULL, ncl = 4, alpha = 0.05, nstart = 10, silent=F)
plot(dbscan$X, dbscan$Y, col=r3$labels)
table(dbscan[,3], r3$labels)



# ---------------------------------------------------------------------------------------------------------
# classification DBSCAN par estimation de densit?
# ---------------------------------------------------------------------------------------------------------

install.packages("factoextra")
install.packages("fpc")
install.packages("dbscan")

library(factoextra)
data("multishapes", package = "factoextra")
table(multishapes[,3])
df <- multishapes[, 1:2]
plot(df)
library(ggplot2)
qplot(df$x, df$y, shape=as.factor(multishapes[,3]), colour=as.factor(multishapes[,3]))

# kmeans
set.seed(123) # pour partir des m?mes centres initiaux
k <- kmeans(df, centers=6, nstart=10)
# 'nstart' feature in kmeans gives the best results out of n trials
# (minimizing the total within cluster sum of squares)
# taille des classes
k$size
# croisement entre classes d?tect?es et r?elles
table(multishapes[,3], k$cluster)
# no de classe de chaque observation
head(k$cluster,10)
# centres des classes
k$centers
# affichage
fviz_cluster(k, df, stand = FALSE, ellipse = FALSE, geom = "point")
qplot(df$x, df$y, shape=as.factor(k$cluster))

# PAM
library(cluster)
k <- pam(df, 6)
summary(k)
plot(k)
# taille des classes
k$clusinfo
# croisement entre classes d?tect?es et r?elles
table(multishapes[,3], k$cluster)
# no de classe de chaque observation
head(k$cluster,10)
# affichage
fviz_cluster(k, df, stand = FALSE, ellipse = FALSE, geom = "point")
qplot(df$x, df$y, colour=as.factor(k$cluster), shape=as.factor(k$cluster))

# CLARA
library(cluster)
k <- clara(df, 6, samples=50)
summary(k)
plot(k)
# taille des classes
k$clusinfo
# croisement entre classes d?tect?es et r?elles
table(multishapes[,3], k$cluster)
# no de classe de chaque observation
head(k$cluster,10)
# affichage
fviz_cluster(k, df, stand = FALSE, ellipse = FALSE, geom = "point")
qplot(df$x, df$y, shape=as.factor(k$cluster))

# CAH avec package cluster
library(cluster)
d <- dist(df, method = "euclidean")
ag <- agnes(d, method="single", trace.lev=1)
ag.clust <- cutree(ag, k=6) # d?coupage du dendrogramme
#clusplot(df, ag.clust, color = T, shade = T, labels = 3)
table(ag.clust)
table(cah$data.clust$clust, ag.clust)
# affichage
qplot(df$x, df$y, colour=as.factor(ag.clust))

# DBSCAN avec dbscan
library(dbscan)
dbscan::kNNdistplot(df, k = 5)
abline(h = 0.15, lty = 2)
k <- dbscan::dbscan(df, eps = .15, minPts = 5)
#k <- dbscan(df, eps = .15, minPts = 5, borderPoints = FALSE)
# description de la classification
print(k)
# nombre des classes
table(k$cluster)
# croisement entre classes d?tect?es et r?elles
table(multishapes[,3], k$cluster)
# affichage
fviz_cluster(k, df, stand = FALSE, ellipse = FALSE, geom = "point")
qplot(df$x, df$y, shape=as.factor(k$cluster), colour=as.factor(k$cluster))

# DBSCAN avec fpc
library(fpc)
# Compute DBSCAN using fpc package
set.seed(123)
db <- fpc::dbscan(df, eps = 0.15, MinPts = 5)
# Plot DBSCAN results
plot(db, df, main = "DBSCAN", frame = FALSE)
fviz_cluster(db, df, stand = FALSE, ellipse = FALSE, geom = "point")
# Print DBSCAN
print(db)



# ---------------------------------------------------------------------------------------------------------
# Classification de variables
# ---------------------------------------------------------------------------------------------------------

library(ClustOfVar)
str(credit2)
# s?paration des variables qualis et quantis
classes <- as.character(sapply(credit2, class))
varquali <- which(classes=="factor")
varquanti <- -varquali
# on appelle la fonction hclustvar de CAH avec les variables
# - quantis en 1er argument
# - qualis en 2e argument
tree <- hclustvar(credit2[,varquanti],credit[,varquali])
# dendrogramme
plot(tree)
# coupure du dendrogramme
part_hier <- cutreevar(tree,3)
print(part_hier)
part_hier$var # coeff de corr?lation entre chaque variable quali et chaque variable synth?tique d'un cluster
part_hier$scores
part_hier$cluster
part_hier$wss
part_hier$coef
# on appelle la fonction kmeansvar de kmeans avec les variables
# - quantis en 1er argument
# - qualis en 2e argument
set.seed(123)
part_km <- kmeansvar(credit2[,varquanti],credit2[,varquali], init=3, nstart=10)
levels(credit2$Type_emploi)[4] <- "Sans_emploi"
part_km$var
# homog?n?it? des classes = somme des carr?s des coefficients de corr?lation
# des variables de la classe avec la composante principale de la classe
part_km$E
part_hier$E
# homog?n?it? de la classification en fonction du nb de classes de variables
sapply(2:6, function(n) (kmeansvar(credit[,varquanti],credit[,varquali], init=n, nstart=10)$E))
tree <- hclustvar(credit[,varquanti],credit[,varquali])
barplot(sapply(2:12, function(n) (cutreevar(tree,n)$E)))
# stabilit? test?e par bootstrap
stab <- stability(tree, B=40)
plot(stab, main="Stability of the partitions")




# =========================================================================================================
# INDUSTRIALISATION
# =========================================================================================================

# export PMML
install.packages('pmml')
library(pmml)
setwd("C:/Users/TUFFERST/Documents")
pmml(rn)
write(toString(pmml(rn)),file = "nnet.xml") # non reconnu par SPSS
saveXML(pmml(rn),"softmax.xml") # reconnu par SPSS
write.csv2(train,"C:/Users/TUFFERST/Documents/DATA MINING/Cours Data Mining/Institut des Actuaires\\germancredit_train.csv")
write.csv2(valid,"C:/Users/TUFFERST/Documents/DATA MINING/Cours Data Mining/Institut des Actuaires\\germancredit_valid.csv")
str(valid)



# =========================================================================================================
# Sous- et sur-apprentissage
# =========================================================================================================


set.seed(123)
n <- 100
x <- runif(n)*10
y0 <- sin(x/2)
y <- y0 + rnorm(length(x))/2
db <- data.frame(x,y)
# donn?es ? ajuster
plot(x,y)
# sous-apprentissage
reg <- lm(y~x, data=db)
points(x, predict(reg), col="green", pch=15)
# sur-apprentissage
library(splines)
reg <- lm(y~bs(x, degree=10), data=db)
points(x, predict(reg), col="red", pch=17)
# mod?le parfait
points(x, y0, col="blue", pch=16)
