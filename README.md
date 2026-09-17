# Moneyballton: Identifying Big 5 Attacking Establishment
A data-driven recruitment pipeline identifying high-upside U23 attacking prospects, modeled on Brighton & Hove Albion's acquisition philosophy.

**📊 [View the Live Tableau Interactive Dashboard Here](https://public.tableau.com/views/Moneyballton/Dashboard1)**

### Executive Summary
This project shifts away from subjective "player-replacement" models to a testable historical backtest. By evaluating over 4,000 player-season records across a 4-year validation window, the pipeline identifies young wide attackers most likely to establish themselves in Europe's Big 5 leagues (defined as accumulating 4,000+ top-flight minutes).

### Technical Architecture
* **Extraction:** Python (soccerdata/FBref) scraping historical and live 2025/26 data.
* **Storage & Transformation:** MySQL relational database managing historical cohort firewalls and live scouting data.
* **Modeling:** Heuristic, explainable weights (Context-Adjusted Production × Age Runway × Current Opportunity) avoiding black-box ML to ensure stakeholder buy-in.
* **Presentation:** Tableau interactive decision funnel and player deep-dive.

### Project Documentation
For a detailed breakdown of the engineering choices, constraints, and validation metrics, please review:
1. [The Decision Log](./docs/Decision_Log.md): Outlines architectural pivots, including handling missing upstream API data via defensive SQL/Tableau patching.
2. [Methodology & Validation](./docs/Methodology_and_Validation.md): Details the 70% out-of-sample hit rate and the logic behind the step-up tax.