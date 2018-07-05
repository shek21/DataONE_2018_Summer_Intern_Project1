#@begin EVOS_GoA_Analysis
#@in PAH @URI file:PAH.csv
#@in Sample @URI file:Sample.csv
#@in Non_EVOS_SINs @URI file:Non-EVOS_SINs.csv
#@in Alkane @URI file:Alkane.csv

#@begin Analysis @desc hdbcSites.R	
#@in Total_Aromatic_Alkanes_PWS @URI file:Total_Aromatic_Alkanes_PWS.csv
#@out hcdbSampleLocs @URI file: hcdbSampleLocs.png
#@out hcdbSamplesGOA @URI file: hcdbSamplesGOA.png
#@end Analysis

#@begin DataMerge @desc Total_PAH_and_Alkanes_GoA_Hydrocarbons_Clean.R
#@in PAH
#@in Sample
#@in Non_EVOS_SINs
#@in Alkane
#@out Total_Aromatic_Alkanes_PWS @URI file:Total_Aromatic_Alkanes_PWS.csv
#@end DataMerge


#@out hcdbSampleLocs
#@out hcdbSamplesGOA
#@end EVOS_GoA_Analysis
