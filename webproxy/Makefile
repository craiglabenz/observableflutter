run/server:
	cd server && dart_frog dev

run/web:
	cd app && flutter run --dart-define=API_BASE_URL="http://localhost:9000" -d web-server

build/web:
	cd app && flutter build web --dart-define=API_BASE_URL="https://prod.api.com"
	cp -r app/build/web/* server/public/
	# firebase deploy --only=hosting