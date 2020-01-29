

library(ggplot2)

TAD_size<-read.table("./diff.head.bed", header=TRUE)
TAD_number<-read.table("./diff.counts.sorted.bed", header=TRUE)

pdf("TADsizedistribution.pdf")
hist(TAD_size$substraction, main="Histogram for TAD size distribution", xlab="TAD size", ylab="Frequency", col="grey", breaks=250)
dev.off()

pdf("TADs_per_chromosome.pdf")
p<-ggplot(TAD_number, aes(x=CHR, y=TADnumber)) +
  geom_bar(stat="identity", color="blue", fill="white")
p
dev.off()



