FROM mcr.microsoft.com/dotnet/sdk:5.0 AS sdk

# This URL value requested from Heroku Dyno.
ENV ASPNETCORE_URLS=http://*:$PORT

WORKDIR /app
COPY Source/Model/ src/Model/
COPY Source/WebAPI/ src/WebAPI/

# Restore and build entire solution then run ModelTests and publish WebAPI.
RUN dotnet restore src/Model/
RUN dotnet restore src/WebAPI/
RUN dotnet build -c Release --nologo --no-restore src/Model/
RUN dotnet build -c Release --nologo --no-restore src/WebAPI/
RUN dotnet publish -o publish/ -c Release --no-build --nologo src/WebAPI/

# Use single ASP.NET Core runtime to reduce image size.
FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app
COPY --from=sdk app/publish/ publish/

# Run WebAPI.
# Using CMD instead of ENTRYPOINT requested from Heroku Dyno.
CMD dotnet publish/WebAPI.dll