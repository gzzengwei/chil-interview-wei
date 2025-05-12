# Objective
This exercise is designed to assess your skills in working with Rails models, associations, and testing with RSpec. In this challenge, you’ll build a simple referral system and demonstrate your ability to write clean, testable code.

## Task:
Build a referral system where users can refer new users and earn rewards when their referrals sign up.
1. **User Model:**
    * Users should have attributes like name, email, referral_code, and referred_by_id (a self-referential association to the user who referred them).
2. **Referral Tracking:**
    * Each user has a unique referral_code.
    * When a new user signs up, they can input a referral code, linking them to the referrer.
    * Store referral relationships in a way that makes it easy to track how many people a user has referred.
3. **Rewards System:**
    * Each referral grants the referrer a reward. You can keep this simple: each referral could add points to the referrer’s balance or just increment a reward_count.
    * Implement a simple reward logic, such as awarding points for each signup or granting a special status after a certain number of referrals.
4. **Tests:**
    * Write model tests for user creation, referral tracking, and reward logic.
    * Implement controller tests for user creation and referral tracking, focusing on validation and success scenarios.
5. **Basic Interface (optional)**
    * Create simple views to show a user’s referrals and reward balance.
    * **Rendering the view in ERB is sufficient; using React is unnecessary.**
  
**Note:** You do not need to implement any authentication for this exercise. Focus solely on the referral functionality.

## Prerequisites

Ruby 3.2+

Rails 8.0.2

Node 20+

## Unzipping into WSL (if you use Windows)
```
Expand-Archive -Path "C:\Users\konam\Downloads\chil-interview-new.zip" -DestinationPath "\\wsl$\Ubuntu-22.04\home\rchou\workspace\"
```

## Setup
```
bundle install
yarn install
rails s
```

## Watch mode

```
yarn build --watch
```

## Tests

```
rspec
```

## Rubocop

```
rubocop --autocorrect-all
```
