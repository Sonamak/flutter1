# Golden Test Harness

This folder contains an initial golden-test setup for Flutter using `golden_toolkit`.

## How to run
1) Ensure `dev_dependencies` include:
   - flutter_test
   - golden_toolkit

2) Run:
```
flutter test --update-goldens
flutter test
```

## Device configurations
- Desktop: 1440×900
- Mobile: 390×844

## Notes
- The initial golden test renders a Token Specimen widget (added at `lib/app/theme/token_specimen.dart`) to verify typography and spacing tokens match React.
- Page-specific goldens will be added per route in later phases.
