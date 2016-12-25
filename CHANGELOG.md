# Change log
All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
- Support for week days
- Job validation

### Improved 
- Overall project documentation
- `Job.can_run?` tests

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
