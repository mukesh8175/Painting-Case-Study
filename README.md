# Painting Collection Analysis Case Study

## Objective
The primary goal of this project is to analyze a painting collection using SQL Server, organizing and extracting meaningful insights from data spread across seven key tables:
- **Artist**
- **Canvas Size**
- **Image Link**
- **Museum**
- **Museum Hours**
- **Product Size**
- **Subject**
- **Work**

This analysis focuses on understanding artist productivity, optimizing museum hours, analyzing subject distribution, tracking trends in canvas sizes, and comparing product versus canvas sizes.

## Key Analyses
The project aims to answer the following questions:

- **Prolific Artists**: Identify the most prolific artists in the collection.
- **Museum Hours Optimization**: Optimize museum hours based on visitor traffic and the number of exhibitions held.
- **Subject Distribution**: Analyze the distribution of subjects (e.g., landscapes, portraits) across the collection.
- **Canvas Size Trends**: Track trends in canvas sizes over time and their relationship with different art styles.
- **Product vs. Canvas Size Comparison**: Compare and analyze the differences between product sizes (prints, posters, etc.) and the original canvas sizes.

## Technologies Used
- **SQL Server**: To manage and query the painting collection data.
- **Power BI**: For visualizing insights and creating interactive reports.
- **Python (Optional)**: For advanced data processing and visualization.

## Features
- Database schema design to organize data efficiently across seven tables.
- SQL queries for key analyses like identifying prolific artists and analyzing subject distributions.
- Trend analysis on canvas sizes and optimization of museum operations based on visitor data.
- Power BI dashboards to visualize insights for museum management, exhibition planning, and art curation.

## Dataset Structure
The analysis uses a dataset that spans seven tables, each capturing different aspects of the painting collection and museum operations:

1. **Artist**: Contains details about artists and their body of work.
2. **Canvas Size**: Stores information about the dimensions of each canvas used for paintings.
3. **Image Link**: Links to digital images of the works in the collection.
4. **Museum**: Contains information about different museums holding the paintings.
5. **Museum Hours**: Tracks opening hours and visitor patterns for each museum.
6. **Product Size**: Contains details about products derived from the paintings (e.g., posters, prints).
7. **Subject**: Describes the subject of each painting (e.g., landscape, portrait, abstract).
8. **Work**: Represents each painting or artwork, linking to the other tables for details.

## Conclusion
This project provides detailed insights into a painting collection and its associated data, helping museum managers, curators, and exhibition planners make data-driven decisions. By leveraging SQL Server for data organization and Power BI for visualization, the project reveals trends in artist productivity, subject matter, and canvas size preferences while optimizing museum operations.
