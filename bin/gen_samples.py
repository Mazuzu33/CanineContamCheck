import yaml
import sys
import pandas as pd
from pathlib import Path

# Open yaml file
with open("../config/config.yaml", "r") as file:
        config = yaml.safe_load(file)

# Extract path of samples csv, depending on whether it is a relative or absolute path
if config["samples_csv"][0] == "/":
       samples_csv_path = config["samples_csv"]
else:
       samples_csv_path = Path("../" + config["samples_csv"])

# Check if the user provided one argument
if len(sys.argv) > 1 and len(sys.argv) < 3:
        # Check if the argument is a valid path
        bam_dir_path = Path(sys.argv[1])
        if not bam_dir_path.is_dir():
               print("Error: the provided argument is not a valid path")
               sys.exit(1)
       
        bam_files = list(bam_dir_path.glob("*.cram")) + list(bam_dir_path.glob("*.bam"))
else:
    print("Error: This script expects exactly one argument")
    sys.exit(1)


samples_data = []
# For each bam file,
for file in bam_files:
       # Extract samplename
       samplename = file.name.split(".")[0]
       samples_data.append(
              {
                     "samplename": samplename,
                     "breed": "",
                     "samplepath": str(file)
              }
       )

# Write the data to a csv file
samples_df = pd.DataFrame(samples_data)
samples_df.to_csv(str(samples_csv_path), index=False)
    
     



