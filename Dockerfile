FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["azuredockerlearn/azuredockerlearn.csproj", "azuredockerlearn/"]
RUN dotnet restore "azuredockerlearn/azuredockerlearn.csproj"
COPY . .
WORKDIR "/src/azuredockerlearn"
RUN dotnet build "azuredockerlearn.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "azuredockerlearn.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "azuredockerlearn.dll"]