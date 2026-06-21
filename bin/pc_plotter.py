import pandas as pd
import plotly.express as px

# Import tsv file containing PC coordinates from verifybamid
df = pd.read_csv("data/verifybamid/resource_files/dog_wgs.n3973.UU_Cfam_GSD_1.0_ROSY.20251223.snps.phased.filter.prune.vcf.gz.V", 
                 sep='\t', 
                 header=None, 
                 names=['Sample Name', 'PC1', 'PC2', 'PC3', 'PC4', 'PC5', 'PC6', 'PC7', 'PC8', 'PC9', 'PC10'], 
                 usecols=range(11)
)

# Create a new column identifying the breed of the dog
df['Breed'] = df['Sample Name'].str[0:4]


fig = px.scatter_3d(
    df,
    x='PC1',
    y='PC2',
    z='PC3',
    color='Breed'
)

fig.show()

