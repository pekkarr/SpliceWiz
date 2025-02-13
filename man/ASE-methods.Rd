% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ASE-methods.R
\name{ASE-methods}
\alias{ASE-methods}
\alias{ASE_limma}
\alias{ASE_edgeR}
\alias{ASE_limma_timeseries}
\alias{ASE_edgeR_timeseries}
\alias{ASE_DESeq}
\alias{ASE_DoubleExpSeq}
\title{Differential Alternative Splicing Event analysis}
\usage{
ASE_limma(
  se,
  test_factor,
  test_nom,
  test_denom,
  batch1 = "",
  batch2 = "",
  IRmode = c("all", "annotated", "annotated_binary"),
  filter_antiover = TRUE,
  filter_antinear = FALSE
)

ASE_edgeR(
  se,
  test_factor,
  test_nom,
  test_denom,
  batch1 = "",
  batch2 = "",
  useQL = TRUE,
  IRmode = c("all", "annotated", "annotated_binary"),
  filter_antiover = TRUE,
  filter_antinear = FALSE
)

ASE_limma_timeseries(
  se,
  test_factor,
  batch1 = "",
  batch2 = "",
  degrees_of_freedom = 1,
  IRmode = c("all", "annotated", "annotated_binary"),
  filter_antiover = TRUE,
  filter_antinear = FALSE
)

ASE_edgeR_timeseries(
  se,
  test_factor,
  batch1 = "",
  batch2 = "",
  degrees_of_freedom = 1,
  useQL = TRUE,
  IRmode = c("all", "annotated", "annotated_binary"),
  filter_antiover = TRUE,
  filter_antinear = FALSE
)

ASE_DESeq(
  se,
  test_factor,
  test_nom,
  test_denom,
  batch1 = "",
  batch2 = "",
  n_threads = 1,
  IRmode = c("all", "annotated", "annotated_binary"),
  filter_antiover = TRUE,
  filter_antinear = FALSE
)

ASE_DoubleExpSeq(
  se,
  test_factor,
  test_nom,
  test_denom,
  IRmode = c("all", "annotated", "annotated_binary"),
  filter_antiover = TRUE,
  filter_antinear = FALSE
)
}
\arguments{
\item{se}{The \linkS4class{NxtSE} object created by \code{makeSE()}. To reduce
runtime and avoid excessive multiple testing, consider filtering
the object using \link{applyFilters}}

\item{test_factor}{The column name in the sample annotation \code{colData(se)}
that contains the desired variables to be contrasted. For
\code{ASE_limma_timeseries()} and \code{ASE_DESeq()} (when \code{test_nom} and
\code{test_denom} parameters are left blank), \code{test_factor} must contain
numerical values representing the time variable.}

\item{test_nom}{The nominator condition to test for differential ASE. Usually
the "treatment" condition}

\item{test_denom}{The denominator condition to test against for differential
ASE. Usually the "control" condition}

\item{batch1, batch2}{(Optional, limma and DESeq2 only) One or two condition
types containing batch information to account for.}

\item{IRmode}{(default \code{all}) Choose the approach to quantify IR events.
Default \code{all} considers all introns as potentially retained, and calculates
IR-ratio based on total splicing across the intron using the "SpliceOver"
or "SpliceMax" approach (see \link{collateData}). Other options include
\code{annotated} which calculates IR-ratios for annotated introns only, and
\code{annotated_binary} which calculates PSI considering the "included"
isoform as the IR-transcript, and the "excluded" transcript is
quantified from splice counts only across the exact intron
(but not that of overlapping introns). IR-ratio are denoted as "IR" events,
whereas PSIs calculated using IR and intron-spliced binary alternatives are
denoted as "RI" events.}

\item{filter_antiover, filter_antinear}{Whether to remove novel IR events that
overlap over or near anti-sense genes. Default will exclude antiover but
not antinear introns. These are ignored if strand-specific RNA-seq
protocols are used.}

\item{useQL}{(default \code{TRUE}) Whether to use edgeR's quasi-likelihood method
to help reduce false positives from near-zero junction / intron counts.}

\item{degrees_of_freedom}{(default \code{1}) The complexity of time series trends
modeled by \code{ASE_limma_timeseries}. E.g., \code{1} will only model linear trends,
whereas \code{2} extends the capacity for quadratic trends, \code{3} for cubic
trends, etc.}

\item{n_threads}{(DESeq2 only) How many threads to use for DESeq2
based analysis.}
}
\value{
For all methods, a data.table containing the following:
\itemize{
\item EventName: The name of the ASE event. This identifies each ASE
in downstream functions including \link{makeMeanPSI}, \link{makeMatrix},
and \link{plotCoverage}
\item EventType: The type of event. See details section above.
\item EventRegion: The genomic coordinates the event occupies. This spans the
most upstream and most downstream splice junction involved in the ASE,
and is use to guide the \link{plotCoverage} function.
\item flags: Indicates which isoforms are NMD substrates and/or which are
formed by novel splicing only.
\item AvgPSI_nom, Avg_PSI_denom: the average percent spliced in / percent
IR levels for the two conditions being contrasted. \code{nom} and \code{denom} in
column names are replaced with the condition names. Note this is a
geometric mean, based on the arithmetic mean of logit PSI values.
\item deltaPSI: The difference in PSI between the mean values of the two
conditions.
\item abs_deltaPSI: The absolute value of difference in PSI between
the mean values of the two conditions.
}

\strong{limma specific output}
\itemize{
\item logFC, AveExpr, t, P.Value, adj.P.Val, B: limma topTable columns of
differential ASE. See \link[limma:toptable]{limma::topTable} for details.
\item inc/exc_(logFC, AveExpr, t, P.Value, adj.P.Val, B): limma results
for differential testing for raw included / excluded counts only
}

\strong{edgeR specific output} equivalent to statistics returned by
\link[edgeR:topTags]{edgeR::topTags}:
\itemize{
\item logFC, logCPM, F, PValue, FDR: log fold change, log counts per million,
F statistic, p value and (Benjamini Hochberg) adjusted p values.
\item inc/exc_(...): edgeR statistics corresponding to
differential expression testing for raw included / excluded counts
in isolation
}

\strong{DESeq2 specific output}
\itemize{
\item baseMean, log2FoldChange, lfcSE, stat, pvalue, padj:
DESeq2 results columns for differential ASE; see \link[DESeq2:results]{DESeq2::results} for
details.
\item inc/exc_(baseMean, log2FoldChange, lfcSE, stat, pvalue, padj):
DESeq2 results for differential testing for
raw included / excluded counts only
}

\strong{DoubleExp specific output}
\itemize{
\item MLE_nom, MLE_denom: Maximum likelihood expectation of PSI values for the
\code{denom} in column names are replaced with the condition names
\item MLE_LFC: Log2-fold change of the MLE
\item P.Value, adj.P.Val: Nominal and BH-adjusted P values
\item n_eff: Number of effective samples (i.e. non-zero or non-unity PSI)
\item mDepth: Mean Depth of splice coverage in each of the two groups.
\item Dispersion_Reduced, Dispersion_Full: Dispersion values for reduced and
full models. See \link[DoubleExpSeq:DBGLM1]{DoubleExpSeq::DBGLM1} for details.
}
}
\description{
Use Limma, DESeq2, DoubleExpSeq, and edgeR wrapper functions
to test for differential Alternative Splice Events (ASEs)
}
\details{
Using \strong{limma}, SpliceWiz models included and excluded counts as log-normal
distributed, whereas
using \strong{DESeq2}, SpliceWiz models included and excluded counts as negative
binomial distributed with dispersion shrinkage according to their mean count
expressions.
For \strong{limma} and \strong{DESeq2}, differential ASE are considered as the
"interaction" between included and excluded splice counts for each sample.
See \href{https://rpubs.com/mikelove/ase}{this vignette} for an explanation of
how this is done.

SpliceWiz's \strong{limma} wrapper implements an additional filter where ASEs with
an average cpm values of either Included or Excluded counts are less than 1.
\strong{DESeq2} has its own method for handling outliers, which seems to work well
for handling situations where PSI ~= 0 or PSI ~= 1.

Time series are supported by SpliceWiz to a limited extent.
Time series analysis can be performed via limma or DESeq2.
For limma time-series analysis, use \code{ASE_limma_timeseries()}, specifying
the \code{test_factor} as the column of numeric values containing
time series data. For DESeq, time series differential analysis can be
activated using the \code{ASE_DESeq()} function, again specifying \code{test_factor}
as the column containing time series data (and leaving \code{test_nom}
and \code{test_denom} parameters blank). See examples below.

(NEW) \strong{edgeR} models counts using a negative binomial model. It accounts
appropriately for zero-counts which are often
problematic as PSI approaches zero or one, leading to false positives. The
edgeR-based option produces differential ASEs that are less biased towards
low counts. Our preliminary analysis shows it to be more accurate than limma
or DoubleExpSeq based methods.

(NEW) For time series analysis using edgeR, \code{ASE_edgeR_timeseries()} can be
used interchangeably with its counterpart limma-based function. For
complex models, please see \link{ASE-GLM-edgeR} to build your own GLM models.

Using \strong{DoubleExpSeq}, included and excluded counts are modeled using
the generalized beta prime distribution, using empirical Bayes shrinkage
to estimate dispersion.

\strong{EventType} are as follow:
\itemize{
\item \code{IR} = intron retention (IR-ratio) - all introns are considered
\item \code{MXE} = mutually exclusive exons
\item \code{SE} = skipped exons
\item \code{AFE} = alternate first exon
\item \code{ALE} = alternate last exon
\item \code{A5SS} = alternate 5'-splice site
\item \code{A3SS} = alternate 3'-splice site
\item \code{RI} = (known / annotated) intron retention (PSI).
}

NB: SpliceWiz measures intron retention events using two different
approaches, the choice of which is left to the user - see \link{ASE-methods}:
\itemize{
\item \strong{IR} (intron retention) events: considers all introns to be potentially
retained. Given in most scenarios there may be uncertainty as to which of the
many mutually-overlapping introns are spliced to produce the major isoform,
SpliceWiz adopts the IRFinder approach by using the IR-ratio. The "included"
isoform is the relative abundance of the IR-transcript, as approximated by
the trimmed-mean depth of coverage across the intron (excluding outliers
including exons of other transcripts, intronic elements such as snoRNAs,
etc). The "excluded isoform" includes \strong{all} spliced transcripts that
contain an overlapping intron, as estimated via SpliceWiz's \code{SpliceOver} and
IRFinder's \code{SpliceMax} methods - see \link{collateData}.
\item \strong{RI} (annotated retained introns) considers only annotated retained
introns, i.e., those annotated within the given reference. These are
quantified using PSI, considering the included (IR-transcript) and excluded
(splicing of the exact intron) as binary alternatives.
}

SpliceWiz considers "included" counts as those that represent abundance of
the "included" isoform, whereas "excluded" counts represent the abundance of
the "excluded" isoform.
To allow comparison between modalities, SpliceWiz applies a convention
whereby the "included" transcript is one where its splice junctions
are by definition shorter than those of "excluded" transcripts.
Specifically, this means the included / excluded isoforms are as follows:\tabular{ccc}{
   EventType \tab Included \tab Excluded \cr
   IR or RI \tab Intron Retention \tab Spliced Intron \cr
   MXE \tab Upstream exon inclusion \tab Downstream exon inclusion \cr
   SE \tab Exon inclusion \tab Exon skipping \cr
   AFE \tab Downstream exon usage \tab Upstream exon usage \cr
   ALE \tab Upstream exon usage \tab Downstream exon usage \cr
   A5SS \tab Downstream 5'-SS \tab Upstream 5'-SS \cr
   A3SS \tab Upstream 3'-SS \tab Downstream 3'-SS \cr
}
}
\section{Functions}{
\itemize{
\item \code{ASE_limma()}: Use limma to perform differential ASE analysis of
a filtered NxtSE object

\item \code{ASE_edgeR()}: Use edgeR to perform differential ASE analysis of
a filtered NxtSE object

\item \code{ASE_limma_timeseries()}: Use limma to perform differential ASE analysis of
a filtered NxtSE object (time series)

\item \code{ASE_edgeR_timeseries()}: Use edgeR to perform differential time series
of a filtered NxtSE object

\item \code{ASE_DESeq()}: Use DESeq2 to perform differential ASE analysis of
a filtered NxtSE object

\item \code{ASE_DoubleExpSeq()}: Use DoubleExpSeq to perform differential ASE analysis
of a filtered NxtSE object (uses double exponential beta-binomial model)
to estimate group dispersions, followed by LRT

}}
\examples{
# Load the NxtSE object and set up the annotations
# - see ?makeSE on example code of generating this NxtSE object
se <- SpliceWiz_example_NxtSE(novelSplicing = TRUE)

colData(se)$treatment <- rep(c("A", "B"), each = 3)
colData(se)$replicate <- rep(c("P","Q","R"), 2)

# Limma analysis (counts modeled using log-normal distribution)

require("limma")
res_limma <- ASE_limma(se, "treatment", "A", "B")

# edgeR analysis (counts modeled using negative binomial distribution)
# - QL: whether quasi-likelihood method was used

require("edgeR")
res_edgeR <- ASE_edgeR(se, "treatment", "A", "B", useQL = FALSE)
res_edgeR_QL <- ASE_edgeR(se, "treatment", "A", "B", useQL = TRUE)

# DoubleExpSeq analysis (counts modeled using beta binomial distribution)

require("DoubleExpSeq")
res_DES <- ASE_DoubleExpSeq(se, "treatment", "A", "B")

# DESeq2 analysis (counts modeled using negative binomial distribution)

require("DESeq2")
res_DESeq <- ASE_DESeq(se, "treatment", "A", "B")

# Time series examples

colData(se)$timepoint <- rep(c(1,2,3), each = 2)
colData(se)$batch <- rep(c("1", "2"), 3)

res_limma_timeseries <- ASE_limma_timeseries(se, "timepoint")
res_edgeR_timeseries <- ASE_edgeR_timeseries(se, "timepoint")
res_DESeq_timeseries <- ASE_DESeq(se, "timepoint")

}
\references{
Ritchie ME, Phipson B, Wu D, Hu Y, Law CW, Shi W, Smyth GK (2015).
'limma powers differential expression analyses for RNA-sequencing and
microarray studies.' Nucleic Acids Research, 43(7), e47.
\url{https://doi.org/10.1093/nar/gkv007}

Love MI, Huber W, Anders S (2014). 'Moderated estimation of fold change and
dispersion for RNA-seq data with DESeq2.' Genome Biology, 15, 550.
\url{https://doi.org/10.1186/s13059-014-0550-8}

Ruddy S, Johnson M, Purdom E (2016). 'Shrinkage of dispersion parameters in
the binomial family, with application to differential exon skipping.'
Ann. Appl. Stat. 10(2): 690-725.
\url{https://doi.org/10.1214/15-AOAS871}

Gilis J, Vitting-Seerup K, Van den Berge K, Clement L (2021). 'Scalable
analysis of differential transcript usage for bulk and single-cell
RNA-sequencing applications.' F1000Research 2021, 10:374.
\url{https://doi.org/10.12688/f1000research.51749.1}

Lun A, Smyth G (2017).
'No counts, no variance: allowing for loss of degrees of freedom when
assessing biological variability from RNA-seq data'
Stat Appl Genet Mol Biol, 017 Apr 25;16(2):83-93.
\url{https://doi.org/10.1515/sagmb-2017-0010}
}
