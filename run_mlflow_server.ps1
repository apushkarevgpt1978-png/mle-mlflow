# Windows-вариант run_mlflow_server.sh

# читаем .env в переменные окружения (на Linux это делает export $(cat .env | xargs))
Get-Content .env | Where-Object { $_ -match '^[A-Z0-9_]+=.+' } | ForEach-Object {
    $name, $value = $_ -split '=', 2
    Set-Item "env:$name" $value.Trim()
}

$env:MLFLOW_S3_ENDPOINT_URL = "https://hb.ru-msk.vkcloud-storage.ru"
$env:AWS_BUCKET_NAME = $env:S3_BUCKET_NAME

mlflow server `
    --backend-store-uri "postgresql://$($env:DB_DESTINATION_USER):$($env:DB_DESTINATION_PASSWORD)@$($env:DB_DESTINATION_HOST):$($env:DB_DESTINATION_PORT)/$($env:DB_DESTINATION_NAME)" `
    --default-artifact-root "s3://$($env:AWS_BUCKET_NAME)" `
    --no-serve-artifacts
