## Introduction
📊 Dive into the data job market! Focusing on **data engineering roles**, this project explores 💰 **top-paying jobs**, 🔥 **in-demand skills**, and 📈 **where high demand meets high salary** in data engineering.  
<br>
🔍 **SQL queries?** Check them out here: [SQL_project folder](/SQL_Project/)
 
---

## Background
Driven by a quest to navigate the data engineer job market more effectively, this project was born from a desire to **pinpoint top-paid** and **in-demand skills**, streamlining the search for optimal opportunities.

**Data hails from my SQL Course**, packed with insights on job titles, salaries, locations, and essential skills. Through a series of SQL queries, I set out to answer:

1. **What are the top-paying data engineer jobs?**  
2. **Which skills are required for these top-paying jobs?**  
3. **What skills are most in demand for data engineers?**  
4. **Which skills correlate with higher salaries?**  
5. **What are the most optimal skills to learn?**

---

## Tools I Used
For my deep dive into the data engineer job market, I harnessed the power of several key tools:

- **SQL**: The backbone of my analysis, enabling me to query the database and extract crucial insights.  
- **PostgreSQL**: Chosen as the database management system, perfect for handling structured job posting data.  
- **Visual Studio Code**: My go-to environment for writing and running SQL queries.  
- **Git & GitHub**: Critical for version control and collaboration, allowing me to track changes and share my work seamlessly.

## The Analysis

Below are the **key questions** guiding the analysis, each paired with its corresponding **SQL query** and a brief explanation of what it does.

---

### 1. **What are the top-paying data engineer jobs?**

**Goal**: Identify the top 10 highest-paying Data Engineer roles that are available remotely (i.e., “Anywhere”), excluding null salary entries.

```sql
SELECT  
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM job_postings_fact
LEFT JOIN company_dim 
    ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title_short = 'Data Engineer'
    AND job_location = 'Anywhere'
    AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;
```

**Highlights**  
- Filters for **Data Engineer** roles.  
- Ensures only **non-null salaries** and **remote** positions.  
- Orders by **descending salary** to get the **top 10**.

---

**Findings**  
From the query results, we see a range of **top-paying remote Data Engineer positions**. Salaries reach as high as **\$325,000**, often for **Principal** or **Staff** Data Engineer titles. The list includes companies like **Engtal**, **Durlston Partners**, **Signify Technology**, and even a **Data Engineering Manager** role at **Meta**.  

These roles typically offer:
- **Senior/Principal** or **Manager** titles, suggesting a **high level of expertise** is required.  
- **Full-time** schedules, aligning with standard industry practices for advanced engineering positions.  

![Top 10 Paying Data Engineer Roles - Visualization](/assets/output_1.png)

---

### 2. **What skills are required for these top-paying data engineer jobs?**

**Goal**  
Take the **top 10 highest-paying Data Engineer jobs** from the first query and **join** with the skills table to see which specific skills they require.

```sql
WITH top_paying_jobs AS (
    SELECT  
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM job_postings_fact
    LEFT JOIN company_dim 
        ON job_postings_fact.company_id = company_dim.company_id
    WHERE 
        job_title_short = 'Data Engineer'
        AND job_location = 'Anywhere'
        AND salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 10
)
SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim 
    ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC;
```

**Highlights**  
- **CTE** (`top_paying_jobs`) isolates the **10 highest-paying Data Engineer roles** from Query 1.  
- **INNER JOIN** with `skills_job_dim` and `skills_dim` to retrieve **specific skills** associated with each job.  
- Orders by `salary_year_avg` in descending order, keeping the focus on **top-paying** roles.

---

**Findings**  
From the results, the **top-paying Data Engineer roles** consistently feature skills such as **Python**, **Spark**, **Hadoop**, and **Kafka**. We also see frameworks like **Kubernetes** and libraries like **Pandas** and **NumPy**. This suggests a strong emphasis on:

- **Big Data Technologies**: Tools like **Spark** and **Hadoop** are widely used in large-scale data processing.  
- **Programming/Analysis Stacks**: **Python**, **Pandas**, **NumPy**, and occasionally **Scala** for high-performance data pipelines.  
- **Infrastructure & Orchestration**: **Kubernetes** for containerization and job scheduling, indicating DevOps skills are a plus.

![Skills Required for Top-Paying Data Engineer Jobs](/assets/output_2.png)

---

### 3. **What are the most in-demand skills for data engineers?**

**Goal**  
Determine the **top 5** most frequently requested skills for all Data Engineer roles, regardless of location.

```sql
SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS skill_ocurrences
FROM job_postings_fact
INNER JOIN skills_job_dim 
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Engineer'
GROUP BY skills
ORDER BY skill_ocurrences DESC
LIMIT 5;
```

**Highlights**  
- Groups by **skills** and counts how often each appears.  
- Focuses on **all Data Engineer** postings.  
- Limited to the **top 5** most in-demand skills.

---

**Findings**  
The query results reveal the **five most frequently mentioned skills** in Data Engineer job postings. Below is an example table showcasing these top skills and their corresponding demand count:

| **Skill** | **Skill Demand** |
|:----------:|:--------------------:|
| sql        | 113375              |
| python     | 108265              |
| aws        | 62174               |
| azure      | 60823               |
| spark      | 53789               |

> **Table**: Demand for the top 5 skills in Data Engineer job postings.

From this table, we can see that **SQL** and **Python** dominate the landscape, closely followed by **cloud technologies** such as **AWS** and **Azure**, and **big data processing** with **Spark**. This underscores the need for a solid foundation in **database querying**, **programming**, and **cloud/big data** platforms for aspiring or advancing Data Engineers.

---

### 4. **Which skills correlate with higher salaries?**

**Goal**  
Calculate the **average salary** associated with each skill for Data Engineer positions (with non-null salaries) to identify the **most lucrative** skill sets.

```sql
SELECT
    skills,
    ROUND(AVG(salary_year_avg),2) AS average_salary
FROM 
    job_postings_fact
INNER JOIN skills_job_dim 
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Engineer'
    AND salary_year_avg IS NOT NULL
GROUP BY skills
ORDER BY average_salary DESC
LIMIT 25;
```

**Highlights**  
- Uses `AVG(salary_year_avg)` to measure the **salary impact** of each skill.  
- Focuses on **Data Engineer** roles with **non-null** salaries.  
- Sorted by **descending** average salary, returning the **top 25**.

---

**Findings**  
The results show that specialized or emerging technologies often command **premium salaries** in Data Engineer roles. Below is an example table showcasing some of the **top-paying skills** from the query:

| **Skill**  | **Average Salary ($)** |
|:-----------:|:------------------:|
| node        | 181,861.78        |
| mongo       | 179,402.54        |
| ggplot2     | 176,250.00        |
| solidity    | 166,250.00        |
| vue         | 159,375.00        |
| codecommit  | 155,000.00        |
| ubuntu      | 154,455.00        |
| clojure     | 153,662.60        |
| cassandra   | 150,255.30        |
| rust        | 147,770.73        |

> **Table**: Sample of the average salary for the top-paying skills in Data Engineer roles.

#### Key Takeaways
- **Full-Stack & Multi-Language**: Technologies like **Node** and **Mongo** suggest a **full-stack** emphasis in certain high-paying data roles.  
- **Niche / Emerging Tech**: Skills like **Rust**, **Solidity**, and **Clojure** appear less frequently in general postings but **command higher pay** when sought.  
- **Infrastructure & Cloud**: Tools such as **Kubernetes**, **CodeCommit**, and **Ubuntu** underscore the demand for **DevOps** and **cloud-native** expertise.  

These findings highlight that **staying ahead of emerging trends** and **broadening one’s skill set** can significantly boost earning potential in Data Engineering.

---

### 5. **What are the most optimal skills to learn?**

**Goal**  
Identify skills that are both **high in demand** and **offer high salaries** for **remote** Data Engineer roles with specified (non-null) salaries.

```sql
WITH skills_demand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS skill_ocurrences
    FROM 
        job_postings_fact
    INNER JOIN skills_job_dim 
        ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim 
        ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_title_short = 'Data Engineer'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = True
    GROUP BY skills_dim.skill_id
),
avg_salary AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        ROUND(AVG(salary_year_avg),2) AS average_salary
    FROM 
        job_postings_fact
    INNER JOIN skills_job_dim 
        ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim 
        ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_title_short = 'Data Engineer'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = True
    GROUP BY skills_dim.skill_id
)
SELECT
    skills_demand.skill_id,    
    skills_demand.skills,
    skill_ocurrences,
    average_salary
FROM
    skills_demand
INNER JOIN avg_salary 
    ON skills_demand.skill_id = avg_salary.skill_id
WHERE skill_ocurrences > 10
ORDER BY 
    average_salary DESC,
    skill_ocurrences DESC
LIMIT 25;
```

**Highlights**  
- **CTEs** (`skills_demand` & `avg_salary`) calculate **demand** and **average salary** for each skill.  
- **Filtered** to **remote** Data Engineer positions with **non-null salaries**.  
- Returns skills with **more than 10 occurrences**; then orders by **highest average salary** and **demand**.

---

**Findings**  
Below is an example table illustrating some **high-demand, high-paying skills** identified by the query:

| **Skill**   | **Demand Count** | **Average Salary** |
|:-----------:|:----------------:|:------------------:|
| kubernetes  | 56               | 158,189.73        |
| numpy       | 19               | 157,592.32        |
| cassandra   | 14               | 150,549.04        |
| kafka       | 13               | 150,504.08        |
| golang      | 12               | 147,584.27        |

> **Table**: Sample of the most optimal skills (high demand + high salary) for Data Engineer roles (remote).

#### Key Takeaways
1. **Cloud & DevOps Tools**: Skills like **Kubernetes**, **Kafka**, and **Cassandra** often appear at the top, indicating strong demand for **distributed systems** and **container orchestration**.  
2. **Data Processing Libraries**: **NumPy** remains highly valued, underscoring the importance of **data manipulation** and **scientific computing**.  
3. **Programming Languages**: **Golang** stands out among the top-paying remote roles, reflecting a growing interest in **high-performance** back-end and infrastructure development.  

Professionals focusing on **both** **in-demand** and **lucrative** skills can enhance their **remote job prospects** and **earning potential** in Data Engineering.


## Conclusions

Through these queries and visualizations, several clear patterns emerge in the **Data Engineer** job market:

- **High Salaries at Senior Levels**: Roles such as Principal and Staff Data Engineer or Data Engineering Manager frequently offer the highest pay, indicating that **experience and expertise** play a major role in compensation.
- **Core Technical Stack**: Skills like **Python**, **SQL**, **Spark**, and **Hadoop** dominate, demonstrating the **industry-standard** toolkit for data processing, analytics, and large-scale pipelines.
- **Cloud & DevOps Integration**: Proficiency in tools such as **Kubernetes**, **Kafka**, and **AWS/Azure** signals an emphasis on **scalable, cloud-native** solutions, suggesting that Data Engineers increasingly operate in DevOps-style environments.
- **Emerging Tech = Higher Pay**: Niche or newer technologies (e.g., **Rust**, **Solidity**, **Golang**) often correlate with premium salaries, reflecting the value placed on **specialized skill sets**.

Ultimately, **remote** and **high-paying** Data Engineer positions reward professionals who can blend **big data** expertise, **cloud-native tooling**, and **programming** prowess. By focusing on the **in-demand** and **highly-compensated** skills, aspiring or current Data Engineers can better align their learning paths and career strategies to succeed in this competitive, evolving field.