<p align="center">
<img src="https://user-images.githubusercontent.com/81607668/134615258-d1108e0d-0816-4cd7-a972-d45580f82352.png" alt="Image" width="500" height="520">
</p>

## Contents

[Introduction](#introduction)

- Case Study Questions
  - [A. Enterprise Relationship Diagram](#a-er)
  - [B. Digital Analysis](#b-digital-analysis)
  - [C. Product Funnel Analysis](#c-product-funnel-analysis)
  - [D. Campaigns Analysis](#d-campaigns-analysis)

[8 Week SQL Challenge](#challenge)
***
<a name="introduction"/>

## Introduction
Clique Bait is not like your regular online seafood store - the founder and CEO Danny, was also a part of a digital data analytics team and wanted to expand his knowledge into the seafood industry!

In this case study - you are required to support Danny’s vision and analyse his dataset and come up with creative solutions to calculate funnel fallout rates for the Clique Bait online store.

<a name="a-er"/>

## A. Enterprise Relationship Diagram

Using the following DDL schema details to create an ERD for all the Clique Bait datasets.


<a name="b-digital-analysis"/>

## B. Digital Analysis

1. How many users are there?
2. How many cookies does each user have on average?
3. What is the unique number of visits by all users per month?
4. What is the number of events for each event type?
5. What is the percentage of visits which have a purchase event?
6. What is the percentage of visits which view the checkout page but do not have a purchase event?
7. What are the top 3 pages by number of views?
8. What is the number of views and cart adds for each product category?
9. What are the top 3 products by purchases?

<a name="c-product-funnel-analysis"/>

## C. Product Funnel Analysis

Using a single SQL query - create a new output table which has the following details:

-  How many times was each product viewed?
-  How many times was each product added to cart?
-  How many times was each product added to a cart but not purchased (abandoned)?
-  How many times was each product purchased?

Use your 2 new output tables - answer the following questions:

1. Which product had the most views, cart adds and purchases?
2. Which product was most likely to be abandoned?
3. Which product had the highest view to purchase percentage?
4. What is the average conversion rate from view to cart add?
5. What is the average conversion rate from cart add to purchase?

<a name="d-campaigns-analysis"/>

## D. Campaigns Analysis

Generate a table that has 1 single row for every unique visit_id record and has the following columns:

- user_id
- visit_id
- visit_start_time: the earliest event_time for each visit
- page_views: count of page views for each visit
- cart_adds: count of product cart add events for each visit
- purchase: 1/0 flag if a purchase event exists for each visit
- campaign_name: map the visit to a campaign if the visit_start_time falls between the start_date and end_date
- impression: count of ad impressions for each visit
- click: count of ad clicks for each visit
- (Optional column) cart_products: a comma separated text value with products added to the cart sorted by the order they were added to the cart (hint: use the sequence_number)

<a name="challenge"/>

## 8 Week SQL Challenge by Danny Ma

You can find all the details about this challenge and more information about Danny Ma on the [8-Week SQL Challenge page](https://8weeksqlchallenge.com/).