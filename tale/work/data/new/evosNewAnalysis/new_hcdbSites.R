## HCDB sampling locations and sample type
## 

library(dataone) #needed to run
library(dplyr)

## Initialize a client to interact with DataONE
cli <- D1Client("PROD", "urn:node:GOA")

hcdb=read.csv("rp_Total_Aromatic_Alkanes_PWS.csv",header=T)
hcdb=hcdb %>%
  mutate(matr2=tolower(matrix)) %>%
  filter(!matr2=='fblank') %>%
  filter(!matr2=='blank') %>%
  filter(!matr2=='us') %>%
  filter(!matr2=='qcsed') %>%
  filter(!matrix=='') 
  
### mapping
library(rworldmap)
library(rworldxtra)
library(rgdal)
library(ggplot2)


world=getMap('low',projection=NA)
worldB=world[!is.na(world$continent),]
world2=worldB[worldB$continent=='North America' & worldB$LON<0,]
fWorld=fortify(world2)
colMap=c('dimgrey','black')

extDf=data.frame(xmin=-157,xmax=-143,ymin=56,ymax=62)

ggplot(data=fWorld) +
  geom_map(map=fWorld,aes(x=long,y=lat,map_id=id))+
  coord_map(xlim = c(-180, -123),ylim = c(34, 63))+ 
  geom_point(data=hcdb,mapping=aes(x=as.numeric(LONG), y=as.numeric(LAT),colour=matr2),size=1,alpha=0.7, shape=20, colour="#FF7777") +
  #scale_color_manual(values=tsColors,name='category')+ #,breaks=rev(cnLevels),labels=rev(cnLevels)
  #geom_rect(data=extDf,aes(xmin=xmin,xmax=xmax,ymin=ymin,ymax=ymax),color='gray53',fill=NULL,lwd=0.5,alpha=0.75)+
  ggtitle('Locations of HCDB data in the Gulf of Alaska')+
  xlab('lon')+
  theme(axis.line=element_line(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        legend.position='none',
        axis.text=element_text(size=14),
        title=element_text(size=16,face="bold"))+
  guides(colour = guide_legend(override.aes = list(size=6)))
ggsave("rp_hcdbSamplesGOA.png", width=12, height=8)


#### ZOOOOOM in:
#tempFilename <- "shape.zip"
#akMapObject=getDataObject(cli,'df35d.431.1')  ## shp file from dataONE
#akMapData <- getData(akMapObject)
#writeBin(akMapData,"shape")
#file.rename("shape",tempFilename)
#unzip(tempFilename, list=FALSE) ### ERRORS, not sure why, line 21: Error in name == "GADM" : comparison (1) is possible only for atomic and list types

state <- readOGR('../../../GIS','statep010')
stateDf=fortify(state)

## Colors:
library('RColorBrewer')


ggplot(data=stateDf, aes(y=lat, x=lon)) +
  geom_map(map=stateDf,aes(x=long,y=lat,map_id=id))+
  coord_map(xlim = c(-157, -143),ylim = c(56, 62))+ 
  #scale_fill_manual(values=colMap)+
  geom_point(data=hcdb, aes(x=as.numeric(LONG), y=as.numeric(LAT),colour=matrix), size=2, shape=20,alpha=0.75) + 
  scale_colour_brewer(palette='Set1',name='Sample type')+#,breaks=cnLevels,labels=cnLevels
  ggtitle('Locations of HCDB data in Northern GOA')+
  theme(axis.line=element_line('black'),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        legend.position='right',
        axis.text=element_text(size=14),
        title=element_text(size=16,face="bold"))+
  guides(colour = guide_legend(override.aes = list(size=6)))
ggsave("rp_hcdbSampleLocs.png", width=12, height=9)

############################################
###########################################
