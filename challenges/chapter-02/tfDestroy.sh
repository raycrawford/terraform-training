.. ./myCreds.secret.sh

docker run `echo $ARGS` terraform destroy -auto-approve
