.PHONY: gen test analyze format golden coverage check-money

gen:
	dart run build_runner build --delete-conflicting-outputs

test:
	flutter test && (cd packages/budget_engine && dart test)

check-money:
	@echo "Checking for forbidden 'double' usage for money..."
	@! grep -rnE "\bdouble\b[[:space:]]+(amount|money|cents|spend|budget|income|balance|expense|cost|price|safeToSpend)\b" lib/ packages/budget_engine/lib/
	@! grep -rnE "\bdouble\b[[:space:]]+get[[:space:]]+(amount|money|cents|spend|budget|income|balance|expense)\b" lib/ packages/budget_engine/lib/
	@echo "Verified: No 'double' used for monetary values."

analyze: check-money
	flutter analyze && (cd packages/budget_engine && dart analyze)

format:
	dart format --set-exit-if-changed .

golden:
	flutter test --update-goldens --tags golden

coverage:
	flutter test --coverage && (cd packages/budget_engine && dart test --coverage=coverage)
