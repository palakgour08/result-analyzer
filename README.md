# Result Analyzer

## Overview

Result Analyzer is a Rails application for receiving student test results from MSM and producing aggregate result statistics.

The application stores incoming test results, computes daily per-subject statistics, and calculates monthly averages under a specific calendar rule: the monthly job runs only on the Monday of the week containing the third Wednesday of the month.

## Tech Stack

- Ruby on Rails
- PostgreSQL
- RSpec

## Setup Instructions

Install dependencies:

```bash
bundle install
```

Prepare the database:

```bash
bin/rails db:prepare
```

Start the server:

```bash
bin/rails server
```

## Running Tests

```bash
bundle exec rspec
```

## API Endpoint

### `POST /api/test_results`

Stores a single test result received from MSM.

Example payload:

```json
{
  "student_name": "Palak",
  "subject": "Math",
  "marks": 88,
  "timestamp": "2026-05-12T10:00:00Z"
}
```

Successful responses return the created record id:

```json
{
  "id": 1
}
```

Validation errors return `422 Unprocessable Content`.

## Daily Statistics Processing

Daily statistics are aggregated per subject and day from stored test results.

For each subject/date pair, the job calculates:

- `daily_low`
- `daily_high`
- `result_count`

The daily job is designed to be idempotent. Re-running it for the same date updates the existing aggregate rows instead of creating duplicates.

## Monthly Average Processing

Monthly averages are calculated only on the Monday of the week containing the third Wednesday of the month.

For each subject, the calculation:

1. Starts with the most recent 5 days of daily statistics up to the calculation date.
2. Extends further backward if the cumulative `result_count` is below `200`.
3. Stores:
   - `average_daily_high`
   - `average_daily_low`
   - `total_result_count`

The monthly job is also idempotent and updates the existing subject/month calculation when re-run.

## Design Notes

- SQL aggregation is used for daily statistics instead of grouping records in Ruby.
- Database constraints enforce core data integrity rules.
- Aggregate jobs use upserts so retries do not create duplicate rows.
- Business logic is kept in focused service objects, with jobs responsible mainly for orchestration.

## Assumptions

- Marks are integers between `0` and `100`.
- Incoming timestamps are treated as UTC.
- Duplicate submissions from MSM are allowed because the payload does not include an external idempotency key.
- Monthly averages are calculated from available daily statistics up to the calculation date.

## Scheduling Notes

The jobs are written so they can be called by a scheduler or cron process.

In production, the daily and monthly jobs could be scheduled with Sidekiq Cron, GoodJob recurring jobs, Heroku Scheduler, Kubernetes CronJobs, or another platform scheduler.

## Tradeoffs / Future Improvements

- Authentication and rate limiting are omitted for the scope of this assignment.
- MSM-provided idempotency keys would allow safer duplicate detection for incoming results.
- Observability could be expanded with structured logs, metrics, and alerting around job runs.
- Scheduler configuration is intentionally left environment-specific.
