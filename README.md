# Codes and data for Inferring-historical-management-from-forest-census-patterns

## Data
* allTreeCensusData12-21-22: Census data from Ong lab
* full\_dat: UTM coordinates and land use + census data from Crispy
* tree\_soil: soil type data + full\_dat from Crispy
* census\_cluster\_only: species + cluster only
* census\_w\_cluster: only variables relevant for analysis

## Library 1: s\_clust\_lib
### Funtion: census\_viz
* Output: Scatter plots of tree distribution
* Inputs: 
	1. top num\_species (max 10) will be color coded and the rest will be clumped into a single group
	2. pl\_name\_1 - file name of plot with color based on species. e.g., base.png
	3. pl\_name\_2 - file name of plot with color based on land-use history. e.g., landuse.png
* Dependency: full\_dat.csv file in data folder

### Function: clust\_nhood
* Output: RData file with distance matrix for heirarchical clustering
* Inputs:
	1. ne\_type: stem/basal - metric to use for distances
	2. norm\_i: 0/1 - whether to normalize rows
* Dependency: full\_dat.csv file in data folder

### Function: clust\_plot
* Outputs:
	1. csv file with cluster number
	2. spatial plot colored by clusters
* Inputs:
	1. nb\_method: distance metric
	2. ind: index used to find best number of cluster
	3. ne\_type: stem/basal - metric to use for distances
	4. norm\_i: 0/1 - whether to normalize rows
* Dependency: full\_dat.csv file in data folder

### Function: clust\_stats
* Output: Table (csv) of best number of clusters and index value
* Inputs
	1. nb\_method: distance metric
	2. ind: index used to find best number of cluster
	3. ne\_type: stem/basal - metric to use for distances
	4. norm\_i: 0/1 - whether to normalize rows
* Dependency: Output of corresponding clust\_hood function

## Library 2: clust\_boot\_lib
### Function: clust\_boots
* Outputs:
	1.  csv file with best number of cluster, best index value and index value for other clusters no.
	2. histograms of number of clusters, best index value, index value of best number of cluster
* Inputs:
	1. nb\_method: distance metric
	2. ind: index used to find best number of cluster
	3. ne\_type: stem/basal - metric to use for distances
	4. norm\_i: 0/1 - whether to normalize rows
	5. nboot: Number of bootstrap replicates
* Dependency: full\_dat.csv file in data folder

## Library 3: pattern\_model\_lib
### Function: pattern\_model\_2d
* Output: data frame with species, x, y and environmental condition
* Inputs:
    1. cs >0 - conditioning strength
    2. cap - "n" or "p" - negative or positive conditioning
    3. cnd - "l" or "nl" - linear or nonlinear conditioning
    4. sp0 - positive matrix - initial abundances
    5. e0 - >0, <1 matrix same dimension as sp0 - initial environmental condition

## Scripts
### paper\_figs
* Output:
    1. (Fig. 2d) Tree distribution as scatter plot with top 10 species in legend
    2. (Fig. 4a) Cluster distribution as scatter plot

### assembled\_dat
* Output: Spreadsheet with census, elevation, soil, land use and cluster - census\_w\_cluster.csv
* Dependency: tree\_soil, full\_dat, ward.D2\_ball\_basal\_1\_20, census\_elevation csv files in data folder

### fig3
* Output: (Fig. 3) Two sets of initial condition and community assembly outcome for 4 different community assembly processes

### fig4b\_prep
* Output: PCoA results as RData
* Dependency: basal\_1\_neighbours.RData

### fig4b
* Output: PCoA plot
* Dependency: pcoa\_basal.RData and census\_w\_cluster.csv
