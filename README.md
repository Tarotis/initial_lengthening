# Word-initial consonant lengthening is a robust phenomenon across typologically diverse languages

## Preparing DoReCo for the analysis

This workflow leads you through the process of reproducing our analysis. We recommend to run this in a fresh virtual environment. To initialize this, please first clone this repository to your workspace and `cd` into the directory.

```CLI
git clone https://github.com/Tarotis/initial_lengthening
cd initial_lengthening
```

The first step consists in cloning the repositories of the DoReCo data, as well as CLTS. You can clone them with the following commands:

TODO: Clone specific version/commit of the respective repository to highlight with which version of the sources this analysis was tested/done? I.e. a specific commit hash or tag of the repositories. (for CLTS: see comment below)

```CLI
git clone https://github.com/cldf-datasets/doreco
git clone https://github.com/cldf-clts/clts
```

The next step is to download the DoReCo and convert it to CLDF. To do this, first `cd` into the DoReCo repository and install all the necessary packages.

```CLI
cd doreco/
pip install -e .
```

You can now run the download and the conversion to CLDF. While downloading, insert "Y" when asked for ND-data. You do not need to download the audio files, and leaving them out will speed up the downloading. When prompted for the path to CLTS, type `../clts/` to link to the cloned CLTS-repository.

TODO: `download` was very slow for me during testing (with ND data, without audio data). As I was mentioning in private communication, using VPN connection helped and solved that issue. I still can't download the files 'normally' without VPN. This is most likely not worth mentioning in this README, but it might be good to keep in mind in case someone else experiences these issues.

TODO: Since CLTS is not part of the catalog arguments (unlike pylexibank etc.) and specified afterwards, would it be necessary to checkout a specific version tag of CLTS beforehand?

```
cldfbench download cldfbench_doreco.py
cldfbench makecldf cldfbench_doreco.py --glottolog-version v4.8
```

The last step created a SQLite database out of the CLDF data, to quickly access all the data. Once you have the SQLite database ready, you need to install the pre-written views. Run SQL:

TODO: Mention (additional) system dependencies at the beginning? E.g. `sqlite3` etc.

```
cldf createdb cldf/Generic-metadata.json doreco.sqlite
sqlite3 -echo doreco.sqlite < etc/views.sql
cd ../
```

TODO: With the added `cd ../` the following code block is potentially confusing, i.e. explicitly mention to `cd initial_lengthening/`?

You can now run the query we provide to extract all the data needed for the analysis.

TODO: Maybe point out that `stdev` is only available when running the query through `doreco.query`, so running the query without `doreco.query` might lead to wrong/unexpected results, i.e. when people try running the query using a different interface, through sqlite3, etc.

```
cldfbench doreco.query --format tsv init_query.sql > scripts/data.tsv
```

## Running the analysis

Please `cd` into the `scripts`-directory:

```CLI
cd scripts/
```

Now you are in a folder full of R-Scripts. The first script `00_setup.R` includes a `groundhog`-call, which installs packages with the correct versions. Running this script will create a folder `R_groundhog` in the current working directory which includes those packages. It also includes calls to the other scripts. You can run all of them via the following command:

TODO: Use bash or nothing as syntax highlighting for this block, but not R.

```R
Rscript 00_setup.R
```

Please not that the two scripts which run the brms-model are currently commented out. This has a simple reason: Running them takes several days. If you want to re-run the model, please go to the respective script and run it from there, or un-comment the line in `00_setup.R`. We provide the fitted model within our OSF-repository, so that you do not need to re-run the model.
