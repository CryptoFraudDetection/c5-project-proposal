/* --- SETTINGS --- */
#import "@preview/rubber-article:0.1.0": *
#import "@preview/fletcher:0.5.1" as fletcher: diagram, node, edge, shapes

// Setup document
#show: article.with(lang: "en")
#set text(font: "PT Sans")

// Define colors
#let primary-color = rgb("#FDE70E")
#let secondary-color = rgb("#F1F1EE")
#let tertiary-color = rgb("#DF305B")
#let note-color = rgb("#7f00ff")

// Setup table style
#set table(align: horizon, fill: (x, y) => if y == 0 {
  primary-color
}, stroke: 0.5pt, gutter: 0pt)

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
      node(positions.at(i), n, stroke: 1pt, name: str(i), corner-radius: 5pt, fill: secondary-color)
    }
    // Draw edges between nodes
    for (from, to) in edges {
      if from != to { 
        edge(label(str(from)), label(str(to)), "-|>", stroke: 1pt)
      } else {
        edge(label(str(from)), label(str(to)), "--|>", stroke: 1pt, bend: 140deg)
      }
    }
  })
}

/* --- Content --- */
#maketitle(
  title: "Project proposal - CryptoFraudDetection",
  authors: ("Gabriel Torres Gamez",),
  date: datetime.today().display("[day padding:none]. [month repr:long] [year]"),
)

= Project Overview
== Project Title
The project title will be *CryptoFraudDetection*.

== Team Members
The project will be done in collaboration with the "Challenge X" group. Here are the students involved, along with their affiliations:

#align(left, table(
  columns: (auto, auto, auto),
  table.header([*Affiliation*], [*Student Name*], [*GitHub Username*]),
  [cgml/5Da],[Gabriel Torres Gamez],[\@gabrieltorresgamez],
  [cx],[Aaron Brülisauer],[\@nod0n],
  [cx],[Florian Baumgartner],[\@FloBaumgartner],
  [cx],[Can-Elian Barth],[\@can020202],
))

== Project Objectives
- The primary objective is to predict if a cryptocurrency is fraudulent.
- The broader goal of the challenge is to evaluate different methods, both graph-based and traditional, and gain insights into which approach is most effective for fraud detection in this context.

== Brief Description of the Fraud Detection Problem
Our aim is to identify potentially fraudulent cryptocurrency schemes, mainly rug pulls and pump-and-dump schemes. By leveraging sentiment analysis, I hope to develop methods that can detect suspicious activity and help protect investors from falling prey to fraudulent coins.

#pagebreak()
= Data Collection and Preprocessing
== Data Source(s)
- To establish ground truth on fraudulent coins, I will use the list from: \ #link("https://www.comparitech.com/crypto/cryptocurrency-scams/")
- For sentiment analysis, I will scrape data from Reddit, and store the data in an Elasticsearch database for further analysis/retrieval.

== Graph Model Selection & Data Description
I will use a weighted, directed graph model where:
- Nodes represent users, comments, search terms (coin name), and subreddits.
- Edges represent relationships such as which user posted a comment, on which subreddit a comment was made, what search term was used during scraping of a comment and which comment is a subcomment of another one.

#let nodes = ("comment", "user", "search term", "subreddit")
#let edges = ((1,0), (0,0), (2,0), (3,0),)
#let positions = (
  (25mm, 15mm), // "Comment"
  (50mm, 00mm), // "Users"
  (25mm, 00mm), // "Search Term"
  (00mm, 00mm), // "Subreddit"
)
#draw_graph(nodes, edges, positions)

The idea would be to also extract keywords from a comment (e.g. top 10 TF-IDF words) and encode them into word vectors or add them to the graph. The coin graphs would therefore have connections through identical users/subreddits and keywords.

= Machine Learning Model
== Model Selection

=== Graph-based Model
I will implement a Graph Attention Network (GAT) based on the model proposed by Veličković et al. (2017) @velickovic_graph_2018. The node features will be derived from the relative occurrence of words per cryptocurrency. 

=== Traditional ML Model
As a comparison, I will implement a gradient boosting model. The data for this model will be encoded in a tabular format, where the features will include the same word counts and associated metadata from the scraped posts.

=== Baseline Model
I will use a Naive Bayes classifier as a baseline model. This model will detect which words are most likely to indicate a fraudulent scheme, serving as a simple but informative point of reference.

== Training Process (e.g. cluster or local)
Whenever possible, I will use local GPUs for model training. If needed, I will request additional GPU resources from i4DS or use cloud services like Lambda Labs.

== Hyperparameter Tuning Approach
Due to the complexity of the models, I will prioritize random search for hyperparameter tuning. Random search is often more efficient than grid search and can explore a broader range of hyperparameter combinations, making it preferable in this case. Bayesian optimization could also be considered for more computationally intensive models if resources allow.

== Data Split
The data will be split at the cryptocurrency level to ensure that no information leaks between the training and test sets.

#pagebreak()
= Evaluation Metrics
== Performance Metrics
This is a classification task, so I will evaluate models using the following metrics:
- *Accuracy*: This measures overall correctness but may not be the best metric due to class imbalance (few fraudulent coins vs. many non-fraudulent coins).
- *Precision*: The percentage of true positive predictions out of all positive predictions. This is crucial for minimizing false alarms.
- *Recall*: The percentage of true positive predictions out of all actual positive cases. Recall is important to ensure that I do not miss fraudulent coins.
- *F1-score*: The harmonic mean of precision and recall. This provides a balanced measure, especially useful for imbalanced datasets.

All metrics will be reported in their macro-averaged form to account for class imbalance.

== Cross-validation Strategy
The cross-validation strategy will depend on the computational cost of training and the amount of cryptocurrency data available. Ideally, I would use k-fold cross-validation (likely k=5 or 10).

== Model Comparison
I will compare the models using the above metrics, with particular attention to:
- GAT vs. Gradient Boosting Model
- All models vs. the baseline model.

= References and Resources
== Datasets
- Custom, scraped datasets.
- Worldwide crypto & NFT rug pulls and scams tracker @moody_worldwide_nodate.

== Tools and Libraries Used
- Python 3.12.x
- PyTorch 3.4
- NetworkX 3.3 (with cuGraph backend where possible)

== Academic Papers
#nocite[@li_cryptocurrency_2021]
#nocite[@nghiem_detecting_2021]
#nocite[@moody_worldwide_nodate]
#bibliography("refs.bib", style: "ieee", title: none)