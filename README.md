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

Below is an example **horizontal bar chart** in a **dark theme** that visualizes the **Top 10 Paying Data Engineer Jobs** based on this query:

![Top 10 Paying Data Engineer Roles - Visualization](/assets/output_1.png)

In the chart, the Y-axis displays the **job title and company**, while the X-axis shows the **average yearly salary (USD)**. The highest-paying roles appear at the top, reflecting the descending salary order from the SQL query.
---

### 2. **What skills are required for these top-paying jobs?**

**Goal**: Take the **top 10 highest-paying** Data Engineer jobs from the first query and **join** with the skills table to see which specific skills they require.

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

**Highlights**:
- **CTE** (`top_paying_jobs`) isolates the top 10 roles.
- **INNER JOIN** with `skills_job_dim` and `skills_dim` to pull in **specific skill requirements**.
- Ordered by `salary_year_avg` to maintain the high-salary focus.

---

### 3. **What skills are most in demand for data engineers?**

**Goal**: Determine the **top 5** most frequently requested skills for all Data Engineer roles.

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

**Highlights**:
- Groups by **skills** and counts how often each appears.
- Focuses on **Data Engineer** roles across all locations.
- Limits to the **top 5** most in-demand skills.

---

### 4. **Which skills correlate with higher salaries?**

**Goal**: Calculate the **average salary** associated with each skill for Data Engineer positions (with non-null salaries) to identify the **most lucrative** skill sets.

```sql
SELECT
    skills,
    ROUND(AVG(salary_year_avg),2) AS average_salary
FROM job_postings_fact
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

**Highlights**:
- Uses `AVG(salary_year_avg)` to measure the **salary impact** of each skill.
- Focuses specifically on **Data Engineer** roles with a valid salary.
- Sorted by **descending** average salary, capping at the **top 25**.

---

### 5. **What are the most optimal skills to learn?**

**Goal**: Identify skills that are both **high in demand** and **offer high salaries**, specifically for **remote** Data Engineer roles with non-null salaries.

```sql
WITH skills_demand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS skill_ocurrences
    FROM job_postings_fact
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
    FROM job_postings_fact
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
FROM skills_demand
INNER JOIN avg_salary 
    ON skills_demand.skill_id = avg_salary.skill_id
WHERE skill_ocurrences > 10
ORDER BY 
    average_salary DESC,
    skill_ocurrences DESC
LIMIT 25;
```

**Highlights**:
- Two **CTEs**:
  - **`skills_demand`** to count how many job postings list each skill.
  - **`avg_salary`** to compute the average salary per skill.
- Merged on `skill_id`, then filtered to **remote** (`job_work_from_home = True`) roles with **non-null** salaries.
- Orders by **highest salary** first, then by **skill frequency**, returning the top 25.