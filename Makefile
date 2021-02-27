modeltests:
	@echo Build Docker image:
	docker build -f ModelTests.dockerfile -t herokuapp/modeltests .

	@echo Run Docker container:
	docker run --rm herokuapp/modeltests

webapi:
	@echo Build Docker image:
	docker build -f WebAPI.dockerfile -t herokuapp/webapi .

	@echo Run docker container:
	docker run -d --rm -p 5000:80 herokuapp/webapi

webapi.heroku:
	@echo Login to Heroku:
	docker login -u=_ -p=${HEROKU_API_KEY} registry.heroku.com
	
	@echo Build Docker image:
	docker build -f WebAPI.heroku.dockerfile -t registry.heroku.com/whippingboy/web .

	@echo Push image:
	docker push registry.heroku.com/whippingboy/web

	@echo Release container:
	heroku container:release web