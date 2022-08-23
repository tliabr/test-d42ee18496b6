# Patchwork backend take home test

Welcome to the Patchwork backend take home test. Thanks for taking the time to do our take home test.

The test is not designed to take a long time. Please do not spend more than 3 hours maximum.

We are not looking for every goal to be met, we are more interested in how you approach the task, and how you work on an everyday engineering problem.

If there is anything you would have liked to have done but didn't have the time for, please write it up in the pull request so that we can discuss it later.

This README has been prepared to provide you with everything we believe you need to get started, but please don't hesitate to get in touch if you have any questions.

## Intro

This repo is a simple representation of our internal Ruby on Rails backend. It stores simple representations of Shifts for Workers.

A Shift represents a period of time that a given Worker is working. It stores when the Shift starts, when it ends, the type of Shift, and the assigned Worker.

The Worker is a simple record that simply stores their first and last name.

Workers in the UK are protected by regulations that put limits on how many hours they can work each week. Health workers have additional safeguards to accommodate the different kinds of shifts they may work.

## Goals

We have started building a way to check that a worker's shifts are compliant with regulation. You can find the code compliance checking in `./app/services/compliance`. Tests can be found in `./spec`.

We have implemented a single rule so far: "Maximum shift length of 13 hours". No worker can be booked to work a shift of over 13 hours in duration.

The main goal is to extend this implementation and support new compliance rules.

**For Junior applicants, please only focus on Goal #1.**

1. Update the existing "Maximum shift length of 13 hours" rule to account for "Multiple shifts on the same day"
   - The current implementation does not account for multiple shifts on the same day
   - The definition for multiple shifts on the same day can be found in the [Key concepts](#key-concepts) section
2. Support a "Minimum 11 hours rest between shifts" rule
   - Rule key: `min_break`
   - Description: At the conclusion of a worker’s shift, there must be a minimum of 11 hours rest before the start of the worker’s next shift
3. Support a "Maximum 7 consecutive shifts" rule
   - Rule key: `max_cons_any`
   - Description: No more than 7 shifts of any length should be worked on consecutive days, where such a pattern would not breach any of the other limits on working hours or rest.
   - The definition for consecutive shifts can be found in the [Key concepts](#key-concepts) section

### Key concepts

#### Multiple shifts on the same day

Multiple Shifts starting on the same day for a Worker are interpreted as 1 Shift when it comes to calculating the hours worked. The hours worked is calculated from the earliest start time and the latest end time.

**Example 1**

Shift 1: 8am - 1pm

Shift 2 4pm - 6pm

Hours worked = 8am - 6pm = 10 hours

#### Consecutive days

Shifts are considered as "consecutive" if they start on consecutive days.

**Example 1**

Shift 1: 1st Jan 8am - 1pm

Shift 2: 2nd Jan 9am - 2pm (Consecutive)

Shift 3: 2nd Jan 3pm - 9pm (Not consecutive. This counts as multiple shifts on the same day)

**Example 2** (overnight shifts)

Shift 1: 1st Jan 10pm - 2nd Jan 8am

Shift 2: 2nd Jan 10pm - 3rd Jan 8am (Consecutive because they start on consecutive days).

### Considerations

In this test we are only implementing a couple of rules, but there are many more rules that we will want to support in the future.

### Origin of rules

Although you do not need to have an understanding of the regulations (we are using simplified rules inspired by the regulations), you may review them by visiting the following:

[Working time regulations](https://www.bma.org.uk/pay-and-contracts/working-hours/european-working-time-directive-ewtd/doctors-and-the-european-working-time-directive)

[Junior Doctor 2016 Contract](https://www.nhsemployers.org/sites/default/files/media/NHS-doctors-and-dentists-in-training-eng-tcs-v9_0.pdf) (Skip to Schedule 03, page 25)

## What are we looking for?

- A good understanding of the problem
- How you approach the problem
- Your ability to work on top of existing code
- How you work in a day to day code review process
- How your pull request explains the changes to our team

We are not looking for a perfect solution. And you do not need to complete all of the goals.

We would rather you spend the 3 hours working on a thoughtful solution, than rush through all of the goals. We are more interested in how you work, and will not mark you down for not completing every goal.

## Submission instructions

1. Fork the repository
   - [Instructions can be found here](https://docs.github.com/en/get-started/quickstart/fork-a-repo)
2. Work on the solution locally
3. Push the changes to your fork
4. Open a pull request against this repo, treating it like an everyday feature
5. Contact us to let us know you have done so, and include your Github username

## What happens to my code afterwards?

After submitting your pull request, we will review your code and may ask questions as part of a normal pull request process.

We will also discuss the code with you in the next interview stage.

After the final stage interview we will delete the repository. We will never use any code you have written in production.

Please delete your forked copy of the tech test once you have completed the interview process.

## Setup

Make sure you have Ruby 2.7.6 installed (`.ruby-version` and `.tool-versions` files are present for use with rbenv or asdf-ruby).

To setup the app, run: `bin/setup`. Other useful binstubs can be found in the `./bin` folder.

### Development

A basic rubocop config has been included for linting. To run rubocop against the app, use `bin/rubocop`.

Rubocop supports auto-correction, saving you having to do it yourself. To do this, use the autocorrect flag `bin/rubocop -a`.

### Testing

Tests are written with RSpec.

The test suite can be run with `bin/rspec spec`. To run individual files you can pass in the filepath, e.g. `bin/rspec spec/models/shift_spec.rb`.

We've also set up the Guard gem, which will automatically run specs as you save your files. Run `bin/guard` in your Terminal, and once it's started up it will watch for any files changes. Tests will be run automatically for you. This will save you from having to manually run `bin/rspec` every time you change a file.
