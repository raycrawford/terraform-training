. ../myCreds.secret.sh

docker run `echo $ARGS` terraform init
docker run `echo $ARGS` terraform plan
docker run `echo $ARGS` terraform apply -auto-approve
