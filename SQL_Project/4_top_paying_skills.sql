/*
Answer: What are the top skills based on salary?
- Look at the average salary associated with each skill for Data Analyst positions
- Focuses on roles with specified salaries, regardless of location
- Why? It reveals how different skills impact salary levels for Data Analysts and helps identify the most financially rewarding skills to acquire or improve
*/

SELECT
    skills,
    ROUND(AVG(salary_year_avg),2) AS average_salary
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Engineer' AND
    salary_year_avg IS NOT NULL
GROUP BY skills
ORDER BY average_salary DESC
LIMIT 25;

/* INSIGHTS:
- **Cross-Disciplinary Stack:** High-paying data engineering roles increasingly require full-stack or multi-language expertise (e.g., Node, Mongo, Solidity), suggesting a shift toward broader backend and blockchain integration skills.  
- **Specialized/Modern Languages in Demand:** Less conventional languages (Rust, Clojure, Perl) appear alongside staples like Scala and Kafka, indicating premium pay for niche or emerging technologies.  
- **Cloud & DevOps Emphasis:** Tools like Kubernetes, IBM Cloud, and AWS CodeCommit feature prominently, highlighting a strong demand for infrastructure-as-code and cloud deployment proficiency.

[
  {
    "skills": "node",
    "average_salary": "181861.78"
  },
  {
    "skills": "mongo",
    "average_salary": "179402.54"
  },
  {
    "skills": "ggplot2",
    "average_salary": "176250.00"
  },
  {
    "skills": "solidity",
    "average_salary": "166250.00"
  },
  {
    "skills": "vue",
    "average_salary": "159375.00"
  },
  {
    "skills": "codecommit",
    "average_salary": "155000.00"
  },
  {
    "skills": "ubuntu",
    "average_salary": "154455.00"
  },
  {
    "skills": "clojure",
    "average_salary": "153662.60"
  },
  {
    "skills": "cassandra",
    "average_salary": "150255.30"
  },
  {
    "skills": "rust",
    "average_salary": "147770.73"
  },
  {
    "skills": "drupal",
    "average_salary": "147500.00"
  },
  {
    "skills": "perl",
    "average_salary": "145539.92"
  },
  {
    "skills": "next.js",
    "average_salary": "145000.00"
  },
  {
    "skills": "angular",
    "average_salary": "143318.96"
  },
  {
    "skills": "scala",
    "average_salary": "143161.07"
  },
  {
    "skills": "kafka",
    "average_salary": "143085.77"
  },
  {
    "skills": "gdpr",
    "average_salary": "142368.74"
  },
  {
    "skills": "shell",
    "average_salary": "141724.61"
  },
  {
    "skills": "macos",
    "average_salary": "141616.67"
  },
  {
    "skills": "numpy",
    "average_salary": "141605.32"
  },
  {
    "skills": "opencv",
    "average_salary": "141250.00"
  },
  {
    "skills": "atlassian",
    "average_salary": "140643.52"
  },
  {
    "skills": "ibm cloud",
    "average_salary": "140546.60"
  },
  {
    "skills": "splunk",
    "average_salary": "140156.30"
  },
  {
    "skills": "kubernetes",
    "average_salary": "140091.81"
  }
]

*/
