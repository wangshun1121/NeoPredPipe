## Summary

Post netMHCpan predictions, this pipeline allows you to perform neoantigen recognition potential predictions as described by [Marta Luksza et al., Nature 2017](https://www.nature.com/articles/nature24473).

## Dependencies
###### Note: Should be compatible on Darwin and Linux systems, not Windows.

The pipeline relies on a neoantigen table in the format produced by NeoPredPipe, running netMHCpan-4.0 or netMHCpan-4.1.
This can be generated following the procedure outlined [here](README.md). but a suitably formatted input would also suffice. Please note that if another software was used for neoantigen binding predictions, the outputted neoantigen table should be further processed to follow the same format shown in [NeoPredPipe](README.md).
Make sure to use the same netMHCpan version as in NeoPredPipe.py (specificed in _usr_paths.ini_), as it is automatically detected from _usr_paths.ini_ and used to process the neoantigen table accordingly.

Besides the dependencies outlined [here](README.md), the following are required for neoantigen recognition potential predictions.

1. [NCBI BlastX+](https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs&DOC_TYPE=Download)
   - Fully install NCBI BlastX+ as per NCBI's instructions
2. Full blastp executable added to usr_paths.ini

## Running the model
```bash
# Use 'python ./NeoRecoPo.py --help' to view the full list of options'. 

python ./NeoRecoPo.py --neopred_in=<predictions from NeoPredPipe> --neoreco_out=<output.txt> --fastas=<directory of fasta files for samples created in previous step>
# if running for indel mutations, specify it with the option --indel
python ./NeoRecoPo.py --neopred_in=<indel predictions from NeoPredPipe> --neoreco_out=<output.txt> --fastas=<directory of fasta files for samples created in previous step> --indel
```

## Output

The new output has a few additional columns. Most notable are A, R, Excluded, and a final calculated NeoantigenRecognitionPotential. Further information can be found in the publication in the Summary section for these outputs.
