import pandas as pd
import numpy as np
from scipy.stats import chi2
from sklearn.covariance import MinCovDet

# Import tsv file containing PC coordinates from reference panel
ref_df = pd.read_csv("data/verifybamid/resource_files/dog_wgs.n3973.UU_Cfam_GSD_1.0_ROSY.20251223.snps.phased.filter.prune.vcf.gz.V", 
                 sep='\t', 
                 header=None, 
                 names=["Sample Name", "PC1", "PC2", "PC3", "PC4", "PC5", "PC6", "PC7", "PC8", "PC9", "PC10"], 
                 usecols=range(11)
)

# Create a new column identifying the breed of the dog
ref_df["Breed"] = ref_df["Sample Name"].str.split("#").str[0]

# Import csv file containing PC coordinates from new samples, with breed already included
new_df = pd.read_csv(snakemake.input[0])

# Set up our features and dimensions
features = ["PC1", "PC2", "PC3"]
n_dimensions = len(features)

# Build reference models, only for breeds with >= 30 dogs
reference_models = {}

for breed, breed_df in ref_df.groupby("Breed"):
    if len(breed_df) >= 30:
        try:
            model = MinCovDet(random_state=42).fit(breed_df[features].values)
            reference_models[breed] = model
        except ValueError:
            pass

# Check the breed of each new sample
samples = []
p_values = []
for index, row in new_df.iterrows():
    sample_id = row["Sample"]
    samples.append(sample_id)
    claimed_breed = row["Breed"]
    # Check if we have a reference model for the claimed breed that we can use
    if claimed_breed not in reference_models:
        p_values.append(np.nan)
    else:
        # Reshape coordinates to a 2D table of data
        coords = row[features].values.reshape(1,-1)
        # Calculate the p-value using a chi square distribution
        model = reference_models[claimed_breed]
        mah_sq = model.mahalanobis(coords)[0]
        p_value = 1 - chi2.cdf(mah_sq, n_dimensions)
        p_values.append(p_value)

# Write results to a csv file
results = {
    "Sample": samples,
    "P-value": p_values
}
results_df = pd.DataFrame(results)
results_df.to_csv(snakemake.output[0], index=False)
