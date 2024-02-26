# Étape 1: Utiliser l'image officielle .NET SDK pour construire le projet
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["pipelines-dotnet-core.csproj", "./"]
RUN dotnet restore "pipelines-dotnet-core.csproj"
COPY . .
RUN dotnet build "pipelines-dotnet-core.csproj" -c Release -o /app/build

# Étape 2: Publier l'application
FROM build AS publish
RUN dotnet publish "pipelines-dotnet-core.csproj" -c Release -o /app/publish

# Étape 3: Créer l'image runtime avec l'image officielle .NET ASP.NET
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "pipelines-dotnet-core.dll"]

