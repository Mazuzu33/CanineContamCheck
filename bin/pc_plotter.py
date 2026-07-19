import pandas as pd
import plotly.express as px
import plotly.graph_objects as go

# Import tsv file containing PC coordinates from reference panel
ref_df = pd.read_csv("data/verifybamid/resource_files/dog_wgs.n3973.UU_Cfam_GSD_1.0_ROSY.20251223.snps.phased.filter.prune.vcf.gz.V", 
                 sep='\t', 
                 header=None, 
                 names=["Sample Name", "PC1", "PC2", "PC3", "PC4", "PC5", "PC6", "PC7", "PC8", "PC9", "PC10"], 
                 usecols=range(11)
)

# Create a new column identifying the breed of the dog
ref_df["Breed"] = ref_df["Sample Name"].str[0:4]

# Create a new column identifying the points as reference points
ref_df["Type"] = "Reference"

# Import csv file containing pc coordinates of new samples
new_df = pd.read_csv(snakemake.input[0])

# Create a new column identifying the points as new points
new_df["Type"] = "New"

# Join the two dataframes together
concat_df = pd.concat([ref_df, new_df])



# Create the 3d plot
fig = px.scatter_3d(
    concat_df,
    x="PC1",
    y="PC2",
    z="PC3",
    color="Breed",
    symbol="Type",
    symbol_map={"Reference": "circle", "New": "circle"},
    opacity=0.5
)

# Apply a black outline to new points
fig.add_trace(go.Scatter3d(
    x=new_df["PC1"],
    y=new_df["PC2"],
    z=new_df["PC3"],
    mode="markers",
    marker=dict(size=10, color="black", symbol="circle-open"),
    name="Outline",
    showlegend=False,
    hoverinfo="skip"
))

# Save figure to a html file
fig.write_html(snakemake.output[0])

