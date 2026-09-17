# Methodology & Empirical Validation

## 1. Canonical Definitions & Modeling Progression

### Ground Truth Outcome Definition
A successful prediction is defined as a player who accumulates at least **4,000 minutes in Europe's Big 5 leagues** during the 4-year post-discovery evaluation window. This metric captures cumulative top-level involvement while reducing sensitivity to single-season rotation and temporary club selection circumstances.

### Staged Modeling Progression
* **Stage 0 (Naive Baseline):** U23 + $\ge 1,200$ minutes + raw NPG+A/90.
* **Stage 1 (Contextual Baseline):** Naive Baseline adjusted by league-strength UEFA coefficients.
* **Stage 2 (Tactical Population Filter):** Restriction of the pool strictly to hybrid attackers (`MF,FW` and `FW,MF`).
* **Stage 3 (Composite Score):** Context-Adjusted NPG+A/90 × Age Multiplier × Current Opportunity Multiplier.

### Stage 3 Heuristic Weights
* **Analyst-Defined Weights:** These weights are deliberately heuristic rather than statistically learned, prioritizing interpretability and domain logic given the project's sample size.
* **Age Runway Multiplier:** Rewards developmental upside (1.15x for $\le 19$, 1.10x for 20, 1.05x for 21).
* **Current Opportunity / Reliability Multiplier:** Uses senior minutes logged as a proxy for manager trust, squad competition, and physical durability (1.10x for $\ge 2,500$ mins, 1.05x for $\ge 2,000$ mins).

---

## 2. The Validation Matrix

| Modeling Stage | Cohort A (19/20) Hit Rate | Cohort B (20/21) Hit Rate | Key Diagnostic Finding |
| :--- | :---: | :---: | :--- |
| **Stage 1 (Naive Baseline)** | 65% | — | Production alone is heavily skewed by the "Step-Up Tax". |
| **Stage 2 (Tactical Filter + Context)** | 70% | 65% | Context and tactical filtering stabilized predictions, but out-of-sample testing showed vulnerability to elite club rotation. |
| **Stage 3 (Composite Score)** | 55%* | **70%** | Cohort B provided out-of-sample evidence that combining production, age, and opportunity improves ranking stability. |

*\*Note: Cohort A Stage 3 was impacted by incomplete Bundesliga outcome strings in upstream historical extraction (e.g., Nkunku, Sancho); it is retained for transparency but excluded from primary cross-cohort comparison.*

---

## 3. Engineering & Modeling Rationale

### Problem Reframing
Rather than building an unprovable "player clone" replacement model, the objective was reframed into an empirically testable hypothesis: identifying young wide attackers in secondary leagues whose statistical profile indicates sustained Big 5 establishment.

### Data Leakage Firewall
To simulate realistic scouting conditions without lookahead bias, historical cohorts were strictly firewalled in SQL. Discovery-season stats were frozen prior to running four-year outcome evaluations against future league minutes.

### Metric Constraints & The Step-Up Tax
Due to extraction constraints on granular event-level carrying and take-on data across second-tier European competitions, non-penalty expected goals and assists (NPG+A/90) were leveraged as stable proxies. A league coefficient discount was implemented as project shorthand ("step-up tax") to account for the performance drop observed when prospects transition out of development leagues.

### Out-of-Sample Diagnostics
Initial backtesting revealed that raw production metrics frequently over-rewarded players in dominant sides who struggled when stepping into high-variance Big 5 environments. Incorporating an explicit age runway and an opportunity/durability multiplier brought out-of-sample identification accuracy to 70% in Cohort B (surfacing targets like Pedro Neto and Amine Gouiri).

### Strategy Translation (The 2025/26 Run)
Raw statistical rankings are not actionable scouting advice without stratification. Scoring the live 2025/26 dataset served two strategic functions:
1. **Face-Validity:** World-class talents (Lamine Yamal, Endrick) ranked at the top, confirming the mathematical scaling behaves sensibly on elite output.
2. **Actionable Shortlisting:** Filtering by secondary leagues surfaced high-asymmetric bets (e.g., Mika Godts at Ajax, Said El Mala at FC Köln) while independently flagging João Pedro (#5), mirroring Brighton's actual recruitment profile out-of-sample.