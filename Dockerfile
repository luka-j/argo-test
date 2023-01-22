FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["test-dotnet/test-dotnet.csproj", "test-dotnet/"]
RUN dotnet restore "test-dotnet/test-dotnet.csproj"
COPY . .
WORKDIR "/src/test-dotnet"
RUN dotnet build "test-dotnet.csproj" -r linux-arm64 -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "test-dotnet.csproj" -r linux-arm64 -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "test-dotnet.dll"]
