---
title:  "Tech Tips #0"
date:   2023-01-10 12:00:00 +0000
categories: tech tutorial bayes phD
---

I'm launching a new category dedicated to small tech tips, where I'll document the challenges and solutions I encounter during my PhD journey, as well as in my broader research and technology-related endeavors.

To kick things off, here's a handy tip: Converting Bayesian networks from [pgmpy](https://pgmpy.org/index.html) to [bnlearn](https://www.bnlearn.com/documentation/bnlearn-manual.pdf) and then using them in [SamIam](http://reasoning.cs.ucla.edu/samiam/).

Recently, I created a network in pgmpy (Python) and wanted to test it in SamIam. Although SamIam offers several options for opening networks, I faced difficulties with the available formats (namely xmlbif or bif from pgmpy).

My solution was to convert the network to the Hugin net format for use in SamIam. However, this conversion was not straightforward:

1. Start by exporting the pgmpy network to the bif format.
2. Import the bif format into bnlearn and then export it to the .net format. (code below)
3. Open it in SamIam.

```r
library(bnlearn)

model<-read.bif("<network>.bif",debug = TRUE)


model
write.net(""<network>.net",model)

```

This process should have been simple, but I encountered errors related to conditional probabilities. Upon inspecting the network in a text editor, I noticed several probabilities were in scientific notation (e-01, e-02, etc.), which SamIam couldn't process properly.

To address this, I converted them back to standard notation using the following Python script:

```python
import re

# Read the file
with open('../model_total.net', 'r') as file:
    content = file.read()

# Substitute numbers in scientific notation with natural number representation
content = re.sub(r'(\d+\.\d+)e-01', lambda match: str((float(match.group(1)) * 0.1)), content)

# Print the modified content
#print(content)
content = re.sub(r'(\d+\.\d+)e-02', lambda match: str((float(match.group(1)) * 0.01)), content)
content = re.sub(r'(\d+\.\d+)e-03', lambda match: str((float(match.group(1)) * 0.001)), content)
content = re.sub(r'(\d+\.\d+)e-04', lambda match: str((float(match.group(1)) * 0.0001)), content)
content = re.sub(r'(\d+\.\d+)e-05', lambda match: str((float(match.group(1)) * 0.00001)), content)

# Specify the path of the new file
new_file_path = '../modified_model_total.net'

# Write the modified content to the new file
with open(new_file_path, 'w') as file:
    file.write(content)

# Print a message to confirm that the file has been written
print(f"The modified content has been written to {new_file_path}")
```

With these adjustments, I was able to successfully read the file in SamIam with the data appearing correctly.


![Network in SamIam](/assets/img/samiam-example.png)