# NMF operator

##### Description

The `NMF operator` is a template repository for the creation of R operators in Tercen.

##### Usage

Input projection|.
---|---
`y-axis`        | numeric, value
`row`           | factor, variables
`column`        | factor, observation IDs 

Input parameters|.
---|---
`n_clust`        | Number of archetypes to infer
`method`        | NMF method

Output relations|.
---|---
`Archetype_n`        | Scores of each observation on each inferred archetype
`H_Archetype_n`        | Scores of each variable on each inferred archetype

##### Details

This operator is a wrapper of the `nmf` function from the `NMF` R package. Available 
methods are described in the [documentation of this function](https://www.rdocumentation.org/packages/NMF/versions/0.23.0/topics/nmf).

##### See Also

[autoencoder_operator](https://github.com/tercen/autoencoder_operator)

