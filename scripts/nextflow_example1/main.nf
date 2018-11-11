#!/usr/bin/env nextflow

params.file_dir = 'data/fastas/*.fasta'
params.out_dir = 'data/'
params.out_file = 'histogram.png'

file_channel = Channel.fromPath( params.file_dir )

process get_seq_length {
    container 'bioconductor/release_core2:R3.5.0_Bioc3.7'

    input:
    file f from file_channel

    output:
    stdout lengths

    """
    #!/usr/local/bin/Rscript

    suppressMessages(library(Biostrings))

    s = readDNAStringSet('$f')
    l = length(s[[1]])

    cat(l)
    """
}

process r_transform_list {

    input:
    val l from lengths.collect()

    output:
    stdout lengths_transformed

    """
    #!/usr/local/bin/Rscript

    print($l)
    """
}
