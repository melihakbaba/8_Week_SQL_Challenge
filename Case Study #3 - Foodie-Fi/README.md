
<p align="center">
<img src="https://user-images.githubusercontent.com/81607668/129742132-8e13c136-adf2-49c4-9866-dec6be0d30f0.png" width="500" height="520" alt="image">
</p>

## Contents

[Introduction](#introduction)

[Entity Relationship Diagram](#entity-relationship-diagram)
- Case Study Questions
  - [A. Customer Journey](#a-customer-journey)
  - [B. Data Analysis Questions](#b-data-analysis-questions)

[8 Week SQL Challenge](#challenge)
***
<a name="introduction"/>

## Introduction
Subscription based businesses are super popular and Danny realised that there was a large gap in the market - he wanted to create a new streaming service that only had food related content - something like Netflix but with only cooking shows!

Danny finds a few smart friends to launch his new startup Foodie-Fi in 2020 and started selling monthly and annual subscriptions, giving their customers unlimited on-demand access to exclusive food videos from around the world!

Danny created Foodie-Fi with a data driven mindset and wanted to ensure all future investment decisions and new features were decided using data. This case study focuses on using subscription style digital data to answer important business questions.

<a name="entity-relationship-diagram"/>

## Entity Relationship Diagram

![Foodie-Fi](https://user-images.githubusercontent.com/81607668/129744449-37b3229b-80b2-4cce-b8e0-707d7f48dcec.png)

<a name="a-customer-journey"/>

## A. Customer Journey

Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief description about each customer’s onboarding journey.

Try to keep it as short as possible - you may also want to run some sort of join to make your explanations a bit easier!

<a name="b-data-analysis-questions"/>

## B. Data Analysis Questions

1. How many customers has Foodie-Fi ever had?
2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
6. What is the number and percentage of customer plans after their initial free trial?
7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
8. How many customers have upgraded to an annual plan in 2020?
9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

<a name="challenge"/>

## 8 Week SQL Challenge by Danny Ma

You can find all the details about this challenge and more information about Danny Ma on the [8-Week SQL Challenge page](https://8weeksqlchallenge.com/).

