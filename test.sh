#! /bin/bash

ROLE1_ARN="arn:aws:iam::$AWS_ACCOUNT_ID:role/nn-role-1"
ROLE2_ARN="arn:aws:iam::$AWS_ACCOUNT_ID:role/nn-role-2"

echo "Assume role1..."
source ./aws-assume.sh $ROLE1_ARN

echo "Test access to testobj1"
DATA=$(aws s3 cp s3://nn-bucket-${AWS_ACCOUNT_ID}-1/testobj1 -)
STATUS=$?
if [ $STATUS = 0 ] && [ "$DATA" = "Test data for object 1" ]; then
    echo "...OK"
else
    echo "*** FAILED!  ($STATUS, $DATA)"
fi

echo "Test blocked access to testobj2"
DATA=$(aws s3 cp s3://nn-bucket-${AWS_ACCOUNT_ID}-2/testobj2 -)
STATUS=$?
if [ $STATUS = 0 ] || [ "$DATA" = "Test data for object 2" ]; then
    echo "*** FAILED!  ($STATUS, $DATA)"
else
    echo "...OK"
fi


echo "Assume role2..."
source ./aws-assume.sh $ROLE2_ARN

echo "Test access to testobj2"
DATA=$(aws s3 cp s3://nn-bucket-${AWS_ACCOUNT_ID}-2/testobj2 -)
STATUS=$?
if [ $STATUS = 0 ] && [ "$DATA" = "Test data for object 2" ]; then
    echo "...OK"
else
    echo "*** FAILED!  ($STATUS, $DATA)"
fi

echo "Test blocked access to testobj1"
DATA=$(aws s3 cp s3://nn-bucket-${AWS_ACCOUNT_ID}-1/testobj1 -)
STATUS=$?
if [ $STATUS = 0 ] || [ "$DATA" = "Test data for object 1" ]; then
    echo "*** FAILED!  ($STATUS, $DATA)"
else
    echo "...OK"
fi
