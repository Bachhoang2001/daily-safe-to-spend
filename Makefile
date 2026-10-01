.PHONY: gen test analyze format golden coverage

gen:
	dart run build_runner build --delete-conflicting-outputs

test:
	flutter test && (cd packages/budget_engine && dart test)

analyze:
	flutter analyze && (cd packages/budget_engine && dart analyze)

format:
	dart format --set-exit-if-changed .

golden:
	flutter test --update-goldens --tags golden

coverage:
	flutter test --coverage && (cd packages/budget_engine && dart test --coverage=coverage)
