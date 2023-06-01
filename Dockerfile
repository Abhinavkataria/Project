# Start with the official .NET SDK image
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app

# Copy the project file and restore dependencies
COPY *.csproj .
RUN dotnet restore

# Copy the remaining source code and build the application
COPY . .
RUN dotnet publish -c Release -o out

# Create the runtime image
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime
WORKDIR /app
COPY --from=build /app/out ./

# Set the ASP.NET Core environment variables
ENV ASPNETCORE_URLS http://*:8080
ENV ASPNETCORE_ENVIRONMENT Production

# Expose port 8080 for the application
EXPOSE 8080
ENTRYPOINT ["dotnet", "Project.dll"]