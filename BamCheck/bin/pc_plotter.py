import pandas as pd
import plotly.express as px
import plotly.graph_objects as go
import numpy as np

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

# Filter down the new samples dataframe to the only samples of the specified breed
new_df_filtered = new_df.loc[new_df["Breed"] == snakemake.wildcards.breed]
# Join the two dataframes together
concat_df = pd.concat([ref_df, new_df_filtered])

# Create a color map identifying the specified breed points to be electric blue and other breeds to be light gray
unique_breeds = concat_df["Breed"].unique()
color_map = {breed: ("rgba(0, 144, 239, 1.0)" if breed == snakemake.wildcards.breed else "lightgray") for breed in unique_breeds}

# Create the 3d plot
fig = px.scatter_3d(
    concat_df,
    x="PC1",
    y="PC2",
    z="PC3",
    color="Breed",
    color_discrete_map=color_map,
    hover_data = {
        "Breed": True,
        "Type": True,
        "PC1": True,
        "PC2": True,
        "PC3": True
    }
)

# Reduce marker size of points to 5
fig.update_traces(marker_size=5)

# Apply a black outline to new points
fig.add_trace(go.Scatter3d(
    x=new_df_filtered["PC1"],
    y=new_df_filtered["PC2"],
    z=new_df_filtered["PC3"],
    mode="markers",
    marker=dict(size=10, color="black", symbol="circle-open"),
    name="Outline",
    hoverinfo="skip"
))

# Save figure to a html file
fig.write_html(snakemake.output[0])

