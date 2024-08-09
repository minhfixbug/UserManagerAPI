FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build-env
# ENV ASPNETCORE_ENVIRONMENT=Development
WORKDIR /app

COPY . ./

RUN dotnet restore ./userapi.csproj

RUN dotnet publish ./userapi.csproj -c Release -o out

# ARG TARGETARCH

# RUN --mount=type=cache,id=nuget,target=/root/.nuget/packages \
#     dotnet publish -a ${TARGETARCH/amd64/x64} --use-current-runtime --self-contained false -o /app

FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine
WORKDIR /app
EXPOSE 80
# Copy everything needed to run the app from the "build" stage.
COPY --from=build-env /app/out .
# USER $APP_UID

ENTRYPOINT ["dotnet", "userapi.dll"]