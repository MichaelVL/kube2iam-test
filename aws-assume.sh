#! /bin/bash

AWS_CLI="aws"
#AWS_CLI="docker run --rm -it -v $HOME/.aws:/root/.aws:ro amazon/aws-cli"

ROLE_ARN=$1

unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
unset AWS_EXPIRATION

CREDENTIALS=$($AWS_CLI sts assume-role --role-arn ${ROLE_ARN} --role-session-name TmpSession --duration-seconds 900 --output=json)

#export AWS_DEFAULT_REGION=eu-central-1
export AWS_ACCESS_KEY_ID=$(echo $CREDENTIALS | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo $CREDENTIALS | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo $CREDENTIALS | jq -r '.Credentials.SessionToken')
export AWS_EXPIRATION=$(echo $CREDENTIALS | jq -r '.Credentials.Expiration')


echo "Assumed role $ROLE_ARN, expires $AWS_EXPIRATION"
