# Change log

All notable changes to this project will be documented in this file.

## [Unreleased]

### Fixed
- Dependency on `Miv.env` that is not available in production (#4)

### Changed
- Starting a `Cronex.Table` always requires a valid `Cronex.Scheduler` 
- Minimum Elixir version is now 1.7 (#18)

### Improved 
- `Cronex.Table` documentation

## Version 0.4 - 2017/02/10

### Added 
- Support for interval time based jobs

### Changed
- Minimum Elixir version is now 1.4

### Removed
- `Cronex.DateTime` module 

## Version 0.3 - 2016/12/29

### Added
- Support for week days
- Job validation
- `Cronex.Test` module with test helpers

### Improved 
- Overall project documentation
- `Job.can_run?` tests
- `Scheduler` tests

## Version 0.2 - 2016/11/26

### Changed
- Cronex is no longer an `Application`, it is now a `Supervisor` defined by `Cronex.Scheduler`

### Fixed
- `Cronex.Every.every/3` macro

### Improved 
- README with a `Getting Started` section
- Overall tests

## Version 0.1.1 - 2016/11/05

### Fixed
- Adding jobs to the `Cronex.Table` via the `Cronex.Scheduler`
- `Cronex.Table` ping message handling

## Version 0.1.0 - 2016/11/02

### Added
- Initial version 🎉
