FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build

WORKDIR /app/

COPY *.sln ./
COPY myapp/*.csproj ./sourcecode/
RUN dotnet restore

COPY myapp/ sourcecode/
WORKDIR /app/sourcecode/
RUN dotnet publish --no-restore -c release -o build/


FROM mcr.microsoft.com/dotnet/aspnet:5.0

WORKDIR /app/

COPY --from=build /app/sourcecode/build/ ./

CMD ["dotnet", "app.dll"]
