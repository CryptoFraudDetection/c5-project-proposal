/* --- SETTINGS --- */
#import "@preview/rubber-article:0.1.0": *
#import "@preview/fletcher:0.5.1" as fletcher: diagram, node, edge, shapes

// Setup document
#show: article.with(lang:"en")
#set text(font: "PT Sans")

// Define colors
#let primary-color = rgb("#FDE70E")
#let secondary-color = rgb("#F1F1EE")
#let tertiary-color = rgb("#DF305B")
#let note-color = rgb("#7f00ff")

// Setup table style
#set table(
  align: horizon,
  fill: (x, y) =>
    if y == 0 { primary-color },
  stroke: 0.5pt,
  gutter: 0pt,  
)

// Add color to links
#show link: this => text(this, fill: tertiary-color)

// Function to add a ghost citation
#let nocite(citation) = {
  place(hide[#citation])
}

// Function to highlight notes
#let note(this) = {
  text(note-color)[\[#this\]]
}

// Function to draw graphs
#let draw_graph(nodes, edges, positions) = {
  diagram({
    // Loop through each node and place it at the specified position
    for (i, n) in nodes.enumerate() {
      node(positions.at(i), n, stroke: 1pt, name: str(i), corner-radius: 10pt, fill: secondary-color)
    }
    // Draw edges between nodes
    for (from, to) in edges {
      edge(label(str(from)), label(str(to)), "-|>", stroke: 0.8pt)
    }
  })
}

/* --- Content --- */
#maketitle(
  title: "Project proposal - CryptoFraudDetection",
  authors: (
    "Gabriel Torres Gamez",
  ),
  date: datetime.today().display("[day padding:none]. [month repr:long] [year]"),
)
= Project Overview
== Project Title
The project title will be *CryptoFraudDetection*.

== Team Members
The project will be done in collaboration with the "Challenge X" group. Here are the students involved, along with their affiliations:

#align(left,
  table(
    columns: (auto, auto, auto),
    table.header(
      [*Affiliation*], [*Studentname*], [*GitHub Handle*]
    ),
    [cgml/5Da], [Gabriel Torres Gamez], [\@gabrieltorresgamez],
    [cx], [Aaron Brülisauer], [\@nod0n],
    [cx], [Florian Baumgartner], [\@FloBaumgartner],
    [cx], [Can-Elian Barth], [\@can020202],
  )
)

== Project Objectives
- The objective of each method is to predict if a coin is fraudulent.
- The objective of the whole challenge evaluate different methods (graph-based and not graph-based) and get insights into what works the best for our use-case.

== Brief Description of the Fraud Detection Problem
We aim to identify potential fraudulent cryptocurrency schemes such as ICO exit scams, exchange scams, rug pulls, pump-and-dump schemes and pre-mined coins. Using historical data and sentiment analysis, we aim to develop methods to detect suspicious activity and protect investors from fraudulent coins.

#pagebreak()
= Data Collection and Preprocessing
== Data Source(s)
- For having a ground truth on which coins are fraudulent we aim to use the list from: \ #link("https://www.comparitech.com/crypto/cryptocurrency-scams/")
- We will try to get historical coin data from either #link("www.tradingview.com/") or #link("coinmarketcap.com/"), depending on how easy it is to get or scrape the data. #note[Maybe drop this point?]
- For sentiment analysis, we will scrape websites like Google, X, Reddit and Telegram and save the scraped data in a ElasticSearch (or comparable) database.

== Graph Model Selection & Data Description
I will use a weighted, directed graph where:
- Nodes represent users, websites, coins, posts, words.
- Edges between users and posts represent who posted.
- Edges between websites and posts represent on which platform was posted.
- Edges between coins and and posts represent on which post a coin was mentioned.
- Edges between posts and words represent which words were used in a post.

#let nodes = ("Users", "Websites", "Coins", "Posts", "Words")
#let edges = (
	(0, 3),
	(1, 3),
	(3, 2),
	(3, 4),
)
#let positions = (
	(0mm, 0mm),   // "Users"
	(0mm, -10mm),  // "Websites"
	(50mm, -10mm), // "Coins"
	(25mm, -5mm), // "Posts"
	(50mm, 0mm),  // "Words"
)
#draw_graph(nodes, edges, positions)

= Machine Learning Model
== Model Selection

=== Graph-based
#note[No idea atm.]

=== Traditional ML/DL
#note[No idea atm.]

=== Baseline Model
I will use a naive bayes baseline model which simply detects, which words could indicate a scam.

== Training Process (e.g. cluster or local)
As long as possible i will try to use my local GPU. If necessary, i could ask i4DS for some GPU time or use a cloud provider like Lambda Labs.

== Hyperparameter Tuning Approach
Depends on how intense a model is. Prefferably I would use Bayesian Hyperparameter Optimization or Random Search.

== Data split
#note[No idea atm.]

#pagebreak()
= Evaluation Metrics
== Performance Metrics
- Accuracy: Measures the overall correctness of the model, but might not be reliable due to the class imbalance (few fraudulent coins vs. many non-fraudulent coins).
- Precision: The percentage of true positive predictions out of all positive predictions made by the model. Important in minimizing false alarms.
- Recall: The percentage of true positive predictions out of all actual positive cases. This metric is crucial for ensuring that we don't miss out on detecting fraud.
- F1-score: The harmonic mean of precision and recall, which provides a balanced measure, especially useful when dealing with imbalanced datasets.


== Cross-validation Strategy
Depends on the intensity of model training.
Best case would be applying k-fold cross-validation (likely k=5 or 10).

== Model Comparison
I will compare the models using the above metrics, with special note to:
- Graph-based models vs. Traditional ML or DL models
- All models vs. Baseline

= References and Resources
== Datasets
- Custom, scraped datasets
- Worldwide crypto & NFT rug pulls and scams tracker @moody_worldwide_nodate

== Tools and Libraries Used
- Python 3.12.x
- PyTorch 3.4
- NetworkX 3.3 (using cuGraph Backend when possible)

== Academic Papers
#nocite[@li_cryptocurrency_2021]
#nocite[@nghiem_detecting_2021]
#nocite[@moody_worldwide_nodate]
#bibliography("refs.bib", style: "ieee", title: none)

